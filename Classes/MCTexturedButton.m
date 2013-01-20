//
//  MCTexturedButton.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "MCTexturedButton.h"
#import "MCSceneController.h"
#import "CoordinatingController.h"
@implementation MCTexturedButton

- (id) initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey
{
	self = [super init];
	if (self != nil) {
		upQuad = [[MCMaterialController sharedMaterialController] quadFromAtlasKey:upKey];
		downQuad = [[MCMaterialController sharedMaterialController] quadFromAtlasKey:downKey];
		[upQuad retain];
		[downQuad retain];
	}
	return self;
}

// called once when the object is first created.
-(void)awake
{
	[self setNotPressedVertexes];
	screenRect = [[[CoordinatingController sharedCoordinatingController] currentController].inputController 
                  screenRectFromMeshRect:self.meshBounds 
                  atPoint:CGPointMake(translation.x, translation.y)];
    //CGPoint orih =  screenRect.origin;
    //CGSize size =  screenRect.size;
   // NSLog(@"screenRect.x = %f,screenRect.y = %f",orih.x,orih.y);
   // NSLog(@"screenRect.sizex = %f,screenRect.sizey = %f",size.width,size.height);
   // NSLog(@"translation.x = %f,translation.y = %f",translation.x,translation.y);
	// this is a bit rendundant, but allows for much simpler subclassing
}

// called once every frame
-(void)update
{
	// check for touches
	[self handleTouches];
	[super update];
}

-(void)setPressedVertexes
{
	self.mesh = downQuad;
}

-(void)setNotPressedVertexes
{
	self.mesh = upQuad;
}

- (void) dealloc
{
	[upQuad release];
	[downQuad release];
	[super dealloc];
}


@end

