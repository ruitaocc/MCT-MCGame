//
//  MCMesh.m
//  
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCMesh.h"


@implementation MCMesh

@synthesize vertexCount,vertexSize,colorSize,renderStyle,vertexes,colors;

- (id)initWithVertexes:(CGFloat*)verts 
           vertexCount:(NSInteger)vertCount 
            vertexSize:(NSInteger)vertSize
           renderStyle:(GLenum)style;
{
	self = [super init];
	if (self != nil) {
		self.vertexes = verts;
		self.vertexCount = vertCount;
		self.vertexSize = vertSize;
		self.renderStyle = style;
	}
	return self;
}

// called once every frame
-(void)render
{
    //glEnable(GL_DEPTH_TEST);

    
	// load arrays into the engine
	glVertexPointer(vertexSize, GL_FLOAT, 0, vertexes);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(colorSize, GL_FLOAT, 0, colors);	
	glEnableClientState(GL_COLOR_ARRAY);
	
	//render
	glDrawArrays(renderStyle, 0, vertexCount);	
}


- (void) dealloc
{
	[super dealloc];
}



@end
