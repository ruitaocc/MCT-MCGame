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

#import "MCPlayHelper.h"
@implementation MCNormalPlayInputViewController
@synthesize stepcounter;
@synthesize timer;
@synthesize actionQueue;


-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    
    
    NSString *counterName[10] = {@"zero",@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine"};
    stepcounter = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:3 andKeys:counterName];
    [stepcounter setScale : MCPointMake(135, 72, 1.0)];
    [stepcounter setTranslation :MCPointMake(380, -320, 0.0)];
    [stepcounter setActive:YES];
    [stepcounter awake];
    [interfaceObjects addObject:stepcounter];
    
    
    
    //[counter release];
    timer = [[MCTimer alloc]initWithTextureKeys:counterName];
    [timer setScale:MCPointMake(450/2, 72/2, 1.0)];
    [timer setTranslation:MCPointMake(-360, -340, 0.0)];
    [timer setActive:YES];
    [timer awake];
    //[timer startTimer];
    [interfaceObjects addObject:timer];
    
    //add action queue
    NSMutableArray *actionname = [[NSMutableArray alloc]init];
    NSString *names[45]={@"",@"frontCCW",@"front2CW",@"backCW",@"backCCW",@"back2CW",@"rightCW",@"rightCCW",@"right2CW",@"leftCW",@"leftCCW",@"left2CW",@"upCW",@"upCCW",@"up2CW",@"downCW",@"downCCW",@"down2CW",@"xCW",@"xCCW",@"x2CW",@"yCW",@"yCCW",@"y2CW",@"zCW",@"zCCW",@"z2CW",@"frontTwoCW",@"frontTwoCCW",@"frontTwo2CW",@"backTwoCW",@"backTwoCCW",@"backTwo2CW",@"rightTwoCW",@"rightTwoCCW",@"rightTwo2CW",@"leftTwoCW",@"leftTwoCCW",@"leftTwo2CW",@"upTwoCW",@"upTwoCCW",@"upTwo2CW",@"downTwoCW",@"downTwoCCW",@"downTwo2CW"};
    /*
    for (int i=5; i<17; i++) {
        [actionname addObject:names[i]];
    }*/
    //[actionname addObject:names[1]];

    actionQueue = [[MCActionQueue alloc]initWithActionList:actionname];
    [actionQueue setScale : MCPointMake(32, 32, 1.0)];
    [actionQueue setTranslation :MCPointMake(0, 320, 0.0)];
    [actionQueue setActive:NO];
    [actionQueue awake];
    [interfaceObjects addObject:actionQueue];

       
	
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
    //上一步/撤销
	MCTexturedButton * undoCommand = [[MCTexturedButton alloc] initWithUpKey:@"previousSolutionBtnUp" downKey:@"previousSolutionBtnUp"];
	undoCommand.scale = MCPointMake(40, 40, 1.0);
	undoCommand.translation = MCPointMake(-60, -320.0, 0.0);
	undoCommand.target = self;
	undoCommand.buttonDownAction = @selector(previousSolutionBtnDown);
	undoCommand.buttonUpAction = @selector(previousSolutionBtnUp);
	undoCommand.active = YES;
	[undoCommand awake];
	[interfaceObjects addObject:undoCommand];
	[undoCommand release];
    
    
    //提示按钮
    MCTexturedButton * tips = [[MCTexturedButton alloc] initWithUpKey:@"tipsBtnUp" downKey:@"tipBtnUp"];
	tips.scale = MCPointMake(110, 55, 1.0);
	tips.translation = MCPointMake(450, 320.0, 0.0);
	tips.target = self;
	tips.buttonDownAction = @selector(tipsBtnDown);
	tips.buttonUpAction = @selector(tipsBtnUp);
	tips.active = YES;
	[tips awake];
	[interfaceObjects addObject:tips];
	[tips release];

    
    
    //暂停
	MCTexturedButton * pause = [[MCTexturedButton alloc] initWithUpKey:@"pauseSolutionBtnUp" downKey:@"pauseSolutionBtnUp"];
	pause.scale = MCPointMake(40, 40, 1.0);
	pause.translation = MCPointMake(0, -320.0, 0.0);
	pause.target = self;
	pause.buttonDownAction = @selector(pauseSolutionBtnDown);
	pause.buttonUpAction = @selector(pauseSolutionBtnUp);
	pause.active = YES;
	[pause awake];
	[interfaceObjects addObject:pause];
	[pause release];
    
    
    //下一步/恢复
	MCTexturedButton * redoCommand = [[MCTexturedButton alloc] initWithUpKey:@"nextSolutionBtnUp" downKey:@"nextSolutionBtnUp"];
	redoCommand.scale = MCPointMake(40, 40, 1.0);
	redoCommand.translation = MCPointMake(60, -320.0, 0.0);
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
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    //hiden the action queue
    [self.actionQueue setActive : !self.actionQueue.active ];
    //hiden the tips
    [[c tipsLabel] setHidden:![[c tipsLabel] isHidden]];
    //switch the isShowQueue flag in scenecontroller
    c.isShowQueue = !c.isShowQueue;
    if (self.actionQueue.active) {
        [[c playHelper] checkStateFromInit:YES];
        [c showQueue];
    }else{
        [self.actionQueue removeAllActions];
        [[c tipsLabel]setText:@""];
    }
};
-(void)tipsBtnDown{};

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
    pauseMenuView = [[[PauseMenu alloc] initWithFrame:self.view.bounds title:@"暂停"] autorelease];
    pauseMenuView.isShowColseBtn = NO;
    pauseMenuView.delegate = self;
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:pauseMenuView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[pauseMenuView showFromPoint:CGPointMake(512,384)];
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
    NSLog(@"mainMenuPlayBtnDown");
}
-(void)mainMenuBtnUp{NSLog(@"mainMenuPlayBtnUp");
    
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
            NSLog(@"dd");
        }else if([askReloadView askReloadType]==kAskReloadView_Reload){
            //Default
            [timer startTimer];
        }else{
            //cancel
            
        }
        askReloadView = nil;
    }
    
    
    if (pauseMenuView){
    
        if ([pauseMenuView pauseSelectType]==kPauseSelect_GoBack) {
            [self mainMenuBtnUp];
        }else if([pauseMenuView pauseSelectType]==kPauseSelect_GoOn){
            //停止计时器
    
            [timer startTimer];
            NSLog(@"ddd");
        }
        pauseMenuView = nil;
    }
    
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
    askReloadView = [[[AskReloadView alloc] initWithFrame:self.view.bounds title:@"上次未完成"] autorelease];
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
@end
