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

// Return wheather the face color on the specified orientation is the specified color
- (BOOL)isFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation;

// Set the face color on the specified orientation.
// If the cubie has face on this orientation, set the color.
// Otherwise, return NO.
- (BOOL)setFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation;

// Return the number of cubie's faces
- (NSInteger)skinNum;

// Return the identity of the cubie
- (ColorCombinationType)identity;

// Return the coordinate of the cubie
- (Point3i)coordinateValue;

// Return all face colors.
// The size of array is skinNum.
// The Element is NSNumber of FaceColorType and it maybe 'NoColor'.
- (NSArray *)allFaceColors;


// Return all face orientations.
// The size of array is skinNum.
// The Element is NSNumber of FaceOrientationType and it can be Up, Down...
- (NSArray *)allOrientations;


//Return state in the "format" orientation-facecolor
//No reutrn 6 faces but skinNum faces.
- (NSDictionary *)getCubieColorInOrientationsWithoutNoColor;

@end
