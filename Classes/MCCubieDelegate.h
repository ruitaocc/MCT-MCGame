//
//  MCCubieDelegate.h
//  MCGame
//
//  Created by Aha on 13-5-16.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"

@protocol MCCubieDelegate <NSObject>

//shift the cube‘s data
- (void) shiftOnAxis: (AxisType)axis  inDirection: (LayerRotationDirectionType)direction;

//get the faceColor in specified orientation
- (FaceColorType)faceColorInOrientation: (FaceOrientationType)orientation;

//return wheather the face color on the specified orientation is the specified color
- (BOOL)isFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation;

//Return the number of cubie's faces
- (NSInteger)skinNum;

//Return the identity of the cubie
- (ColorCombinationType)identity;

//Return the coordinate of the cubie
- (Point3i)coordinateValue;

//Return state in the "format" orientation-facecolor
//No reutrn 6 faces but skinNum faces.
- (NSDictionary *)getCubieColorInOrientationsWithoutNoColor;

@end
