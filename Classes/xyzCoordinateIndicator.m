
//
//  xyzCoordinateIndicator.m
//  MCGame
//
//  Created by kwan terry on 13-6-9.
//
//

#import "xyzCoordinateIndicator.h"
#import "MCTexturedMesh.h"
#import "MCMesh.h"
//#import "data.hpp"

float xyzCoordinate_vertex_coordinates []={
    0.0,0.0,0.0,1.0,0.0,0.0,//x轴
    1.0,0.0,0.0,0.95,0.05,0.0,//x轴箭头j1
    1.0,0.0,0.0,0.95,-0.05,0.0,//x轴箭头j1
    
    1.10,-0.04,0.0,1.05,0.04,0.0,//x轴箭头j1
    1.10,0.04,0.0,1.05,-0.04,0.0,//x轴箭头j1
    
    0.0,0.0,0.0,0.0,1.0,0.0,//y轴
    0.0,1.0,0.0,0.05,0.95,0.0,//y轴箭头j1
    0.0,1.0,0.0,0.0,0.95,0.05,//y轴箭头j1
    0.0,1.08,0.0,0.04,1.12,0.0,//y
    0.0,1.08,0.0,0.0,1.12,0.04,
    0.0,1.08,0.0,0.0,1.03,0.0,
    0.0,0.0,0.0,0.0,0.0,1.0,//z轴
    0.0,0.0,1.0,0.0,0.05,0.95,//z轴箭头j1
    0.0,0.0,1.0,0.0,-0.05,0.95,//z轴箭头j1
    
    0.0,0.04,1.10,0.0,0.04,1.05,//z
    0.0,0.04,1.05,0.0,-0.05,1.10,
    0.0,-0.05,1.10,0.0,-0.05,1.05
};

@implementation xyzCoordinateIndicator
-(id)init{
    if (self = [super init]) {
       
        mesh = [[MCMesh alloc] initWithVertexes:xyzCoordinate_vertex_coordinates
                                            vertexCount:34
                                             vertexSize:3
                                            renderStyle:GL_LINES];
        
    }
    return self;
}
@end
