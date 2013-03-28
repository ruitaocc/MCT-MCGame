//
//  CoordinatingController.h
//  MCGame
//
//  Created by kwan terry on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCCountingPlaySceneController__1.h"
#import "MCSceneController.h"
#import "inputController.h"
#import "sceneController.h"
#import "MBProgressHUD.h"
#import "UserManagerSystemViewController.h"
#import "MCNormalPlaySceneController.h"
@interface CoordinatingController : NSObject <MBProgressHUDDelegate>{
    sceneController * currentController;
    MBProgressHUD *HUD;
    UIWindow *window;
@private
    MCSceneController * _mainSceneController;
    MCCountingPlaySceneController *_countingPlaySceneController;
    MCNormalPlaySceneController *_normalPlaySceneController;
    UserManagerSystemViewController *userManagerSystemViewController;
    BOOL needToReload;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (assign)BOOL needToReload;
@property (nonatomic ,readonly)MCSceneController *_mainSceneController;
@property (nonatomic, readonly )MCCountingPlaySceneController *_countingPlaySceneController;
@property (nonatomic, readonly )MCNormalPlaySceneController *_normalPlaySceneController;

@property (nonatomic,assign)sceneController *currentController;
@property (nonatomic,retain)UserManagerSystemViewController *userManagerSystemViewController;
+(CoordinatingController *) sharedCoordinatingController;
-(void)requestViewChangeByObject:(int)type;
-(void)reloadMeterial;
@end
