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
#import "Cube.h"
#import "MCBackGroundTexMesh.h"
#import "MCMagicCubeUIModelController.h"
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
	
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    /*
	// our 'character' object
	Cube * magicCube = [[Cube alloc] init];
    //[magicCube.mesh setColors:&colorss];
	magicCube.pretranslation = MCPointMake(0.0, 40.0, 0.0);
	magicCube.scale = MCPointMake(60, 60, 60);
    magicCube.prerotation = MCPointMake(30, 30, 0);
    magicCube.rotationalSpeed = MCPointMake(20, 20, 20);
	[self addObjectToScene:magicCube];
	[magicCube release];
	*/
    //大魔方
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiate] ;
    magicCubeUI.target=self;
    [magicCubeUI setUsingMode:SOlVE_Input_MODE];
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];

    
	
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
	if([inputController respondsToSelector:@selector(gameOver)]){
      //  [inputController gameOver];
    }
}
#pragma mark dealloc


- (void) dealloc
{
	
	[super dealloc];
}
- (void)releaseSrc{
    [super releaseSrc];
    //[self stopAnimation];
    //[self restartScene];
}


@end
