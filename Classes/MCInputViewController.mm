//
//  MCInputViewController.m
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCInputViewController.h"
#import "MCTexturedButton.h"
@implementation MCInputViewController

@synthesize touchEvents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)niMCundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:niMCundleOrNil]) {
		// init our touch storage set
		touchEvents = [[NSMutableSet alloc] init];
		
	}
	return self;
}
-(void)loadView
{
	
}

-(CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter
{
	// find the point on the screen that is the center of the rectangle
	// and use that to build a screen-space rectangle
	CGPoint screenCenter = CGPointZero;
	CGPoint rectOrigin = CGPointZero;
	// since our view is rotated, then our x and y are flipped
	screenCenter.x = meshCenter.y + 160.0; // need to shift it over
	screenCenter.y = meshCenter.x + 240.0; // need to shift it up
	
	rectOrigin.x = screenCenter.x - (CGRectGetHeight(rect)/2.0); // height and width 
	rectOrigin.y = screenCenter.y - (CGRectGetWidth(rect)/2.0); // are flipped
	
	return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetHeight(rect), CGRectGetWidth(rect));
}


#pragma mark Touch Event Handlers

// just a handy way for other object to clear our events
- (void)clearEvents
{
	[touchEvents removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}


#pragma mark unload, dealloc

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    
	// countingPlayBtn 
	
	MCTexturedButton * countingPlayBtn = [[MCTexturedButton alloc] initWithUpKey:@"countingPlayBtnUp" downKey:@"countingPlayBtnDown"];
	countingPlayBtn.scale = MCPointMake(50.0, 50.0, 1.0);
	countingPlayBtn.translation = MCPointMake(-155.0, -130.0, 0.0);
	countingPlayBtn.target = self;
	countingPlayBtn.buttonDownAction = @selector(countingPlayBtnDown);
	countingPlayBtn.buttonUpAction = @selector(countingPlayBtnUp);
	countingPlayBtn.active = YES;
	[countingPlayBtn awake];
	[interfaceObjects addObject:countingPlayBtn];
	[countingPlayBtn release];
	
	// normalPlayBtn
	MCTexturedButton * normalPlayBtn = [[MCTexturedButton alloc] initWithUpKey:@"normalPlayBtnUp" downKey:@"normalPlayBtnDown"];
	normalPlayBtn.scale = MCPointMake(50.0, 50.0, 1.0);
	normalPlayBtn.translation = MCPointMake(-210.0, -130.0, 0.0);
	normalPlayBtn.target = self;
	normalPlayBtn.buttonDownAction = @selector(normalPlayBtnDown);
	normalPlayBtn.buttonUpAction = @selector(normalPlayBtnUp);
	normalPlayBtn.active = YES;
	[normalPlayBtn awake];
	[interfaceObjects addObject:normalPlayBtn];
	[normalPlayBtn release];
	
	// randomSolveBtn
	MCTexturedButton * randomSolveBtn = [[MCTexturedButton alloc] initWithUpKey:@"randomSolveBtnUp" downKey:@"randomSolveBtnDown"];
	randomSolveBtn.scale = MCPointMake(50.0, 50.0, 1.0);
	randomSolveBtn.translation = MCPointMake(-185.0, -75.0, 0.0);
	randomSolveBtn.target = self;
	randomSolveBtn.buttonDownAction = @selector(randomSolveBtnDown);
	randomSolveBtn.buttonUpAction = @selector(randomSolveBtnUp);	
	randomSolveBtn.active = YES;
	[randomSolveBtn awake];
	[interfaceObjects addObject:randomSolveBtn];
	[randomSolveBtn release];
	
	// systemSettingBtn
	MCTexturedButton * systemSettingBtn = [[MCTexturedButton alloc] initWithUpKey:@"systemSettingBtnUp" downKey:@"systemSettingBtnDown"];
	systemSettingBtn.scale = MCPointMake(50.0, 50.0, 1.0);
	systemSettingBtn.translation = MCPointMake(210.0, -130.0, 0.0);
	systemSettingBtn.target = self;
	systemSettingBtn.buttonDownAction = @selector(systemSettingBtnDown);
	systemSettingBtn.buttonUpAction = @selector(systemSettingBtnUp);
	systemSettingBtn.active = YES;
	[systemSettingBtn awake];
	[interfaceObjects addObject:systemSettingBtn];
	[systemSettingBtn release];
	
	// heroBoardBtn
	MCTexturedButton * heroBoardBtn = [[MCTexturedButton alloc] initWithUpKey:@"heroBoardBtnUp" downKey:@"heroBoardBtnDown"];
	heroBoardBtn.scale = MCPointMake(50.0, 50.0, 1.0);
	heroBoardBtn.translation = MCPointMake(155.0, -130.0, 0.0);
	heroBoardBtn.target = self;
	heroBoardBtn.buttonDownAction = @selector(heroBoardBtnDown);
	heroBoardBtn.buttonUpAction = @selector(heroBoardBtnUp);
	heroBoardBtn.active = YES;
	[heroBoardBtn awake];
	[interfaceObjects addObject:heroBoardBtn];
	[heroBoardBtn release];
}

-(void)updateInterface
{
	[interfaceObjects makeObjectsPerformSelector:@selector(update)];
}


-(void)renderInterface
{
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
	
	// set up the viewport so that it is analagous to the screen pixels
	glOrthof(-240, 240, -160, 160, -1.0f, 50.0f);
	
	glMatrixMode(GL_MODELVIEW);
	glDisable(GL_LIGHTING);
	glDisable(GL_CULL_FACE);
    //	glCullFace(GL_FRONT);
    
	// simply call 'render' on all our scene objects
	[interfaceObjects makeObjectsPerformSelector:@selector(render)];
    
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
    
}


-(void)countingPlayBtnDown{}
-(void)countingPlayBtnUp{}
-(void)normalPlayBtnDown{}
-(void)normalPlayBtnUp{}
-(void)randomSolveBtnDown{}
-(void)randomSolveBtnUp{}
-(void)systemSettingBtnDown{}
-(void)systemSettingBtnUp{}
-(void)heroBoardBtnDown{}
-(void)heroBoardBtnUp{}



- (void)dealloc 
{
	[touchEvents release];
	[super dealloc];
}


@end
