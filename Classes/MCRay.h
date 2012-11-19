//
//  MCRay.h
//  HelloCone
//
//  Created by Aha on 12-10-24.
//
//

#import <Foundation/Foundation.h>
#import "Vector.hpp"
#import "MCGL.h"

@interface MCRay : NSObject{
    vec3 vOrigin;
    vec3 vDirection;
}

@property() vec3 vOrigin;
@property() vec3 vDirection;

//Once create the ray, this function is used for updatint self by the screen coordinate.
//What it gets is the ray in the world coordinate.
-(void)updateWithScreenX:(float) screenX
                 screenY:(float) screenY;

//Once the ray is transfor into the model coordinate, by this function you can check if the triangle intersect with the ray.
//You should give three vertexs of the triangle.
//If intersection occurs, it will return the distance between intersected point and the clicked point.
//If no, return -1.
-(GLfloat)intersectWithTriangleMadeUpOfV0:(float *)V0
                                    V1:(float *)V1
                                    V2:(float *)V2;

//You can transform the ray from world coordinate into model world coordinate by use the inverse of the current modelview.
//If you want to check intersection many times, don't forget that before what is transformed should be the copy object.
-(void)transformWithMatrix:(mat4) matrix;

@end
