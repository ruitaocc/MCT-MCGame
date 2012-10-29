//
//  TestCube.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestCube.h"



#import "data.hpp"
//#import "TestCubeData.h"
#import "MCParticleSystem.h"
#import "CoordinatingController.h"
@implementation TestCube

- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

-(void)awake
{
	mesh = [[MCTexturedMesh alloc] initWithVertexes:Cube_vertex_coordinates 
                                        vertexCount:Cube_vertex_array_size
                                         vertexSize:3 
                                        renderStyle:GL_TRIANGLES];
	[(MCTexturedMesh*)mesh setMaterialKey:@"cubeTexture"];
	[(MCTexturedMesh*)mesh setUvCoordinates:Cube_texture_coordinates];
	[(MCTexturedMesh*)mesh setNormals:Cube_normal_vectors];
	
	
	
}


-(void)fireMissile
{

}


// called once every frame
-(void)update
{
    
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
