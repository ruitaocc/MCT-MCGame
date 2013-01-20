//
//  MCUserCalculator.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-30.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCUserCalculator.h"
#define highestScore 99999
#define moveWeight 50
#define timeWeight 50

@implementation MCUserCalculator

-(NSInteger)calculateScoreForMove:(NSInteger)move Time:(double)time
{
    //expression of calculating the total score for each time
    NSInteger score = highestScore - move*moveWeight - time*timeWeight;
    return score;
}

-(double)calculateSpeedForMove:(NSInteger)move Time:(double)time
{
    return (double)move/time;
}

@end
