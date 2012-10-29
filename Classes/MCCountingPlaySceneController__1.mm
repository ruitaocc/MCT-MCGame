//
//  MCCountingPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlaySceneController__1.h"
#import "TestCube.h"
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
	
	// our 'character' object
	TestCube * magicCube2 = [[TestCube alloc] init];
    magicCube2.translation = MCPointMake(0.0, 0.0, 0.0);
	magicCube2.scale = MCPointMake(35, 35, 35);
    magicCube2.rotation = MCPointMake(0, 0, 0);
    magicCube2.rotationalSpeed = MCPointMake(20, 20, 20);
    
	[self addObjectToScene:magicCube2];
	[magicCube2 release];		
    
	
	    
	// reload our interface
	[inputController loadInterface];
}
@end
