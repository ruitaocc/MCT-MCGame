//
//  MCCubieColorConstraintUtil.h
//  MCGame
//
//  Created by Aha on 13-6-9.
//
//

#import <Foundation/Foundation.h>
#import "MCCubieDelegate.h"

@interface MCCubieColorConstraintUtil : NSObject


// Return colors that can be filled in this orientation of the cubie.
+ (NSMutableArray *)avaiableColorsOfCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation;


+ (void)fillRightFaceColorAtCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation;

// Get the right orientations in CW order.
+ (NSArray *)getFaceOrientationsInColokWiseOrderAtCornerPosition:(struct Point3i)point;

@end
