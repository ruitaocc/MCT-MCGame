//
//  RCRubiksCube.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCCube.h"

@interface RCRubiksCube : NSObject


//rotate operation
- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction;

//get coordinate of cube having the colors combination
- (struct Point3i) coordinateValueOfCubeWithColorCombination : (ColorCombinationType)combination;

@end
