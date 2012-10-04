//
//  MCTexturedQuad.h
//  MCGame
//
//  Created by kwan terry on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMesh.h"
#import "MCMaterialController.h"
@interface MCTexturedQuad : MCMesh{
    GLfloat * uvCoordinates;
	NSString * materialKey;
}

@property (assign) GLfloat * uvCoordinates;
@property (retain) NSString * materialKey;

@end
