//
//  MCPoint.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


// MCPoint is a 3d point struct.  
// this is the definition of that struct and a hand ful of inline functions for manipulating the point.

// A 3D point
#include "Vector.hpp"
typedef struct {
	CGFloat			x, y, z;
} MCPoint;

typedef MCPoint* MCPointPtr;

static inline MCPoint MCPointMake(CGFloat x, CGFloat y, CGFloat z)
{
	return (MCPoint) {x, y, z};
}

static inline NSString * NSStringFromMCPoint(MCPoint p)
{
	return [NSString stringWithFormat:@"{%3.2f, %3.2f, %3.2f}",p.x,p.y,p.z];
}


typedef struct {
	CGFloat			start, length;
} MCRange;

static inline MCRange MCRangeMake(CGFloat start, CGFloat len)
{
	return (MCRange) {start,len};
}

static inline NSString * NSStringFromMCRange(MCRange p)
{
	return [NSString stringWithFormat:@"{%3.2f, %3.2f}",p.start,p.length];
}

static inline CGFloat MCRandomFloat(MCRange range) 
{
	// return a random float in the range
	CGFloat randPercent = ( (CGFloat)(random() % 1001) )/1000.0;
	CGFloat offset = randPercent * range.length;
	return offset + range.start;	
}


static inline NSString * NSStringFromMatrix(CGFloat * m)
{
	return [NSString stringWithFormat:@"%3.2f %3.2f %3.2f %3.2f\n%3.2f %3.2f %3.2f %3.2f\n%3.2f %3.2f %3.2f %3.2f\n%3.2f %3.2f %3.2f %3.2f\n",m[0],m[4],m[8],m[12],m[1],m[5],m[9],m[13],m[2],m[6],m[10],m[14],m[3],m[7],m[11],m[15]];
}

static inline MCPoint MCPointMatrixMultiply(MCPoint p, CGFloat* m)
{
	CGFloat x = (p.x*m[0]) + (p.y*m[4]) + (p.z*m[8]) + m[12];
	CGFloat y = (p.x*m[1]) + (p.y*m[5]) + (p.z*m[9]) + m[13];
	CGFloat z = (p.x*m[2]) + (p.y*m[6]) + (p.z*m[10]) + m[14];
	
	return (MCPoint) {x, y, z};
}

//顶点数组与矩阵成绩
static inline GLfloat* VertexesArray_Matrix_Multiply(GLfloat *ptr, int vertexStride, int vertexesCount, CGFloat* m)
{
    GLfloat *tmp = new GLfloat[vertexStride*vertexesCount];
	for (int i = 0; i < vertexesCount; i++) {
        
        tmp[0+vertexStride*i] = (ptr[0+vertexStride*i]*m[0]) + (ptr[1+vertexStride*i]*m[4]) + (ptr[2+vertexStride*i]*m[8]) + m[12];
        tmp[1+vertexStride*i] = (ptr[0+vertexStride*i]*m[1]) + (ptr[1+vertexStride*i]*m[5]) + (ptr[2+vertexStride*i]*m[9]) + m[13];
        tmp[2+vertexStride*i] = (ptr[0+vertexStride*i]*m[2]) + (ptr[1+vertexStride*i]*m[6]) + (ptr[2+vertexStride*i]*m[10]) + m[14];
    }
    	
	return tmp;
}

static inline float MCPointDistance(MCPoint p1, MCPoint p2)
{
	return sqrt(((p1.x - p2.x) * (p1.x - p2.x)) + 
                ((p1.y - p2.y)  * (p1.y - p2.y)) + 
                ((p1.z - p2.z) * (p1.z - p2.z)));
}
static inline float VectorPointDistance(vec2 p1, vec2 p2)
{
	return sqrt(((p1.x - p2.x) * (p1.x - p2.x)) +
                ((p1.y - p2.y)  * (p1.y - p2.y)));
}












