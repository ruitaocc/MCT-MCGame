//
//  MCCountingPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlaySceneController__1.h"
#import "MCMagicCubeUIModelController.h"
#import "Cube.h"
#import "MCMultiDigitCounter.h"
@implementation MCCountingPlaySceneController
@synthesize magicCube;
@synthesize playHelper;
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
    [self.playHelper rotateOnAxis:[rotateType rotate_axis] onLayer:[rotateType rotate_layer] inDirection:[rotateType rotate_direction]];
}


-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	magicCube = [[MCMagicCube magicCube]retain];
    playHelper = [[MCPlayHelper playerHelperWithMagicCube:magicCube]retain];
    
	// our 'character' object
	/*
    Cube * magicCube0 = [[Cube alloc] init];
    magicCube0.translation = MCPointMake(300.0, 0.0, 0.0);
	magicCube0.scale = MCPointMake(scale, scale, scale);
    magicCube0.rotation = MCPointMake(0, 0, 0);
    magicCube0.rotationalSpeed = MCPointMake(0, 0, 0);
    
    [self addObjectToScene:magicCube0];
	[magicCube0 release];		
    */
    //大魔方
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
	    
	// reload our interface
	[inputController loadInterface];
}

-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [inputController stepcounter];
    [tmp addCounter];
}
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [inputController stepcounter];
    [tmp minusCounter];
}





-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(nextSolution)];
}

@end
