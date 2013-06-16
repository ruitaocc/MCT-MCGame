//
//  MCPlayHelper.h
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMagicCubeDelegate.h"
#import "Global.h"
#import "MCBasicElement.h"
#import "MCApplyQueue.h"
#import "MCInferenceEngine.h"
#import "MCExplanationSystem.h"


//rotation queue, locked cubies, tips
#define DEFAULT_ACTION_INFOMATION_NUM 3

typedef enum _HelperStateMachine {
    Normal,
    ApplyingRotationQueue
} HelperStateMachine;


@interface MCPlayHelper : NSObject

@property (nonatomic) HelperStateMachine helperState;
@property (nonatomic, retain) MCInferenceEngine *inferenceEngine;
@property (nonatomic, retain) MCExplanationSystem *explanationSystem;
@property (nonatomic, retain) MCActionPerformer *actionPerformer;



+ (MCPlayHelper *)playerHelperWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc;


- (id)initPlayerHelperWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc;


// Rotate operation with axis, layer, direction
- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction;

// Rotate operation with parameter SingmasterNotation
- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation;

// Get the result of the last rotation
- (RotationResult)getResultOfTheLastRotation;

// Do some preparation work before inference.
- (void)prepare;

// Apply rules and return actions
// the result is directory:
// "RotationQueue"——the rotation queue in array
// "LockingAt"——an array contains identities(ColorCombinationType) of cubies
// "Tips"——the strings showing tips
//       ——the NSArray with several NSString objects
- (NSDictionary *)applyRules;


- (void)close;


- (NSArray *)extraQueue;


// get notation of next rotation that will be finished.
- (SingmasterNotation)nextNotation;

- (BOOL)isOver;

- (void)setMagicCube:(NSObject<MCMagicCubeDelegate > *)mc;

@end
