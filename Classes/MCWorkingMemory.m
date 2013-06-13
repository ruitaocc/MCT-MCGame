//
//  MCWorkingMemory.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-3.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCWorkingMemory.h"


@implementation MCWorkingMemory

@synthesize magicCube = _magicCube;
@synthesize applyQueue = _applyQueue;
@synthesize residualActions = _residualActions;
@synthesize agendaPattern = _agendaPattern;
@synthesize magicCubeState = _magicCubeState;

+ (MCWorkingMemory *)workingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    return [[[MCWorkingMemory alloc] initWorkingMemoryWithMagicCube:mc] autorelease];
}


- (id)initWorkingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    if (self = [super init]) {
        self.magicCube = mc;
        
        // Here allocate the array which store residual actions.
        // The residual actions contains all actions of the applied rule except rotation actions.
        self.residualActions = [NSMutableArray arrayWithCapacity:DEFAULT_RESIDUAL_ACTION_NUM];
    }
    return self;
}


- (void)dealloc{
    [super dealloc];
    [_applyQueue release];
    [_magicCube release];
    [_residualActions release];
    [_agendaPattern release];
    [_magicCubeState release];
}


- (void)unlockAllCubies{
    for (int i = 0; i < CubieCouldBeLockMaxNum; i++) {
        lockedCubies[i] = nil;
    }
}

- (void)unlockCubieAtIndex:(NSInteger)index{
    lockedCubies[index] = nil;
}


- (void)unlockCubiesInRange:(NSRange)range{
    int i = 0;
    int position = range.location;
    for (; i < range.length; i++, position++) {
        lockedCubies[position] = nil;
    }
}


- (BOOL)lockerEmptyAtIndex:(NSInteger)index{
    return lockedCubies[index] == nil;
}


- (void)lockCubie:(NSObject<MCCubieDelegate> *)cubie atIndex:(NSInteger)index{
    lockedCubies[index] = cubie;
}


- (NSObject<MCCubieDelegate> *)cubieLockedInLockerAtIndex:(NSInteger)index{
    return lockedCubies[index];
}


- (void)clearExceptMagicCubeData{
    self.applyQueue = nil;
    self.residualActions = nil;
    self.agendaPattern = nil;
    self.magicCubeState = UNKNOWN_STATE;
    [self unlockAllCubies];
}

// The magic cube setter has been rewritten.
// Once you set the magic cube object, all other data will be clear.
- (void)setMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    [mc retain];
    [_magicCube release];
    _magicCube = mc;
    
    [self clearExceptMagicCubeData];
    
}


@end
