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

#import "MCOBJLoader.h"
#import "MCStringDefine.h"
#import "MCMaterialController.h"
#import "MCLabel.h"
@implementation MCInputViewController


-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    
    //apptitle lebel
    //UI UI step counter label
    MCLabel *apptitleLabel= [[MCLabel alloc]initWithNstring:TextureKey_appTitle];
    apptitleLabel.scale =  MCPointMake(546, 151, 1);
    [apptitleLabel setTranslation :MCPointMake(0, 285, 0.0)];
    [apptitleLabel setActive:YES];
    [apptitleLabel awake];
    [interfaceObjects addObject:apptitleLabel];
    [apptitleLabel release];
    
    
	CGFloat yBased = -262;
   	// normalPlayBtn
	MCTexturedButton * normalPlayBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_learnButtonUp downKey:TextureKey_learnButtonDown];
	normalPlayBtn.scale =  MCPointMake(174, 174, 1);
	normalPlayBtn.translation = MCPointMake(0 , yBased, 0.0);
	normalPlayBtn.target = self;
	normalPlayBtn.buttonDownAction = @selector(normalPlayBtnDown);
	normalPlayBtn.buttonUpAction = @selector(normalPlayBtnUp);
	normalPlayBtn.active = YES;
	[normalPlayBtn awake];
	[interfaceObjects addObject:normalPlayBtn];
	[normalPlayBtn release];
    
    // countingPlayBtn
	
	MCTexturedButton * countingPlayBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_raceButtonUp downKey:TextureKey_raceButtonDown];
	countingPlayBtn.scale =  MCPointMake(144, 144, 1);;
	countingPlayBtn.translation = MCPointMake(-165 , yBased, 0.0);
	countingPlayBtn.target = self;
	countingPlayBtn.buttonDownAction = @selector(countingPlayBtnDown);
	countingPlayBtn.buttonUpAction = @selector(countingPlayBtnUp);
	countingPlayBtn.active = YES;
	[countingPlayBtn awake];
	[interfaceObjects addObject:countingPlayBtn];
	[countingPlayBtn release];
	
	// randomSolveBtn
	MCTexturedButton * randomSolveBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_solveButtonUp downKey:TextureKey_solveButtonDown];
	randomSolveBtn.scale =  MCPointMake(144, 144, 1);
	randomSolveBtn.translation = MCPointMake(165, yBased, 0.0);
	randomSolveBtn.target = self;
	randomSolveBtn.buttonDownAction = @selector(randomSolveBtnDown);
    randomSolveBtn.buttonUpAction = @selector(randomSolveBtnUp);	
	randomSolveBtn.active = YES;
	[randomSolveBtn awake];
	[interfaceObjects addObject:randomSolveBtn];
	[randomSolveBtn release];
	
	// systemSettingBtn
	MCTexturedButton * systemSettingBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_optionButtonUp downKey:TextureKey_optionButtonDown];
	systemSettingBtn.scale =  MCPointMake(120, 120, 1);;
	systemSettingBtn.translation = MCPointMake(-300, yBased, 0.0);
	systemSettingBtn.target = self;
	systemSettingBtn.buttonDownAction = @selector(systemSettingBtnDown);
	systemSettingBtn.buttonUpAction = @selector(systemSettingBtnUp);
	systemSettingBtn.active = YES;
	[systemSettingBtn awake];
	[interfaceObjects addObject:systemSettingBtn];
	[systemSettingBtn release];
	
	// heroBoardBtn
	MCTexturedButton * heroBoardBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_rankButtonUp downKey:TextureKey_rankButtonDown];
	heroBoardBtn.scale =  MCPointMake(120, 120, 1);
	heroBoardBtn.translation = MCPointMake(300, yBased, 0.0);
	heroBoardBtn.target = self;
	heroBoardBtn.buttonDownAction = @selector(heroBoardBtnDown);
	heroBoardBtn.buttonUpAction = @selector(heroBoardBtnUp);
	heroBoardBtn.active = YES;
	[heroBoardBtn awake];
	[interfaceObjects addObject:heroBoardBtn];
	[heroBoardBtn release];
    
    [super loadInterface];
}



-(void)normalPlayBtnDown{NSLog(@"normalPlayBtnDown");}
-(void)normalPlayBtnUp{
    NSLog(@"normalPlayBtnUp");  
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kNormalPlay];
}
-(void)countingPlayBtnDown{
    NSLog(@"countingPlayBtnDown");
    
}
-(void)countingPlayBtnUp{
    NSLog(@"countingPlayBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kCountingPlay];
}
-(void)randomSolveBtnDown{NSLog(@"randomSolveBtnDown");}
-(void)randomSolveBtnUp{
    NSLog(@"randomSolveBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kRandomSolve];
    
}
-(void)systemSettingBtnDown{NSLog(@"systemSettingBtnDown");}
-(void)systemSettingBtnUp{
    NSLog(@"systemSettingBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kSystemSetting];
}



-(void)heroBoardBtnDown{
    NSLog(@"heroBoardBtnDown");    
}
-(void)heroBoardBtnUp{
    NSLog(@"heroBoardBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kHeroBoard];
}






@end
