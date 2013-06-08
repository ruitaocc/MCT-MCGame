//
//  MCRandomSolveViewInputControllerViewController.h
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "InputController.h"
#import "QuadCurveMenu.h"

@interface MCRandomSolveViewInputControllerViewController : InputController <QuadCurveMenuDelegate>

@property (nonatomic, retain) QuadCurveMenu *selectMenu;
@property (nonatomic) CGPoint lastestPoint;

-(void)loadInterface;

-(void)mainMenuBtnDown;

-(void)mainMenuBtnUp;

@end
