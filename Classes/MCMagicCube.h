//
//  RCRubiksCube.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCubie.h"
#import "MCMagicCubeDelegate.h"

@interface MCMagicCube : NSObject <NSCoding, MCMagicCubeDelegate>


//FaceColorKey-RealColor
@property (retain, nonatomic) NSDictionary *faceColorKeyMappingToRealColor;


//get a new magic cube
+ (MCMagicCube *)magicCube;

//get a saved magic cube from an archived file
+ (MCMagicCube *)unarchiveMagicCubeWithFile:(NSString *)path;

//get the state of cubies
//every state in the "format" axis-orientation
- (NSArray *)getAxisStatesOfAllCubie;

//get the state of cubies
//every state in the "format" orientation-face color
- (NSArray *)getColorInOrientationsOfAllCubie;

//After change the color setting,
//you can applying it in the data model by invoking this method.
- (void)reloadColorMappingDictionary;



@end
