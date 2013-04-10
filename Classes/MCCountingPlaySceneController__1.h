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
#import "MCMagicCube.h"
#import "RotateType.h"
#import "MCPlayHelper.h"
@interface MCCountingPlaySceneController : sceneController{
    MCMagicCube * magicCube;
    MCPlayHelper * playHelper;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (nonatomic,retain)MCPlayHelper * playHelper;
+ (MCCountingPlaySceneController*)sharedCountingPlaySceneController;

-(void)loadScene;
-(void)rotate:(RotateType*)rotateType;
-(void)previousSolution;
-(void)nextSolution;

@end
