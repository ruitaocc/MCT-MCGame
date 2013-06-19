//
//  MCRandomSolveViewInputControllerViewController.h
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "InputController.h"
#import "QuadCurveMenu.h"
#import "MCActionQueue.h"
#import "MCMultiDigitCounter.h"
#import "InfoView.h"
//#import "MBProgressHUD.h"
@interface MCRandomSolveViewInputControllerViewController : InputController <QuadCurveMenuDelegate>{
    //判断是否要弹出选择框到标记
    BOOL isWantShowSelectView;
    MCActionQueue *actionQueue;
    MCMultiDigitCounter *stepcounter;
    InfoView * infoView;
    //MBProgressHUD *HUD;
    BOOL isFinishInput;
    NSMutableArray * singmasternotations;
    int totalMove;
    int currentMove;
}

@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, retain) QuadCurveMenu *selectMenu;
@property (nonatomic) CGPoint lastestPoint;
@property(nonatomic, retain)NSArray *cubieArray;
@property (nonatomic,retain) MCActionQueue *actionQueue;
@property (nonatomic,retain) MCMultiDigitCounter *stepcounter;

-(void)loadInterface;

-(void)mainMenuBtnDown;

-(void)mainMenuBtnUp;
//求解
-(void)qSolveBtnDown;
-(void)qSolveBtnUp;

//
-(void)pauseSolutionBtnDown;
-(void)pauseSolutionBtnUp;

//撤销
-(void)previousSolutionBtnUp;
-(void)previousSolutionBtnDown;

//恢复
-(void)nextSolutionBtnUp;
-(void)nextSolutionBtnDown;

-(void)releaseInterface;

@end
