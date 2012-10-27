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
#import "MCMaterialController.h"
#import "MCInputViewController.h"
#import "MCCountingPlayInputViewController__1.h"
@implementation CoordinatingController
@synthesize mainSceneController,countingPlaySceneController;
@synthesize  currentController;



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
            
            //计时竞赛场景控制
            countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
            //当前场景控制
            mainSceneController = (MCSceneController*)[[CoordinatingController sharedCoordinatingController] currentController];
             InputController * mainInputController = mainSceneController.inputController ;
            //将当前控制器置为计时场景控制器
            [CoordinatingController sharedCoordinatingController].currentController = countingPlaySceneController;
            
            [mainInputController presentModalViewController: countingPlaySceneController.inputController animated:YES];
            
            [mainSceneController stopAnimation];
            
            
            [countingPlaySceneController startScene];
            [[countingPlaySceneController inputController ]becomeFirstResponder];
            
           
        }
        break;
        case kMainMenu:
        {
            NSLog(@"will return mainmenu");
            InputController * mainInputController =  [[CoordinatingController sharedCoordinatingController]currentController ].inputController;
            [mainInputController dismissModalViewControllerAnimated:YES];
            
            [CoordinatingController sharedCoordinatingController].currentController = [MCSceneController sharedSceneController];
            
            [[[CoordinatingController sharedCoordinatingController] currentController] startAnimation];
            //[mainInputController resignFirstResponder];
            
            [[[[CoordinatingController sharedCoordinatingController]currentController ].inputController view ]becomeFirstResponder ];
       
        }
            break;
        default:
            break;
    }
}
@end
