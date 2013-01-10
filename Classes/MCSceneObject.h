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
@class MCCollider;
@interface MCSceneObject : NSObject {
	// transform values
	MCPoint pretranslation;
	MCPoint prerotation;
    
    Quaternion m_orientation;
    Quaternion m_previousOrientation;
    
    MCPoint translation;
	MCPoint scale;
	MCPoint rotation;
    
    Quaternion quaRotation;
    Quaternion quaPreviousRotation;

	MCMesh * mesh;
	
	BOOL active;
    
    
	CGFloat * matrix;
	
	CGRect meshBounds;
	
	MCCollider *collider;//;

    
}
@property (retain) MCCollider *collider;
@property (retain) MCMesh * mesh;
@property (assign) MCPoint translation;
@property (assign) MCPoint rotation;
@property (assign) MCPoint scale;
@property (assign) CGFloat * matrix;
@property (assign) MCPoint pretranslation;
@property (assign) MCPoint prerotation;
@property (assign) Quaternion m_orientation;
@property (assign) Quaternion quaRotation;
@property (assign) BOOL active;
@property (assign) CGRect meshBounds;
- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;




@end
