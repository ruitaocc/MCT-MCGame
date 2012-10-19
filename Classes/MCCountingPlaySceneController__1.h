//
//  MCCountingPlaySceneController.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSceneController.h"
#import "MCCountingPlayInputViewController__1.h"
@interface MCCountingPlaySceneController : MCSceneController{
    
}
+ (MCCountingPlaySceneController*)sharedCountingPlaySceneController;
-(void)loadScene;
@end
