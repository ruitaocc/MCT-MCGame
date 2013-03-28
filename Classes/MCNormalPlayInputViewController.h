//
//  MCNormalPlayInputViewController.h
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "InputController.h"
#import "UAModalPanel.h"
#import "MCMultiDigitCounter.h"
#import "MCTimer.h"
#import "AskReloadView.h"
#import "PauseMenu.h"
#import "MCActionQueue.h"
@interface MCNormalPlayInputViewController : InputController<UAModalPanelDelegate>{
    MCMultiDigitCounter *stepcounter;
    MCTimer * timer;
    AskReloadView* askReloadView;
    PauseMenu *pauseMenuView;
    MCActionQueue *actionQueue;
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
//回到主菜单
-(void)mainMenuBtnDown;
-(void)mainMenuPlayBtnUp;

@end
