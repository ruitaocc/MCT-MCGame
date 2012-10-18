//
//  MCInputViewController.m
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCInputViewController.h"
#import "MCTexturedButton.h"
#import "CoordinatingController.h"
@implementation MCInputViewController


-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];

    CGFloat xBased = -270.0;
    CGFloat yBased = 200.0;
    CGFloat xGap = 0.0;
    CGFloat yGap = 10.0;
    
    CGFloat btnWidth = 220.0;
    CGFloat btnHeight = 88.0;
    
	// countingPlayBtn 
	
	MCTexturedButton * countingPlayBtn = [[MCTexturedButton alloc] initWithUpKey:@"countingPlayBtnUp" downKey:@"countingPlayBtnDown"];
	countingPlayBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	countingPlayBtn.translation = MCPointMake(xBased , yBased, 0.0);
	countingPlayBtn.target = self;
	countingPlayBtn.buttonDownAction = @selector(countingPlayBtnDown);
	countingPlayBtn.buttonUpAction = @selector(countingPlayBtnUp);
	countingPlayBtn.active = YES;
	[countingPlayBtn awake];
	[interfaceObjects addObject:countingPlayBtn];
	[countingPlayBtn release];
	
   	// normalPlayBtn
	MCTexturedButton * normalPlayBtn = [[MCTexturedButton alloc] initWithUpKey:@"normalPlayBtnUp" downKey:@"normalPlayBtnDown"];
	normalPlayBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	normalPlayBtn.translation = MCPointMake(xBased , yBased-(btnHeight+yGap), 0.0);
	normalPlayBtn.target = self;
	normalPlayBtn.buttonDownAction = @selector(normalPlayBtnDown);
	normalPlayBtn.buttonUpAction = @selector(normalPlayBtnUp);
	normalPlayBtn.active = YES;
	[normalPlayBtn awake];
	[interfaceObjects addObject:normalPlayBtn];
	[normalPlayBtn release];
	
	// randomSolveBtn
	MCTexturedButton * randomSolveBtn = [[MCTexturedButton alloc] initWithUpKey:@"randomSolveBtnUp" downKey:@"randomSolveBtnDown"];
	randomSolveBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	randomSolveBtn.translation = MCPointMake(xBased , yBased-(btnHeight+yGap)*2, 0.0);
	randomSolveBtn.target = self;
	randomSolveBtn.buttonDownAction = @selector(randomSolveBtnDown);
    randomSolveBtn.buttonUpAction = @selector(randomSolveBtnUp);	
	randomSolveBtn.active = YES;
	[randomSolveBtn awake];
	[interfaceObjects addObject:randomSolveBtn];
	[randomSolveBtn release];
	
	// systemSettingBtn
	MCTexturedButton * systemSettingBtn = [[MCTexturedButton alloc] initWithUpKey:@"systemSettingBtnUp" downKey:@"systemSettingBtnDown"];
	systemSettingBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	systemSettingBtn.translation = MCPointMake(xBased , yBased-(btnHeight+yGap)*3, 0.0);
	systemSettingBtn.target = self;
	systemSettingBtn.buttonDownAction = @selector(systemSettingBtnDown);
	systemSettingBtn.buttonUpAction = @selector(systemSettingBtnUp);
	systemSettingBtn.active = YES;
	[systemSettingBtn awake];
	[interfaceObjects addObject:systemSettingBtn];
	[systemSettingBtn release];
	
	// heroBoardBtn
	MCTexturedButton * heroBoardBtn = [[MCTexturedButton alloc] initWithUpKey:@"heroBoardBtnUp" downKey:@"heroBoardBtnDown"];
	heroBoardBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	heroBoardBtn.translation = MCPointMake(xBased , yBased-(btnHeight+yGap)*4, 0.0);
	heroBoardBtn.target = self;
	heroBoardBtn.buttonDownAction = @selector(heroBoardBtnDown);
	heroBoardBtn.buttonUpAction = @selector(heroBoardBtnUp);
	heroBoardBtn.active = YES;
	[heroBoardBtn awake];
	[interfaceObjects addObject:heroBoardBtn];
	[heroBoardBtn release];
}

-(void)countingPlayBtnDown{
    NSLog(@"countingPlayBtnDown");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kCountingPlay];
}
-(void)countingPlayBtnUp{NSLog(@"countingPlayBtnUp");}

-(void)normalPlayBtnDown{NSLog(@"normalPlayBtnDown");}
-(void)normalPlayBtnUp{NSLog(@"normalPlayBtnUp");}
-(void)randomSolveBtnDown{NSLog(@"randomSolveBtnDown");}
-(void)randomSolveBtnUp{NSLog(@"randomSolveBtnUp");}
-(void)systemSettingBtnDown{NSLog(@"systemSettingBtnDown");}
-(void)systemSettingBtnUp{NSLog(@"systemSettingBtnUp");}
-(void)heroBoardBtnDown{NSLog(@"heroBoardBtnDown");}
-(void)heroBoardBtnUp{NSLog(@"heroBoardBtnUp");}






@end
