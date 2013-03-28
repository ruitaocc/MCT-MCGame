//
//  MCNormalPlaySceneController.h
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//
#import <Foundation/Foundation.h>
#import "sceneController.h"
#import "MCMagicCube.h"
#import "MCMagicCubeUIModelController.h"
#import "RotateType.h"
@interface MCNormalPlaySceneController : sceneController{
    //MCMagicCubeUIModelController* magicCubeUI;
    //MCMagicCube * magicCube;
}
//@property (nonatomic,retain)MCMagicCubeUIModelController* magicCubeUI;
@property (nonatomic,retain)MCMagicCube * magicCube;

+ (MCNormalPlaySceneController*)sharedNormalPlaySceneController;
-(void)loadScene;

-(void)rotate:(RotateType*)rotateType;
-(void)previousSolution;
-(void)nextSolution;
-(void)reloadLastTime;
@end
