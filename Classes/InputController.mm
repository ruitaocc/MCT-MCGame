//
//  InputControllerViewController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputController.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation InputController

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
	screenCenter.x = meshCenter.y + 384.0; // need to shift it over
	screenCenter.y = meshCenter.x + 512.0; // need to shift it up
	
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
	//implemented by sub class
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
	glOrthof(-512, 512, -384, 384, -1.0f, 50.0f);
	
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

//
-(void)releaseSrc{
    [interfaceObjects removeAllObjects];
}




- (void)dealloc 
{
	[touchEvents release];
	[super dealloc];
}
@end
