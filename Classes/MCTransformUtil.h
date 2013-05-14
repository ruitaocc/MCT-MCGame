//
//  MCTransformUtil.h
//  MagicCubeModel
//
//  Created by Aha on 13-3-12.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCBasicElement.h"

@interface MCTransformUtil : NSObject

+ (FaceOrientationType)getContraryOrientation:(FaceOrientationType)orientation;

+ (NSString *)getRotationTagFromSingmasterNotation:(SingmasterNotation)notation;

+ (SingmasterNotation)getSingmasterNotationFromAxis:(AxisType)axis layer:(int)layer direction:(LayerRotationDirectionType)direction;

+ (SingmasterNotation)getContrarySingmasterNotation:(SingmasterNotation)notation;

+ (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation;

//By delivering pattern node to this function,
//we can get the node content.
//Notice! The type of this node must be 'PatternNode'.
+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node;

//Return the negative sentence of the string returned by
//"+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node"
+ (NSString *)getNegativeSentenceOfContentFromPatternNode:(MCTreeNode *)node;

//Expand the tree node at three occasions:
//@1     not                    or
//        |                    /  \
//       and        ->       not   not
//      /   \                 |     |
//  child  child            child  child
//-----------------------------------------
//@2     not                    and
//        |                    /  \
//       or        ->        not   not
//      /   \                 |     |
//  child  child            child  child
//-----------------------------------------
//@3 not-not-child  ->  child
+ (void)convertToTreeByExpandingNotSentence:(MCTreeNode *)node;

@end
