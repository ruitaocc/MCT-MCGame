//
//  MCNormalPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "MCNormalPlaySceneController.h"
#import "MCMagicCubeUIModelController.h"
#import "Cube.h"
#import "MCMultiDigitCounter.h"
#import "MCCollisionController.h"
#import "MCNormalPlayInputViewController.h"
@implementation MCNormalPlaySceneController
//@synthesize magicCubeUI;
@synthesize magicCube;
@synthesize playHelper;
+(MCNormalPlaySceneController*)sharedNormalPlaySceneController
{
    static MCNormalPlaySceneController *sharedNormalPlaySceneController;
    @synchronized(self)
    {
        if (!sharedNormalPlaySceneController)
            sharedNormalPlaySceneController = [[MCNormalPlaySceneController alloc] init];
	}
	return sharedNormalPlaySceneController;
}

-(void)rotate:(RotateType *)rotateType{
    //流程1，通知数据模型UI已经旋转
    [playHelper rotateOnAxis:[rotateType rotate_axis] onLayer:[rotateType rotate_layer] inDirection:[rotateType rotate_direction]];
    //流程2，询问是否正确
    RotationResult result = [playHelper getResultOfTheLastRotation];
    if (result == Accord) {
        //流程2.1，正确，队列右移动一位
        [[(MCNormalPlayInputViewController*)inputController actionQueue]shiftRight];
        
    }else if(result == Disaccord){
        //流程2.2，错误，
        //流程2.2.1，获取应该插入队列extraRotations
        NSArray *actionAry = [playHelper extraRotations];
        [[(MCNormalPlayInputViewController*)inputController actionQueue] insertQueueCurrentIndexWithNmaeList:actionAry];
         
    }else if (result==StayForATime){
        //do nothing
    }else if (result ==Finished){
        //结束，清空当前队列
        [[(MCNormalPlayInputViewController*)inputController actionQueue]removeAllActions];
        //重新加载队列，applyRules ,
        NSDictionary *rules = [[playHelper applyRules] retain];
        NSArray *actionqueue = [[rules objectForKey:RotationQueueKey] retain];
        [[(MCNormalPlayInputViewController*)inputController actionQueue] insertQueueCurrentIndexWithNmaeList:actionqueue];
    }else if (result ==NoneResult){
        //do nothing
    }
    
}

-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];
	
    float scale = 60.0;
    
	magicCube = [[MCMagicCube magicCube]retain];
    playHelper = [[MCPlayHelper playerHelperWithMagicCube:self.magicCube]retain];
    //[playHelper applyRules];
    //大魔方
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiate];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    //[magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	// reload our interface
	[inputController loadInterface];
}

-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [inputController stepcounter];
    [tmp addCounter];
}
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [inputController stepcounter];
    [tmp minusCounter];
}

-(void)reloadLastTime{
    [super removeAllObjectFromScene];
    //大魔方
    //magicCube = [MCMagicCube magicCube];
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    
    /*magicCubeUI = [[MCMagicCubeUIModelController alloc]initiate];*/
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    
     //[inputController setIsNeededReload:YES];
    //[(MCNormalPlayInputViewController*)inputController reloadInterface];
    //[magicCubeUI release];
     
}



-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(nextSolution)];
}

@end
