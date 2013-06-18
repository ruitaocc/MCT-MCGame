//
//  MCCountingPlayInputViewController__1.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlayInputViewController__1.h"
#import "MCTexturedButton.h"
#import "CoordinatingController.h"
#import "MCMultiDigitCounter.h"
#import "PauseMenu.h"
#import "MCStringDefine.h"
#import "MCLabel.h"
@implementation MCCountingPlayInputViewController
@synthesize stepcounter;
@synthesize timer;

-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    
  
    NSString *counterName[10] = {@"zero2",@"one2",@"two2",@"three2",@"four2",@"five2",@"six2",@"seven2",@"eight2",@"nine2"};
     stepcounter = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:3 andKeys:counterName];
    [stepcounter setScale : MCPointMake(96, 50, 1.0)];
    [stepcounter setTranslation :MCPointMake(450, -340, 0.0)];
    [stepcounter setActive:YES];
    [stepcounter awake];
    [interfaceObjects addObject:stepcounter];
    //[counter release];
    timer = [[MCTimer alloc]initWithTextureKeys:counterName];
    [timer setScale:MCPointMake(450/2, 72/2, 1.0)];
    [timer setTranslation:MCPointMake(-360, -340, 0.0)];
    [timer setActive:YES];
    [timer awake];
    [timer startTimer];
    [interfaceObjects addObject:timer];
    
    
    //lebel
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
    
}
#pragma mark - button actions
//撤销
-(void)previousSolutionBtnUp{
    NSLog(@"previousSolutionBtnUp");
    MCCountingPlaySceneController *c = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    [c previousSolution];
}
-(void)previousSolutionBtnDown{}

//暂停
-(void)pauseSolutionBtnUp{
    NSLog(@"pauseSolutionBtnUp");
    //停止计时器
    [timer stopTimer];
    //[[[CoordinatingController sharedCoordinatingController]currentController]stopAnimation];
    //弹出对话框
    puseMenu = [[[PauseMenu alloc] initWithFrame:self.view.bounds title:@"暂停"] autorelease];
    puseMenu.isShowColseBtn = NO;
    puseMenu.delegate = self;
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:puseMenu];
	///////////////////////////////////

	// Show the panel from the center of the button that was pressed
	[puseMenu showFromPoint:CGPointMake(512,384)];
}
-(void)pauseSolutionBtnDown{}
//恢复
-(void)nextSolutionBtnUp{
    NSLog(@"nextSolutionBtnUp");
    MCCountingPlaySceneController *c = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    [c nextSolution];
}
-(void)nextSolutionBtnDown{}

-(void)mainMenuBtnDown{
    NSLog(@"mainMenuPlayBtnDown");
   }
-(void)mainMenuBtnUp{NSLog(@"mainMenuPlayBtnUp");
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

-(void)releaseInterface{
    [super releaseInterface];
};
// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
    
    if (puseMenu){
        
        if ([puseMenu pauseSelectType]==kPauseSelect_GoBack) {
            [self mainMenuBtnUp];
        }else if([puseMenu pauseSelectType]==kPauseSelect_GoOn){
            //停止计时器
            
            [timer startTimer];
        }else if([puseMenu pauseSelectType]==kPauseSelect_Restart){
            //更新UI模型
           // MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
            //[c reloadScene];
            //Default
            //[self randomBtnUp];

        }
        
        puseMenu = nil;
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
    finishView.learningStepCountLabel.text = [NSString stringWithFormat:@"%d步", stepcounter.m_counterValue];
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




@end
