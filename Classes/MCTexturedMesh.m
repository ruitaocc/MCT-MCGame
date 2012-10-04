//
//  MCTexturedMesh.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCTexturedMesh.h"


@implementation MCTexturedMesh

@synthesize normals, uvCoordinates, materialKey;

// called once every frame
-(void)render
{
	[[MCMaterialController sharedMaterialController] bindMaterial:materialKey];
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(vertexSize, GL_FLOAT, 0, vertexes);
    glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
    glNormalPointer(GL_FLOAT, 0, normals);
    glDrawArrays(renderStyle, 0, vertexCount);
}
@end

