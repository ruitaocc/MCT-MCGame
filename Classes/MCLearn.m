//
//  MCLearn.m
//  UserManagerSystemXib
//
//  Created by yellow Dai on 13-3-13.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "MCLearn.h"

@implementation MCLearn

@synthesize learnID;
@synthesize userID;
@synthesize name;
@synthesize move;
@synthesize time;
@synthesize date;

- (id)initWithLearnID:(NSInteger)_lID userID:(NSInteger)_uID name:(NSString *)_name move:(NSInteger)_move time:(double)_time date:(NSString *)_date
{
    if (self = [self init]) {
        self.learnID = _lID;
        self.userID = _uID;
        self.name = _name;
        self.move = _move;
        self.time = _time;
        self.date = _date;
    }    
    return self;
}

- (void)dealloc{
    self.name = nil;
    self.date = nil;
    [super dealloc];
}

@end
