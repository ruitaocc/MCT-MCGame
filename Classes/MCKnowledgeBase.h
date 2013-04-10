//
//  MCKnowledgeBase.h
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#include "MCBasicElement.h"

#define PATTERN_NUM 30

@interface MCKnowledgeBase : NSObject

+ (MCKnowledgeBase *)getSharedKnowledgeBase;

//return the path of the DB file
- (NSString *)knowledgeBaseFilePath;

//insert the pattern
- (BOOL)insertPattern:(NSString *)pattern withKey:(NSString *)key withPreState:(NSString *)state;

//insert the rule
- (BOOL)insertRullOfMethod:(NSInteger)method withState:(NSString *)state ifContent:(NSString *)ifContent thenContent:(NSString *)thenContent;

//insert the state
- (BOOL)insertStateOfMethod:(NSInteger)method withPattern:(NSString *)pattern preState:(NSString *)preState afterState:(NSString *)afterState;

//get the pattern dictionary based on state
- (NSMutableDictionary *)getPatternsWithPreState:(NSString *)state;

//get the states based on method
- (NSMutableDictionary *)getStatesOfMethod:(NSInteger)method;

//get the rules based on method and state
- (NSMutableDictionary *)getRulesOfMethod:(NSInteger)method withState:(NSString *)state;

@end
