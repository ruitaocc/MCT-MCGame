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
    [super init];
}
#pragma mark -
#pragma mark a method for view transitions
-(void)requestViewChangeByObject:(int)type{
    switch (type) {
        case kCountingPlay:
        {
            NSLog(@"requestViewChangeByObject:kCountingPlay");
            [currentController stopAnimation];
            
                        
            [currentController.inputController presentModalViewController: countingPlaySceneController.inputController animated:YES];
            
            //将当前控制器置为计时场景控制器
            currentController = countingPlaySceneController;

            //[countingPlaySceneController startAnimation];
           
           
            [NSTimer scheduledTimerWithTimeInterval:1/4 target:self selector:@selector(reloadMeterial) userInfo:nil repeats:NO];
                        
            
            
            
           
        }
        break;
        case kMainMenu:
        {
            NSLog(@"requestViewChangeByObject:kMainMenu");
            //[countingPlaySceneController stopAnimation];
            
            InputController * mainInputController =  mainSceneController.inputController;
            [mainInputController dismissModalViewControllerAnimated:YES];
            
            currentController =mainSceneController;
            
            [currentController startAnimation];
            [NSTimer scheduledTimerWithTimeInterval:1/4 target:self selector:@selector(reloadMeterial) userInfo:nil repeats:NO];
            
       
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
-(void)reloadMeterial{
    if (needToReload == false) {
        return;
    }
    NSLog(@"reloadMeterial");
    //[[MCMaterialController sharedMaterialController]dealloc];
    //[MCMaterialController sharedMaterialController];
     [[MCMaterialController sharedMaterialController]reload];
 
    [[CoordinatingController sharedCoordinatingController].currentController startScene];
    needToReload = false;

}

@end
