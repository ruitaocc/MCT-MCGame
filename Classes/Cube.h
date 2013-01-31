//
//  TestCube.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMobileObject.h"
#import "MCRay.h"
@class MCParticleSystem;
@class MCCollider;
enum direction {
    FX = -1,
    ZX = 1,
    FY = -2,
    ZY = 2,
    FZ = -3,
    ZZ = 3
    };
@interface Cube :MCMobileObject{
    MCParticleSystem * particleEmitter;
    int index;
    direction O_X;
    direction O_Y;
    direction O_Z;
}

@property (assign) int index;
@property (assign) direction O_X,O_Y,O_Z;

- (id) init;
- (void) dealloc;
- (void)awake;
- (void)update;


@end
