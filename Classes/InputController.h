//
//  InputControllerViewController.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCConfiguration.h"
#import "MCParticleSystem.h"
@interface InputController : UIViewController{
	NSMutableSet* touchEvents;
  	FSM_Interaction_State fsm_Previous_State;
    FSM_Interaction_State fsm_Current_State;
	NSMutableArray * interfaceObjects;
    MCParticleSystem *particleEmitter;
    int touchCount;
   // BOOL isNeededReload;
}
//@property (nonatomic,assign) BOOL isNeededReload;
@property (assign) int touchCount;
@property (retain) NSMutableSet* touchEvents;
@property (assign) FSM_Interaction_State fsm_Previous_State;
@property (assign) FSM_Interaction_State fsm_Current_State;
//10
- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ;
- (void)clearEvents;
- (void)dealloc ;
- (void)didReceiveMemoryWarning ;
- (void)loadView ;
- (void)viewDidUnload ;
- (void)loadInterface;
- (void)renderInterface;
- (void)updateInterface;
//
-(void)releaseSrc;
//3
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;


@end
