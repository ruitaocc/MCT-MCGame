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
#import "SVProgressHUD.h"
@implementation CoordinatingController
@synthesize mainSceneController,countingPlaySceneController;
@synthesize  currentController;
@synthesize needToReload;



+ (CoordinatingController*)sharedCoordinatingController{
    static CoordinatingController *sharedCoordinatingController;
    @synchronized(self)
    {
        if (!sharedCoordinatingController)
            sharedCoordinatingController = [[CoordinatingController alloc] init];
	}
	return sharedCoordinatingController;
}

-(id)init{
    needToReload = true;
    countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    mainSceneController = [MCSceneController sharedSceneController];
    currentController = [MCSceneController sharedSceneController];
    [super init];
    
}
#pragma mark -
#pragma mark a method for view transitions
-(void)requestViewChangeByObject:(int)type{
    switch (type) {
        case kCountingPlay:
        {
            //log
            NSLog(@"requestViewChangeByObject:kCountingPlay");
            [currentController stopAnimation];

            
            
//            HUD = [[MBProgressHUD alloc] initWithView:currentController.openGLView];
//            [currentController.openGLView addSubview:HUD];
//            HUD.dimBackground = YES;
//            // Regiser for HUD callbacks so we can remove it from the window at the right time
//            HUD.delegate = self;
//            // Show the HUD while the provided method executes in a new thread
//            [HUD showWhileExecuting:@selector(loadCountingPlayScene) onTarget:self withObject:nil animated:YES];
//
            
            
            
            
            
            //Loading...
            //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            //load the new scene            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadCountingPlayScene) userInfo:nil repeats:NO];
            

           
        }
        break;
        case kMainMenu:
        {
            NSLog(@"requestViewChangeByObject:kMainMenu");
            //Loading...
            [SVProgressHUD show];
            [currentController stopAnimation];

            //load the new scene            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadMainMenuScene) userInfo:nil repeats:NO];
            
       
        }
        break;
        case kNormalPlay:
        {
            
            NSLog(@"requestViewChangeByObject:kNormalPlay");
            [[[CoordinatingController sharedCoordinatingController]currentController]stopAnimation];
        }
        break;
        case kRandomSolve:
        {
            NSLog(@"requestViewChangeByObject:kRandomSolve");
            [[[CoordinatingController sharedCoordinatingController]currentController]startAnimation];
        }
        break;
        default:
            break;
    }
}

-(void)loadCountingPlayScene{
    [SVProgressHUD dismiss];
    //[SVProgressHUD dismiss];
    [currentController stopAnimation];
    MCCountingPlaySceneController * countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    MCCountingPlayInputViewController * countingInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
    countingPlaySceneController.inputController = countingInputController;
    [countingInputController release];
    
    countingPlaySceneController.inputController.view = [currentController openGLView] ;
    countingPlaySceneController.openGLView = [currentController openGLView];
    [countingPlaySceneController.inputController resignFirstResponder];
    
    currentController = countingPlaySceneController;
    [currentController removeAllObjectFromScene];
    [currentController loadScene];
    [currentController startScene];
    [currentController startAnimation];
    //sleep(1);
    
}
-(void)loadMainMenuScene{
    [SVProgressHUD dismiss];
    [currentController stopAnimation];
    
    MCSceneController * mainSceneController = [MCSceneController sharedSceneController];
    MCInputViewController * anInputController = [[MCInputViewController alloc] initWithNibName:nil bundle:nil];
	mainSceneController.inputController = anInputController;
	[anInputController release];
	mainSceneController.inputController.view = [currentController openGLView];
	mainSceneController.openGLView = [currentController openGLView];
    
    [mainSceneController.inputController resignFirstResponder];
    
    currentController = mainSceneController;
    [currentController removeAllObjectFromScene];;
    [currentController loadScene];
    [currentController startScene];
    [currentController startAnimation];
    [SVProgressHUD dismiss];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}
@end
