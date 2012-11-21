//
//  MCMagicCubeUIModelController.h
//  MCGame
//
//  Created by kwan terry on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPoint.h"
@interface MCMagicCubeUIModelController : NSObject{
    NSMutableArray* array27Cube;
    MCPoint translation;
	MCPoint rotation;
	MCPoint scale;
    MCPoint rotationalSpeed;
}
@property (assign)MCPoint translation,rotation,scale,rotationalSpeed;
-(void)init;
-(void)rotate:(int)axis :(int)layer :(int)direction;
-(void)render;
-(void)update;
@end
