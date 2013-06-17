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
#import "MCBackGroundTexMesh.h"

@implementation MCRandomSolveSceneController

@synthesize magicCube,playHelper;
@synthesize selected_face_index;
@synthesize selected_index;

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
    selected_index = -1;
    selected_face_index = -1;
    
    //初始化只有中心小块到魔方
    magicCube = [[MCMagicCube magicCubeOnlyWithCenterColor]retain];
    
    playHelper = [[MCPlayHelper playerHelperWithMagicCube:self.magicCube]retain];
    //背景
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    
    //
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[magicCube getColorInOrientationsOfAllCubie]] ;
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI setUsingMode:SOlVE_Input_MODE];
    [magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
    
	// reload our interface
	[(MCRandomSolveViewInputControllerViewController*)inputController loadInterface];
    
}

-(BOOL)isSelectOneFace:(vec2)touchpoint{
    if ([magicCubeUI isSelectOneFace:touchpoint]) {
        selected_index = [magicCubeUI selected_cube_index];
        selected_face_index = [magicCubeUI selected_cube_face_index];
        return YES;
    }else
        return NO;
};
-(void)flashSecne{
    [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];
};

-(void)releaseSrc{
    [super releaseSrc];
}

- (void)dealloc{
    [super dealloc];
}

@end
