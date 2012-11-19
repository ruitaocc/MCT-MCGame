//
//  MCRay.m
//  HelloCone
//
//  Created by Aha on 12-10-24.
//
//

#import "MCRay.h"
#import <math.h>

@implementation MCRay

@synthesize vOrigin;
@synthesize vDirection;


-(void)updateWithScreenX:(float) screenX
                 screenY:(float) screenY{
    //由于OpenGL坐标系原点为左下角，而窗口坐标系原点为左上角
    //因此，在OpenGl中的Y应该需要用当前视口高度，减去窗口坐标Y
    float object[3];
    //z = 0 , 得到P0
    [MCGL unProjectfWithScreenX:screenX
                        screenY:screenY
                         depthZ:0.0
                   returnObject:object];
    //填充射线原点P0
    vOrigin.set(object[0], object[1], object[2]);
    
    
    
    //z = 1 ，得到P1
    [MCGL unProjectfWithScreenX:screenX
                        screenY:screenY
                         depthZ:1.0
                   returnObject:object];
    //计算射线的方向，P1 - P0
    vDirection.set(object[0], object[1], object[2]);
    vDirection -= vOrigin;
    //向量归一化
    vDirection.Normalize();

}


-(GLfloat)intersectWithTriangleMadeUpOfV0:(float *)V0
                                    V1:(float *)V1
                                    V2:(float *)V2{
    GLfloat edge1[3];
    GLfloat edge2[3];
    
    edge1[0]=V1[0]-V0[0];
    edge1[1]=V1[1]-V0[1];
    edge1[2]=V1[2]-V0[2];
    edge2[0]=V2[0]-V0[0];
    edge2[1]=V2[1]-V0[1];
    edge2[2]=V2[2]-V0[2];
    
    
    
    GLfloat pvec[3];
    pvec[0]= vDirection.y*edge2[2] - vDirection.z*edge2[1];
    pvec[1]= vDirection.z*edge2[0] - vDirection.x*edge2[2];
    pvec[2]= vDirection.x*edge2[1] - vDirection.y*edge2[0];
    
    GLfloat det ;
    det = edge1[0]*pvec[0]+edge1[1]*pvec[1]+edge1[2]*pvec[2];
    
    GLfloat tvec[3];
    
    if( det > 0 )
    {
        
        tvec[0] =vOrigin.x-V0[0];
        tvec[1] =vOrigin.y-V0[1];
        tvec[2] =vOrigin.z-V0[2];
    }
    else
    {
        
        tvec[0] =V0[0] -vOrigin.x;
        tvec[1] =V0[1] -vOrigin.y;
        tvec[2] =V0[2] -vOrigin.z;
        
        det = -det ;
        
    }
    
    if( det < 0.0001f ) return -1;
    
    
    GLfloat u ;
    u = tvec[0]*pvec[0]+ tvec[1]*pvec[1]+ tvec[2]*pvec[2];
    
    if( u < 0.0f || u > det ) return -1;
    
    GLfloat qvec[3];
    qvec[0]= tvec[1]*edge1[2] - tvec[2]*edge1[1];
    qvec[1]= tvec[2]*edge1[0] - tvec[0]*edge1[2];
    qvec[2]= tvec[0]*edge1[1] - tvec[1]*edge1[0];
    
    
    GLfloat v;
    v = vDirection.x*qvec[0]+vDirection.y*qvec[1]+vDirection.z*qvec[2];
    if( v < 0.0f || u + v > det ) return -1;
    
    GLfloat t = edge2[0]*qvec[0]+edge2[1]*qvec[1]+edge2[2]*qvec[2];
    GLfloat fInvDet = 1.0f / det;
    t *= fInvDet;
    u *= fInvDet;
    v *= fInvDet;
    vec3 distanceVector = vDirection*t;
    
    return sqrt(distanceVector.x*distanceVector.x +
                distanceVector.y*distanceVector.y +
                distanceVector.z*distanceVector.z);
}

-(void)transformWithMatrix:(mat4) matrix{
    vec3 v0 = vOrigin;
    vec3 v1 = vOrigin;
    v1 += vDirection;
    
    matrix.transform(v0, v0);
    matrix.transform(v1, v1);
    
    vOrigin = v0;
    v1 -= v0;
    v1.Normalize();
    vDirection = v1;
}


@end
