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
@synthesize _mainSceneController,_countingPlaySceneController;
@synthesize  currentController;
@synthesize needToReload;
@synthesize userManagerSystemViewController;
@synthesize window;

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
    _countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    _mainSceneController = [MCSceneController sharedSceneController];
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
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadCountingPlayScene) userInfo:nil repeats:NO];
            

           
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
        case kScoreBoard2MainMenu:
        {
            NSLog(@"requestViewChangeByObject:kScoreBoard2MainMenu");
            //[userManagerSystemViewController pushViewController:userManagerSystemViewController];
            //[currentController presentModalViewController:[currentController inputController] animated:NO];
            [currentController.inputController dismissModalViewControllerAnimated:YES];
            
        }
        break;
        case kNormalPlay:
        {
            
            NSLog(@"requestViewChangeByObject:kNormalPlay");
            
        }
        break;
        case kRandomSolve:
        {
            NSLog(@"requestViewChangeByObject:kRandomSolve");
            
        }
        break;
        case kHeroBoard:
        {
            NSLog(@"requestViewChangeByObject:kHeroBoard");
            userManagerSystemViewController = [[[UserManagerSystemViewController alloc] initWithNibName:@"UserManagerSystemViewController" bundle:nil] autorelease];
            [[currentController inputController]presentModalViewController:userManagerSystemViewController animated:YES];
            //[currentController.inputController resignFirstResponder];
            
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
    _countingPlaySceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    MCCountingPlayInputViewController * countingInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
    
    [currentController.inputController setView:nil];
    _countingPlaySceneController.inputController = countingInputController;
    [countingInputController release];
    
    _countingPlaySceneController.inputController.view = [currentController openGLView] ;
    _countingPlaySceneController.openGLView = [currentController openGLView];
    
    [_countingPlaySceneController.inputController resignFirstResponder];
    
    [window setRootViewController:_countingPlaySceneController.inputController];
    currentController = _countingPlaySceneController;
    [currentController removeAllObjectFromScene];
    [currentController loadScene];
    [currentController startScene];
    [currentController startAnimation];
    //sleep(1);
    
}
-(void)loadMainMenuScene{
    [SVProgressHUD dismiss];
    [currentController stopAnimation];
    
    _mainSceneController = [MCSceneController sharedSceneController];
    MCInputViewController * anInputController = [[MCInputViewController alloc] initWithNibName:nil bundle:nil];
	
    [currentController.inputController setView:nil];
    _mainSceneController.inputController = anInputController;
	[anInputController release];
	_mainSceneController.inputController.view = [currentController openGLView];
	_mainSceneController.openGLView = [currentController openGLView];
    
    [_mainSceneController.inputController resignFirstResponder];
    
     [window setRootViewController:_mainSceneController.inputController];
    
    currentController = _mainSceneController;
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
