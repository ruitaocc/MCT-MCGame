//
//  RCCube.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface MCCubie : NSObject<NSCoding>

@property(nonatomic)struct Point3i coordinateValue;
@property(nonatomic)int skinNum;
@property(nonatomic)CubieType type;
@property(nonatomic)ColorCombinationType identity;
@property(nonatomic)FaceColorType *faceColors;
@property(nonatomic)FaceOrientationType *orientations;

//initial the cube's data by coordinate value
- (id) initRightCubeWithCoordinate : (struct Point3i)value;

//re-initiate the cube
- (id)redefinedWithCoordinate:(struct Point3i)value orderedColors:(NSArray *)colors orderedOrientations:(NSArray *)orientations;

//shift the cube‘s data
- (void) shiftOnAxis: (AxisType)axis  inDirection: (LayerRotationDirectionType)direction;

//get the faceColor in specified orientation
- (FaceColorType) faceColorInOrientation: (FaceOrientationType)orientation;

//return wheather the face color on the specified orientation is the specified color
- (BOOL)isFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation;

//return state in the "format" axis-orientation
- (NSDictionary *)getCubieOrientationOfAxis;

//return state in the "format" orientation-facecolor
- (NSDictionary *)getCubieColorInOrientations;

@end
