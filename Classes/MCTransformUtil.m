//
//  MCTransformUtil.m
//  MagicCubeModel
//
//  Created by Aha on 13-3-12.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCTransformUtil.h"

@implementation MCTransformUtil

+ (FaceOrientationType)getContraryOrientation:(FaceOrientationType)orientation{
    FaceOrientationType result;
    switch (orientation) {
        case Up:
            result = Down;
            break;
        case Down:
            result = Up;
            break;
        case Front:
            result = Back;
            break;
        case Back:
            result = Front;
            break;
        case Left:
            result = Right;
            break;
        case Right:
            result = Left;
            break;
        default:
            return WrongOrientation;
    }
    return result;
}

+ (NSString *)getRotationTagFromSingmasterNotation:(SingmasterNotation)notation{
    NSString *names[45] = {
        @"frontCW",     @"frontCCW",    @"front2CW",
        @"backCW",      @"backCCW",     @"back2CW",
        @"rightCW",     @"rightCCW",    @"right2CW",
        @"leftCW",      @"leftCCW",     @"left2CW",
        @"upCW",        @"upCCW",       @"up2CW",
        @"downCW",      @"downCCW",     @"down2CW",
        @"xCW",         @"xCCW",        @"x2CW",
        @"yCW",         @"yCCW",        @"y2CW",
        @"zCW",         @"zCCW",        @"z2CW",
        @"frontTwoCW",  @"frontTwoCCW", @"frontTwo2CW",
        @"backTwoCW",   @"backTwoCCW",  @"backTwo2CW",
        @"rightTwoCW",  @"rightTwoCCW", @"rightTwo2CW",
        @"leftTwoCW",   @"leftTwoCCW",  @"leftTwo2CW",
        @"upTwoCW",     @"upTwoCCW",    @"upTwo2CW",
        @"downTwoCW",   @"downTwoCCW",  @"downTwo2CW"};
    return names[notation];
}

+ (SingmasterNotation)getSingmasterNotationFromAxis:(AxisType)axis layer:(int)layer direction:(LayerRotationDirectionType)direction{
    SingmasterNotation notation = NoneNotation;
    switch (axis) {
        case X:
        {
            switch (layer) {
                case 0:
                    if (direction == CW) {
                        return Li;
                    } else {
                        return L;
                    }
                    break;
                case 1:
                    if (direction == CW) {
                        return Mi;
                    } else {
                        return M;
                    }
                case 2:
                    if (direction == CW) {
                        return R;
                    } else {
                        return Ri;
                    }
                case NO_SELECTED_LAYER:{
                    if (direction == CW) {
                        return x;
                    }
                    else{
                        return xi;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case Y:
        {
            switch (layer) {
                case 0:
                    if (direction == CW) {
                        return Di;
                    } else {
                        return D;
                    }
                    break;
                case 1:
                    if (direction == CW) {
                        return Ei;
                    } else {
                        return E;
                    }
                case 2:
                    if (direction == CW) {
                        return U;
                    } else {
                        return Ui;
                    }
                case NO_SELECTED_LAYER:{
                    if (direction == CW) {
                        return y;
                    }
                    else{
                        return yi;
                    }
                }
                default:
                    break;
            }
        }
            break;
        case Z:
        {
            switch (layer) {
                case 0:
                    if (direction == CW) {
                        return Bi;
                    } else {
                        return B;
                    }
                    break;
                case 1:
                    if (direction == CW) {
                        return S;
                    } else {
                        return Si;
                    }
                case 2:
                    if (direction == CW) {
                        return F;
                    } else {
                        return Fi;
                    }
                case NO_SELECTED_LAYER:{
                    if (direction == CW) {
                        return z;
                    }
                    else{
                        return zi;
                    }
                }
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return notation;
}

+ (SingmasterNotation)getContrarySingmasterNotation:(SingmasterNotation)notation{
    if (notation == NoneNotation) {
        return NoneNotation;
    }
    SingmasterNotation result;
    int remainder = notation % 3;
    switch (remainder) {
        case 0:
            result = (SingmasterNotation)((int)notation + 1);
            break;
        case 1:
            result = (SingmasterNotation)((int)notation - 1);
            break;
        case 2:
            result = notation;
            break;
        default:
            result = NoneNotation;
            break;
    }
    return result;
}

+ (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation{
    SingmasterNotation result = NoneNotation;
    switch (orientation) {
        case Up:
            switch (coordinate.y) {
                case 1:
                    result = NoneNotation;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.z) {
                        case 1:
                            result = x;
                            break;
                        case -1:
                            result = xi;
                            break;
                        case 2:
                            result = zi;
                            break;
                        case -2:
                            result = z;
                            break;
                        default:
                            break;
                    }
                    break;
                case -1:
                    result = x2;
                    break;
                default:
                    break;
            }
            break;
        case Down:
            switch (coordinate.y) {
                case -1:
                    result = NoneNotation;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.z) {
                        case 1:
                            result = xi;
                            break;
                        case -1:
                            result = x;
                            break;
                        case 2:
                            result = z;
                            break;
                        case -2:
                            result = zi;
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    result = x2;
                    break;
                default:
                    break;
            }
            break;
        case Left:
            switch (coordinate.x) {
                case -1:
                    result = NoneNotation;
                    break;
                case 0:
                    switch (coordinate.y*2+coordinate.z) {
                        case 1:
                            result = y;
                            break;
                        case -1:
                            result = yi;
                            break;
                        case 2:
                            result = zi;
                            break;
                        case -2:
                            result = z;
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        case Right:
            switch (coordinate.x) {
                case 1:
                    result = NoneNotation;
                    break;
                case 0:
                    switch (coordinate.y*2+coordinate.z) {
                        case 1:
                            result = yi;
                            break;
                        case -1:
                            result = y;
                            break;
                        case 2:
                            result = z;
                            break;
                        case -2:
                            result = zi;
                            break;
                        default:
                            break;
                    }
                    break;
                case -1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        case Front:
            switch (coordinate.z) {
                case 1:
                    result = NoneNotation;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.y) {
                        case 1:
                            result = xi;
                            break;
                        case -1:
                            result = x;
                            break;
                        case 2:
                            result = y;
                            break;
                        case -2:
                            result = yi;
                            break;
                        default:
                            break;
                    }
                    break;
                case -1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        case Back:
            switch (coordinate.z) {
                case -1:
                    result = NoneNotation;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.y) {
                        case 1:
                            result = x;
                            break;
                        case -1:
                            result = xi;
                            break;
                        case 2:
                            result = yi;
                            break;
                        case -2:
                            result = y;
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        default:
            result = NoneNotation;
            break;
    }
    return result;
}

+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node{
    NSString *result = nil;
    //Before generate the content,
    //detect the wrong type.
    if ([node type] != PatternNode) {
        return nil;
    }
    
    //Generate the content of pattern node
    switch ([node value]) {
        case Home:
            
            break;
        case Check:
            
            break;
        case ColorBindOrientation:
            
            break;
        case At:
            
            break;
        case NotAt:
            
            break;
        case CubiedBeLocked:
            
            break;
        default:
            result = @"Unrecongized pattern node!!!";
            break;
    }
    return result;
}

+ (NSString *)getNegativeSentenceOfContentFromPatternNode:(MCTreeNode *)node{
    return [NSString stringWithFormat:@"%@ 不符合", [MCTransformUtil getContenFromPatternNode:node]];
}

@end
