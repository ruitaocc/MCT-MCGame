//
//  MCGameAppDelegate.m
//  MCGame
//
//  
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "MCGameAppDelegate.h"

#import "MCInputViewController.h"
#import "EAGLView.h"
#import "MCSceneController.h"

@implementation MCGameAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{   
    //场景对象控制器
	MCSceneController * sceneController = [MCSceneController sharedSceneController];
	
    //创建输入控制器，并绑定到场景控制器
	// make a new input view controller, and save it as an instance variable
	MCInputViewController * anInputController = [[MCInputViewController alloc] initWithNibName:nil bundle:nil];
	sceneController.inputController = anInputController;
	[anInputController release];
	
    //创建glview
	// init our main EAGLView with the same bounds as the window
	EAGLView * glView = [[EAGLView alloc] initWithFrame:window.bounds];
	sceneController.inputController.view = glView;
	sceneController.openGLView = glView;
	[glView release];
	
	// set our view as the first window view
	[window addSubview:sceneController.inputController.view];
	[window makeKeyAndVisible];
	
    //开始游戏循环
	// begin the game.
	[sceneController loadScene];
	[sceneController startScene];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
