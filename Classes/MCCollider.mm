//
//  MCCollider.m
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCCollider.h"
#import "MCConfiguration.h"


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
	self.matrix = [sceneObject matrix];
    translation = transformedCentroid;
    scale = MCPointMake(sceneObject.scale.x, sceneObject.scale.y,sceneObject.scale.z);
   //scale = MCPointMake(17, 17,17);
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
    bool line = YES;
    if (line) {
        mesh = [[MCMesh alloc] initWithVertexes:MCCubreOutlineVertexes_line vertexCount:MCCubreOutlineVertexesCount_line vertexSize:MCCubreVertexStride_line renderStyle:GL_LINES];
        mesh.colors = MCCubreColorValues_line;
        mesh.colorSize = MCCubreColorStride_line;
    }else {
        mesh = [[MCMesh alloc] initWithVertexes:MCCubreOutlineVertexes vertexCount:        MCCubreOutlineVertexesCount vertexSize:MCCubreVertexStride renderStyle:GL_TRIANGLES];
        mesh.colors = MCCubreColorValues;
        mesh.colorSize = MCCubreColorStride;
    }
}


-(void)render
{
	if (!mesh || !active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	
	glMultMatrixf(matrix);
    //glTranslatef(translation.x, translation.y, translation.z);
    //glScalef(scale.x, scale.y, scale.z);
    //NSLog(@"%f",scale.x);
    
	[mesh render];	
	glPopMatrix();
}


- (void) dealloc
{
	[super dealloc];
}

@end
