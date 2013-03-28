//
//  MCKnowledgeBase.m
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCKnowledgeBase.h"


@implementation MCKnowledgeBase

+ (MCKnowledgeBase *)getSharedKnowledgeBase{
    static MCKnowledgeBase *knowledgeBase;
    @synchronized(self)
    {
        if (!knowledgeBase)
            knowledgeBase = [[MCKnowledgeBase alloc] init];
        return knowledgeBase;
    }
}

- (id)init{
    if(self = [super init]){
        sqlite3 *database;
        if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            NSLog(@"Failed to open database.");
        }
        else{
            char *errorMsg;
            //create the pattern table if not exist
            NSString *createPatternSQL = @"CREATE TABLE IF NOT EXISTS PATTERNS (PRE_STATE CHAR(20) NOT NULL, KEY CHAR(20) NOT NULL, PATTERN TEXT NOT NULL);";
            if (sqlite3_exec(database, [createPatternSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                sqlite3_close(database);
                NSLog(@"error creating table: %s", errorMsg);
            }
            //create the rule table if not exist
            NSString *createRuleSQL = @"CREATE TABLE IF NOT EXISTS RULES(MEHOD INTEGER NOT NULL, PRE_STATE CHAR(20) NOT NULL, RULE_IF CHAR(20) NOT NULL, RULE_THEN TEXT NOT NULL);";
            if (sqlite3_exec(database, [createRuleSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                sqlite3_close(database);
                NSLog(@"error creating table: %s", errorMsg);
            }
            //create the state table if no exist
            NSString *createStateSQL = @"CREATE TABLE IF NOT EXISTS STATES(MEHOD INTEGER NOT NULL, PRE_STATE CHAR(20) NOT NULL, PATTERN TEXT NOT NULL, AFTER_STATE CHAR(20) NOT NULL);";
            if (sqlite3_exec(database, [createStateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                sqlite3_close(database);
                NSLog(@"error creating table: %s", errorMsg);
            }
        }
    }
    return self;
}

- (NSString *)knowledgeBaseFilePath{
    NSString *documentsDirectory  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentsDirectory stringByAppendingPathComponent:KNOWLEDGE_DB_FILE_NAME];
}

- (BOOL)insertPattern:(NSString *)pattern withKey:(NSString *)key withPreState:(NSString *)state{
    sqlite3 *database;
    if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database.");
        return NO;
    }
    else{
        char *insertPattern = "INSERT OR REPLACE INTO PATTERNS (PRE_STATE, KEY, PATTERN) VALUES (?, ?, ?);";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insertPattern, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [state UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [key UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [pattern UTF8String], -1, NULL);
        }
        else{
            NSLog(@"Failed to prepare insert stmt.");
            return NO;
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSLog(@"Failed to insert pattern.");
            return NO;
        }
        
        sqlite3_finalize(stmt);
    }
    sqlite3_close(database);
    return YES;
}

- (BOOL)insertRullOfMethod:(NSInteger)method withState:(NSString *)state ifContent:(NSString *)ifContent thenContent:(NSString *)thenContent{
    sqlite3 *database;
    if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database.");
        return NO;
    }
    else{
        char *insertRule = "INSERT OR REPLACE INTO RULES (MEHOD, PRE_STATE, RULE_IF, RULE_THEN) VALUES (?, ?, ?, ?);";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insertRule, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt, 1, method);
            sqlite3_bind_text(stmt, 2, [state UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [ifContent UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [thenContent UTF8String], -1, NULL);
        }
        else{
            NSLog(@"Failed to prepare insert stmt.");
            return NO;
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSLog(@"Failed to insert rule.");
            return NO;
        }
        
        sqlite3_finalize(stmt);
    }
    sqlite3_close(database);
    return YES;
}

- (BOOL)insertStateOfMethod:(NSInteger)method withPattern:(NSString *)pattern preState:(NSString *)preState afterState:(NSString *)afterState{
    sqlite3 *database;
    if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database.");
        return NO;
    }
    else{
        char *insertState = "INSERT OR REPLACE INTO STATES (MEHOD, PRE_STATE, PATTERN, AFTER_STATE) VALUES (?, ?, ?, ?);";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insertState, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt, 1, method);
            sqlite3_bind_text(stmt, 2, [preState UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [pattern UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [afterState UTF8String], -1, NULL);
        }
        else{
            NSLog(@"Failed to prepare insert stmt.");
            return NO;
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSLog(@"Failed to insert pattern.");
            return NO;
        }
        
        sqlite3_finalize(stmt);
    }
    sqlite3_close(database);
    return YES;
}

- (NSMutableDictionary *)getPatternsWithPreState:(NSString *)state{
    sqlite3 *database;
    if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database.");
        return nil;
    }
    else{
        NSMutableDictionary *patterns = [NSMutableDictionary dictionaryWithCapacity:PATTERN_NUM];
        NSString *patternQuery = [NSString stringWithFormat:@"SELECT KEY, PATTERN FROM PATTERNS WHERE PRE_STATE='%@'", state];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, [patternQuery UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *key = (char *)sqlite3_column_text(stmt, 0);
                char *pattern = (char *)sqlite3_column_text(stmt, 1);
                
                NSString *patternName = [[NSString alloc] initWithUTF8String:key];
                NSString *patternStr = [[NSString alloc] initWithUTF8String:pattern];
                MCPattern *mcPattern = [[MCPattern alloc] initWithString:patternStr];
                [patterns setObject:mcPattern forKey:patternName];
                [patternName release];
                [patternStr release];
                [mcPattern release];
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return patterns;
    }
}

- (NSMutableDictionary *)getStatesOfMethod:(NSInteger)method{
    sqlite3 *database;
    if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database.");
        return nil;
    }
    else{
        NSMutableDictionary *states = [NSMutableDictionary dictionaryWithCapacity:PATTERN_NUM];
        NSString *stateQuery = [NSString stringWithFormat:@"SELECT PRE_STATE, PATTERN, AFTER_STATE FROM STATES WHERE MEHOD=%i", method];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, [stateQuery UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *preState = (char *)sqlite3_column_text(stmt, 0);
                char *pattern = (char *)sqlite3_column_text(stmt, 1);
                char *afterState = (char *)sqlite3_column_text(stmt, 2);
                
                
                NSString *preStateStr = [[NSString alloc] initWithUTF8String:preState];
                NSString *patternStr = [[NSString alloc] initWithUTF8String:pattern];
                NSString *afterStateStr = [[NSString alloc] initWithUTF8String:afterState];
                MCState *mcState = [[MCState alloc] initWithPatternStr:patternStr andAfterState:afterStateStr];
                [states setObject:mcState forKey:preStateStr];
                [preStateStr release];
                [patternStr release];
                [afterStateStr release];
                [mcState release];
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return states;
    }
}

- (NSMutableDictionary *)getRulesOfMethod:(NSInteger)method withState:(NSString *)state{
    sqlite3 *database;
    if (sqlite3_open([[self knowledgeBaseFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database.");
        return nil;
    }
    else{
        NSMutableDictionary *rules = [NSMutableDictionary dictionaryWithCapacity:PATTERN_NUM];
        NSString *stateQuery = [NSString stringWithFormat:@"SELECT RULE_IF, RULE_THEN FROM RULES WHERE MEHOD=%i AND PRE_STATE='%@'", method, state];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, [stateQuery UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *ruleIf = (char *)sqlite3_column_text(stmt, 0);
                char *ruleThen = (char *)sqlite3_column_text(stmt, 1);
                
                NSString *ruleIfStr = [[NSString alloc] initWithUTF8String:ruleIf];
                NSString *ruleThenStr = [[NSString alloc] initWithUTF8String:ruleThen];
                MCRule *mcRule = [[MCRule alloc] initWithString:ruleThenStr];
                [rules setObject:mcRule forKey:ruleIfStr];
                [ruleIfStr release];
                [ruleThenStr release];
                [mcRule release];
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return rules;
    }
}


@end
