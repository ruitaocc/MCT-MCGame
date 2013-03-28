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

@implementation MCInputViewController


-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];

    CGFloat xBased = 0.0;
    CGFloat yBased = -200.0;
    CGFloat xGap = 10.0;
    CGFloat yGap = 10.0;
    
    CGFloat btnWidth = 175;
    CGFloat btnHeight = 70.0;
    
	
	
   	// normalPlayBtn
	MCTexturedButton * normalPlayBtn = [[MCTexturedButton alloc] initWithUpKey:@"normalPlayBtnUp" downKey:@"normalPlayBtnUp"];
	normalPlayBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	normalPlayBtn.translation = MCPointMake(xBased-(btnWidth+xGap) , yBased, 0.0);
	normalPlayBtn.target = self;
	normalPlayBtn.buttonDownAction = @selector(normalPlayBtnDown);
	normalPlayBtn.buttonUpAction = @selector(normalPlayBtnUp);
	normalPlayBtn.active = YES;
	[normalPlayBtn awake];
	[interfaceObjects addObject:normalPlayBtn];
	[normalPlayBtn release];
    
    // countingPlayBtn
	
	MCTexturedButton * countingPlayBtn = [[MCTexturedButton alloc] initWithUpKey:@"countingPlayBtnUp" downKey:@"countingPlayBtnUp"];
	countingPlayBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	countingPlayBtn.translation = MCPointMake(xBased , yBased, 0.0);
	countingPlayBtn.target = self;
	countingPlayBtn.buttonDownAction = @selector(countingPlayBtnDown);
	countingPlayBtn.buttonUpAction = @selector(countingPlayBtnUp);
	countingPlayBtn.active = YES;
	[countingPlayBtn awake];
	[interfaceObjects addObject:countingPlayBtn];
	[countingPlayBtn release];
	
	// randomSolveBtn
	MCTexturedButton * randomSolveBtn = [[MCTexturedButton alloc] initWithUpKey:@"randomSolveBtnUp" downKey:@"randomSolveBtnUp"];
	randomSolveBtn.scale = MCPointMake(btnWidth, btnHeight, 1.0);
	randomSolveBtn.translation = MCPointMake(xBased+(btnWidth+xGap), yBased, 0.0);
	randomSolveBtn.target = self;
	randomSolveBtn.buttonDownAction = @selector(randomSolveBtnDown);
    randomSolveBtn.buttonUpAction = @selector(randomSolveBtnUp);	
	randomSolveBtn.active = YES;
	[randomSolveBtn awake];
	[interfaceObjects addObject:randomSolveBtn];
	[randomSolveBtn release];
	
	// systemSettingBtn
	MCTexturedButton * systemSettingBtn = [[MCTexturedButton alloc] initWithUpKey:@"optionBtnUp" downKey:@"optionBtnUp"];
	systemSettingBtn.scale = MCPointMake(60, 78, 1.0);
	systemSettingBtn.translation = MCPointMake(xBased -btnWidth/2, yBased-(btnHeight+yGap), 0.0);
	systemSettingBtn.target = self;
	systemSettingBtn.buttonDownAction = @selector(systemSettingBtnDown);
	systemSettingBtn.buttonUpAction = @selector(systemSettingBtnUp);
	systemSettingBtn.active = YES;
	[systemSettingBtn awake];
	[interfaceObjects addObject:systemSettingBtn];
	[systemSettingBtn release];
	
	// heroBoardBtn
	MCTexturedButton * heroBoardBtn = [[MCTexturedButton alloc] initWithUpKey:@"rankBtnUp" downKey:@"rankBtnUp"];
	heroBoardBtn.scale = MCPointMake(60 , 78, 1.0);
	heroBoardBtn.translation = MCPointMake(xBased +btnWidth/2, yBased-(btnHeight+yGap), 0.0);
	heroBoardBtn.target = self;
	heroBoardBtn.buttonDownAction = @selector(heroBoardBtnDown);
	heroBoardBtn.buttonUpAction = @selector(heroBoardBtnUp);
	heroBoardBtn.active = YES;
	[heroBoardBtn awake];
	[interfaceObjects addObject:heroBoardBtn];
	[heroBoardBtn release];
    
    particleEmitter = [[MCParticleSystem alloc]init];
    particleEmitter.emissionRange = MCRangeMake(300.0, 50.0);
    particleEmitter.sizeRange = MCRangeMake(8.0, 1.0);
    particleEmitter.growRange = MCRangeMake(-0.8, 0.5);
    particleEmitter.xVelocityRange = MCRangeMake(-0.5, 1.0);
    particleEmitter.yVelocityRange = MCRangeMake(-0.5, 1.0);
    particleEmitter.lifeRange = MCRangeMake(0.0, 5.5);
    particleEmitter.decayRange = MCRangeMake(0.03, 0.05);
    [particleEmitter setParticle:@"lightBlur"];
    particleEmitter.translation = MCPointMake(300,10,0);
    particleEmitter.active = YES;
    particleEmitter.emit = YES;
    [interfaceObjects addObject:particleEmitter];
    [particleEmitter release];
    
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
    
}
-(void)systemSettingBtnDown{NSLog(@"systemSettingBtnDown");}
-(void)systemSettingBtnUp{NSLog(@"systemSettingBtnUp");}



-(void)heroBoardBtnDown{
    NSLog(@"heroBoardBtnDown");    
}
-(void)heroBoardBtnUp{
    NSLog(@"heroBoardBtnUp");
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kHeroBoard];
}






@end
