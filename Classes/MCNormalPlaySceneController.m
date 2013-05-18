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
    
    //提示标签
    [self setTipsLabel: [[[UILabel alloc]initWithFrame:CGRectMake(800,150,200,160)] autorelease]];
    [[self tipsLabel] setText:@""];
    [[self tipsLabel]setNumberOfLines:15];
    [[self tipsLabel] setLineBreakMode:UILineBreakModeWordWrap|UILineBreakModeTailTruncation];
    [[self tipsLabel] setOpaque:YES];
    [openGLView addSubview:[self tipsLabel]];
    [[self tipsLabel]setHidden:YES];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	// reload our interface
	[inputController loadInterface];
    
    
    
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
    
    //[magicCubeUI adjustWithCenter];
}

- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction isTribleRotate:(BOOL)is_trible_roate{
    SingmasterNotation notation = [MCTransformUtil getSingmasterNotationFromAxis:axis layer:layer direction:direction];
    [playHelper rotateWithSingmasterNotation:notation];
    [magicCubeUI rotateOnAxis:axis onLayer:layer inDirection:direction isTribleRotate:NO];
}
-(void)showQueue{
          
    MCNormalPlayInputViewController* input_C = (MCNormalPlayInputViewController*)inputController;
    //如果队列为空 先applyRules
    if ([[input_C actionQueue] isQueueEmpty]) {
        NSDictionary *applyResult = [playHelper applyRules];
        NSArray *actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
        NSArray *tipStrArray = [applyResult objectForKey:KEY_TIPS];
        NSLog(@"applyRuleRotation:%@", [actionqueue description]);
        while([[playHelper state]isEqual:START_STATE]&&[actionqueue count]==0){
            [playHelper clearResidualActions];
            applyResult = [playHelper applyRules];
            actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
            tipStrArray = [applyResult objectForKey:KEY_TIPS];
        };
        NSMutableString *tipstr = [[NSMutableString alloc]init];
        for (NSString *msg in tipStrArray) {
            [tipstr appendString:msg];
            [tipstr appendString:@"\n"];
        }
        [[self tipsLabel]setText:tipstr];
        [[input_C actionQueue] insertQueueCurrentIndexWithNmaeList:actionqueue];
    }else{
        //流程2，询问是否正确
        RotationResult result = [playHelper getResultOfTheLastRotation];
        if (result == Accord) {
            NSLog(@"result : Accord");
            //流程2.1，正确，队列右移动一位
            [[input_C actionQueue]shiftRight];
            [[self tipsLabel]setText:Accord_Msg];
            
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
            [[self tipsLabel]setText:Disaccord_Msg];
            NSLog(@"extraRotation:%@", [actionAry description]);
            [[input_C actionQueue] insertQueueCurrentIndexWithNmaeList:actionAry];
            
        }else if (result==StayForATime){
            NSLog(@"result : StayForATime");
            [[self tipsLabel]setText:StayForATime_Msg];

            //do nothing
        }else if (result ==Finished){
            NSLog(@"result : Finished");
            //先清空数据模型对队列。
            [playHelper clearResidualActions];
            //结束，清空当前队列
            [[input_C actionQueue]removeAllActions];
            //重新加载队列，applyRules ,
            NSDictionary *applyResult = [playHelper applyRules];
            NSArray *actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
            NSArray *tipStrArray = [applyResult objectForKey:KEY_TIPS];
            //NSArray *lockArray = applyResult objectForKey:key_
            NSLog(@"applyRuleRotation:%@", [actionqueue description]);
            while([actionqueue count]==0){
                NSLog(@"[actionqueue count]==0");
                [playHelper clearResidualActions];
                applyResult = [playHelper applyRules];
                actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
                tipStrArray = [applyResult objectForKey:KEY_TIPS];
            };
            NSMutableString *tipstr = [[NSMutableString alloc]init];
            for (NSString *msg in tipStrArray) {
                [tipstr appendString:msg];
                [tipstr appendString:@"\n"];
            }
            [[self tipsLabel]setText:tipstr];
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
