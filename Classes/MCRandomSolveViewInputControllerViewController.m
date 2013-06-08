//
//  MCRandomSolveViewInputControllerViewController.m
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "MCRandomSolveViewInputControllerViewController.h"
#import "MCTexturedButton.h"
#import "CoordinatingController.h"
#import "Global.h"
#import "MCRandomSolveSceneController.h"

@implementation MCRandomSolveViewInputControllerViewController

@synthesize selectMenu = _selectMenu;
@synthesize lastestPoint = _lastestPoint;

-(void)loadInterface{
    [super loadInterface];
    
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    
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
    
    CGRect itemFrame =  self.view.bounds;
    itemFrame.size.height = itemFrame.size.height * POPUP_ITEM_WINDOW_SIZE_RATIO;
    itemFrame.size.width = itemFrame.size.height;
    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color00.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color00.png"]
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color01.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color01.png"]
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color02.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color02.png"]
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color03.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color03.png"]
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem5 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color04.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color04.png"]
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem6 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color05.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color05.png"]
                                                                      withFrame:itemFrame];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    [starMenuItem4 release];
    [starMenuItem5 release];
    [starMenuItem6 release];
    
    _selectMenu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    
    _selectMenu.delegate = self;
}

-(void)mainMenuBtnDown{
    NSLog(@"mainMenuPlayBtnDown");
}


-(void)mainMenuBtnUp{
    NSLog(@"mainMenuPlayBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kMainMenu];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //do something
    [super touchesBegan:touches withEvent:event];
    
    //FSM_Interaction_State fsm_Current_State = [[[CoordinatingController sharedCoordinatingController] currentController].inputController fsm_Current_State];
    if (fsm_Current_State == kState_F2||fsm_Current_State == kState_S2||fsm_Current_State==kState_M2) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    _lastestPoint = [touch locationInView:self.view];
    //判断是否拾取到
    MCRandomSolveSceneController * secencontroller = [MCRandomSolveSceneController sharedRandomSolveSceneController];
    vec2 lastpoint = vec2(_lastestPoint.x,_lastestPoint.y);
    
    BOOL isSelectOneFace = [secencontroller isSelectOneFace:lastpoint];
    
    if (!self.selectMenu.isProtection) {
        if (!self.selectMenu.expanding && isSelectOneFace) {
            self.selectMenu.center = _lastestPoint;
            [self.view addSubview:_selectMenu];
            [self.selectMenu setExpanding:YES];
        }
        else{
            [self.selectMenu setExpanding:NO];
        }
    }
}


- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx{
    NSLog(@"Select the index : %d",idx);
    //1.选择颜色
    //
}
- (void)releaseInterface{
    [super releaseInterface];
    [_selectMenu removeFromSuperview];
    [_selectMenu release];
}

@end
