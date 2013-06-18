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


// FaceColorKey-RealColor
@property (retain, nonatomic) NSDictionary *faceColorKeyMappingToRealColor;


// Get a new magic cube
+ (MCMagicCube *)magicCube;

// Get a saved magic cube from an archived file
+ (MCMagicCube *)unarchiveMagicCubeWithFile:(NSString *)path;

// Get a magic cube that only center cubie has been filled with color.
+ (id)magicCubeOnlyWithCenterColor;

// Get the state of cubies
// Every state in the "format" axis-orientation
- (NSArray *)getAxisStatesOfAllCubie;

// Get the state of cubies
// Every state in the "format" orientation-face color
- (NSArray *)getColorInOrientationsOfAllCubie;

// After change the color setting,
// you can applying it in the data model by invoking this method.
- (void)reloadColorMappingDictionary;

// This function will flip the magic cube.
// The result will be that:
// UpColor face Up
// DownColor face Down
// FrontColor face Front
// BackColor face Back
// LeftColor face Left
// RightColor face Right
- (void)resetCenterFaceOrientation;


- (NSString *)stateString;


// If all faces of this cubie have been filled.
- (BOOL)hasAllFacesBeenFilledWithColors;

@end
