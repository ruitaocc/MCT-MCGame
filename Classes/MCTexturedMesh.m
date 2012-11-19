//
//  MCTexturedMesh.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCTexturedMesh.h"

#import "CoordinatingController.h"
#import "MCCountingPlaySceneController__1.h"
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
    
//    float *color_array = new float[vertexSize*4];
//    for (int i = 0; i < vertexSize; i++) {
//        color_array[i*4] = 1.0;
//        color_array[i*4+1] = 0.0;
//        color_array[i*4+2] = 0.0;
//        color_array[i*4+3] = 1.0;
//    }
    
	glVertexPointer(vertexSize, GL_FLOAT, 0, vertexes);
    glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
    //glColorPointer(4, GL_FLOAT, 0, color_array);
    glNormalPointer(GL_FLOAT, 0, normals);
    glDrawArrays(renderStyle, 0, vertexCount);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
}
@end

