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

@implementation MCCountingPlaySceneController

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



-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	
    float scale = 60.0;
    
	// our 'character' object
	/*
    TestCube * magicCube0 = [[TestCube alloc] init];
    magicCube0.translation = MCPointMake(0.0, 0.0, 0.0);
	magicCube0.scale = MCPointMake(scale, scale, scale);
    magicCube0.rotation = MCPointMake(0, 0, 0);
    magicCube0.rotationalSpeed = MCPointMake(0, 0, 0);
    
    [self addObjectToScene:magicCube0];
	[magicCube0 release];		
    */
    
    //大魔方
    MCMagicCubeUIModelController *magicCube = [[MCMagicCubeUIModelController alloc]initiate];
    [self addObjectToScene:magicCube];
    [magicCube release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = sceneObjects;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
	    
	// reload our interface
	[inputController loadInterface];
}

-(void)rotateTest{
    NSLog(@"mc rotate test");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(rotateTest)];
};
@end
