//
//  MCDBController.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCDBController.h"

@implementation MCDBController

static MCDBController* sharedSingleton_ = nil;

#pragma mark implement singleton
+ (MCDBController *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL] init];
        NSLog(@"create single db");
    }
    return sharedSingleton_;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id)copy
{
    return self;
}

-(id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSIntegerMax;
}

- (oneway void)release
{
    //do nothing
}

- (NSString *)dataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:DBName];
}

-(id)init
{
    //init database: create database and tables
    if (self = [super init]) {
        
        if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert(0,@"Failed to open database.");
        }
        
        char* errorMsg;
        
        //user table
        NSString *createSQL = @"CREATE TABLE IF NOT EXISTS user(userID INTEGER PRIMARY KEY, name VARCHAR, sex VARCHAR, totalgames INTEGER, totalmoves INTEGER, totaltimes FLOAT)";
        
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert1(0, @"Failed to create table :%s", errorMsg);
        }
        [createSQL release];
        
        
        //score table 
        createSQL = @"CREATE TABLE IF NOT EXISTS score(scoreid INTEGER PRIMARY KEY, userid INTEGER, name VARCHAR, score INTEGER, move INTEGER, speed FLOAT, time FLOAT, date DATE)";
        
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg)) {
            sqlite3_close(database);
            NSAssert1(0, @"Failed to create table :%s", errorMsg);
        }
        [createSQL release];
        
        //cube state table
        
        
        sqlite3_close(database);
        NSLog(@"create table success");
    }
    
    return self;
}

#pragma mark -
#pragma mark user methods
-(void)insertUser:(MCUser *)_user
{
    [_user retain];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    char* errorMsg;
    //dont need userID to create a new user. use the ID automatically generate by DBMS.
    NSString *insertUserSQL = [[NSString alloc] initWithFormat:@"INSERT INTO user( name, sex, totalgames, totalmoves, totaltimes) VALUES ('%@','%@',0,0,0)", _user.name, _user.sex];
    
    if (sqlite3_exec(database, [insertUserSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to insert");
    }

    sqlite3_close(database);
    [insertUserSQL release];
    [_user release];
    
    NSLog(@"insert user success");
    
    //post notification
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:_user.name forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DBInsertUserSuccess" object:self userInfo:userInfo];
}


- (MCUser *)queryUser:(NSString *)_name
{
    [_name retain];
    
    MCUser *user = [MCUser alloc];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    NSString *queryUserSQL = [[NSString alloc] initWithFormat:@"SELECT * FROM user WHERE name = '%@'",_name];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [queryUserSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            int userid = sqlite3_column_int(stmt, 0);
            NSString *name = [[NSString alloc] initWithUTF8String:((char*)sqlite3_column_text(stmt, 1))];
            NSString *sex = [[NSString alloc] initWithUTF8String:((char*)sqlite3_column_text(stmt, 2))];
            int totalgames = sqlite3_column_int(stmt, 3);
            int totalmoves = sqlite3_column_int(stmt, 4);
            double totaltimes = sqlite3_column_double(stmt, 5);
            
            [user initWithUserID:userid UserName:name UserSex:sex totalGames:totalgames totalMoves:totalmoves totalTimes:totaltimes];
        }
        else {
            sqlite3_finalize(stmt);
            [user initWithUserID:0 UserName:nil UserSex:nil totalGames:0 totalMoves:0 totalTimes:0];
            NSAssert(0,@"Failed to fetch row");
        }
        sqlite3_finalize(stmt);
    }
    else {
        [user initWithUserID:0 UserName:nil UserSex:nil totalGames:0 totalMoves:0 totalTimes:0];
        NSAssert(0,@"Failed to select");
    }
    
    sqlite3_close(database);
    [queryUserSQL release];
    [_name release];
    
    NSLog(@"query user success");
    
    return user;
}


- (NSMutableArray *)queryAllUser
{
    NSMutableArray *allUser = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open");
    }
    
    NSString *queryAllUserSQL = @"SELECT * FROM user";
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [queryAllUserSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            int userid = sqlite3_column_int(stmt, 0);
            NSString *name = [[NSString alloc] initWithUTF8String:((char*)sqlite3_column_text(stmt, 1))];
            NSString *sex = [[NSString alloc] initWithUTF8String:((char*)sqlite3_column_text(stmt, 2))];
            int totalgames = sqlite3_column_int(stmt, 3);
            int totalmoves = sqlite3_column_int(stmt, 4);
            double totaltimes = sqlite3_column_double(stmt, 5);
            
            MCUser *user = [[MCUser alloc] initWithUserID:userid UserName:name UserSex:sex totalGames:totalgames totalMoves:totalmoves totalTimes:totaltimes];
            
            [allUser addObject:user];
        }
        sqlite3_finalize(stmt);
            } else {
                sqlite3_finalize(stmt);
                NSAssert(0,@"failed to query");
                    }
    
    sqlite3_close(database);
    [queryAllUserSQL release];
    
    NSLog(@"query all users");
    return allUser;
}


#pragma mark - 
#pragma mark score methods
- (void)insertScore:(MCScore *)_score
{
    [_score retain];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    char* errorMsg;
    //dont need scoreID to create a new user. use the ID automatically generate by DBMS.
    NSString *insertScoreSQL = [[NSString alloc] initWithFormat:@"INSERT INTO score(userid, name, score, move, speed, time, date) VALUES (%d,'%@',%d,%d,%f,%f,'%@')", _score.userID, _score.name, _score.score, _score.move, _score.speed, _score.time, _score.date];
    
    if (sqlite3_exec(database, [insertScoreSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to insert");
    }
    
    sqlite3_close(database);
    [insertScoreSQL release];
    [_score release];
    
    NSLog(@"insert score success");
    
    //update user information
    [self insertScoreUpdateUser:_score];
    
    //post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DBInsertScoreSuccess" object:nil];
}

- (NSMutableArray *)queryTopScore
{
    NSMutableArray *topScore = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open");
    }
    
    //select top 5 score
    NSString *queryTopScoreSQL = @"SELECT * FROM score ORDER BY score.score DESC LIMIT 5";
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [queryTopScoreSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            int scoreid = sqlite3_column_int(stmt, 0);
            int userid = sqlite3_column_int(stmt, 1);
            NSString *username = [[NSString alloc] initWithUTF8String:((char*) sqlite3_column_text(stmt, 2))];
            int score = sqlite3_column_int(stmt, 3);
            int move = sqlite3_column_int(stmt, 4);
            double speed = sqlite3_column_double(stmt, 5);
            double time = sqlite3_column_double(stmt, 6);
            NSString* data = [[NSString alloc] initWithUTF8String:((char*)sqlite3_column_text(stmt, 7))];
            
            MCScore* _score = [[MCScore alloc] initWithScoreID:scoreid userID:userid name:username score:score move:move time:time speed:speed date:data];
            
            [topScore addObject:_score];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query");
    }
    
    sqlite3_close(database);
    [queryTopScoreSQL release];
    
    NSLog(@"query top score");
    return topScore;
}

- (NSMutableArray *)queryMyScore:(NSInteger)_userID
{
    NSMutableArray *myScore = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open");
    }
    
    //select my top 5 score
    NSString *queryMyScoreSQL = [[NSString alloc] initWithFormat: @"SELECT * FROM score WHERE score.userID = %d ORDER BY score.score DESC LIMIT 5", _userID];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [queryMyScoreSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            int scoreid = sqlite3_column_int(stmt, 0);
            int userid = sqlite3_column_int(stmt, 1);
            NSString *username = [[NSString alloc] initWithUTF8String:((char*) sqlite3_column_text(stmt, 2))];
            int score = sqlite3_column_int(stmt, 3);
            int move = sqlite3_column_int(stmt, 4);
            double speed = sqlite3_column_double(stmt, 5);
            double time = sqlite3_column_double(stmt, 6);
            NSString* data = [[NSString alloc] initWithUTF8String:((char*)sqlite3_column_text(stmt, 7))];
            
            MCScore* _score = [[MCScore alloc] initWithScoreID:scoreid userID:userid name:username score:score move:move time:time speed:speed date:data];
            
            [myScore addObject:_score];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query");
    }
    
    sqlite3_close(database);
    [queryMyScoreSQL release];
    
    NSLog(@"query my top score");
    return myScore;

}

- (void)insertScoreUpdateUser:(MCScore *)_score
{
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    //select the user to update
    NSString *selectUserSQL = [[NSString alloc] initWithFormat:@"SELECT totalgames,totalmoves,totaltimes FROM user WHERE user.userID = %d",_score.userID];
    int _totalgames;
    int _totalmoves;
    double _totaltimes;
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [selectUserSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            _totalgames = sqlite3_column_int(stmt, 0);
            _totalmoves = sqlite3_column_int(stmt, 1);
            _totaltimes = sqlite3_column_double(stmt, 2);
            
            _totalgames += 1;
            _totalmoves += _score.move;
            _totaltimes += _score.time;
        }
        sqlite3_finalize(stmt);
    }
    else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query in updateing user");
    }
    
    char* errorMsg;
    NSString *updateUserSQL = [[NSString alloc] initWithFormat:@"UPDATE user SET totalgames = %d, totalmoves = %d, totaltimes = %f WHERE user.userID = %d",_totalgames, _totalmoves, _totaltimes, _score.userID];
    
    if (sqlite3_exec(database, [updateUserSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"failed to update user");
    }
    
    sqlite3_close(database);
    [selectUserSQL release];
    [updateUserSQL release];
    
    NSLog(@"update user information success");
}
@end
