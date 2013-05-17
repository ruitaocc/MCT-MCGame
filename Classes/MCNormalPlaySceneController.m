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
@synthesize magicCube;
@synthesize playHelper;
@synthesize tipsLabel = _tipsLabel;
@synthesize isShowQueue;
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

-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];
	
    //float scale = 60.0;
    isShowQueue = NO;
	magicCube = [[MCMagicCube magicCube]retain];
    playHelper = [[MCPlayHelper playerHelperWithMagicCube:self.magicCube]retain];
    //[playHelper applyRules];
    
    //大魔方
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiate];
    magicCubeUI.target=self;
    [magicCubeUI setUsingMode:TECH_MODE];
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    //[magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	// reload our interface
	[inputController loadInterface];
    
    [self setTipsLabel: [[[UILabel alloc]initWithFrame:CGRectMake(800,150,160,60)] autorelease]];
    [[self tipsLabel] setText:@"针对action给出提示"];
    [[self tipsLabel] setOpaque:YES];
    [openGLView addSubview:[self tipsLabel]];
    [[self tipsLabel]setHidden:YES];
    
}

-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [(MCNormalPlayInputViewController*)inputController stepcounter];
    [tmp addCounter];
}
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [(MCNormalPlayInputViewController*)inputController stepcounter];
    [tmp minusCounter];
}

-(void)reloadLastTime{
    [super removeAllObjectFromScene];
    //大魔方
    //magicCube = [MCMagicCube magicCube];
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    
    /*magicCubeUI = [[MCMagicCubeUIModelController alloc]initiate];*/
    magicCubeUI.target=self;
    [magicCubeUI setUsingMode:TECH_MODE];
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    
     //[inputController setIsNeededReload:YES];
    //[(MCNormalPlayInputViewController*)inputController reloadInterface];
    //[magicCubeUI release];
     
}

-(void)rotate:(RotateType *)rotateType{
    //流程1，通知数据模型UI已经旋转
   // [playHelper rotateOnAxis:[rotateType rotate_axis] onLayer:[rotateType rotate_layer] inDirection:[rotateType rotate_direction]];
    [playHelper rotateWithSingmasterNotation:[rotateType notation]];
    //NSLog(@"tell playHelper rotate:%@",[rotateType notation]);
    //the first you apply rules
    //you need to verify the current state
    //checking state from 'init' will clear all locked cubies
    if (isShowQueue) {
        [self showQueue];
    }
    
    [magicCubeUI adjustWithCenter_2];
}

-(void)showQueue{
          
    MCNormalPlayInputViewController* input_C = (MCNormalPlayInputViewController*)inputController;
    //如果队列为空 先applyRules
    if ([[input_C actionQueue] isQueueEmpty]) {
        [playHelper applyRules];
        NSArray *actionqueue= [playHelper.applyQueue getQueueWithStringFormat];
        NSLog(@"applyRuleRotation:%@", [actionqueue description]);
        while([[playHelper state]isEqual:START_STATE]&&[actionqueue count]==0){
            [playHelper applyRules];
            actionqueue= [playHelper.applyQueue getQueueWithStringFormat];
        };
        [[input_C actionQueue] insertQueueCurrentIndexWithNmaeList:actionqueue];
    }else{
        //流程2，询问是否正确
        RotationResult result = [playHelper getResultOfTheLastRotation];
        if (result == Accord) {
            NSLog(@"result : Accord");
            //流程2.1，正确，队列右移动一位
            [[input_C actionQueue]shiftRight];
            
        }else if(result == Disaccord){
            NSLog(@"result : Disaccord");
            //流程2.2，错误，
            //流程2.2.1，获取应该插入队列extraRotations
            //NSArray *actionAry = [playHelper.applyQueue getExtraQueueWithStringFormat];
            //NSLog(@"%@",  [actionAry description]);
            NSMutableArray *actionAry = [[NSMutableArray alloc]init];
            for (NSNumber *rotation in playHelper.applyQueue.extraRotations) {
                [actionAry addObject: [MCTransformUtil getRotationTagFromSingmasterNotation:(SingmasterNotation)[rotation integerValue]]];
            }
            NSLog(@"extraRotation:%@", [actionAry description]);
            [[input_C actionQueue] insertQueueCurrentIndexWithNmaeList:actionAry];
            
        }else if (result==StayForATime){
            NSLog(@"result : StayForATime");
            //do nothing
        }else if (result ==Finished){
            NSLog(@"result : Finished");
            //先清空数据模型对队列。
            [playHelper clearResidualActions];
            //结束，清空当前队列
            [[input_C actionQueue]removeAllActions];
            //重新加载队列，applyRules ,
            [playHelper applyRules];
            NSArray *actionqueue= [playHelper.applyQueue getQueueWithStringFormat];
            NSLog(@"applyRuleRotation:%@", [actionqueue description]);
            while([[playHelper state]isEqual:START_STATE]&&[actionqueue count]==0){
                 [playHelper applyRules];
                    actionqueue= [playHelper.applyQueue getQueueWithStringFormat];
            };
            [[input_C actionQueue] insertQueueCurrentIndexWithNmaeList:actionqueue];
            if([[playHelper state]isEqual:END_STATE]){
                //弹出结束对话框
                NSLog(@"END form Scene");
                
            };
        }else if (result ==NoneResult){
            
            //do nothing
        }
    }
};

-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(nextSolution)];
}

@end
