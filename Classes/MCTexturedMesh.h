//
//  MCTexturedMesh.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MCMesh.h"
#import "MCMaterialController.h"

@interface MCTexturedMesh : MCMesh {
	GLfloat * uvCoordinates;
	GLfloat * normals;
	NSString * materialKey;
}

@property (assign) GLfloat * uvCoordinates;
@property (assign) GLfloat * normals;
@property (retain) NSString * materialKey;

@end