//
//  RCCube.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCCubieDelegate.h"

@interface MCCubie : NSObject<NSCoding, MCCubieDelegate>

@property(nonatomic)struct Point3i coordinateValue;
@property(nonatomic)int skinNum;
@property(nonatomic)CubieType type;
@property(nonatomic)ColorCombinationType identity;
@property(nonatomic)FaceColorType *faceColors;
@property(nonatomic)FaceOrientationType *orientations;

// Initial the cube's data by orignal coordinate value
- (id) initRightCubeWithCoordinate : (struct Point3i)value;

// Re-initiate the cube
- (id)redefinedWithCoordinate:(struct Point3i)value orderedColors:(NSArray *)colors orderedOrientations:(NSArray *)orientations;

// Only the center color will be filled, others will be filled with 'NoColor'
- (id)initOnlyCenterColor:(struct Point3i)value;

//return state in the "format" axis-orientation
- (NSDictionary *)getCubieOrientationOfAxis;

//return state in the "format" orientation-facecolor
//All 6 faces will be returned.
- (NSDictionary *)getCubieColorInOrientations;

@end
