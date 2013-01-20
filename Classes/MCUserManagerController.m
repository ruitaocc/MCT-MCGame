//
//  MCUserManagerController.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-30.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCUserManagerController.h"

#define userFile @"userFile.txt"

@implementation MCUserManagerController

static MCUserManagerController* sharedSingleton_ = nil;

@synthesize userModel;
@synthesize database;
@synthesize calculator;

#pragma mark -
#pragma mark single instance methods
+ (MCUserManagerController *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL] init];
        NSLog(@"create single user manager controller");
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

- (void)release
{
    //do nothing
}

- (NSString *)dataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:userFile];
}


- (id)init
{
    if (self = [super init]) {
        database = [MCDBController allocWithZone:NULL];
        userModel = [MCUserManagerModel allocWithZone:NULL];
        calculator = [MCUserCalculator alloc];
        
        //init all users from database
        [self updateAllUser];
        NSData *lastUser = [[NSData alloc] initWithContentsOfFile:[self dataFilePath]];
        NSString *lastName = [[NSString alloc] initWithData:lastUser encoding:NSStringEncodingConversionExternalRepresentation];
        [self changeCurrentUser:lastName];
        
        //init top score
        [self updateTopScore];
        [self updateMyScore];
        
        //add observer to database and user model
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertUserSuccess:) name:@"DBInsertUserSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertScoreSuccess) name:@"DBInsertScoreSuccess" object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [database release];
    [userModel release];
    [calculator release];
    [super dealloc];
}

#pragma mark -
#pragma mark user methods
- (void)createNewUser:(NSString *)_name
{
    MCUser *newUser = [[MCUser alloc] initWithUserID:0 UserName:_name UserSex:@"unknown" totalGames:0 totalMoves:0 totalTimes:0];
    [database insertUser:newUser];
}

- (void)changeCurrentUser:(NSString *)_name
{
    for (MCUser* user in userModel.allUser) {
        if ([user.name isEqualToString:_name]) {
            userModel.currentUser = user;
        }
    }
    NSLog(@"change user");
    
    [self saveCurrentUser];
}

- (void) insertUserSuccess:(NSNotification*)_notification
{
    //after insert successful, update information
    [self updateAllUser];
    
    NSString* name = [[NSString alloc] initWithString:[_notification.userInfo objectForKey:@"name"]];
    [self changeCurrentUser:name];
}

- (void)updateAllUser
{
    userModel.allUser = [database queryAllUser];
    NSLog(@"update all user");
}

- (void)updateCurrentUser
{
    userModel.currentUser = [database queryUser:userModel.currentUser.name];
}

#pragma mark
#pragma mark score methods
- (void)createNewScoreWithMove:(NSInteger)_move Time:(double)_time
{
    NSInteger _score = [calculator calculateScoreForMove:_move Time:_time];
    double _speed = [calculator calculateSpeedForMove:_move Time:_time];
    NSString* _date = [[[NSDate alloc] init] description];
    
    MCScore* newScore = [[MCScore alloc] initWithScoreID:0 userID:userModel.currentUser.userID name:userModel.currentUser.name score:_score move:_move time:_time speed:_speed date:_date];    
    [database insertScore:newScore];
}

- (void) insertScoreSuccess
{
    //after insert successful, update information
    [self updateTopScore];
    [self updateMyScore];
    
    [self updateAllUser];
    [self updateCurrentUser];
    
    //post notification to view controller to refresh view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserManagerSystemUpdateScore" object:nil];
}

- (void)updateTopScore
{
    userModel.topScore = [database queryTopScore];
    NSLog(@"update top score");
}

- (void)updateMyScore
{
    userModel.myScore = [database queryMyScore:userModel.currentUser.userID];
    NSLog(@"update my score");
}



- (void)saveCurrentUser
{
    if (userModel.currentUser.name != nil) {
    //save current user to file
    const char *name = [userModel.currentUser.name UTF8String];
    //NSData *lastUser = [[NSData alloc] initWithBytes:userModel.currentUser.name length:[userModel.currentUser.name length]]; 
    NSData *lastUser = [NSData dataWithBytes:name length:strlen(name)];
    
    NSLog(@"user name: %s",[lastUser bytes]);
    
    [lastUser writeToFile:[self dataFilePath] atomically:YES];
    }
}

@end
