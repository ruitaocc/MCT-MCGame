//
//  MCMesh.h
//  
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface MCMesh : NSObject {
	// mesh data
	GLfloat * vertexes;
	GLfloat * colors;
	
	GLenum renderStyle;
	NSInteger vertexCount;
	NSInteger vertexSize;
	NSInteger colorSize;	
}

@property (assign) NSInteger vertexCount;
@property (assign) NSInteger vertexSize;
@property (assign) NSInteger colorSize;
@property (assign) GLenum renderStyle;

@property (assign) GLfloat * vertexes;
@property (assign) GLfloat * colors;

- (id)initWithVertexes:(CGFloat*)verts 
           vertexCount:(NSInteger)vertCount 
            vertexSize:(NSInteger)vertSize
           renderStyle:(GLenum)style;

-(void)render;

@end
