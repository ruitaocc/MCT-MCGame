//
//  MCParticle.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPoint.h"
@interface MCParticle  :NSObject{
    MCPoint  position;
    MCPoint  velocity;
    CGFloat life;
    CGFloat decay;
    CGFloat size;
    CGFloat grow;
}
@property (assign) MCPoint position;
@property (assign) MCPoint velocity;
@property (assign) CGFloat life;
@property (assign) CGFloat decay;
@property (assign) CGFloat size;
@property (assign) CGFloat grow;

-(void)update;

@end
