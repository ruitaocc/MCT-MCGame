//
//  MCDBController.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MCUser.h"
#import "MCScore.h"

#define DBName @"MCDatabase.sqlite3"

@interface MCDBController : NSObject
{
    @private sqlite3 *database;
}

+ (MCDBController*) sharedInstance;
- (void) insertUser:(MCUser*)_user;
- (MCUser*) queryUser:(NSString*)_name;
- (NSMutableArray*) queryAllUser;

- (void) insertScore:(MCScore*)_score;
- (NSMutableArray*) queryTopScore;
- (NSMutableArray*) queryMyScore:(NSInteger)_userID;

- (void)insertScoreUpdateUser:(MCScore*)_score;
@end
