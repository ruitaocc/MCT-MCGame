//
//  MCCountingPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlaySceneController__1.h"
#import "MCCountingPlayInputViewController__1.h"
#import "EAGLView.h"
#import "MCSceneObject.h"
#import "MCConfiguration.h"
#import "MCPoint.h"
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
	TestCube * magicCube = [[TestCube alloc] init];
	magicCube.translation = MCPointMake(0.0, 0.0, 0.0);
	magicCube.scale = MCPointMake(40, 40, 40);
    magicCube.rotation = MCPointMake(0, 0, 0);
    magicCube.rotationalSpeed = MCPointMake(20, 20, 20);
	[self addObjectToScene:magicCube];
	[magicCube release];	
    
	
	    
	// reload our interface
	[inputController loadInterface];
}
@end
