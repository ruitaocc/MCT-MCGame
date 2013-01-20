//
//  MCUserCalculator.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-30.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCUserCalculator : NSObject

-(NSInteger) calculateScoreForMove:(NSInteger)move Time:(double)time;
-(double) calculateSpeedForMove:(NSInteger)move Time:(double)time;

@end
