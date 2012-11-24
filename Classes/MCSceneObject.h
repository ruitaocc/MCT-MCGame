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
#import "MCPoint.h"
#import "MCMaterialController.h"
#import "MCTexturedQuad.h"
#import "MCSceneController.h"
#import "MCTexturedMesh.h"
#import "MCPoint.h"
#import "MCConfiguration.h"
//#include "MeshRenderEngine.hpp"
@class MCMesh;

@interface MCSceneObject : NSObject {
	// transform values
	MCPoint translation;
	MCPoint rotation;
	MCPoint scale;
	
	MCMesh * mesh;
	
	BOOL active;
    
    
	CGFloat * matrix;
	
	CGRect meshBounds;
	
	//MCCollider * collider;

    
}

@property (retain) MCMesh * mesh;
@property (assign) MCPoint translation;
@property (assign) MCPoint rotation;
@property (assign) MCPoint scale;
@property (assign) CGFloat * matrix;
@property (assign) BOOL active;
@property (assign) CGRect meshBounds;
- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;




@end
