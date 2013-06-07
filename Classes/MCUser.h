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
@property (nonatomic) NSInteger totalMoves;
@property (nonatomic) double totalGameTime;     //seconds
@property (nonatomic) double totalLearnTime;    //seconds
@property (nonatomic) NSInteger totalFinish;

- (id)initWithUserID:(NSInteger)_ID UserName:(NSString*)_name UserSex:(NSString*)_sex totalMoves:(NSInteger)_moves totalGameTime:(double)_gameTime totalLearnTime:(double)_learnTime totalFinish:(NSInteger)_finish;

@end
