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

@interface Cube :MCMobileObject{
    MCParticleSystem * particleEmitter;
    NSMutableArray *cube6faces;
    NSMutableArray *cube6faces_locksign;
    //CubeFace *faces[6];
    int index;
    BOOL _isLocked;
    int index_selectedFace;
}

@property (assign) int index;
@property (assign) int index_selectedFace;
@property (assign) BOOL isLocked;
@property (nonatomic,retain)NSMutableArray *cube6faces;
@property (nonatomic,retain)NSMutableArray *cube6faces_locksign;
-(id)init;
- (id) initWithState:(NSDictionary*)states;
- (void) flashWithState:(NSDictionary*)states;
- (void) dealloc;
- (void)awake;
- (void)update;
-(void)render;
//魔方输入时


@end
