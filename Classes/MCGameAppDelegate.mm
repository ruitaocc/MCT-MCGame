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
#import "MCCountingPlayInputViewController__1.h"
#import "MCCountingPlaySceneController__1.h"
#import "CoordinatingController.h"
#import "MCOBJLoader.h"
@implementation MCGameAppDelegate

@synthesize window;

+ (MCGameAppDelegate*)sharedMCGameAppDelegate{
    static MCGameAppDelegate *sharedMCGameAppDelegate;
    @synchronized(self)
    {
        if (!sharedMCGameAppDelegate)
            sharedMCGameAppDelegate = [[MCGameAppDelegate alloc] init];
	}
	return sharedMCGameAppDelegate;
}
- (void)applicationDidFinishLaunching:(UIApplication *)application 
{   
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"oneCube1" ofType:@"obj"];
    MCOBJLoader *tmp = [MCOBJLoader sharedMCOBJLoader];
    [tmp loadObjFromFile:filename objkey:nil];
    
    
    
    //场景对象控制器
	MCSceneController * sceneController = [MCSceneController sharedSceneController];
	//MCCountingPlaySceneController * sceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    
    [CoordinatingController sharedCoordinatingController].currentController= sceneController;
    
    //创建输入控制器，并绑定到场景控制器
	// make a new input view controller, and save it as an instance variable
	MCInputViewController * anInputController = [[MCInputViewController alloc] initWithNibName:nil bundle:nil];
    //MCCountingPlayInputViewController * anInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
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
    
    //创建其他的控制器和视图
    //计时竞赛场景控制
    MCCountingPlaySceneController * countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    //创建输入控制器，并绑定到场景控制器
    // make a new input view controller, and save it as an instance variable
    MCCountingPlayInputViewController * countingInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
    countingPlaySceneController.inputController = countingInputController;
    [countingInputController release];
    //创建glview
    // init our main EAGLView with the same bounds as the window
    EAGLView * glView_counting =  [[EAGLView alloc] initWithFrame:window.bounds];
    countingPlaySceneController.inputController.view = glView_counting;
    countingPlaySceneController.openGLView = glView_counting;
    [glView_counting release];
   
       [countingPlaySceneController loadScene];
    

    
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
