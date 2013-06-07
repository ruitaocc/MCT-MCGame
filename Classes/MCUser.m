//
//  MCUser.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCUser.h"

@implementation MCUser

@synthesize userID;
@synthesize name;
@synthesize sex;
@synthesize totalMoves;
@synthesize totalGameTime;
@synthesize totalLearnTime;
@synthesize totalFinish;

- (id)initWithUserID:(NSInteger)_ID UserName:(NSString *)_name UserSex:(NSString *)_sex totalMoves:(NSInteger)_moves totalGameTime:(double)_gameTime totalLearnTime:(double)_learnTime totalFinish:(NSInteger)_finish
{
    if (self = [self init]) {
        self.userID = _ID;
        self.name = _name;
        self.sex = _sex;
        self.totalMoves = _moves;
        self.totalGameTime = _gameTime;
        self.totalLearnTime = _learnTime;
        self.totalFinish = _finish;
    }
    
    return self;
}


-(void)dealloc
{
    self.sex = nil;
    self.name = nil;
    [super dealloc];
}

@end
