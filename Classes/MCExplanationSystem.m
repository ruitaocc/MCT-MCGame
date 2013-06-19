//
//  MCExplanationSystem.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCExplanationSystem.h"

@implementation MCExplanationSystem

@synthesize accordanceMsgs;
@synthesize workingMemory;





+ (MCExplanationSystem *)explanationSystemWithWorkingMemory:(MCWorkingMemory *)wm{
    return [[[MCExplanationSystem alloc] initExplanationSystemWithWorkingMemory:wm] autorelease];
}


- (id)initExplanationSystemWithWorkingMemory:(MCWorkingMemory *)wm{
    if (self = [super init]) {
        self.workingMemory = wm;
        
        // Allocate accordance messages of the pattern of the applied rule
        self.accordanceMsgs = [NSMutableArray arrayWithCapacity:DEFAULT_PATTERN_ACCORDANCE_MESSAGE_NUM];
        
    }
    return self;
}


- (void)dealloc{    
    [accordanceMsgs release];
    [workingMemory release];
    [super dealloc];
}


- (NSArray *)translateAgendaPattern{
    //Before apply pattern, clear accrodance messages firstly.
    [self.accordanceMsgs removeAllObjects];
    
    // apply
    MCPattern *targetPattern = self.workingMemory.agendaPattern;
    if (targetPattern != nil) {
        [self treeNodesApply:targetPattern.root withDeep:0];
    }
    else{
        NSLog(@"Error! Explanation system receives nil pattern.");
        return nil;
    }
    
    
    return [NSArray arrayWithArray:self.accordanceMsgs];
}


- (NSInteger)treeNodesApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    switch (root.type) {
        case ExpNode:
        {
            switch (root.value) {
                case And:
                    return [self andNodeApply:root withDeep:deep];
                case Or:
                    return [self orNodeApply:root withDeep:deep];
                case Not:
                    return [self notNodeApply:root withDeep:deep];
                default:
                    break;
            }
        }
            break;
        case PatternNode:
        {
            switch (root.value) {
                case Home:
                {
                    if (root.result == YES && deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                case Check:
                {
                    if (root.result == YES && deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                case CubiedBeLocked:
                {
                    if (root.result == YES && deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                default:
                    return NO;
            }
        }
            break;
        default:
            return NO;
    }
    return YES;
}


- (BOOL)andNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        
        //Being a 'and' node,
        //it will be failed whever one of its child is failed.
        if (![self treeNodesApply:node withDeep: deep+1]) {
            return NO;
        }
        
        //While this node is true, we store some accordance messages
        //for several occasions.
        switch (node.type) {
            case ExpNode:
                if (node.value == Not) {
                    //Notice that the node is 'Not' node.
                    //You should get the negative sentence by invoking
                    //'getNegativeSentenceOfContentFromPatternNode'
                    NSString *msg = [MCTransformUtil getNegativeSentenceOfContentFromPatternNode:[node.children objectAtIndex:0]
                                                                        accordingToWorkingMemory:self.workingMemory];
                    if (msg != nil) {
                        [self.accordanceMsgs addObject:msg];
                    }
                }
                break;
            case PatternNode:
            {
                switch (node.value) {
                    case Home | Check:
                    {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                        break;
                    case CubiedBeLocked:
                    {
                        if ([node.children count] == 0 ||
                            [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                            NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                             accordingToWorkingMemory:self.workingMemory];
                            if (msg != nil) {
                                [self.accordanceMsgs addObject:msg];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    }
    return YES;
}


- (BOOL)orNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        if ([self treeNodesApply:node withDeep:deep+1]) {
            //While this node is true, we store some accordance messages
            //for several occasions.
            switch (node.type) {
                case ExpNode:
                    if (node.value == Not) {
                        //Notice that the node is 'Not' node.
                        //You should get the negative sentence by invoking
                        //'getNegativeSentenceOfContentFromPatternNode'
                        //The result maybe nil.
                        NSString *msg = [MCTransformUtil getNegativeSentenceOfContentFromPatternNode:[node.children objectAtIndex:0]
                                                                            accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                        
                    }
                    break;
                case PatternNode:
                {
                    switch (node.value) {
                        case Home | Check:
                        {
                            NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                             accordingToWorkingMemory:self.workingMemory];
                            if (msg != nil) {
                                [self.accordanceMsgs addObject:msg];
                            }
                        }
                            break;
                        case CubiedBeLocked:
                        {
                            if ([node.children count] == 0 ||
                                [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                                NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                                 accordingToWorkingMemory:self.workingMemory];
                                if (msg != nil) {
                                    [self.accordanceMsgs addObject:msg];
                                }
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            
            return YES;
        }
    }
    return NO;
}


- (BOOL)notNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    return ![self treeNodesApply:[root.children objectAtIndex:0] withDeep:deep+1];
}

@end
