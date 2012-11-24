//
//  TestCube.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMobileObject.h"

@class MCParticleSystem;
@interface TestCube :MCMobileObject{
    MCParticleSystem * particleEmitter;
    
    MCPoint lastTranslation;
    MCPoint lastRotation;
    
    BOOL m_spinning;
    float m_trackballRadius;
    ivec2 m_fingerStart;
    Quaternion m_orientation;
    Quaternion m_previousOrientation;
}
@property (assign)MCPoint lastTranslation;
@property (assign)MCPoint lastRotation;




- (id) init;
- (void) dealloc;
- (void)awake;
- (void)update;
-(void)handleTouches;
-(vec3)MapToSphere:(ivec2 )touchpoint;

@end
