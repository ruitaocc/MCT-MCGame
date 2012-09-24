//
//  MCSceneObject.m
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCSceneController.h"
#import "MCInputViewController.h"
#import "MCMesh.h"

#pragma mark Spinny Square mesh
//Define the cubeVertices
static GLfloat cubeVertices[]={
    //Define the front face
    -1.0,1.0,1.0,//left top
    -1.0,-1.0,1.0,//left buttom
    1.0,-1.0,1.0,//right buttom
    1.0,1.0,1.0,//top right
    //top face
    -1.0,1.0,-1.0,//left top(at rear)
    -1.0,1.0,1.0,//left buttom(at front)
    1.0,1.0,1.0,//right buttom(at front)
    1.0,1.0,-1.0,//top right(at rear)
    //rear face
    1.0,1.0,-1.0,//right top(when viewed from front)
    1.0,-1.0,-1.0,//rigtht buttom
    -1.0,-1.0,-1.0,//left buttom
    -1.0,1.0,-1.0,//left top 
    //buttom face
    -1.0,-1.0,1.0,//buttom left front
    1.0,-1.0,1.0,//rigtht buttom
    1.0,-1.0,-1.0,//right rear
    -1.0,-1.0,-1.0,//left rear
    //left face
    -1.0,1.0,-1.0,// top left
    -1.0,1.0,1.0,// top right
    -1.0,-1.0,1.0,//buttom right
    -1.0,-1.0,-1.0,//buttom left
    //right face
    1.0,1.0,1.0,//top left
    1.0,1.0,-1.0,//top right
    1.0,-1.0,-1.0,//right
    1.0,-1.0,1.0//left
    
};
//Define the 
static GLfloat colorss[]={
    //Define the front face
    1.0,0.0,0.0,1.0,
    //top face
    0.0,1.0,0.0,1.0,
    //rear face
    0.0,0.0,1.0,1.0,
    //buttom face
    1.0,1.0,0.0,1.0,
    
    //left face
    0.0,1.0,1.0,1.0,
    //right face
    1.0,0.0,1.0,1.0
    
};


static CGFloat spinnySquareVertices[8] = {
-0.5f, -0.5f,
0.5f,  -0.5f,
-0.5f,  0.5f,
0.5f,   0.5f,
};

static CGFloat spinnySquareColors[16] = {
1.0, 1.0,   0, 1.0,
0,   1.0, 1.0, 1.0,
0,     0,   0,   0,
1.0,   0, 1.0, 1.0,
};


@implementation MCSceneObject

@synthesize x,y,z,xRotation,yRotation,zRotation,xScale,yScale,zScale,active;

- (id) init
{
	self = [super init];
	if (self != nil) {
		x = 0.0;
		y = 0.0;
		z = 0.0;
		
		xRotation = 0.0;
		yRotation = 0.0;
		zRotation = 0.0;
		
		xScale = 1.0;
		yScale = 1.0;
		zScale = 1.0;
		
		active = NO;
	}
	return self;
}

// called once when the object is first created.
-(void)awake
{
	mesh = [[MCMesh alloc] initWithVertexes:spinnySquareVertices 
															vertexCount:4
														 vertexSize:2
															renderStyle:GL_TRIANGLE_STRIP];
	mesh.colors = spinnySquareColors;
	mesh.colorSize = 4;
  }

// called once every frame
-(void)update
{
	
	// check the inputs, have we gotten a touch down?
	NSSet * touches = [[MCSceneController sharedSceneController].inputController touchEvents];
    NSUInteger numTaps = [[touches anyObject]tapCount];
	for (UITouch * touch in [touches allObjects]) {
		// then we toggle our active state
		if (touch.phase == UITouchPhaseEnded) {
			active = !active;				
		} 
//        if (touch.phase == UITouchPhaseBegan) {
//            NSUInteger numTaps = [touch tapCount];
//            touch
//        }
	}
	
	// if we are currently active, we will update our zRotation by 3 degrees
	if (active)	zRotation += 3.0;
    //xRotation = 3;
    //yRotation = 3;
   
}

// called once every frame
-(void)render
{
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	
	// move to my position
	glTranslatef(x, y, z);
	
	// rotate
	glRotatef(xRotation, 1.0f, 0.0f, 0.0f);
	glRotatef(yRotation, 0.0f, 1.0f, 0.0f);
	glRotatef(zRotation, 0.0f, 0.0f, 1.0f);
	
	//scale
	glScalef(xScale, yScale, zScale);
	
	[mesh render];
	
	//restore the matrix
	glPopMatrix();
}


- (void) dealloc
{
	[super dealloc];
}

@end
