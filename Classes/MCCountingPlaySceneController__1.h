//
//  MCCountingPlaySceneController.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sceneController.h"
#import "MCCollisionController.h"
@interface MCCountingPlaySceneController : sceneController{
    
}
+ (MCCountingPlaySceneController*)sharedCountingPlaySceneController;
-(void)loadScene;
-(void)rotateTest;
@end
