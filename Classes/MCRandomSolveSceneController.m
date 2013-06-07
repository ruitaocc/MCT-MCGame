//
//  MCRandomSolveViewController.m
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "MCRandomSolveSceneController.h"
#import "MCConfiguration.h"
#import "MCMagicCubeUIModelController.h"
#import "MCRandomSolveViewInputControllerViewController.h"
@implementation MCRandomSolveSceneController
@synthesize magicCube,playHelper;
+(MCRandomSolveSceneController*)sharedRandomSolveSceneController
{
    static MCRandomSolveSceneController *sharedRandomSolveSceneController;
    @synchronized(self)
    {
        if (!sharedRandomSolveSceneController)
            sharedRandomSolveSceneController = [[MCRandomSolveSceneController alloc] init];
	}
	return sharedRandomSolveSceneController;
}
-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];
	
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]] ;
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
    
	// reload our interface
	[(MCRandomSolveViewInputControllerViewController*)inputController loadInterface];
}

@end
