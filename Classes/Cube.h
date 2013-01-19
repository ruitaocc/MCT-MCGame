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
@interface Cube :MCMobileObject{
    MCParticleSystem * particleEmitter;
    int index;
}

@property (assign) int index;


- (id) init;
- (void) dealloc;
- (void)awake;
- (void)update;


@end
