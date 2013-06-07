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
    return [[MCUserManagerController sharedInstance] retain];
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
        [lastName release];
        [lastUser release];
        
        //init top score
        [self updateTopScore];
        [self updateMyScore];
        
        //add observer to database and user model
        //notification was sent by MC DB Controller
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertUserSuccess:) name:@"DBInsertUserSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertScoreSuccess) name:@"DBInsertScoreSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertLearnSuccess) name:@"DBInsertLearnSuccess" object:nil];
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
    for (MCUser* user in userModel.allUser) {
        if ([user.name isEqualToString:_name]) {
            //show it's repeat
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"重复了" message:@"你所输入的用户名已经存在,请输入其他再试一次" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    MCUser *newUser = [[MCUser alloc] initWithUserID:0 UserName:_name UserSex:@"unknown" totalMoves:0 totalGameTime:0 totalLearnTime:0 totalFinish:0];
    [database insertUser:newUser];
    [newUser release];
}

- (void)changeCurrentUser:(NSString *)_name
{
    for (MCUser* user in userModel.allUser) {
        if ([user.name isEqualToString:_name]) {
            self.userModel.currentUser = user;
        }
    }
    NSLog(@"change user");
    
    [self saveCurrentUser];
    [self updateMyScore];
}

- (void) insertUserSuccess:(NSNotification*)_notification
{
    //after insert successful, update information
    [self updateAllUser];
    
    NSString* name = [[NSString alloc] initWithString:[_notification.userInfo objectForKey:@"name"]];
    [self changeCurrentUser:name];
    [name release];
}

- (void)updateAllUser
{
    self.userModel.allUser = [database queryAllUser];
    NSLog(@"update all user");
}

- (void)updateCurrentUser
{
    self.userModel.currentUser = [database queryUser:userModel.currentUser.name];
}

#pragma mark
#pragma mark score methods
- (void)createNewScoreWithMove:(NSInteger)_move Time:(double)_time
{
    NSInteger _score = [calculator calculateScoreForMove:_move Time:_time];
    double _speed = [calculator calculateSpeedForMove:_move Time:_time];
    
    NSDate *date = [[NSDate alloc] init];
    NSString* _date = [date description];
    [date release];
    
    MCScore* newScore = [[MCScore alloc] initWithScoreID:0 userID:userModel.currentUser.userID name:userModel.currentUser.name score:_score move:_move time:_time speed:_speed date:_date];    
    [database insertScore:newScore];
    
    [newScore release];
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

- (void) createNewLearnWithMove:(NSInteger)_move Time:(double)_time
{
    NSDate *date = [[NSDate alloc] init];
    NSString* _date = [date description];
    [date release];
    
    MCLearn* newLearn = [[MCLearn alloc] initWithLearnID:0 userID:userModel.currentUser.userID name:userModel.currentUser.name move:_move time:_time date:_date];
    [database insertLearn:newLearn];
    
    [newLearn release];
}

- (void) insertLearnSuccess
{
    //after insert learn record. update information
    [self updateAllUser];
    [self updateCurrentUser];
    
    //post notification to view controller to refresh view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserManagerSystemUpdateScore" object:nil];

}

- (void)updateTopScore
{
    self.userModel.topScore = [database queryTopScore];
    NSLog(@"update top score");
}

- (void)updateMyScore
{
    self.userModel.myScore = [database queryMyScore:userModel.currentUser.userID];
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
