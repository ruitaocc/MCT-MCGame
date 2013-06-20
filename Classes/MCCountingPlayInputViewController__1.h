//
//  MCCountingPlayInputViewController__1.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputController.h"
#import "MCMultiDigitCounter.h"
#import "MCTimer.h"
#import "UAModalPanel.h"
#import "PauseMenu.h"
#import "CountingFinishView.h"
#import "AskReloadView.h"
@interface MCCountingPlayInputViewController : InputController<UAModalPanelDelegate>{
    MCMultiDigitCounter *stepcounter;
    MCTimer * timer;
    PauseMenu* puseMenu;
    CountingFinishView *finishView;
    AskReloadView* askReloadView;

}
@property (nonatomic,retain) MCMultiDigitCounter *stepcounter;
@property (nonatomic,retain) MCTimer * timer;
//overload
-(void)loadInterface;

//interface action selectors
//撤销
-(void)previousSolutionBtnUp;
-(void)previousSolutionBtnDown;
//暂停
-(void)pauseSolutionBtnUp;
-(void)pauseSolutionBtnDown;
//恢复
-(void)nextSolutionBtnUp;
-(void)nextSolutionBtnDown;

-(void)mainMenuBtnDown;
-(void)mainMenuBtnUp;

-(void)releaseInterface;
-(void)showFinishView;

@end
