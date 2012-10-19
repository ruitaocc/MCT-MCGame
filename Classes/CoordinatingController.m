//
//  CoordinatingController.m
//  MCGame
//
//  Created by kwan terry on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CoordinatingController.h"
#import "MCConfiguration.h"
#import "MCGameAppDelegate.h"
#import "EAGLView.h"
@implementation CoordinatingController
@synthesize rootSceneController,countingPlaySceneController;



+ (CoordinatingController*)sharedCoordinatingController{
    static CoordinatingController *sharedCoordinatingController;
    @synchronized(self)
    {
        if (!sharedCoordinatingController)
            sharedCoordinatingController = [[CoordinatingController alloc] init];
	}
	return sharedCoordinatingController;
}

#pragma mark -
#pragma mark a method for view transitions
-(void)requestViewChangeByObject:(int)type{
    switch (type) {
        case kCountingPlay:
        {
            NSLog(@"requestViewChangeByObject:kCountingPlay");
            //do something to view transition
            //场景对象控制器
            countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
            rootSceneController = [MCSceneController sharedSceneController];
             InputController * rootInputController = [MCSceneController sharedSceneController].inputController ;
            
            //创建输入控制器，并绑定到场景控制器
            // make a new input view controller, and save it as an instance variable
            MCCountingPlayInputViewController * anInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
            countingPlaySceneController.inputController = anInputController;
            [anInputController release];
            
            //创建glview
            // init our main EAGLView with the same bounds as the window
            EAGLView * glView = [[EAGLView alloc] initWithFrame:[[MCGameAppDelegate sharedMCGameAppDelegate]window].bounds ];
            countingPlaySceneController.inputController.view = glView;
            countingPlaySceneController.openGLView = glView;
            [glView release];
            
            [rootSceneController stopAnimation];
            [rootSceneController restartScene];
           
           
            
            
            [rootInputController presentModalViewController: countingPlaySceneController.inputController animated:YES];
            
            // [[MCSceneController sharedSceneController] releaseSrc ];
            // set our view as the first window view
            
         //   [[[MCGameAppDelegate sharedMCGameAppDelegate]window] addSubview:sceneController.inputController.view];
          //  [[[MCGameAppDelegate sharedMCGameAppDelegate]window] makeKeyAndVisible];
            
            //开始游戏循环
            // begin the game.
            [[countingPlaySceneController inputController] becomeFirstResponder];
            [[countingPlaySceneController.inputController view] becomeFirstResponder];
           
            [countingPlaySceneController loadScene];
            [countingPlaySceneController startScene];
            
            
        }
        break;
        case kMainMenu:
        {
            NSLog(@"will return mainmenu");
            InputController * rootInputController = [[MCSceneController sharedSceneController].inputController retain];
            [rootInputController dismissModalViewControllerAnimated:YES];
       
        }
            break;
        default:
            break;
    }
}
@end
