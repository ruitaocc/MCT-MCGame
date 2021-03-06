//
//  MCApplyQueue.m
//  MagicCubeModel
//
//  Created by Aha on 13-4-11.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCApplyQueue.h"
#import "MCTransformUtil.h"
#import "MCCompositeRotationUtil.h"

@implementation MCApplyQueue

@synthesize rotationQueue;
@synthesize extraRotations;
@synthesize currentRotationQueuePosition;
@synthesize previousRotation;
@synthesize previousResult;
@synthesize queueCompleteDelegate;


+ (MCApplyQueue *)applyQueueWithRotationAction:(MCTreeNode *)action withMagicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc{
    return [[[MCApplyQueue alloc] initWithRotationAction:action withMagicCube:mc] autorelease];
}

- (id)initWithRotationAction:(MCTreeNode *)action withMagicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc{
    if (self = [super init]) {
        self.currentRotationQueuePosition = 0;
        self.previousResult = NoneResult;
        self.previousRotation = NoneNotation;
        self.rotationQueue = [NSMutableArray arrayWithCapacity:10];
        self.extraRotations = [NSMutableArray arrayWithCapacity:3];
        switch (action.value) {
            case Rotate:
            {
                for (MCTreeNode *child in action.children) {
                    if (child.value == Fw2 || child.value == Bw2 || child.value == Rw2 || child.value == Lw2 ||
                        child.value == Uw2 || child.value == Dw2 ) {
                        [self.rotationQueue addObject:[NSNumber numberWithInteger:(child.value-2)]];
                        [self.rotationQueue addObject:[NSNumber numberWithInteger:(child.value-2)]];
                    }
                    else{
                        [self.rotationQueue addObject:[NSNumber numberWithInteger:child.value]];
                    }
                }
            }
                break;
            case FaceToOrientation:
            {
                MCTreeNode *elementNode;
                elementNode = [action.children objectAtIndex:0];
                ColorCombinationType targetCombination = (ColorCombinationType)elementNode.value;
                struct Point3i targetCoor = [mc coordinateValueOfCubieWithColorCombination:targetCombination];
                elementNode = [action.children objectAtIndex:1];
                FaceOrientationType targetOrientation = (FaceOrientationType)elementNode.value;
                [rotationQueue addObject:[NSNumber numberWithInteger:
                                          [MCTransformUtil getPathToMakeCenterCubieAtPosition:targetCoor inOrientation:targetOrientation]]];
            }
                break;
            default:
                break;
        }
    }
    return self;
}


//reset the current position
- (void)reset{
    currentRotationQueuePosition = 0;
}

//return the queue length
- (long)count{
    return [self.rotationQueue count];
}

//apply rotation and return result
//the position will move to next position
- (void)applyRotation:(SingmasterNotation)currentRotation{
    //detect the rotation result
    //if the queue is exist, continue
    //else, return finished
    if (self.rotationQueue == nil) {
        previousResult = Finished;
    }
    else{
        //if they are same, accord
        SingmasterNotation targetRotation = (SingmasterNotation)[[self.rotationQueue objectAtIndex:currentRotationQueuePosition] integerValue];
        if (previousResult == StayForATime) {
            if ([MCCompositeRotationUtil isSingmasterNotation:previousRotation andSingmasterNotation:currentRotation equalTo:targetRotation]) {
                previousResult = Accord;
                currentRotationQueuePosition++;
            }
            else{
                previousResult = Disaccord;
                //extra queue
                [self.extraRotations removeAllObjects];
                [self.extraRotations addObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]]];
                [self.extraRotations addObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:previousRotation]]];
                //self queue
                [self.rotationQueue insertObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]] atIndex:currentRotationQueuePosition];
                [self.rotationQueue insertObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:previousRotation]] atIndex:currentRotationQueuePosition];
            }
        } else {
            if (targetRotation == currentRotation) {
                previousResult = Accord;
                currentRotationQueuePosition++;
                if ([self isFinished]) previousResult = Finished;
            }
            else{
                if ([MCCompositeRotationUtil isSingmasterNotation:currentRotation PossiblePartOfSingmasterNotation:targetRotation]) {
                    previousResult = StayForATime;
                }
                else{
                    previousResult = Disaccord;
                    //extra queue
                    [self.extraRotations removeAllObjects];
                    [self.extraRotations addObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]]];
                    //self queue
                    [self.rotationQueue insertObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]] atIndex:currentRotationQueuePosition];
                }
            }
        }
        
        if (currentRotationQueuePosition == [self.rotationQueue count]) {
            self.rotationQueue = nil;
            previousResult = Finished;
            [self.queueCompleteDelegate onQueueComplete];
        }
    }
    previousRotation = currentRotation;
}

//finished or not
- (BOOL)isFinished{
    return currentRotationQueuePosition == [self count];
}

- (NSArray *)getQueueWithStringFormat{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSNumber *rotation in self.rotationQueue) {
        [mArray addObject:[MCTransformUtil getRotationTagFromSingmasterNotation:(SingmasterNotation)[rotation integerValue]]];
    }
    return [NSArray arrayWithArray:mArray];
}


- (NSArray *)getExtraQueueWithStringFormat{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[self.extraRotations count]];
    for (NSNumber *rotation in self.extraRotations) {
        [mArray addObject:[MCTransformUtil getRotationTagFromSingmasterNotation:(SingmasterNotation)[rotation integerValue]]];
    }
    return [NSArray arrayWithArray:mArray];
}


- (SingmasterNotation)currentRotation{
    return (SingmasterNotation)[[self.rotationQueue objectAtIndex:currentRotationQueuePosition] integerValue];
}

- (void)dealloc{
    [rotationQueue release];
    [extraRotations release];
    [queueCompleteDelegate release];
    
    [super dealloc];
}


@end
