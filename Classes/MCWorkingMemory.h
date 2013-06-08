//
//  MCWorkingMemory.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-3.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCubieDelegate.h"
#import "MCMagicCubeDelegate.h"
#import "MCApplyQueue.h"


// locker max size
#define CubieCouldBeLockMaxNum 26

#define DEFAULT_RESIDUAL_ACTION_NUM 3

@interface MCWorkingMemory : NSObject {
    NSObject<MCCubieDelegate>* lockedCubies[CubieCouldBeLockMaxNum];
}

@property (nonatomic, retain) NSObject<MCMagicCubeDelegate> *magicCube;
@property (nonatomic, retain) MCApplyQueue *applyQueue;
@property (nonatomic, retain) NSMutableArray *residualActions;
@property (nonatomic, retain) MCPattern *agendaPattern;


+ (MCWorkingMemory *)workingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc;

- (id)initWorkingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc;

// Clear all working memory data except magic cube data.
- (void)clearExceptMagicCubeData;

// This action will unlock all cubies.
// Just when re-check state from init, it should be invoked.
- (void)unlockAllCubies;


- (void)unlockCubieAtIndex:(NSInteger)index;


- (void)unlockCubiesInRange:(NSRange)range;


- (BOOL)lockerEmptyAtIndex:(NSInteger)index;


- (void)lockCubie:(NSObject<MCCubieDelegate> *)cubie atIndex:(NSInteger)index;


- (NSObject<MCCubieDelegate> *)cubieLockedInLockerAtIndex:(NSInteger)index;


@end
