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
@interface CoordinatingController : NSObject{
    @private
    MCSceneController * mcSceneController;
    MCCountingPlaySceneController *countingPlaySceneController;
}
@property (nonatomic ,readonly)MCSceneController *mcSceneController;
@property (nonatomic, readonly )MCCountingPlaySceneController *countingPlaySceneController;

+(CoordinatingController *) sharedCoordinatingController;
-(void)requestViewChangeByObject:(int)type;
@end
