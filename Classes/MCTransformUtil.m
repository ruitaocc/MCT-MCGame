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
            break;
            //return -1;
    }
    return result;
}

@end
