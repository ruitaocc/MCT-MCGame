//
//  MCBasicElement.m
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCBasicElement.h"

#define END_TOKEN -999
#define LOCKED_CUBIE_TOKEN 999

//tree node
@implementation MCTreeNode

@synthesize children;
@synthesize type;
@synthesize value;

-(id)init{
    if (self = [super init]) {
        self.children = [NSMutableArray array];
    }
    return self;
}

-(id)initNodeWithType:(NodeType)typ{
    if (self = [self init]) {
        self.type = typ;
    }
    return self;
}


-(void)dealloc{
    [children release];
    [super dealloc];
}

-(void)addChild:(MCTreeNode *)node{
    [children addObject:node];
}

@end

//pattern
@implementation MCPattern{
    NSInteger token;
    NSEnumerator *enumerator;
    NSArray *elements;
}

@synthesize root;
@synthesize errorFlag;
@synthesize errorPosition;


-(id)initWithString:(NSString *)patternStr{
    if (self = [self init]) {
        NSMutableArray *mutableElements = [[NSMutableArray alloc]init];
        //split the string
        NSArray *components = [patternStr componentsSeparatedByString:@","];
        //transfer into number
        for (NSString *element in components){
            [mutableElements addObject:[NSNumber numberWithInteger:[element intValue]]];
        }
        //transfer into tree
        [self tokenInit:mutableElements];
        [self setRoot:[self parsePattern]];
        //if error occurred, release the tree
        if (errorFlag) {
            [self setRoot:nil];
        }
        //release tmp object
        [self tokenRelease];
        [mutableElements release];
    }
    return self;
}

-(void)dealloc{
    [root release];
    [super dealloc];
}

-(void)tokenInit:(NSMutableArray *)array{
    elements = [NSArray arrayWithArray:array];
    [elements retain];
    enumerator = [elements objectEnumerator];
    errorFlag = NO;
    errorPosition = -1;
}

-(void)tokenRelease{
    [elements release];
    elements = nil;
    enumerator = nil;
}

-(void)getToken{
    NSNumber *t;
    if (t = [enumerator nextObject]) {
        token = [t integerValue];
        errorPosition++;
    }
    else{
        token = END_TOKEN;
    }
}

-(void)errorOccur:(NSString *)errorMsg{
    errorFlag = YES;
    NSLog(@"%@", errorMsg);
}

-(MCTreeNode *)parsePattern{
	[self getToken];
	return [self parseBoolExp];
}

-(MCTreeNode *)parseBoolExp{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
	MCTreeNode * node = [self parseBterm];
    //if error occurred, return node
    if (errorFlag) return node;
    //if no error, continue
	if (token==Token_Or)
	{
		MCTreeNode * orNode = [[MCTreeNode alloc] initNodeWithType:ExpNode];
        orNode.value = Or;
		if (orNode != nil) {
			[orNode addChild:node];
			[self getToken];
			[orNode addChild:[self parseBterm]];
            node = orNode;
            [node autorelease];
		}
    }
    //if error occurred, return node
    if (errorFlag) return node;
    //if no error, continue
    while (token == Token_Or) {
        [self getToken];
        [node addChild:[self parseBterm]];
        //if error occurred, break and return node
        if (errorFlag) break;
        //if no error, continue
    }
	return node;
}

-(MCTreeNode *)parseBterm{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
    MCTreeNode * node = [self parseBfactor];
    //if error occurred, return node
    if (errorFlag) return node;
    //if no error, continue
    if (token == Token_And) {
        MCTreeNode * andNode = [[MCTreeNode alloc] initNodeWithType:ExpNode];
        andNode.value = And;
		if (andNode!=NULL) {
			[andNode addChild:node];
			[self getToken];
            node = [self parseBfactor];
            if (node != nil) [andNode addChild:node];
            node = andNode;
            [node autorelease];
		}
    }
    //if error occurred, return node
    if (errorFlag) return node;
    //if no error, continue
	while (token==Token_And)
	{
        [self getToken];
        MCTreeNode *child = [self parseBfactor];
        if (child != nil) [node addChild:child];
        //if error occurred, break and return node
        if (errorFlag) break;
        //if no error, continue
	}
	return node;
}

-(MCTreeNode *)parseBfactor{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
    MCTreeNode * node = nil;
	switch (token) {
        case Home:
        {
            node = [[MCTreeNode alloc] initNodeWithType:PatternNode];
            node.value = Home;
            [self getToken];
            int count;
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            for (count = 0, [self getToken]; token != Token_RightParentheses; count++) {
                MCTreeNode *tmp;
                if (token == Token_LeftParentheses) {
                    [self getToken];
                    tmp = [self parseInformationItem];
                    [self getToken];
                } else {
                    if (token == END_TOKEN) {
                        [self errorOccur:@"The home function need right parentheses"];
                        return [node autorelease];
                    }
                    else{
                        tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                        tmp.value = token;
                        [self getToken];
                        [tmp autorelease];
                    }
                }
                [node addChild:tmp];
            }
            //error occurred, home function needs parameter
            if (count == 0) {
                [self errorOccur:@"There must be at least one parameter transferred into home function."];
                return [node autorelease];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                break;
            }
            [self getToken];
        }
            break;
        case Check:
        {
            node = [[MCTreeNode alloc] initNodeWithType:PatternNode];
            node.value = Check;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                break;
            }
            for ([self getToken]; token >= 0;) {
                MCTreeNode *child = nil;
                MCTreeNode *childElement;
                switch (token) {
                    case At:
                    case NotAt:
                    {
                        child = [[MCTreeNode alloc] initNodeWithType:PatternNode];
                        child.value = token;
                        [self getToken];
                        int i = 0;
                        //test if '(' has been lost
                        if (token != Token_LeftParentheses) {
                            [self errorOccur:@"There should be '('"];
                            return [node autorelease];
                        }
                        for ([self getToken]; i < 2; i++) {
                            if (token == Token_LeftParentheses) {
                                [self getToken];
                                childElement = [self parseInformationItem];
                                [self getToken];
                            } else {
                                childElement = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                                childElement.value = token;
                                [self getToken];
                                [childElement autorelease];
                            }
                            [child addChild:childElement];
                        }
                        //test if ')' has been lost
                        if (token != Token_RightParentheses) {
                            [self errorOccur:@"There should be ')'"];
                            return [node autorelease];
                        }
                        [self getToken];
                    }
                        break;
                    case ColorBindOrientation:
                    {
                        child = [[MCTreeNode alloc] initNodeWithType:PatternNode];
                        child.value = token;
                        [self getToken];
                        int i = 0;
                        //test if '(' has been lost
                        if (token != Token_LeftParentheses) {
                            [self errorOccur:@"There should be '('"];
                            return [node autorelease];
                        }
                        for ([self getToken]; i < 2; i++) {
                            if (token == Token_LeftParentheses) {
                                [self getToken];
                                childElement = [self parseInformationItem];
                                [self getToken];
                            } else {
                                childElement = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                                childElement.value = token;
                                [self getToken];
                                [childElement autorelease];
                            }
                            [child addChild:childElement];
                        }
                        //if there is the third parameter
                        if (token != Token_RightParentheses) {
                            MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                            tmp.value = token;
                            [child addChild:tmp];
                            [tmp release];
                            [self getToken];
                        }
                        //test if ')' has been lost
                        if (token != Token_RightParentheses) {
                            [self errorOccur:@"There should be ')'"];
                            return [node autorelease];
                        }
                        [self getToken];
                    }
                        break;
                    default:
                        break;
                }
                [node addChild:child];
                [child release];
            }
            [self getToken];
        }
            break;
        case CubiedBeLocked:
        {
            node = [[MCTreeNode alloc] initNodeWithType:PatternNode];
            node.value = CubiedBeLocked;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            [self getToken];
            //there has a parameter
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
        }
            break;
        case Token_LeftParentheses:
        {
            [self getToken];
            node = [self parseBoolExp];
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
        }
            return node;
        case Token_Not:
        {
            node = [[MCTreeNode alloc] initNodeWithType:ExpNode];
            node.value = Not;
            [self getToken];
            [node addChild:[self parseBfactor]];
        }
            break;
        default:
            [self errorOccur:@"unexpected token."];
            return nil;
	}
	return [node autorelease];
}

- (MCTreeNode *)parseInformationItem{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
    MCTreeNode * node = nil;
	switch (token) {
        case getCombinationFromOrientation:
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = getCombinationFromOrientation;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            for ([self getToken]; token >= 0; [self getToken]) {
                if (token == END_TOKEN) {
                    [self errorOccur:@"The getCombinationFromOrientation function need right parentheses"];
                    return node;
                }
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
            break;
        case getCombinationFromColor:
        {
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = getCombinationFromColor;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            for ([self getToken]; token != Token_RightParentheses;) {
                if (token == Token_LeftParentheses) {
                    [self getToken];
                    [node addChild:[self parseInformationItem]];
                    [self getToken];
                } else {
                    MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                    tmp.value = token;
                    [node addChild:tmp];
                    [tmp release];
                    [self getToken];
                }
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
        }
            break;
        case getFaceColorFromOrientation:
        {
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = getFaceColorFromOrientation;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            [self getToken];
            MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
            tmp.value = token;
            [node addChild:tmp];
            [tmp release];
            [self getToken];
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
        }
            break;
        case lockedCubie:
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = lockedCubie;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            [self getToken];
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
            break;
        default:
            [self errorOccur:@"unexpected token."];
            return nil;
    }
	return [node autorelease];
}

@end

//state
@implementation MCState

@synthesize afterState;

- (id)initWithPatternStr:(NSString *)patternStr andAfterState:(NSString *)state{
    if (self = [self initWithString:patternStr]) {
        self.afterState = state;
    }
    return self;
}

- (void)dealloc{
    [afterState release];
    [super dealloc];
}

@end


//rule
@implementation MCRule{
    NSInteger token;
    NSEnumerator *enumerator;
    NSArray *elements;
}

@synthesize root;
@synthesize errorFlag;
@synthesize errorPosition;

- (id)initWithString:(NSString *)patternStr{
    if (self = [self init]) {
        NSMutableArray *mutableElements = [[NSMutableArray alloc]init];
        //split the string
        NSArray *components = [patternStr componentsSeparatedByString:@","];
        //transfer into number
        for (NSString *element in components){
            [mutableElements addObject:[NSNumber numberWithInteger:[element intValue]]];
        }
        //transfer into tree
        [self tokenInit:mutableElements];
        [self setRoot:[self parseRule]];
        //if error occurred, release the tree
        if (errorFlag) {
            [self setRoot:nil];
        }
        //release tmp object
        [self tokenRelease];
        [mutableElements release];
    }
    return self;
}

- (void)dealloc{
    [root release];
    [super dealloc];
}

- (void)tokenInit:(NSMutableArray *)array{
    elements = [NSArray arrayWithArray:array];
    [elements retain];
    enumerator = [elements objectEnumerator];
    errorFlag = NO;
    errorPosition = -1;
}

- (void)tokenRelease{
    [elements release];
    elements = nil;
    enumerator = nil;
}

- (void)getToken{
    NSNumber *t;
    if (t = [enumerator nextObject]) {
        token = [t integerValue];
        errorPosition++;
    }
    else{
        token = END_TOKEN;
    }
}

-(void)errorOccur:(NSString *)errorMsg{
    errorFlag = YES;
    NSLog(@"%@", errorMsg);
}

- (MCTreeNode *)parseRule{
	[self getToken];
	return [self parseSequenceExp];
}

- (MCTreeNode *)parseSequenceExp{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
	MCTreeNode * node = [[MCTreeNode alloc] initNodeWithType:ExpNode];
    node.value = Sequence;
    MCTreeNode * childNode;
    while ((childNode = [self parseItem]) != nil) {
        [node addChild:childNode];
        //if error occurred, return nil
        if (errorFlag) break;
        //if no error, continue
    }
    return [node autorelease];
}

- (MCTreeNode *)parseItem{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
    MCTreeNode * node = nil;
	switch (token) {
        case Rotate:
        {
            node = [[MCTreeNode alloc] initNodeWithType:ActionNode];
            node.value = Rotate;
            [self getToken];
            for ([self getToken]; token >= 0; [self getToken]) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
            }
            [self getToken];
        }
            break;
        case FaceToOrientation:
        {
            node = [[MCTreeNode alloc] initNodeWithType:ActionNode];
            node.value = token;
            [self getToken];        //delete "FaceTo"|"MoveTo"
            [self getToken];        //delete "("
            //add two elements
            MCTreeNode *childElement;
            childElement = [[MCTreeNode alloc] initNodeWithType:ElementNode];
            childElement.value = token;
            [node addChild:childElement];
            [childElement release];
            [self getToken];        //delete first element
            childElement = [[MCTreeNode alloc] initNodeWithType:ElementNode];
            childElement.value = token;
            [node addChild:childElement];
            [childElement release];
            [self getToken];        //delete second element
            [self getToken];        //delete ")"
        }
            break;
        case LockCubie:
        {
            node = [[MCTreeNode alloc] initNodeWithType:ActionNode];
            node.value = LockCubie;
            [self getToken];
            [self getToken];
            if (token == Token_LeftParentheses) {
                [self getToken];
                MCTreeNode *child = [self parseInformationItem];
                [node addChild:child];
                [self getToken];
            }
            else{
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            [self getToken];
        }
            break;
        case UnlockCubie:
        {
            node = [[MCTreeNode alloc] initNodeWithType:ActionNode];
            node.value = UnlockCubie;
            [self getToken];
            [self getToken];
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            [self getToken];
        }
            break;
        case Token_LeftParentheses :
        {
            [self getToken];
            node = [self parseItem];
            [self getToken];
            return node;
        }
            break;
        case END_TOKEN:
            return nil;
            break;
        default:
            [self errorOccur:@"unexpected token."];
            return nil;
	}
	return [node autorelease];
}

- (MCTreeNode *)parseInformationItem{
    //if error occurred, return nil
    if (errorFlag) return nil;
    //if no error, continue
    MCTreeNode * node = nil;
	switch (token) {
        case getCombinationFromOrientation:
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = getCombinationFromOrientation;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            for ([self getToken]; token >= 0; [self getToken]) {
                if (token == END_TOKEN) {
                    [self errorOccur:@"The getCombinationFromOrientation function need right parentheses"];
                    return node;
                }
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
            break;
        case getCombinationFromColor:
        {
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = getCombinationFromColor;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            for ([self getToken]; token != Token_RightParentheses;) {
                if (token == Token_LeftParentheses) {
                    [self getToken];
                    [node addChild:[self parseInformationItem]];
                    [self getToken];
                } else {
                    MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                    tmp.value = token;
                    [node addChild:tmp];
                    [tmp release];
                    [self getToken];
                }
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
        }
            break;
        case getFaceColorFromOrientation:
        {
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = getFaceColorFromOrientation;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            [self getToken];
            MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
            tmp.value = token;
            [node addChild:tmp];
            [tmp release];
            [self getToken];
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
        }
            break;
        case lockedCubie:
            node = [[MCTreeNode alloc] initNodeWithType:InformationNode];
            node.value = lockedCubie;
            [self getToken];
            //test if '(' has been lost
            if (token != Token_LeftParentheses) {
                [self errorOccur:@"There should be '('"];
                return [node autorelease];
            }
            [self getToken];
            if (token != Token_RightParentheses) {
                MCTreeNode *tmp = [[MCTreeNode alloc] initNodeWithType:ElementNode];
                tmp.value = token;
                [node addChild:tmp];
                [tmp release];
                [self getToken];
            }
            //test if ')' has been lost
            if (token != Token_RightParentheses) {
                [self errorOccur:@"There should be ')'"];
                return [node autorelease];
            }
            [self getToken];
            break;
        default:
            [self errorOccur:@"unexpected token."];
            return nil;
    }
	return [node autorelease];
}

@end












