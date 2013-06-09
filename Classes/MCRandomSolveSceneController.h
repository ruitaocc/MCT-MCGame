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
#import "MCMagicCubeUIModelController.h"
#import "MCPoint.h"

@interface MCRandomSolveSceneController : sceneController{
    MCMagicCubeUIModelController* magicCubeUI;
    MCMagicCube * magicCube;
    MCPlayHelper * playHelper;
    int selected_index;
    int selected_face_index;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (nonatomic,retain)MCPlayHelper * playHelper;
@property (assign)int selected_index;
@property (assign)int selected_face_index;


+ (MCRandomSolveSceneController*)sharedRandomSolveSceneController;

-(void)loadScene;

-(void)releaseSrc;

-(BOOL)isSelectOneFace:(vec2)touchpoint;

-(void)flashSecne;

@end
