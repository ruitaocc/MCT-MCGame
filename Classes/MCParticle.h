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
    //粒子当前位置
    MCPoint  position;
    //粒子速度
    MCPoint  velocity;
    //生命
    CGFloat life;
    //衰变
    CGFloat decay;
    //大小
    CGFloat size;
    //大小改变量
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
