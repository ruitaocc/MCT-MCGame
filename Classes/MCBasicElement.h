//
//  MCBasicElement.h
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

//the tree node
@interface MCTreeNode : NSObject

@property (retain, nonatomic)NSMutableArray *children;
@property (nonatomic)NodeType type;
@property (nonatomic)NSInteger value;

-(id)initNodeWithType:(NodeType)type;

-(void)addChild:(MCTreeNode *)node;

@end


//pattern
@interface MCPattern : NSObject

@property(retain, nonatomic)MCTreeNode *root;
@property(nonatomic)BOOL errorFlag;
@property(nonatomic)NSInteger errorPosition;

- (id)initWithString:(NSString *)patternStr;

@end

//state
@interface MCState : MCPattern

@property(retain, nonatomic)NSString *afterState;

- (id)initWithPatternStr:(NSString *)patternStr andAfterState:(NSString *)state;

@end

//rule
@interface MCRule : NSObject

@property(retain, nonatomic)MCTreeNode *root;
@property(nonatomic)BOOL errorFlag;
@property(nonatomic)NSInteger errorPosition;

- (id)initWithString:(NSString *)patternStr;

@end
