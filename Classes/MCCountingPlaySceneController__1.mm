//
//  MCCountingPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlaySceneController__1.h"
#import "MCMagicCubeUIModelController.h"
#import "MCCountingPlayInputViewController__1.h"
#import "Cube.h"
#import "MCMultiDigitCounter.h"
#import "MCBackGroundTexMesh.h"
@implementation MCCountingPlaySceneController
@synthesize magicCube;
//@synthesize playHelper;
+(MCCountingPlaySceneController*)sharedCountingPlaySceneController
{
    static MCCountingPlaySceneController *sharedCountingPlaySceneController;
    @synchronized(self)
    {
        if (!sharedCountingPlaySceneController)
            sharedCountingPlaySceneController = [[MCCountingPlaySceneController alloc] init];
	}
	return sharedCountingPlaySceneController;
}

-(void)rotate:(RotateType *)rotateType{
    [magicCube rotateWithSingmasterNotation:[rotateType notation]];
    [magicCubeUI flashWithState:[ magicCube getColorInOrientationsOfAllCubie]];
}


-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	magicCube = [[MCMagicCube magicCube]retain];
    
    //背景
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    //大魔方
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
	    
	// reload our interface
	[(MCCountingPlayInputViewController*)inputController loadInterface];
}

-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [(MCCountingPlayInputViewController*)inputController stepcounter];
    [tmp addCounter];
}
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [(MCCountingPlayInputViewController*)inputController stepcounter];
    [tmp minusCounter];
}





-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [magicCubeUI performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [magicCubeUI performSelector:@selector(nextSolution)];
}

-(void)releaseSrc{
    [super releaseSrc];
}

@end
