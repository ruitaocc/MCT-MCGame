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
@synthesize totalGames;
@synthesize totalMoves;
@synthesize totalTimes;

- (id)initWithUserID:(NSInteger)_ID UserName:(NSString *)_name UserSex:(NSString *)_sex totalGames:(NSInteger)_games totalMoves:(NSInteger)_moves totalTimes:(double)_times
{
    if (self = [self init]) {
        [_name retain];
        [_sex retain];
        [self.name release];
        [self.sex release];
        
        self.userID = _ID;
        self.name = _name;
        self.sex = _sex;
        self.totalGames = _games;
        self.totalMoves = _moves;
        self.totalTimes = _times;
    }
    
    return self;
}


-(void)dealloc
{
    [sex release];
    [name release];
    [super dealloc];
}

@end
