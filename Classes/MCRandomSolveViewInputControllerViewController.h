//
//  MCRandomSolveViewInputControllerViewController.h
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "InputController.h"
#import "QuadCurveMenu.h"

@interface MCRandomSolveViewInputControllerViewController : InputController <QuadCurveMenuDelegate>{
    //判断是否要弹出选择框到标记
    BOOL isWantShowSelectView;
  
}

@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, retain) QuadCurveMenu *selectMenu;
@property (nonatomic) CGPoint lastestPoint;
@property(nonatomic, retain)NSArray *cubieArray;

-(void)loadInterface;

-(void)mainMenuBtnDown;

-(void)mainMenuBtnUp;

-(void)qSolveBtnDown;
-(void)qSolveBtnUp;

-(void)releaseInterface;

@end
