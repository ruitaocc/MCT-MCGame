//
//  MCCountingPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlaySceneController__1.h"
#import "MCMagicCubeUIModelController.h"
#import "MCCountingPlayInputViewController__1.h"
#import "Cube.h"
#import "MCMultiDigitCounter.h"
#import "MCBackGroundTexMesh.h"
@implementation MCCountingPlaySceneController
@synthesize magicCube;
//@synthesize playHelper;
+(MCCountingPlaySceneController*)sharedCountingPlaySceneController
{
    static MCCountingPlaySceneController *sharedCountingPlaySceneController;
    @synchronized(self)
    {
        if (!sharedCountingPlaySceneController)
            sharedCountingPlaySceneController = [[MCCountingPlaySceneController alloc] init];
	}
	return sharedCountingPlaySceneController;
}

-(void)rotate:(RotateType *)rotateType{
    [magicCube rotateWithSingmasterNotation:[rotateType notation]];
    [magicCubeUI flashWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    [self checkIsOver];
}


-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	magicCube = [[MCMagicCube magicCube]retain];
    //随机置乱魔方
    //[self randomMagiccube];
    //背景
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    //魔方模型
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
	    
	// reload our interface
	[(MCCountingPlayInputViewController*)inputController loadInterface];
}

-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [(MCCountingPlayInputViewController*)inputController stepcounter];
    [tmp addCounter];
}
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [(MCCountingPlayInputViewController*)inputController stepcounter];
    [tmp minusCounter];
}


//检测是否结束
-(void)checkIsOver{
    if ([[self magicCube] isFinished]) {
        [((MCCountingPlayInputViewController*)[self inputController])showFinishView];
        NSLog(@"END form Scene");
    }
};



-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [magicCubeUI performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [magicCubeUI performSelector:@selector(nextSolution)];
}

-(void)randomMagiccube{
    RANDOM_SEED();
    //更新下一次spaceindicator方向
    AxisType lastRandomAxis = X;
    AxisType axis;
    for (int i = 0; i<20; i++) {
        axis = (AxisType)(RANDOM_INT(0, 2));
        if (axis==lastRandomAxis) {
            axis = (AxisType)((lastRandomAxis+1)%3);
        }
        lastRandomAxis = axis;
        LayerRotationDirectionType direction = (LayerRotationDirectionType)(RANDOM_INT(0, 1));
        int layer = RANDOM_INT(0, 2);
        [magicCube rotateOnAxis:axis onLayer:layer inDirection:direction];
    }

}
-(void)flashScene{
    [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];
};
-(void)releaseSrc{
    [super releaseSrc];
}

@end
