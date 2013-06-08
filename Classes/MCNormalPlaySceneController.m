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
#import "MCStringDefine.h"
#import "SoundSettingController.h"
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
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[magicCube getColorInOrientationsOfAllCubie]] ;
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
    [[self tipsLabel]setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    //[[self tipsLabel]setAlpha:0.8];
    [openGLView addSubview:[self tipsLabel]];
    [[self tipsLabel]setHidden:YES];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	// reload our interface
	[inputController loadInterface];
    
}

-(void)reloadScene{
    //[super removeAllObjectFromScene];
    
    //大魔方
     [magicCubeUI flashWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    [self stepcounterReset];
    
}

-(void)stepcounterReset{
    MCMultiDigitCounter *tmp = [(MCNormalPlayInputViewController*)inputController stepcounter];
    [tmp reset];
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
        //重置魔方到上次状态。。。
    [magicCubeUI flashWithState:[ magicCube getColorInOrientationsOfAllCubie]];
   
     
}

-(void)rotate:(RotateType *)rotateType{
    //流程1，通知数据模型UI已经旋转
   
    [playHelper rotateWithSingmasterNotation:[rotateType notation]];
    
    if (isShowQueue) {
        [self showQueue];
    }
    
    [magicCubeUI flashWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    SoundSettingController *soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting playSoundForKey:Audio_RotateSound_Ding_key];
    
    [self checkIsOver];

}

- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction isTribleRotate:(BOOL)is_trible_roate{
    
    //[playHelper rotateWithSingmasterNotation:notation];
    
    [magicCubeUI rotateOnAxis:axis onLayer:layer inDirection:direction isTribleRotate:NO];
    
    
}
-(void)showQueue{
          
    MCNormalPlayInputViewController* input_C = (MCNormalPlayInputViewController*)inputController;
    //如果队列为空 先applyRules
    if ([[input_C actionQueue] isQueueEmpty]) {
        NSDictionary *applyResult = [playHelper applyRules];
        NSArray *actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
        NSArray *tipStrArray = [applyResult objectForKey:KEY_TIPS];
        NSArray *lockArray = [applyResult objectForKey:KEY_LOCKED_CUBIES];
        NSLog(@"applyRuleRotation:%@", [actionqueue description]);
        while([actionqueue count]==0){
            [playHelper clearResidualActions];
            applyResult = [playHelper applyRules];
            actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
            tipStrArray = [applyResult objectForKey:KEY_TIPS];
            lockArray = [applyResult objectForKey:KEY_LOCKED_CUBIES];
            if([[playHelper state]isEqual:END_STATE]){//alert
                [((MCNormalPlayInputViewController*)[self inputController])showFinishView];
                break;
            }
        };
        NSMutableString *tipstr = [[NSMutableString alloc]init];
        for (NSString *msg in tipStrArray) {
            [tipstr appendString:msg];
            [tipstr appendString:@"\n"];
        }
        for(int i = 0;i<27;i++) {
            [[[magicCubeUI array27Cube]objectAtIndex:i]setIsLocked:NO];
        }
        /*
        for(NSNumber *index in lockArray) {
            //[magicCubeUI.getMagicCubeIndexState[index.intValue] setIsLocked:YES];
            [[[magicCubeUI array27Cube]objectAtIndex:[index intValue]]setIsLocked:YES];
        }*/
        //[magicCubeUI setLockedarray:lockArray];
        [[magicCubeUI lockedarray]removeAllObjects];
        [[magicCubeUI lockedarray]addObjectsFromArray:lockArray];
        [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];
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
            [[self tipsLabel]setTextColor:[UIColor blackColor]];
            
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
             [[self tipsLabel]setTextColor:[UIColor redColor]];
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
            NSArray *lockArray = [applyResult objectForKey:KEY_LOCKED_CUBIES];
            NSLog(@"applyRuleRotation:%@", [actionqueue description]);
            while([actionqueue count]==0){
                [playHelper clearResidualActions];
                applyResult = [playHelper applyRules];
                actionqueue = [applyResult objectForKey:KEY_ROTATION_QUEUE];
                tipStrArray = [applyResult objectForKey:KEY_TIPS];
                lockArray = [applyResult objectForKey:KEY_LOCKED_CUBIES];
                if([[playHelper state]isEqual:END_STATE]){
                    //弹出结束对话框
                    [((MCNormalPlayInputViewController*)[self inputController])showFinishView];
                    break;
                }
            };
            for(int i = 0;i<27;i++) {
                [[[magicCubeUI array27Cube]objectAtIndex:i]setIsLocked:NO];
            }
            /*
            for(NSNumber *index in lockArray) {
                //[magicCubeUI.getMagicCubeIndexState[index.intValue] setIsLocked:YES];
                [[[magicCubeUI array27Cube]objectAtIndex:[index intValue]]setIsLocked:YES];
            }*/
            [[magicCubeUI lockedarray]removeAllObjects];
            [[magicCubeUI lockedarray]addObjectsFromArray:lockArray];
            [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];
            NSMutableString *tipstr = [[NSMutableString alloc]init];
            for (NSString *msg in tipStrArray) {
                [tipstr appendString:msg];
                [tipstr appendString:@"\n"];
            }
            [[self tipsLabel]setText:tipstr];
            [[input_C actionQueue] insertQueueCurrentIndexWithNmaeList:actionqueue];
        }else if (result ==NoneResult){
            
            //do nothing
        }
    }
};
//检测是否结束
-(void)checkIsOver{
    return;
    if ([[[self playHelper]state]isEqual: END_STATE]) {
        [((MCNormalPlayInputViewController*)[self inputController])showFinishView];
        NSLog(@"END form Scene");
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
