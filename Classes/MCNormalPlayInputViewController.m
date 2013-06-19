//
//  MCNormalPlayInputViewController.m
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "MCNormalPlaySceneController.h"
#import "MCTexturedButton.h"
#import "MCNormalPlayInputViewController.h"
#import "CoordinatingController.h"
#import "MCLabel.h"
#import "MCPlayHelper.h"
#import "MCStringDefine.h"
#import "MCMaterialController.h"
#import "Global.h"
@implementation MCNormalPlayInputViewController
@synthesize stepcounter;
@synthesize timer;
@synthesize actionQueue;
@synthesize isRandoming;

-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    lastRandomAxis = X;
    randomRotateCount = 0;
    isRandoming = NO;
    //UI step counter
    NSString *counterName[10] = {@"zero2",@"one2",@"two2",@"three2",@"four2",@"five2",@"six2",@"seven2",@"eight2",@"nine2"};
    stepcounter = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:3 andKeys:counterName];
    [stepcounter setScale : MCPointMake(96, 50, 1.0)];
    [stepcounter setTranslation :MCPointMake(450, -340, 0.0)];
    [stepcounter setActive:YES];
    [stepcounter awake];
    [interfaceObjects addObject:stepcounter];
    
    //UI UI step counter label
    MCLabel *counterLabel= [[MCLabel alloc]initWithNstring:TextureKey_step];
    counterLabel.scale = [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_NumberElement forKey:TextureKey_step];
    [counterLabel setTranslation :MCPointMake(450, -285, 0.0)];
    [counterLabel setActive:YES];
    [counterLabel awake];
    [interfaceObjects addObject:counterLabel];
    [counterLabel release];
    
    //UI timer
    MCLabel *timerLabel= [[MCLabel alloc]initWithNstring:TextureKey_time];
    [timerLabel setScale : [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_NumberElement forKey:TextureKey_time]];
    [timerLabel setTranslation :MCPointMake(-450, -285, 0.0)];
    [timerLabel setActive:YES];
    [timerLabel awake];
    [interfaceObjects addObject:timerLabel];
    [timerLabel release];
    //UI timer
    timer = [[MCTimer alloc]initWithTextureKeys:counterName];
    [timer setScale:MCPointMake(450/2, 72/2, 1.0)];
    [timer setTranslation:MCPointMake(-360, -340, 0.0)];
    [timer setActive:YES];
    [timer awake];
    [interfaceObjects addObject:timer];
    
    //add action queue
    NSMutableArray *actionname = [[NSMutableArray alloc]init];
    actionQueue = [[MCActionQueue alloc]initWithActionList:actionname] ;
    [actionQueue setScale : MCPointMake(32, 32, 1.0)];
    [actionQueue setTranslation :MCPointMake(0, 340, 0.0)];
    [actionQueue setActive:NO];
    [actionQueue awake];
    [interfaceObjects addObject:actionQueue];
    [actionname release];
       
	/*
	// mainMenuBtn
    //the texture 还没设计出来
	MCTexturedButton * mainMenuBtn = [[MCTexturedButton alloc] initWithUpKey:@"mainMenuBtnUp" downKey:@"mainMenuBtnUp"];
	mainMenuBtn.scale = MCPointMake(75, 35, 1.0);
	mainMenuBtn.translation = MCPointMake(-450, 350.0, 0.0);
	mainMenuBtn.target = self;
	mainMenuBtn.buttonDownAction = @selector(mainMenuBtnDown);
	mainMenuBtn.buttonUpAction = @selector(mainMenuBtnUp);
	mainMenuBtn.active = YES;
	[mainMenuBtn awake];
	[interfaceObjects addObject:mainMenuBtn];
	[mainMenuBtn release];
    */
    
    /*
    //队列的下一步
	MCTexturedButton * shiftLeft = [[MCTexturedButton alloc] initWithUpKey:@"previousSolutionBtnUp" downKey:@"previousSolutionBtnUp"];
	shiftLeft.scale = MCPointMake(40, 40, 1.0);
	shiftLeft.translation = MCPointMake(-260, 320.0, 0.0);
	shiftLeft.target = self;
	shiftLeft.buttonDownAction = @selector(shiftLeftBtnDown);
	shiftLeft.buttonUpAction = @selector(shiftLeftBtnUp);
	shiftLeft.active = YES;
	[shiftLeft awake];
	[interfaceObjects addObject:shiftLeft];
	[shiftLeft release];
    //队列的上一步
	MCTexturedButton * shiftRight = [[MCTexturedButton alloc] initWithUpKey:@"nextSolutionBtnUp" downKey:@"nextSolutionBtnUp"];
	shiftRight.scale = MCPointMake(40, 40, 1.0);
	shiftRight.translation = MCPointMake(260, 320.0, 0.0);
	shiftRight.target = self;
	shiftRight.buttonDownAction = @selector(shiftRightBtnDown);
	shiftRight.buttonUpAction = @selector(shiftRightBtnUp);
	shiftRight.active = YES;
	[shiftRight awake];
	[interfaceObjects addObject:shiftRight];
	[shiftRight release];
     */
       
    //提示按钮
    MCTexturedButton * showTipsBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_showTipsButtonUp downKey:TextureKey_showTipsButtonDown];
	showTipsBtn.scale = [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_LearnPageElement forKey:TextureKey_showTipsButtonUp];
	showTipsBtn.translation = MCPointMake(512-41, 345, 0.0);
	showTipsBtn.target = self;
	showTipsBtn.buttonDownAction = @selector(tipsBtnDown);
	showTipsBtn.buttonUpAction = @selector(tipsBtnUp);
	showTipsBtn.active = YES;
	[showTipsBtn awake];
	[interfaceObjects addObject:showTipsBtn];
	[showTipsBtn release];

    
    /*
    //置乱按钮
    MCTexturedButton * randomBtn = [[MCTexturedButton alloc] initWithUpKey:@"tipsBtnUp" downKey:@"tipBtnUp"];
	randomBtn.scale = MCPointMake(110, 55, 1.0);
	randomBtn.translation = MCPointMake(-450, 120.0, 0.0);
	randomBtn.target = self;
	randomBtn.buttonDownAction = @selector(randomBtnDown);
	randomBtn.buttonUpAction = @selector(randomBtnUp);
	randomBtn.active = YES;
	[randomBtn awake];
	[interfaceObjects addObject:randomBtn];
	[randomBtn release];
     */
    //上一步/撤销
	MCTexturedButton * undoCommand = [[MCTexturedButton alloc] initWithUpKey:TextureKey_previousButtonUp downKey:TextureKey_previousButtonDown];
	undoCommand.scale = [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_LearnPageElement forKey:TextureKey_previousButtonUp];
	undoCommand.translation = MCPointMake(-512+46, 0.0, 0.0);
	undoCommand.target = self;
	undoCommand.buttonDownAction = @selector(previousSolutionBtnDown);
	undoCommand.buttonUpAction = @selector(previousSolutionBtnUp);
	undoCommand.active = YES;
	[undoCommand awake];
	[interfaceObjects addObject:undoCommand];
	[undoCommand release];
    

    
    //暂停
	MCTexturedButton * pause = [[MCTexturedButton alloc] initWithUpKey:TextureKey_pauseButtonUp downKey:TextureKey_pauseButtonDown];
	pause.scale = [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_LearnPageElement forKey:TextureKey_pauseButtonUp];
	pause.translation = MCPointMake(-455, 345, 0.0);
	pause.target = self;
	pause.buttonDownAction = @selector(pauseSolutionBtnDown);
	pause.buttonUpAction = @selector(pauseSolutionBtnUp);
	pause.active = YES;
	[pause awake];
	[interfaceObjects addObject:pause];
	[pause release];
    
    
    //下一步/恢复
	MCTexturedButton * redoCommand = [[MCTexturedButton alloc] initWithUpKey:TextureKey_nextButtonUp downKey:TextureKey_nextButtonDown];
	redoCommand.scale = [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_LearnPageElement forKey:TextureKey_nextButtonUp];
	redoCommand.translation = MCPointMake(512-46, 0.0, 0.0);
	redoCommand.target = self;
	redoCommand.buttonDownAction = @selector(nextSolutionBtnDown);
	redoCommand.buttonUpAction = @selector(nextSolutionBtnUp);
	redoCommand.active = YES;
	[redoCommand awake];
	[interfaceObjects addObject:redoCommand];
	[redoCommand release];
    
    [super loadInterface];
    //基本界面加载完后，弹出是否加载上次未完成的任务
    //if (!isNeededReload) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(askReload) userInfo:nil repeats:NO];
    //}
    
    
    
}
-(void)tipsBtnUp{
    if (isRandoming) {
        return;
    }
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    //hiden the action queue
    [self.actionQueue setActive : !self.actionQueue.active ];
    //hiden the tips
    [[c tipsLabel] setHidden:![[c tipsLabel] isHidden]];
    //switch the isShowQueue flag in scenecontroller
    c.isShowQueue = !c.isShowQueue;
    if (self.actionQueue.active) {
        [[c playHelper] prepare];
        [c showQueue];
    }else{
        [self.actionQueue removeAllActions];
        [c closeSpaceIndicator];
        [[c tipsLabel]setText:@""];
        [[c playHelper] close];
    }
};
-(void)tipsBtnDown{};
-(void)randomBtnUp{
    //TIME_PER_ROTATION = 0.15;
    isRandoming = YES;
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c closeSpaceIndicator];
    radomtimer = [NSTimer scheduledTimerWithTimeInterval:TIME_PER_ROTATION+0.1 target:self selector:@selector(randomRotateHelp1) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:(TIME_PER_ROTATION+0.1)*(RandomRotateMaxCount+1)+0.1 target:self selector:@selector(randomRotateHelp2) userInfo:nil repeats:NO];
};
-(void)randomRotateHelp1{
    randomRotateCount ++;
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    RANDOM_SEED();
    
    //更新下一次spaceindicator方向
   
    AxisType axis = (AxisType)(RANDOM_INT(0, 2));
    if (axis==lastRandomAxis) {
        axis = (AxisType)((lastRandomAxis+1)%3);
    }
    lastRandomAxis = axis;
    LayerRotationDirectionType direction = (LayerRotationDirectionType)(RANDOM_INT(0, 1));
    int layer = RANDOM_INT(0, 2);
    [c rotateOnAxis:axis onLayer:layer inDirection:direction isTribleRotate:NO];
    
    if (randomRotateCount == RandomRotateMaxCount) {
        [radomtimer invalidate];
    }
}
-(void)randomRotateHelp2{
    isRandoming = NO;
    randomRotateCount =0;
    [timer startTimer];
    //TIME_PER_ROTATION = 0.5;
    [[self stepcounter]reset];
}

-(void)randomBtnDown{};

#pragma mark - queue shift
-(void)shiftLeftBtnDown{}
-(void)shiftLeftBtnUp{[actionQueue shiftLeft];}
-(void)shiftRightBtnDown{}
-(void)shiftRightBtnUp{[actionQueue shiftRight];}


#pragma mark - button actions
//撤销
-(void)previousSolutionBtnUp{
    NSLog(@"previousSolutionBtnUp");
   MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c previousSolution];
}
-(void)previousSolutionBtnDown{}

//暂停
-(void)pauseSolutionBtnUp{
    NSLog(@"pauseSolutionBtnUp");
    //停止计时器
    [timer stopTimer];
    
    //弹出对话框
    learnPagePauseMenuView = [[LearnPagePauseMenu alloc] initWithFrame:self.view.bounds title:@"暂停"]; /*autorelease*/
    learnPagePauseMenuView.isShowColseBtn = NO;
    learnPagePauseMenuView.delegate = self;
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:learnPagePauseMenuView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[learnPagePauseMenuView showFromPoint:CGPointMake(512,384)];
}
-(void)pauseSolutionBtnDown{}
//恢复
-(void)nextSolutionBtnUp{
    //;
    NSLog(@"nextSolutionBtnUp");
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c nextSolution];
}
-(void)nextSolutionBtnDown{}

-(void)mainMenuBtnDown{
    NSLog(@"mainMenuBtnDown");
}
-(void)mainMenuBtnUp{NSLog(@"mainMenuBtnUp");
    
    //保存魔方状态
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:TmpMagicCubeData];
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    if (![[c tipsLabel]isHidden]) {
        [[c tipsLabel]setHidden:YES];
    }
    [NSKeyedArchiver archiveRootObject:[c magicCube] toFile:fileName];
    
    //发送消息到界面迁移协调控制器
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kMainMenu];
}



#pragma mark - UAModalDisplayPanelViewDelegate

// Optional: This is called before the open animations.
//   Only used if delegate is set.
- (void)willShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the open animations.
//   Only used if delegate is set.
- (void)didShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called when the close button is pressed
//   You can use it to perform validations
//   Return YES to close the panel, otherwise NO
//   Only used if delegate is set.
- (BOOL)shouldCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
	return YES;
}

// Optional: This is called before the close animations.
//   Only used if delegate is set.
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
    
    if (askReloadView) {
        if ([askReloadView askReloadType]==kAskReloadView_LoadLastTime) {
            //重新加载上一次；
            //更新数据模型
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *filePath = [path stringByAppendingPathComponent:TmpMagicCubeData];
            
            MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
            c.magicCube=[MCMagicCube unarchiveMagicCubeWithFile:filePath];
            c.playHelper=[MCPlayHelper playerHelperWithMagicCube:[c magicCube]];

            //[c.playHelper setMagicCube:c.magicCube];
            

            //更新UI模型
            [c reloadLastTime];
            [[self timer]startTimer];
            NSLog(@"dd");
        }else if([askReloadView askReloadType]==kAskReloadView_Reload){
            //Default
            [self randomBtnUp];
            
        }else{
            //cancel
            
            
        }
        askReloadView = nil;
    }
    
    
    if (learnPagePauseMenuView){
    
        if ([learnPagePauseMenuView learnPagePauseSelectType]==kLearnPagePauseSelect_GoBack) {
            [self mainMenuBtnUp];
        }else if([learnPagePauseMenuView learnPagePauseSelectType]==kLearnPagePauseSelect_GoOn){
            //停止计时器
    
            [timer startTimer];
        }else if([learnPagePauseMenuView learnPagePauseSelectType]==kLearnPagePauseSelect_Restart){
            //更新UI模型
            
            //Default
            MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
            //hiden the action queue
            [self.actionQueue setActive : NO ];
            //hiden the tips
            [[c tipsLabel] setHidden:YES];
            c.isShowQueue = NO;
            [self.actionQueue removeAllActions];
            [[c tipsLabel]setText:@""];
            [[c playHelper] close];
            
            //counter reset
            [stepcounter reset];
            [timer reset];
            [self randomBtnUp];

            
        }
        
        learnPagePauseMenuView = nil;
    }
    if (finishView){
        
        if ([finishView finishViewType]==kFinishView_GoBack) {
            [self mainMenuBtnUp];
        }        
        finishView = nil;
    }
    
}

-(void)showFinishView{
    
    //停止计时器
    [timer stopTimer];
    
    //弹出对话框
    finishView = [[FinishView alloc] initWithFrame:self.view.bounds title:@"结束"]; /*autorelease*/
    finishView.isShowColseBtn = NO;
    finishView.delegate = self;
    finishView.alpha = 0.2;
    
    
    // Set step count and learing time.
    finishView.learningStepCountLabel.text = [NSString stringWithFormat:@"%d", stepcounter.m_counterValue];
    finishView.learningTimeLabel.text = [timer description];
    finishView.lastingTime = timer.totalTime/1000;
    finishView.stepCount = stepcounter.m_counterValue;
    
    // If no name, set 'Rubiker'
    if ([finishView.userNameEditField.text compare:@""] == NSOrderedSame) {
        finishView.userNameEditField.text = @"Rubiker";
    }
    
    
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:finishView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[finishView showFromPoint:CGPointMake(512,384)];

}


-(void)askReload{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:TmpMagicCubeData];
    if (fileName!=nil) {
        NSFileManager *fm;
        //Need to create an instance of the file manager
        fm = [NSFileManager defaultManager];
        
        //Let's make sure our test file exists first
        if([fm fileExistsAtPath: fileName] == NO)
        {
            NSLog(@"File doesn't exist'");
            return ;  
        }
        
    }
    //弹出对话框
    askReloadView = [[AskReloadView alloc] initWithFrame:self.view.bounds title:@"上次未完成"]; /*autorelease*/
    askReloadView.isShowColseBtn = NO;
    askReloadView.delegate = self;
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:askReloadView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[askReloadView showFromPoint:CGPointMake(512,384)];
}


-(void)reloadLastTime{
    NSLog(@"reloadLastTime");
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c reloadLastTime];
}
- (void)releaseInterface{
    [super releaseInterface];
}
@end
