//
//  MCCollider.m
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCCollider.h"
#import "MCConfiguration.h"

#pragma mark cubre mesh
static NSInteger MCCubreVertexStride = 3;
static NSInteger MCCubreColorStride = 4;
static NSInteger MCCubreOutlineVertexesCount = 36;
static CGFloat MCCubreOutlineVertexes[108] = {    
    //Define the front face
    -1.0,1.0,1.0,//left top
    -1.0,-1.0,1.0,//left buttom
    1.0,1.0,1.0,//top right
    -1.0,-1.0,1.0,//left buttom     
    1.0,-1.0,1.0,//right buttom
    1.0,1.0,1.0,//top right
    //top face
    -1.0,1.0,-1.0,//left top(at rear)
    -1.0,1.0,1.0,//left buttom(at front)
    1.0,1.0,-1.0,//top right(at rear)
    -1.0,1.0,1.0,//left buttom(at front)
    1.0,1.0,1.0,//right buttom(at front)
    1.0,1.0,-1.0,//top right(at rear)
    //rear face
    1.0,1.0,-1.0,//right top(when viewed from front)    
    1.0,-1.0,-1.0,//left top
    -1.0,1.0,-1.0,//rigtht buttom
    1.0,-1.0,-1.0,//rigtht buttom
    -1.0,-1.0,-1.0,//left top
    -1.0,1.0,-1.0,//left buttom
    //buttom face
    -1.0,-1.0,1.0,//buttom left front
    -1.0,-1.0,-1.0,//left rear
    1.0,-1.0,1.0,//rigtht buttom
    1.0,-1.0,1.0,//rigtht buttom
    -1.0,-1.0,-1.0,//left rear
    1.0,-1.0,-1.0,//right rear
    //left face
    -1.0,1.0,-1.0,// top left
    -1.0,-1.0,-1.0,//buttom left
    -1.0,1.0,1.0,// top right
    -1.0,-1.0,-1.0,//buttom left
    -1.0,-1.0,1.0,//buttom right
    -1.0,1.0,1.0,// top right
    //right face
    1.0,1.0,1.0,//top left    
    1.0,-1.0,1.0,//left
    1.0,1.0,-1.0,//top right
    1.0,-1.0,1.0,//left
    1.0,-1.0,-1.0,//right
    1.0,1.0,-1.0//top right
};

static CGFloat MCCubreColorValues[144] = 
{   1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0} ;



@implementation MCCollider
@synthesize checkForCollision;

+(MCCollider*)collider
{
	MCCollider * collider = [[MCCollider alloc] init];
	if (DEBUG_DRAW_COLLIDERS) {
		collider.active = YES;
		[collider awake];		
	}
	collider.checkForCollision = NO;
	return [collider autorelease];	
}
-(void)updateCollider:(MCSceneObject*)sceneObject
{
	if (sceneObject == nil) return;
	transformedCentroid = MCPointMatrixMultiply([sceneObject mesh].centroid , [sceneObject matrix]);
	translation = transformedCentroid;
    //scale = MCPointMake(sceneObject.scale.x, sceneObject.scale.y,sceneObject.scale.z);
    scale = MCPointMake(0, 0,0);
}
-(BOOL)doesCollideWithCollider:(MCCollider*)aCollider
{
	
	return NO;
}

-(BOOL)doesCollideWithMesh:(MCSceneObject*)sceneObject
{
	
	return NO;
}



#pragma mark Scene Object methods for debugging;

-(void)awake
{
    mesh = [[MCMesh alloc] initWithVertexes:MCCubreOutlineVertexes vertexCount:MCCubreOutlineVertexesCount vertexSize:MCCubreVertexStride renderStyle:GL_TRIANGLES];
    
	
	mesh.colors = MCCubreColorValues;
	mesh.colorSize = MCCubreColorStride;
}


-(void)render
{
	if (!mesh || !active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	glTranslatef(translation.x, translation.y, translation.z);
	glScalef(scale.x, scale.y, scale.z);
    
	[mesh render];	
	glPopMatrix();
}


- (void) dealloc
{
	[super dealloc];
}

@end
