//
//  TestCube.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMobileObject.h"
#import "MCRay.h"
#import "CubeFace.h"
@class MCParticleSystem;
@class MCCollider;
#import "Global.h"
@interface Cube :MCMobileObject{
    MCParticleSystem * particleEmitter;
    NSMutableArray *cube6faces;
    NSMutableArray *cube6faces_locksign;
    NSMutableArray *cube6faces_direction_indicator;
    //CubeFace *faces[6];
    int index;
    BOOL _isLocked;
    int index_selectedFace;
    BOOL _isNeededToShowSpaceDirection;
    AxisType indicator_axis;
    LayerRotationDirectionType indicator_direction;
}

@property (assign) int index;
@property (assign) int index_selectedFace;
@property (assign) BOOL isLocked;
@property (assign) BOOL isNeededToShowSpaceDirection;
@property (assign) AxisType indicator_axis;
@property (assign) LayerRotationDirectionType indicator_direction;
@property (nonatomic,retain)NSMutableArray *cube6faces;
@property (nonatomic,retain)NSMutableArray *cube6faces_locksign;
@property (nonatomic,retain)NSMutableArray *cube6faces_direction_indicator;
-(id)init;
- (id) initWithState:(NSDictionary*)states;
- (void) flashWithState:(NSDictionary*)states;
- (void) dealloc;
- (void)awake;
- (void)update;
-(void)render;
//魔方输入时


@end
