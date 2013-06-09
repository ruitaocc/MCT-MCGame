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


// Return colors that 
+ (NSArray *)avaiableColorsOfCubie:(NSObject<MCCubieDelegate> *)cubie;

@end
