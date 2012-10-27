//
//  MCSceneController.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sceneController.h"


@interface MCSceneController : sceneController {
	}



+ (MCSceneController*)sharedSceneController;

- (void)loadScene;

- (void)gameOver;
// 11 methods
- (void)releaseSrc;
@end
