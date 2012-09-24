//
//  MCSceneObject.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#include "Quaternion.hpp"
//#include "MeshRenderEngine.hpp"
@class MCMesh;

@interface MCSceneObject : NSObject {
	// transform values
	CGFloat x,y,z;
	CGFloat xRotation,yRotation,zRotation;
	CGFloat xScale,yScale,zScale;
	
	MCMesh * mesh;
	//MeshRenderEngine *mesh;
	BOOL active;
    
}

@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat z;

@property (assign) CGFloat xRotation;
@property (assign) CGFloat yRotation;
@property (assign) CGFloat zRotation;

@property (assign) CGFloat xScale;
@property (assign) CGFloat yScale;
@property (assign) CGFloat zScale;

@property (assign) BOOL active;

- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;

- (void) OnFingerUp:(ivec2) location;
- (void) OnFingerDown:(ivec2) location;
- (void) OnFingerMove:(ivec2) oldLocation
                     newLocation:(ivec2) newLocation;
- (vec3) MapToSphere:(ivec2) touchpoint;



@end
