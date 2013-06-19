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
#import "MCCubieColorConstraintUtil.h"
#import "Search.h"
#import "CoordCube.h"
#import "Tools.h"
#import "MCLabel.h"
#import "MCStringDefine.h"
#import "SVProgressHUD.h"

static BOOL _isInitFinished = NO;

@interface MCRandomSolveViewInputControllerViewController () {
    __block BOOL _errorFlag;
}

- (void)checkConstraintAtCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation;


- (BOOL)solveMagicCube;


@end

@implementation MCRandomSolveViewInputControllerViewController

@synthesize selectMenu = _selectMenu;
@synthesize lastestPoint = _lastestPoint;
@synthesize cubieArray = _cubieArray;
@synthesize menuItems = _menuItems;
@synthesize stepcounter;
@synthesize actionQueue;
-(void)loadInterface{
    [super loadInterface];
    
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    isFinishInput = NO;
    totalMove = 0;
    currentMove = -1;
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

    //add action queue
    NSMutableArray *actionname = [[NSMutableArray alloc]init];
    actionQueue = [[MCActionQueue alloc]initWithActionList:actionname] ;
    [actionQueue setScale : MCPointMake(32, 32, 1.0)];
    [actionQueue setTranslation :MCPointMake(0, 340, 0.0)];
    [actionQueue setActive:NO];
    [actionQueue awake];
    [interfaceObjects addObject:actionQueue];
    [actionname release];
    
    
    //qsolvebtn
    //the texture 还没设计出来
	MCTexturedButton * qSolveBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_QsolveButtonUp downKey:TextureKey_QsolveButtonDown];
	qSolveBtn.scale = [MCMaterialController getWidthAndHeightFromTextureFile:TextureFileName_LearnPageElement forKey:TextureKey_QsolveButtonUp];
	qSolveBtn.translation = MCPointMake(512-41, 345, 0.0);
	qSolveBtn.target = self;
	qSolveBtn.buttonDownAction = @selector(qSolveBtnDown);
	qSolveBtn.buttonUpAction = @selector(qSolveBtnUp);
	qSolveBtn.active = YES;
	[qSolveBtn awake];
	[interfaceObjects addObject:qSolveBtn];
	[qSolveBtn release];

    //
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

    //
    isWantShowSelectView = NO;
    //color selector pannel
    CGRect itemFrame =  self.view.bounds;
    itemFrame.size.height = itemFrame.size.height * POPUP_ITEM_WINDOW_SIZE_RATIO;
    itemFrame.size.width = itemFrame.size.height;
    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color00.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color00.png"]
                                                                   presentColor:UpColor
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color01.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color01.png"]
                                                                   presentColor:DownColor
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color02.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color02.png"]
                                                                   presentColor:FrontColor
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color03.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color03.png"]
                                                                   presentColor:BackColor
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem5 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color04.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color04.png"]
                                                                   presentColor:LeftColor
                                                                      withFrame:itemFrame];
    QuadCurveMenuItem *starMenuItem6 = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"Color05.png"]
                                                               highlightedImage:[UIImage imageNamed:@"Color05.png"]
                                                                   presentColor:RightColor
                                                                      withFrame:itemFrame];
    
    self.menuItems = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    [starMenuItem4 release];
    [starMenuItem5 release];
    [starMenuItem6 release];
    
    _selectMenu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:_menuItems];
    
    _selectMenu.delegate = self;
    
    
    //all data in dictionaries
    NSMutableDictionary *cubieDics[27];
    for (int i = 0; i < 27; i++) {
        cubieDics[i] = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    
    self.cubieArray = [NSArray arrayWithObjects:cubieDics count:27];
    
    _errorFlag = NO;
    
    // Init for two phase solver
    // Begin
    if (!_isInitFinished) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // Doing
            CubieCube::initAllStaticVariables();
            CoordCube::initAllStaticVariables();
            
            // Over
            dispatch_async(dispatch_get_main_queue(), ^{
                _isInitFinished = YES;
                NSLog(@"Init over.");
            });
            
            
        });
    }
}
//撤销
-(void)previousSolutionBtnUp{
    if (currentMove<0) {
        return;
    }
    MCRandomSolveSceneController *c = [MCRandomSolveSceneController sharedRandomSolveSceneController];
    [c flashSecne];
    [actionQueue shiftLeft];
    [stepcounter addCounter];
    
    SingmasterNotation notation = (SingmasterNotation)[[singmasternotations objectAtIndex:currentMove]integerValue];
    currentMove--;
    
    [c rotateWithSingmasterNotation:notation];
    //[[c playHelper]rotateWithSingmasterNotation:notation];
};
-(void)previousSolutionBtnDown{};

//恢复
-(void)nextSolutionBtnUp{
    if (currentMove==totalMove-1) {
        return;
    }
    MCRandomSolveSceneController *c = [MCRandomSolveSceneController sharedRandomSolveSceneController];
    [c flashSecne];
     [actionQueue shiftRight];
    [stepcounter minusCounter];
    currentMove++;
    SingmasterNotation notation = (SingmasterNotation)[[singmasternotations objectAtIndex:currentMove]integerValue];
    [c rotateWithSingmasterNotation:notation];
    
    
};
-(void)nextSolutionBtnDown{};

-(void)qSolveBtnDown{
}

-(void)qSolveBtnUp{
    //do solve here
    [SVProgressHUD show];
    [self solveMagicCube];
}

-(void)mainMenuBtnDown{
    NSLog(@"mainMenuPlayBtnDown");
}

-(void)mainMenuBtnUp{
    NSLog(@"mainMenuPlayBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kMainMenu];
}

-(void)pauseSolutionBtnDown{}

-(void)pauseSolutionBtnUp{}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //do something
    if (_selectMenu.expanding) return;
    
    [super touchesBegan:touches withEvent:event];
    if (isFinishInput) {
        return;
    }
    //FSM_Interaction_State fsm_Current_State = [[[CoordinatingController sharedCoordinatingController] currentController].inputController fsm_Current_State];
    if (fsm_Current_State==kState_F2||fsm_Current_State == kState_S2||fsm_Current_State==kState_M2) {
        isWantShowSelectView = NO;
        return;
    }
    isWantShowSelectView = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL isSelectOneFace = NO;
    if (!_selectMenu.expanding){
        [super touchesEnded:touches withEvent:event];
        if (isFinishInput) {
            return;
        }

        UITouch *touch = [touches anyObject];
        _lastestPoint = [touch locationInView:self.view];
        //判断是否拾取到
        MCRandomSolveSceneController * secencontroller = [MCRandomSolveSceneController sharedRandomSolveSceneController];
        vec2 lastpoint2 = vec2(_lastestPoint.x,_lastestPoint.y);
        
        isSelectOneFace = [secencontroller isSelectOneFace:lastpoint2];
        
        if (isSelectOneFace) {
            //选择的小块0-26
            ColorCombinationType index = (ColorCombinationType)[secencontroller selected_index];
            if (index == UColor || index == DColor || index == FColor ||
                index == BColor || index == LColor || index == RColor) {
                isSelectOneFace = NO;
            }
            else{
                FaceOrientationType selectedFaceOrientation = (FaceOrientationType)[secencontroller selected_face_index];
                NSObject<MCCubieDelegate> *targetCubie = [[[MCRandomSolveSceneController sharedRandomSolveSceneController] magicCube] cubieWithColorCombination:index];
                if ([targetCubie isFaceColor:NoColor inOrientation:selectedFaceOrientation]) {
                    [self checkConstraintAtCubie:targetCubie inOrientation:selectedFaceOrientation];
                }
                else{
                    [_selectMenu setMenusArray:_menuItems];
                }
            }
        }
        
    }
    
    
    if (isWantShowSelectView) {
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
}


- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectColor:(FaceColorType)color{
    MCRandomSolveSceneController * secencontroller = [MCRandomSolveSceneController sharedRandomSolveSceneController];
    //选择的小块0-26
    int selected_cube_index = [secencontroller selected_index];
    //选择到面+++上下前后左右012345
    int selected_face_index = [secencontroller selected_face_index];
    //给magicCube填上颜色
    
    NSObject<MCCubieDelegate> *targetCubie = [[[MCRandomSolveSceneController sharedRandomSolveSceneController] magicCube] cubieWithColorCombination:(ColorCombinationType)selected_cube_index];
    [targetCubie setFaceColor:color inOrientation:(FaceOrientationType)selected_face_index];
    
    
    //刷新magicCubeUI
    [secencontroller flashSecne];
    
    
    
    
    //判断是否结束
    
        //结束则开始合成魔方，打开HUD
    
            //合成成功，1，则将魔方到模式变为教学模式，且45度角   2，永久关闭颜色选择框
    
            //合成不成功，alert。
    
            //关闭HUD
    
}


- (void)checkConstraintAtCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation{
    NSMutableArray *avaiableColors = [MCCubieColorConstraintUtil avaiableColorsOfCubie:cubie
                                                                         inOrientation:orientation];
    
    NSMutableArray *loadMenuItems = [NSMutableArray arrayWithCapacity:6];
    
    for (NSNumber *color in avaiableColors) {
        [loadMenuItems addObject:[_menuItems objectAtIndex:[color integerValue]]];
    }
    
    [_selectMenu setMenusArray:loadMenuItems];
}


- (BOOL)solveMagicCube{
    
    MCMagicCube *magicCube = [[MCRandomSolveSceneController sharedRandomSolveSceneController] magicCube];
    
    // Check fill
    if (![magicCube hasAllFacesBeenFilledWithColors]) {
        NSLog(@"Fill all faces firstly!");
        return NO;
    }
    
    // check finish
    if ([magicCube isFinished]) {
        NSLog(@"The magic cube has been finished!");
        return NO;
    }
    
    if (_isInitFinished) {
        
        NSString *stateString = [magicCube stateString];
        
        if (stateString == nil) {
            NSLog(@"Wrong state!");
            return NO;
        } else {
            NSLog(@"%@", stateString);
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // Doing...
            
            // Solve result
            NSString *resultString = [NSString stringWithUTF8String:Search::solution([stateString UTF8String], 24, 1000, true).c_str()];
            
            // Check error
            if ([resultString hasPrefix:@"Error"]) {
                // Set flag yes
                _errorFlag = YES;
                
                if ([resultString hasSuffix:@"1"]) {
                    NSLog(@"%@", @"There are not exactly nine facelets of each color!");
                } else if ([resultString hasSuffix:@"2"]) {
                    NSLog(@"%@", @"Not all 12 edges exist exactly once!");
                } else if ([resultString hasSuffix:@"3"]) {
                    NSLog(@"%@", @"Flip error: One edge has to be flipped!");
                } else if ([resultString hasSuffix:@"4"]) {
                    NSLog(@"%@", @"Not all 8 corners exist exactly once!");
                } else if ([resultString hasSuffix:@"5"]) {
                    NSLog(@"%@", @"Twist error: One corner has to be twisted!");
                } else if ([resultString hasSuffix:@"6"]) {
                    NSLog(@"%@", @"Parity error: Two corners or two edges have to be exchanged!");
                } else if ([resultString hasSuffix:@"7"]) {
                    NSLog(@"%@", @"No solution exists for the given maximum move number!");
                } else if ([resultString hasSuffix:@"8"]) {
                    NSLog(@"%@", @"Timeout, no solution found within given maximum time!");
                }
                
            }
            else {
                NSArray *resultStringComponents = [resultString componentsSeparatedByString:@" "];
                
                // transfer
                NSMutableArray *tags = [NSMutableArray arrayWithCapacity:[resultStringComponents count]];
                if (!singmasternotations) {
                    singmasternotations = [[NSMutableArray alloc]init];
                }
                [singmasternotations removeAllObjects];
                for (int i = 0; i < [resultStringComponents count] - 1; i++) {
                    NSString *component = [resultStringComponents objectAtIndex:i];
                    [tags addObject:[MCTransformUtil getRotationTagFromSingmasterNotation:
                                     [MCTransformUtil singmasternotationFromStringTag:component]]];
                    //[singmasternotations addObject:[[MCTransformUtil singmasternotationFromStringTag:component]];
                    [singmasternotations addObject:[NSNumber numberWithInteger:[MCTransformUtil singmasternotationFromStringTag:component]]];
                }
                totalMove = [singmasternotations count];
                [stepcounter setM_counterValue:totalMove];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Complete
                    NSLog(@"%@", tags);
                    [SVProgressHUD dismiss];
                    [actionQueue removeAllActions];
                    [actionQueue insertQueueCurrentIndexWithNmaeList:tags];
                    //hiden the action queue
                    [self.actionQueue setActive : YES];
            
                    MCRandomSolveSceneController *c = [MCRandomSolveSceneController sharedRandomSolveSceneController];
                    [c turnTheMCUI_Into_SOlVE_Play_MODE];
                    isFinishInput = YES;
                });
            }
            
        });
        
    }
    
    
    return YES;
}


- (void)releaseInterface{
    [super releaseInterface];
    [_selectMenu removeFromSuperview];
    [_selectMenu release];
    [_cubieArray release];
    [_menuItems release];
}

@end
