//
//  MCPlayHelper.h
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMagicCubeDelegate.h"
#import "MCKnowledgeBase.h"
#import "Global.h"
#import "MCBasicElement.h"
#import "MCApplyQueue.h"


#define NO_LOCKED_CUBIE -1
#define DEFAULT_RESIDUAL_ACTION_NUM 3
#define DEFAULT_PATTERN_ACCORDANCE_MESSAGE_NUM 5

//rotation queue, locked cubies, tips
#define DEFAULT_ACTION_INFOMATION_NUM 3

typedef enum _HelperStateMachine {
    Normal,
    ApplyingRotationQueue
} HelperStateMachine;


@interface MCPlayHelper : NSObject

@property (nonatomic, retain)NSObject<MCMagicCubeDelegate> *magicCube;
@property (nonatomic, retain)NSDictionary *patterns;
@property (nonatomic, retain)NSDictionary *rules;
@property (nonatomic, retain)NSDictionary *states;
@property (nonatomic, retain)NSString *state;
@property (nonatomic)HelperStateMachine helperState;
@property (nonatomic, retain)MCApplyQueue *applyQueue;
@property (nonatomic)RotationResult rotationResult;
@property (nonatomic, retain)NSMutableArray *residualActions;

//After applying this pattern,
//intermediate informations will be stored here.
//However, these informations are those accordant condictions beacuse
//this pattern maybe not completely corresponding to current state of the rubik's cube.
@property(nonatomic, retain)NSMutableArray *accordanceMsgs;


+ (MCPlayHelper *)playerHelperWithMagicCube:(MCMagicCube *)mc;

- (id)initWithMagicCube:(MCMagicCube *)mc;

//see whether the target cubie is at home
- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity;

//rotate operation with axis, layer, direction
- (void)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction;

//rotate operation with parameter SingmasterNotation
- (void)rotateWithSingmasterNotation:(SingmasterNotation)notation;

//get the result of the last rotation
- (RotationResult)getResultOfTheLastRotation;

- (void)reloadRulesAccordingToCurrentStateOfRubiksCube;

//check the current state and return it
- (NSString *)checkStateFromInit:(BOOL)isCheckStateFromInit;

//apply rules and return actions
//the result is directory:
//"RotationQueue"——the rotation queue in array
//"LockingAt"——
//"Tips"——the strings showing tips
//      ——the NSArray with several NSString objects
- (NSDictionary *)applyRules;

//do the clear thing for next rotation queue
- (void)clearResidualActions;

@end
