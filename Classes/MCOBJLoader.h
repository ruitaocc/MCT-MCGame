//
//  MCOBJLoader.h
//  MCGame
//
//  Created by kwan terry on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <fstream>
#include <vector>

using namespace std;

#define MaxLineSize 128

@interface MCOBJLoader : NSObject{
    NSMutableDictionary * OBJLibrary;
    
    //vector<float> Cube_vertex_coordinates;
    GLfloat * Cube_vertex_coordinates;
    GLfloat * Cube_normal_vectors;
    GLfloat * Cube_texture_coordinates;
    //vector<float> Cube_normal_vectors;
    //vector<float> Cube_texture_coordinates;
    NSString * texture_key;
    int Cube_vertex_array_size;
}

@property int m_vertexCount, m_vertexNormalCount, m_vertexTextureCount, m_faceCount;
@property (assign) int Cube_vertex_array_size;
//@property vector<float> Cube_vertex_coordinates,Cube_normal_vectors,Cube_texture_coordinates;
@property GLfloat * Cube_vertex_coordinates;
@property GLfloat * Cube_normal_vectors;
@property GLfloat * Cube_texture_coordinates;
@property (nonatomic,retain)NSString * texture_key;
+(MCOBJLoader*)sharedMCOBJLoader;
-(void)loadObjFromFile:(NSString*)filename objkey:(NSString*)objkey;


-(void) getAllCount:(NSString*)filename;

@end
