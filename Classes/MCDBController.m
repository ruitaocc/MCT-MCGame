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
    return [MCDBController sharedInstance];
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
        NSString *createSQL = @"CREATE TABLE IF NOT EXISTS user(userID INTEGER PRIMARY KEY, name VARCHAR, sex VARCHAR, total_moves INTEGER, total_game_time FLOAT, total_learn_time FLOAT, total_finish INTEGER)";
        
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
        
        
        //learn table
        createSQL = @"CREATE TABLE IF NOT EXISTS learn(learnid INTEGER PRIMARY KEY, userid INTEGER, name VARCHAR,move INTEGER, time FLOAT, date DATE)";
        
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg)) {
            sqlite3_close(database);
            NSAssert1(0, @"Failed to create table :%s", errorMsg);
        }
        [createSQL release];
        
        //cube state table
        createSQL = @"CREATE TABLE IF NOT EXISTS cube(cube_id INTEGER PRIMARY KEY, userid INTEGER, state VARCHAR, date DATE)";
        
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg)) {
            sqlite3_close(database);
            NSAssert1(0, @"Failed to create table :%s", errorMsg);
        }
        [createSQL release];
        
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
    NSString *insertUserSQL = [[NSString alloc] initWithFormat:@"INSERT INTO user( name, sex, total_moves, total_game_time, total_learn_time, total_finish) VALUES ('%@','%@',0,0,0,0)", _user.name, _user.sex];
    
    if (sqlite3_exec(database, [insertUserSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to insert");
    }

    sqlite3_close(database);
    [insertUserSQL release];
    [_user release];
    
    NSLog(@"insert user success");
    
    //post notification to user manager controller
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
            [user setUserID:sqlite3_column_int(stmt, 0)];
            [user setName:[NSString stringWithUTF8String:((char*)sqlite3_column_text(stmt, 1))]];
            [user setSex:[NSString stringWithUTF8String:((char*)sqlite3_column_text(stmt, 2))]];
            [user setTotalMoves:sqlite3_column_int(stmt, 3)];
            [user setTotalGameTime:sqlite3_column_double(stmt, 4)];
            [user setTotalLearnTime:sqlite3_column_double(stmt, 5)];
            [user setTotalFinish:sqlite3_column_int(stmt, 6)];
        }
        else {
            [user initWithUserID:0 UserName:nil UserSex:nil totalMoves:0 totalGameTime:0 totalLearnTime:0 totalFinish:0];
            NSAssert(0,@"Failed to fetch row");
        }
        
    }
    else {
        [user initWithUserID:0 UserName:nil UserSex:nil totalMoves:0 totalGameTime:0 totalLearnTime:0 totalFinish:0];
        NSAssert(0,@"Failed to select");
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    [queryUserSQL release];
    [_name release];
    
    NSLog(@"query user success");
    
    return [user autorelease];
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
            int totalmoves = sqlite3_column_int(stmt, 3);
            double totalGameTime = sqlite3_column_double(stmt, 4);
            double totalLearnTime = sqlite3_column_double(stmt, 5);
            int totalFinish = sqlite3_column_int(stmt, 6);
            
            MCUser *user = [[MCUser alloc] initWithUserID:userid UserName:name UserSex:sex totalMoves:totalmoves totalGameTime:totalGameTime totalLearnTime:totalLearnTime totalFinish:totalFinish];
            
            [allUser addObject:user];
            [name release];
            [sex release];
            [user release];
        }
        sqlite3_finalize(stmt);
            } else {
                sqlite3_finalize(stmt);
                NSAssert(0,@"failed to query");
                    }
    
    sqlite3_close(database);
    [queryAllUserSQL release];
    
    NSLog(@"query all users");
    return [allUser autorelease];
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
    
    //post notification to user manager controller
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
            [username release];
            [_score release];
            [data release];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query");
    }
    
    sqlite3_close(database);
    [queryTopScoreSQL release];
    
    NSLog(@"query top score");
    return [topScore autorelease];
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
            [_score release];
            [data release];
            [username release];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query");
    }
    
    sqlite3_close(database);
    [queryMyScoreSQL release];
    
    NSLog(@"query my top score");
    return [myScore autorelease];

}

- (void)insertScoreUpdateUser:(MCScore *)_score
{
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    //select the user to update
    NSString *selectUserSQL = [[NSString alloc] initWithFormat:@"SELECT total_moves,total_game_time,total_finish FROM user WHERE user.userID = %d",_score.userID];
    int _totalmoves = 0;
    double _totalGameTime = 0;
    int _totalFinish = 0;
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [selectUserSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            _totalmoves = sqlite3_column_int(stmt, 0);
            _totalGameTime = sqlite3_column_int(stmt, 1);
            _totalFinish = sqlite3_column_int(stmt, 2);
            
            _totalmoves += _score.move;
            _totalGameTime += _score.time;
            _totalFinish += 1;
        }
        sqlite3_finalize(stmt);
    }
    else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query in updateing user");
    }
    
    char* errorMsg;
    NSString *updateUserSQL = [[NSString alloc] initWithFormat:@"UPDATE user SET total_moves = %d, total_game_time = %f, total_finish = %d WHERE user.userID = %d",_totalmoves, _totalGameTime, _totalFinish, _score.userID];
    
    if (sqlite3_exec(database, [updateUserSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"failed to update user");
    }
    
    sqlite3_close(database);
    [selectUserSQL release];
    [updateUserSQL release];
    
    NSLog(@"update user information success");
}


- (void)insertLearn:(MCLearn *)_learn
{
    [_learn retain];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    char* errorMsg;
    //dont need userID to create a new user. use the ID automatically generate by DBMS.
    NSString *insertLearnSQL = [[NSString alloc] initWithFormat:@"INSERT INTO learn( userid, name, move, time, date) VALUES (%d,'%@', %d, %f, '%@')", _learn.userID, _learn.name, _learn.move, _learn.time, _learn.date];
    
    if (sqlite3_exec(database, [insertLearnSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to insert");
    }
    
    sqlite3_close(database);
    [insertLearnSQL release];
    
    NSLog(@"insert learn success");
    
    //update user information
    [self insertLearnUpdateUser:_learn];
    
    //post notification to user manager controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DBInsertLearnSuccess" object:nil];
    
    [_learn release];
}


- (void)insertLearnUpdateUser:(MCLearn *)_learn
{
    [_learn retain];
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"Failed to open");
    }
    
    //select the user to update
    NSString *selectUserSQL = [[NSString alloc] initWithFormat:@"SELECT total_moves,total_learn_time,total_finish FROM user WHERE user.userID = %d",_learn.userID];
    int _totalmoves = 0;
    double _totalLearnTime = 0;
    int _totalFinish = 0;
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [selectUserSQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            //read a row
            _totalmoves = sqlite3_column_int(stmt, 0);
            _totalLearnTime = sqlite3_column_int(stmt, 1);
            _totalFinish = sqlite3_column_int(stmt, 2);
            
            //_totalmoves += _learn.move;
            _totalLearnTime += _learn.time;
            _totalFinish += 1;
        }
        sqlite3_finalize(stmt);
    }
    else {
        sqlite3_finalize(stmt);
        NSAssert(0,@"failed to query in updateing user");
    }
    
    char* errorMsg;
    NSString *updateUserSQL = [[NSString alloc] initWithFormat:@"UPDATE user SET total_moves = %d, total_learn_time = %f, total_finish = %d WHERE user.userID = %d",_totalmoves, _totalLearnTime, _totalFinish, _learn.userID];
    
    if (sqlite3_exec(database, [updateUserSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"failed to update user");
    }
    
    sqlite3_close(database);
    [selectUserSQL release];
    [updateUserSQL release];
    
    NSLog(@"update user information success");
    
    [_learn release];
}

@end
