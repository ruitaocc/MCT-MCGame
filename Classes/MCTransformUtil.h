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
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCWorkingMemory.h"

@interface MCTransformUtil : NSObject

+ (FaceOrientationType)getContraryOrientation:(FaceOrientationType)orientation;

+ (NSString *)getRotationTagFromSingmasterNotation:(SingmasterNotation)notation;

// Transfer RotateNotationType containing axis, layer, direction and RotationType(Single, Double or Trible) to SingmasterNotation
+ (SingmasterNotation)getSingmasterNotationFromAxis:(AxisType)axis layer:(int)layer direction:(LayerRotationDirectionType)direction;


+ (SingmasterNotation)getContrarySingmasterNotation:(SingmasterNotation)notation;


+ (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation;


// Transfer SingmasterNotation to RotateNotationType containing axis, layer, direction and RotationType(Single, Double or Trible)
+ (struct RotateNotationType)getROtateNotationTypeWithSingmasterNotation:(SingmasterNotation)notation;


// By delivering pattern node to this function,
// we can get the node content.
// Notice! The type of this node must be 'PatternNode'.
+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node
              accordingToWorkingMemory:(MCWorkingMemory *)workingMemory;

//Return the negative sentence of the string returned by
//"+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node"
+ (NSString *)getNegativeSentenceOfContentFromPatternNode:(MCTreeNode *)node
                                 accordingToWorkingMemory:(MCWorkingMemory *)workingMemory;

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


//E.g BColor transfer to XXX(where)XXX colors cubie
+ (NSString *)getConcreteDescriptionOfCubie:(ColorCombinationType)identity fromMgaicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc;

//E.g (0, 0, 1) transfers to front center
+ (NSString *)getPositionDescription:(Point3i)position;



@end
