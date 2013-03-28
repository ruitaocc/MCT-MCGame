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

@end
