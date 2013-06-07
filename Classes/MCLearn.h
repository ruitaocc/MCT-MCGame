//
//  MCLearn.h
//  UserManagerSystemXib
//
//  Created by yellow Dai on 13-3-13.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCLearn : NSObject

@property (nonatomic) NSInteger learnID;
@property (nonatomic) NSInteger userID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic) NSInteger move;
@property (nonatomic) double time;
@property (retain, nonatomic) NSString *date;

- (id)initWithLearnID:(NSInteger)_lID userID:(NSInteger)_uID name:(NSString*)_name move:(NSInteger)_move time:(double)_time date:(NSString *)_date;

@end
