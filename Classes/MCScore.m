//
//  MCScore.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCScore.h"

@implementation MCScore

@synthesize scoreID;
@synthesize userID;
@synthesize name;
@synthesize score;
@synthesize move;
@synthesize time;
@synthesize speed;
@synthesize date;

- (id)initWithScoreID:(NSInteger)_sID userID:(NSInteger)_uID name:(NSString*)_name score:(NSInteger)_score move:(NSInteger)_move time:(double)_time speed:(double)_speed date:(NSString *)_date
{
    if (self = [self init]) {

        [_date retain];
        [date release];
        
        self.scoreID = _sID;
        self.userID = _uID;
        self.name = _name;
        self.score = _score;
        self.move = _move;
        self.time = _time;
        self.speed = _speed;
        self.date = _date;
    }
    return self;
}

- (void)dealloc
{
    [name release];
    [date release];
    [super dealloc];
}

@end
