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
@implementation MCCountingPlayInputViewController
@synthesize stepcounter;
@synthesize timer;

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
    [timer startTimer];
    [interfaceObjects addObject:timer];
    
    
    
    
    
    CGFloat btnWidth = 220.0;
    CGFloat btnHeight = 88.0;
	
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
    //弹出对话框
    puseMenu = [[[PauseMenu alloc] initWithFrame:self.view.bounds title:@"暂停"] autorelease];
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

// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
    if (puseMenu&&[puseMenu pauseSelectType]==kGoBack) {
          [self mainMenuBtnUp];
    }
  
}





@end
