//
//  MCPlayHelper.m
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCPlayHelper.h"
#import "MCTransformUtil.h"


@implementation MCPlayHelper

@synthesize helperState = _helperState;
@synthesize inferenceEngine = _inferenceEngine;
@synthesize explanationSystem;
@synthesize actionPerformer = _actionPerformer;



+ (MCPlayHelper *)playerHelperWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    return [[[MCPlayHelper alloc] initPlayerHelperWithMagicCube:mc] autorelease];
}

- (id)initPlayerHelperWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    if (self = [super init]) {
        
        
        // normal helper state
        _helperState = Normal;
        
        MCWorkingMemory *workingMemory = [MCWorkingMemory workingMemoryWithMagicCube:mc];
        // Init the inference engine.
        self.inferenceEngine = [MCInferenceEngine inferenceEngineWithWorkingMemory:workingMemory];
        
        // Init the explanation system.
        self.explanationSystem = [MCExplanationSystem explanationSystemWithWorkingMemory:workingMemory];
        
        self.actionPerformer = self.inferenceEngine.actionPerformer;
    }
    return self;
}


- (void)dealloc{
    [_inferenceEngine release];
    [explanationSystem release];
    [_actionPerformer release];
    [super dealloc];
}


- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction{
    BOOL result = [self.actionPerformer rotateOnAxis:axis onLayer:layer inDirection:direction];
    //apply rotation
    if (![self.actionPerformer isQueueEmpty] && _helperState == ApplyingRotationQueue) {
        SingmasterNotation currentRotation = [MCTransformUtil getSingmasterNotationFromAxis:axis layer:layer direction:direction];
        [self.actionPerformer applyRotationInQueue:currentRotation];
    }
    
    return result;
}


- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation{
    BOOL result = [self.actionPerformer rotateWithSingmasterNotation:notation];
    //apply rotation
    if (![self.actionPerformer isQueueEmpty] && _helperState == ApplyingRotationQueue) {
        [self.actionPerformer applyRotationInQueue:notation];
    }
    
    return result;
}


- (RotationResult)getResultOfTheLastRotation{
    return [self.actionPerformer queueRotationResult];
}


- (void)prepare{
    _helperState = ApplyingRotationQueue;
    [self.inferenceEngine prepareReasoning];
}

- (NSDictionary *)applyRules{
    if (self.inferenceEngine.workingMemory.magicCube == nil){
        NSLog(@"Set the magic cube before apply rules.");
        return nil;
    }
    
    
    // Start reasoning and return the correct rule.
    MCRule *targetRule = [self.inferenceEngine reasoning];

#ifdef ONLY_TEST
    //error occurs, we can not find the rules to apply and there isn't the finished state.
    if ([self.inferenceEngine.magicCubeState compare:END_STATE] != NSOrderedSame && targetRule == nil) {
        NSLog(@"%@", @"There must be something wrong, I don't apply any rules.");
        //save state for debug
        NSString *savedPath = [NSString stringWithFormat:@"ErrorStateForDebug_%f", [[NSDate date] timeInterval]];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [path stringByAppendingPathComponent:savedPath];
        [NSKeyedArchiver archiveRootObject:self.actionPerformer.workingMemory.magicCube toFile:fileName];
        return nil;
    }
    
    [self.actionPerformer treeNodesApply:[targetRule root]];
#else
    //error occurs, we can not find the rules to apply and there isn't the finished state.
    if ([_inferenceEngine.workingMemory.magicCubeState compare:END_STATE] != NSOrderedSame && targetRule == nil) {
        NSLog(@"%@", @"There must be something wrong, I don't apply any rules.");
        //save state for debug
        NSString *savedPath = [NSString stringWithFormat:@"ErrorStateForDebug_%f", [[NSDate date] timeInterval]];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [path stringByAppendingPathComponent:savedPath];
        [NSKeyedArchiver archiveRootObject:self.actionPerformer.workingMemory.magicCube toFile:fileName];
        return nil;
    }
#endif
    
    
#ifndef ONLY_TEST
    
    // Decompose the rule.
    [self.actionPerformer decomposeRule:targetRule];
    
    NSMutableDictionary *resultDirectory = [NSMutableDictionary dictionaryWithCapacity:DEFAULT_ACTION_INFOMATION_NUM];
    
    // While the apply queue is new, attach it to the result directory.
    if (![self.actionPerformer isQueueEmpty]) {
        NSArray *queueStrings = [self.actionPerformer queueStrings];
        if (queueStrings != nil) {
            [resultDirectory setObject:queueStrings forKey:KEY_ROTATION_QUEUE];
            
            // Attach inference explanation to the result directory.
            NSArray *accordanceMsgs = [self.explanationSystem translateAgendaPattern];
            if (accordanceMsgs != nil) {
                [resultDirectory setObject:accordanceMsgs forKey:KEY_TIPS];
                if ([accordanceMsgs count] != 0) {
                    
                    //------------------------------------
                    NSLog(@"Tips---");
                    for (NSString *msg in accordanceMsgs) {
                        NSLog(@"%@", msg);
                    }
                }
            }
            
            //While there is a cubie is locked at 0 position, add locked cubie info
            
            if (![self.actionPerformer.workingMemory lockerEmptyAtIndex:0]) {
                [resultDirectory setObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:[[self.actionPerformer.workingMemory cubieLockedInLockerAtIndex:0] identity]]]
                                    forKey:KEY_LOCKED_CUBIES];
            }
        }
    }

#else
    NSDictionary *resultDirectory = [NSDictionary dictionary];
#endif
    
    return resultDirectory;
}


- (void)close{
    _helperState = Normal;
    [_inferenceEngine closeReasoning];
}


- (NSArray *)extraQueue{
    return [self.inferenceEngine.workingMemory.applyQueue getExtraQueueWithStringFormat];
}


- (void)setMagicCube:(NSObject<MCMagicCubeDelegate > *)mc{
    self.inferenceEngine.workingMemory.magicCube = mc;
}


- (BOOL)isOver{
    return [_actionPerformer.workingMemory.magicCube isFinished];
}

@end

