//
//  MCUser.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCUser : NSObject
@property (nonatomic) NSInteger userID;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *sex;
@property (nonatomic) NSInteger totalGames;
@property (nonatomic) NSInteger totalMoves;
@property (nonatomic) double totalTimes;     //seconds

- (id)initWithUserID:(NSInteger)_ID UserName:(NSString*)_name UserSex:(NSString*)_sex totalGames:(NSInteger)_games totalMoves:(NSInteger)_moves totalTimes:(double)_times;

@end
