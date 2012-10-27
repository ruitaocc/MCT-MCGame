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

@implementation MCCountingPlayInputViewController



-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    
  
    
    CGFloat btnWidth = 220.0;
    CGFloat btnHeight = 88.0;
    
	
	
	
	// mainMenuBtn
    //the texture 还没设计出来
	MCTexturedButton * mainMenuBtn = [[MCTexturedButton alloc] initWithUpKey:@"systemSettingBtnUp" downKey:@"systemSettingBtnDown"];
	mainMenuBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	mainMenuBtn.translation = MCPointMake(-380, 320.0, 0.0);
	mainMenuBtn.target = self;
	mainMenuBtn.buttonDownAction = @selector(mainMenuBtnDown);
	mainMenuBtn.buttonUpAction = @selector(mainMenuBtnUp);
	mainMenuBtn.active = YES;
	[mainMenuBtn awake];
	[interfaceObjects addObject:mainMenuBtn];
	[mainMenuBtn release];
    
}


-(void)mainMenuBtnDown{
    NSLog(@"mainMenuPlayBtnDown");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kMainMenu];
}
-(void)mainMenuBtnUp{NSLog(@"mainMenuPlayBtnUp");}







@end
