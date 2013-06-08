//
//  MCMagicCubeOperationDelegate.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-2.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@protocol MCMagicCubeOperationDelegate <NSObject>

//rotate operation with axis, layer, direction
- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction;

//rotate with Singmaster Notation
- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation;

@end
