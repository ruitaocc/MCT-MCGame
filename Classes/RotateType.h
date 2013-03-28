//
//  RotateType.h
//  MCGame
//
//  Created by kwan terry on 13-3-14.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"
@interface RotateType : NSObject
@property (assign ,nonatomic)  AxisType rotate_axis;
@property (assign ,nonatomic)  LayerRotationDirectionType rotate_direction;
@property (assign ,nonatomic)  int rotate_layer;
@end
