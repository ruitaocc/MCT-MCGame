//
//  MCInputViewController.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCInputViewController : UIViewController {
	NSMutableSet* touchEvents;
  	
	NSMutableArray * interfaceObjects;
}

@property (retain) NSMutableSet* touchEvents;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ;
- (BOOL)touchesDidBegin;
- (void)clearEvents;
- (void)dealloc ;
- (void)didReceiveMemoryWarning ;
- (void)loadView ;
- (void)viewDidUnload ;

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;

- (void)loadInterface;
- (void)renderInterface;
- (void)updateInterface;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)countingPlayBtnDown;
-(void)countingPlayBtnUp;
-(void)normalPlayBtnDown;
-(void)normalPlayBtnUp;
-(void)randomSolveBtnDown;
-(void)randomSolveBtnUp;
-(void)systemSettingBtnDown;
-(void)systemSettingBtnUp;
-(void)heroBoardBtnDown;
-(void)heroBoardBtnUp;









@end
