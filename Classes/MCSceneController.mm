//
//  MCSceneController.m
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCSceneController.h"
#import "InputController.h"
#import "EAGLView.h"
#import "MCSceneObject.h"
#import "MCConfiguration.h"
#import "MCPoint.h"
#import "TestCube.h"
//#import "data.hpp"
@implementation MCSceneController

// Singleton accessor.  this is how you should ALWAYS get a reference
// to the scene controller.  Never init your own. 
+(MCSceneController*)sharedSceneController
{
  static MCSceneController *sharedSceneController;
  @synchronized(self)
  {
    if (!sharedSceneController)
      sharedSceneController = [[MCSceneController alloc] init];
	}
	return sharedSceneController;
}


#pragma mark scene preload

// this is where we initialize all our scene objects
-(void)loadScene
{needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	
	// our 'character' object
	TestCube * magicCube = [[TestCube alloc] init];
    //[magicCube.mesh setColors:&colorss];
	magicCube.translation = MCPointMake(30.0, 0.0, 0.0);
	magicCube.scale = MCPointMake(60, 60, 60);
    magicCube.rotation = MCPointMake(0, 0, 0);
    magicCube.rotationalSpeed = MCPointMake(20, 20, 20);
	[self addObjectToScene:magicCube];
	[magicCube release];	
    
	
	// if we do not have a collision controller, then make one and link it to our
	// sceneObjects
//	if (collisionController == nil) collisionController = [[MCCollisionController alloc] init];
//	collisionController.sceneObjects = sceneObjects;
//	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
    
	// reload our interface
	[inputController loadInterface];

    
}




-(void)gameOver
{
    //this selector would be the action take by interface when the puzzle is solved. but now it is not implement.
	[inputController gameOver];
}
#pragma mark dealloc


- (void) dealloc
{
	
	[super dealloc];
}
- (void)releaseSrc{
    [self stopAnimation];
    [self restartScene];
}


@end
