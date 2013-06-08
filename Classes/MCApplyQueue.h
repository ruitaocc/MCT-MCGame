//
//  MCApplyQueue.h
//  MagicCubeModel
//
//  Created by Aha on 13-4-11.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCBasicElement.h"
#import "MCMagicCubeDataSouceDelegate.h"

@protocol QueueCompleteDelegate <NSObject>

- (void)onQueueComplete;

@end


@interface MCApplyQueue : NSObject

@property (nonatomic, retain) NSMutableArray *rotationQueue;
@property (nonatomic, retain) NSMutableArray *extraRotations;
@property (nonatomic) NSInteger currentRotationQueuePosition;
@property (nonatomic) SingmasterNotation previousRotation;
@property (nonatomic) RotationResult previousResult;
// Once the queue is complete, the delegate's onQueueComplete will be invoked.
@property (nonatomic, retain) NSObject<QueueCompleteDelegate> *queueCompleteDelegate;


+ (MCApplyQueue *)applyQueueWithRotationAction:(MCTreeNode *)action withMagicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc;

- (id)initWithRotationAction:(MCTreeNode *)action withMagicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc;

//reset the current position
- (void)reset;

//return the queue length
- (long)count;

//apply rotation and return result
//the position will move to next position
- (void)applyRotation:(SingmasterNotation)currentRotation;

// Get the queue in string format being contained in a array
- (NSArray *)getQueueWithStringFormat;

//get the extra queue in string format being contained in a array
- (NSArray *)getExtraQueueWithStringFormat;

//finished or not
- (BOOL)isFinished;

@end
