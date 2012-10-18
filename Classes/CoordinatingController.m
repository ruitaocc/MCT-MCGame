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
@synthesize mcSceneController,countingPlaySceneController;

#pragma mark -
#pragma mark a method for view transitions
-(void)requestViewChangeByObject:(int)type{
    switch (type) {
        case kCountingPlay:
        {
            //do something to view transition
            //场景对象控制器
            MCCountingPlaySceneController * sceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
            
            //创建输入控制器，并绑定到场景控制器
            // make a new input view controller, and save it as an instance variable
            MCCountingPlayInputViewController * anInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
            sceneController.inputController = anInputController;
            [anInputController release];
            
            //创建glview
            // init our main EAGLView with the same bounds as the window
            EAGLView * glView = [[EAGLView alloc] initWithFrame:[[MCGameAppDelegate sharedMCGameAppDelegate]window].bounds ];
            sceneController.inputController.view = glView;
            sceneController.openGLView = glView;
            [glView release];
            
            // set our view as the first window view
            [[[MCGameAppDelegate sharedMCGameAppDelegate]window] addSubview:sceneController.inputController.view];
            [[[MCGameAppDelegate sharedMCGameAppDelegate]window] makeKeyAndVisible];
            
            //开始游戏循环
            // begin the game.
            [sceneController loadScene];
            [sceneController startScene];
        }
        break;
            
        default:
            break;
    }
}
@end
