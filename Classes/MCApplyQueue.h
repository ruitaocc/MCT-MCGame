//
//  MCApplyQueue.h
//  MagicCubeModel
//
//  Created by Aha on 13-4-11.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCBasicElement.h"
#import "Global.h"
#import "MCMagicCube.h"
#import "MCTransformUtil.h"


@interface MCApplyQueue : NSObject

@property (nonatomic, strong)NSMutableArray *rotationQueue;
@property (nonatomic, strong)NSMutableArray *extraRotations;
@property (nonatomic)NSInteger currentRotationQueuePosition;
@property (nonatomic)SingmasterNotation previousRotation;
@property (nonatomic)RotationResult previousResult;
@property (nonatomic, retain)MCMagicCube *magicCube;

+ (id)applyQueueWithRotationAction:(MCTreeNode *)action withMagicCube:(MCMagicCube *)mc;

- (id)initWithRotationAction:(MCTreeNode *)action withMagicCube:(MCMagicCube *)mc;

//reset the current position
- (void)reset;

//return the queue length
- (long)count;

//apply rotation and return result
//the position will move to next position
- (RotationResult)applyRotation:(SingmasterNotation)currentRotation;

//get the queue in string format being contained in a array
- (NSArray *)getQueueWithStringFormat;

//get the extra queue in string format being contained in a array
- (NSArray *)getExtraQueueWithStringFormat;

//finished or not
- (BOOL)isFinished;

@end
