//
//  MCRandomSolveViewController.h
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "sceneController.h"
#import "MCMagicCube.h"
#import "RotateType.h"
#import "MCPlayHelper.h"
#import "MCCollisionController.h"
@interface MCRandomSolveSceneController : sceneController{
    MCMagicCube * magicCube;
    MCPlayHelper * playHelper;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (nonatomic,retain)MCPlayHelper * playHelper;
+ (MCRandomSolveSceneController*)sharedRandomSolveSceneController;

-(void)loadScene;

@end
