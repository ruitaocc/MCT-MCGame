//
//  MCMagicCubeProtocol.h
//  MCGame
//
//  Created by Aha on 13-5-16.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCCubieDelegate.h"

@protocol MCMagicCubeDelegate <NSObject>

//rotate operation with axis, layer, direction
- (void)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction;

//get coordinate of cube having the colors combination
- (struct Point3i)coordinateValueOfCubieWithColorCombination:(ColorCombinationType)combination;

//get the cubie having the colors combination
- (NSObject<MCCubieDelegate> *)cubieWithColorCombination:(ColorCombinationType)combination;

//get the cube in the specified position
- (NSObject<MCCubieDelegate> *)cubieAtCoordinateX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z;
- (NSObject<MCCubieDelegate> *)cubieAtCoordinatePoint3i:(struct Point3i)point;

//rotate with Singmaster Notation
- (void)rotateWithSingmasterNotation:(SingmasterNotation)notation;

- (FaceOrientationType)centerMagicCubeFaceInOrientation:(FaceOrientationType)orientation;

//Using color mapping dictionary,
//you can get the real color corresponding to face color type.
- (NSString *)getRealColor:(FaceColorType)color;

@end
