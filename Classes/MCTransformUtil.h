//
//  MCTransformUtil.h
//  MagicCubeModel
//
//  Created by Aha on 13-3-12.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface MCTransformUtil : NSObject

+ (FaceOrientationType)getContraryOrientation:(FaceOrientationType)orientation;

+ (NSString *)getRotationTagFromSingmasterNotation:(SingmasterNotation)notation;

+ (SingmasterNotation)getSingmasterNotationFromAxis:(AxisType)axis layer:(int)layer direction:(LayerRotationDirectionType)direction;

+ (SingmasterNotation)getContrarySingmasterNotation:(SingmasterNotation)notation;

//all situations but not Bw+Bw=Bw2...
+ (BOOL)isSingmasterNotation:(SingmasterNotation)first andSingmasterNotation:(SingmasterNotation)second equalTo:(SingmasterNotation)target;

//all situations but not Bw+Bw=Bw2...
+ (BOOL)isSingmasterNotation:(SingmasterNotation)part PossiblePartOfSingmasterNotation:(SingmasterNotation)target;

+ (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation;
@end
