//
//  MCActionPerformer.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCActionPerformer.h"

@implementation MCActionPerformer

@synthesize workingMemory;

+ (MCActionPerformer *)actionPerformerWithWorkingMemory:(MCWorkingMemory *)wm{
    return [[[MCActionPerformer alloc] initActionPerformerWithWorkingMemory:wm] autorelease];
}


- (id)initActionPerformerWithWorkingMemory:(MCWorkingMemory *)wm{
    if (self = [super init]) {
        self.workingMemory = wm;
        self.workingMemory.applyQueue.queueCompleteDelegate = self;
    }
    return self;
}


- (void)dealloc{
    [super dealloc];
    [workingMemory release];
}

// Rotate operation with axis, layer, direction
- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction{
    NSObject<MCMagicCubeOperationDelegate> *magicCube = self.workingMemory.magicCube;
    if (magicCube != nil) {
        return [magicCube rotateOnAxis:axis onLayer:layer inDirection:direction];
    }
    return NO;
}

// Rotate operation with parameter SingmasterNotation
- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation{
    NSObject<MCMagicCubeOperationDelegate> *magicCube = self.workingMemory.magicCube;
    if (magicCube != nil) {
        return [magicCube rotateWithSingmasterNotation:notation];
    }
    return NO;
}

- (BOOL)isQueueEmpty{
    return self.workingMemory.applyQueue == nil;
}


- (NSArray *)queueStrings{
    return [self.workingMemory.applyQueue getQueueWithStringFormat];
}


- (void)applyRotationInQueue:(SingmasterNotation)currentRotation{
    [self.workingMemory.applyQueue applyRotation:currentRotation];
}


- (RotationResult)queueRotationResult{
    return self.workingMemory.applyQueue.previousResult;
}

- (NSInteger)treeNodesApply:(MCTreeNode *)root{
    NSObject<MCMagicCubeDelegate> *magicCube = self.workingMemory.magicCube;
    
    switch (root.type) {
        case ExpNode:
        {
            if (root.value == Sequence) {
                return [self sequenceNodeApply:root];
            }
        }
            break;
        case ActionNode:
        {
            switch (root.value) {
                case Rotate:
                    for (MCTreeNode *child in root.children) {
                        [magicCube rotateWithSingmasterNotation:(SingmasterNotation)child.value];
                    }
                    break;
                case FaceToOrientation:
                {
                    MCTreeNode *elementNode;
                    elementNode = [root.children objectAtIndex:0];
                    ColorCombinationType targetCombination = (ColorCombinationType)elementNode.value;
                    struct Point3i targetCoor = [magicCube coordinateValueOfCubieWithColorCombination:targetCombination];
                    elementNode = [root.children objectAtIndex:1];
                    FaceOrientationType targetOrientation = (FaceOrientationType)elementNode.value;
                    [magicCube rotateWithSingmasterNotation:[MCTransformUtil getPathToMakeCenterCubieAtPosition:targetCoor inOrientation:targetOrientation]];
                }
                    break;
                case LockCubie:
                {
                    MCTreeNode *elementNode = [root.children objectAtIndex:0];
                    int index = 0;
                    if ([root.children count] != 1) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                    }
                    int identity = [self treeNodesApply:elementNode];
                    if (identity == -1) {
                        [self.workingMemory unlockCubieAtIndex:index];
                    }
                    else{
                        [self.workingMemory lockCubie:[magicCube cubieWithColorCombination:(ColorCombinationType)identity]
                                atIndex:index];
                    }
                }
                    break;
                case UnlockCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    [self.workingMemory unlockCubieAtIndex:index];
                }
                    break;
                default:
                    return NO;
            }
        }
            break;
        case InformationNode:
            switch (root.value) {
                case getCombinationFromOrientation:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ([magicCube centerMagicCubeFaceInOrientation:(FaceOrientationType)child.value]) {
                            case Up:
                                y = 2;
                                break;
                            case Down:
                                y = 0;
                                break;
                            case Left:
                                x = 0;
                                break;
                            case Right:
                                x = 2;
                                break;
                            case Front:
                                z = 2;
                                break;
                            case Back:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getCombinationFromColor:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ((FaceColorType)[self treeNodesApply:child]) {
                            case UpColor:
                                y = 2;
                                break;
                            case DownColor:
                                y = 0;
                                break;
                            case LeftColor:
                                x = 0;
                                break;
                            case RightColor:
                                x = 2;
                                break;
                            case FrontColor:
                                z = 2;
                                break;
                            case BackColor:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getFaceColorFromOrientation:
                {
                    FaceColorType color;
                    FaceOrientationType orientation = (FaceOrientationType)[(MCTreeNode *)[root.children objectAtIndex:0] value];
                    if ([root.children count] == 1) {
                        switch ([magicCube centerMagicCubeFaceInOrientation:orientation]) {
                            case Up:
                                color = UpColor;
                                break;
                            case Down:
                                color = DownColor;
                                break;
                            case Left:
                                color = LeftColor;
                                break;
                            case Right:
                                color = RightColor;
                                break;
                            case Front:
                                color = FrontColor;
                                break;
                            case Back:
                                color = BackColor;
                                break;
                            default:
                                color = NoColor;
                                break;
                        }
                    }
                    else{
                        int value = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                        struct Point3i coordinate = {value%3-1, value%9/3-1, value/9-1};
                        color = [[magicCube cubieAtCoordinatePoint3i:coordinate] faceColorInOrientation:orientation];
                    }
                    
                    //Store the result at the node
                    root.result = color;
                    return root.result;
                }
                case lockedCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    
                    if ([self.workingMemory lockerEmptyAtIndex:index]) {
                        root.result = -1;
                    }
                    else{
                        root.result = [[self.workingMemory cubieLockedInLockerAtIndex:index] identity];
                    }
                    
                    return root.result;
                }
                default:
                    break;
            }
            break;
        case ElementNode:
            return root.value;
        default:
            return NO;
    }
    return YES;
}

- (BOOL)sequenceNodeApply:(MCTreeNode *)root{
    for (MCTreeNode *node in root.children) {
        [self treeNodesApply:node];
    }
    return YES;
}

- (BOOL)decomposeRule:(MCRule *)rule{
    // Get the tree of the action according to the pattern name
    MCTreeNode *actionTree = [rule root];
    
    // Analyse the action and return the result
    switch (actionTree.type) {
        case ExpNode:
        {
            BOOL flag = YES;
            for (MCTreeNode *node in actionTree.children) {
                if (flag) {
                    if (node.type == ActionNode && (node.value == Rotate|| node.value == FaceToOrientation)) {
                        self.workingMemory.applyQueue = [MCApplyQueue applyQueueWithRotationAction:node withMagicCube:self.workingMemory.magicCube];
                        self.workingMemory.applyQueue.queueCompleteDelegate = self;
                        flag = NO;
                    }
                    else{
                        [self treeNodesApply:node];
                    }
                } else {
                    [self.workingMemory.residualActions addObject:node];
                }
            }
        }
            break;
        case ActionNode:
            switch (actionTree.value) {
                case Rotate:
                case FaceToOrientation:
                    self.workingMemory.applyQueue = [MCApplyQueue applyQueueWithRotationAction:actionTree withMagicCube:self.workingMemory.magicCube];
                    self.workingMemory.applyQueue.queueCompleteDelegate = self;
                    break;
                default:
                    [self treeNodesApply:actionTree];
                    break;
            }
            break;
        default:
            return NO;
    }
    return YES;
}

- (void)onQueueComplete{
    //do the clear thing for next rotation queue
    for (MCTreeNode *node in self.workingMemory.residualActions) {
        [self treeNodesApply:node];
    }
    [self.workingMemory.residualActions removeAllObjects];
}

@end
