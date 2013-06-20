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
//#import "MCPlayHelper.h"
#import "MCCollisionController.h"
#import "MCMagicCubeUIModelController.h"
#import "MCPoint.h"
@interface MCRandomSolveSceneController : sceneController{
    MCMagicCubeUIModelController* magicCubeUI;
//    MCPlayHelper * playHelper;
    int selected_index;
    int selected_face_index;
     UILabel *_tipsLabel;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
//@property (nonatomic,retain)MCPlayHelper * playHelper;
@property (assign)int selected_index;
@property (assign)int selected_face_index;
@property(nonatomic,retain)UILabel *tipsLabel;

+ (MCRandomSolveSceneController*)sharedRandomSolveSceneController;

-(void)loadScene;

//将魔方设置为教学模式下
-(void)turnTheMCUI_Into_SOlVE_Play_MODE;

-(void)rotateWithSingmasterNotation:(SingmasterNotation)notation isNeedStay:(BOOL)isStay isTwoTimes:(BOOL)isTwoTimes;

-(void)clearState;

-(void)releaseSrc;

-(void)previousSolution;

-(void)nextSolution;

-(BOOL)isSelectOneFace:(vec2)touchpoint;

-(void)flashSecne;

-(void)nextSingmasterNotation:(SingmasterNotation)notation;

-(void)closeSingmasterNotation;

@end
