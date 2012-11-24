//
//  RCCube.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

struct Point3i{
    int x;
    int y;
    int z;
};

@interface RCCube : NSObject

@property(nonatomic) struct Point3i coordinateValue;
@property(nonatomic) int skinNum;
@property(nonatomic) CubieType type;
@property(nonatomic) FaceColorType *faceColors;
@property(nonatomic) FaceOrientationType *orientations;

//initial the cube's data by coordinate value
- (id) initWithCoordinateValue : (struct Point3i)value;

//shift the cube‘s data
- (void) shiftOnAxis: (AxisType)axis  inDirection: (LayerRotationDirectionType)direction;

//get the faceColor in specified orientation
- (FaceColorType) faceColorOnDirection: (FaceOrientationType)orientation;


@end
