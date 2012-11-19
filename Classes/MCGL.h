//
//  MCGL.h
//  HelloCone
//
//  Created by Aha on 12-10-24.
//
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <stack>
#import "Matrix.hpp"
#import "Quaternion.hpp"
using namespace std;

#define SWAP_ROWS_DOUBLE(a, b) { double *_tmp = a; (a)=(b); (b)=_tmp; }
#define SWAP_ROWS_FLOAT(a, b) { float *_tmp = a; (a)=(b); (b)=_tmp; }
#define MAT(m,r,c) (m)[(c)*4+(r)]

@interface MCGL : NSObject

//You can use this function for get the vertex in the 3D space(world coordinate).
//You should give the screen location and the Z depth(between 0 and 1, included).
//If the Z is 0, it will return the vertex on the near plane. If 1,the far plane.
//The renturn value will store in parameter object below.
+(BOOL)unProjectfWithScreenX:(float)winx
                     screenY:(float)winy
                      depthZ:(float)winz
                returnObject:(float*)object;

//the function like glMatrixMode.
+(void)matrixMode:(GLenum)mode;

//the function like glLoadIdentity().
+(void)loadIdentity;

//the function like gluPerspective.
//you can use this advanced function to set the projection matrix which isn't in OpenGL ES.
+(void)perspectiveWithFovy:(float)fovy
                    aspect:(float)aspect
                     zNear:(float)zNear
                      zFar:(float)zFar;

//the function like glTranslatef.
+(void)translateWithX:(float)x
                    Y:(float)y
                    Z:(float)z;

//Here, I use quaternion to set rotation.
+(void)rotateWithQuaternion:(Quaternion)delta;

//the function like gluLookAt.
+(void)lookAtEyefv:(vec3)eye
          centerfv:(vec3)center
              upfv:(vec3)up;

//the function like glPushMatrix.
+(void)pushMatrix;

//the function like glPopMatrix.
+(void)popMatrix;

//Because of some differences on multiple operation between normal mathmatic operation and opengl, I retain it.
void multiplyMatrices4by4OpenGL_FLOAT(float *result, const const float *matrix1, const float *matrix2);

//Because of some differences on multiple operation between normal mathmatic operation and opengl, I retain it.
void multiplyMatrixByVector4by4OpenGL_FLOAT(float *resultvector, const float *matrix, const float *pvector);

//This code comes directly from GLU except that it is for float.
int glhInvertMatrixf2(const float *m, float *out);

//You can get the current view matrix.
//Notice!I have split the MODELVIEW_MATRIX into view matrix and model matrix.
+(mat4)getCurrentViewMatrix;

//You can get the current model matrix.
//Notice!I have split the MODELVIEW_MATRIX into view matrix and model matrix.
+(mat4)getCurrentModelMatrix;

//You can get the current projection matrix.
+(mat4)getCurrentProjectionMatrix;

@end
