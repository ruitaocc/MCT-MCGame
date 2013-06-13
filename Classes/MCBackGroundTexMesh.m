//
//  MCBackGroundTexMesh.m
//  MCGame
//
//  Created by kwan terry on 13-6-13.
//
//

#import "MCBackGroundTexMesh.h"
float background_vertex_coordinates []={
    -5.12,3.84,0,
    -5.12,-3.84,0,
    5.12,-3.84,0,
    5.12,-3.84,0,
    5.12,3.84,0,
    -5.12,3.84,0
};
float background_vertex_texture_coordinates []={
    0,0,
    0,0.75,
    1,0.75,
    1,0.75,
    1,0,
    0,0
};
float background_normal_vectors [] = {
    //上
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0
};
@implementation MCBackGroundTexMesh
-(id)init{
    if (self = [super init]) {
        
        mesh = [[MCTexturedMesh alloc] initWithVertexes:background_vertex_coordinates
                                    vertexCount:6
                                     vertexSize:3
                                    renderStyle:GL_TRIANGLES];
        [(MCTexturedMesh*)mesh setMaterialKey:@"background"];
        [(MCTexturedMesh*)mesh setUvCoordinates:background_vertex_texture_coordinates];
        [(MCTexturedMesh*)mesh setNormals:background_normal_vectors];
    }
    return self;
}

-(void)render
{
    if (!mesh || !active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	glMultMatrixf(matrix);
	[mesh render];
	glPopMatrix();
}
@end
