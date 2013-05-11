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
#import "MCPlayHelper.h"
@interface MCNormalPlaySceneController : sceneController{
    MCMagicCubeUIModelController* magicCubeUI;
    MCMagicCube * magicCube;
    MCPlayHelper * playHelper;
    BOOL isShowQueue;
     UILabel *_tipsLabel;
}
//@property (nonatomic,retain)MCMagicCubeUIModelController* magicCubeUI;
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (nonatomic,retain)MCPlayHelper * playHelper;
@property (assign)BOOL isShowQueue;
@property(nonatomic,retain)UILabel *tipsLabel;
+ (MCNormalPlaySceneController*)sharedNormalPlaySceneController;
-(void)loadScene;

-(void)rotate:(RotateType*)rotateType;
-(void)previousSolution;
-(void)nextSolution;
-(void)reloadLastTime;
-(void)showQueue;
@end
