//
//  TestCube.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"

#import "MCOBJLoader.h"

//#import "data.hpp"
//#import "TestCubeData.h"
#import "MCParticleSystem.h"
#import "CoordinatingController.h"
#import "MCCollider.h"
@implementation Cube
- (id) init
{
	self = [super init];
	if (self != nil) {
	//	self.collider = nil;
	}
	return self;
}

-(void)awake
{
    active = YES;
    MCOBJLoader *OBJ = [MCOBJLoader sharedMCOBJLoader];
   /* vector<float> Cube_vertex_coordinates_v( [OBJ Cube_vertex_coordinates]);
    vector<float> Cube_texture_coordinates_v ([OBJ Cube_texture_coordinates]);
    vector<float> Cube_normal_vectors_v ([OBJ Cube_normal_vectors]);
    
    GLfloat * Cube_vertex_coordinates = &Cube_vertex_coordinates_v[0];
    GLfloat * Cube_texture_coordinates = &Cube_texture_coordinates_v[0];
    GLfloat * Cube_normal_vectors = &Cube_normal_vectors_v[0];
    */
    GLfloat * Cube_vertex_coordinates = [OBJ Cube_vertex_coordinates];
    GLfloat * Cube_texture_coordinates = [OBJ Cube_texture_coordinates];
    GLfloat * Cube_normal_vectors = [OBJ Cube_normal_vectors];
    int Cube_vertex_array_size = [OBJ Cube_vertex_array_size];
    
	mesh = [[MCTexturedMesh alloc] initWithVertexes:Cube_vertex_coordinates
                                        vertexCount:Cube_vertex_array_size
                                         vertexSize:3 
                                        renderStyle:GL_TRIANGLES];
	[(MCTexturedMesh*)mesh setMaterialKey:@"cubeTexture2"];
	[(MCTexturedMesh*)mesh setUvCoordinates:Cube_texture_coordinates];
	[(MCTexturedMesh*)mesh setNormals:Cube_normal_vectors];
	
    
	
}




// called once every frame
-(void)update
{
    //if (collider != nil) [collider updateCollider:self];
    [super update];

}

-(void)deadUpdate
{
	if ((particleEmitter.emitCounter <= 0) && (![particleEmitter activeParticles])) {
		[[[CoordinatingController sharedCoordinatingController] currentController] removeObjectFromScene:self];	
		[[[CoordinatingController sharedCoordinatingController] currentController] gameOver];
	}
}



- (void) dealloc
{
    if (particleEmitter != nil) [[[CoordinatingController sharedCoordinatingController] currentController] removeObjectFromScene:particleEmitter];
	[particleEmitter release];
	[super dealloc];
}




@end
