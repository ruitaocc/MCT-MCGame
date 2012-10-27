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
@interface CoordinatingController : NSObject{
    sceneController * currentController;
@private
    MCSceneController * mainSceneController;
    MCCountingPlaySceneController *countingPlaySceneController;
    
}
@property (nonatomic ,readonly)MCSceneController *mainSceneController;
@property (nonatomic, readonly )MCCountingPlaySceneController *countingPlaySceneController;
@property (nonatomic, retain )sceneController *currentController;

+(CoordinatingController *) sharedCoordinatingController;
-(void)requestViewChangeByObject:(int)type;
@end
