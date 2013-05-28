//
//  MCPlayHelper.m
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCPlayHelper.h"
#import "MCTransformUtil.h"


@implementation MCPlayHelper{
    NSObject<MCCubieDelegate>* lockedCubies[CubieCouldBeLockMaxNum];
}

@synthesize magicCube;
@synthesize patterns;
@synthesize rules;
@synthesize specialPatterns;
@synthesize specialRules;
@synthesize states;
@synthesize state;
@synthesize helperState;
@synthesize applyQueue;
@synthesize rotationResult;
@synthesize accordanceMsgs;


+ (MCPlayHelper *)playerHelperWithMagicCube:(MCMagicCube *)mc{
    return [[[MCPlayHelper alloc] initWithMagicCube:mc] autorelease];
}

- (id)initWithMagicCube:(MCMagicCube *)mc{
    if (self = [super init]) {
        //Here allocate the array which store residual actions.
        //The residual actions contains all actions of the applied rule except rotation actions.
        self.residualActions = [NSMutableArray arrayWithCapacity:DEFAULT_RESIDUAL_ACTION_NUM];
        
        //Allocate accordance messages of the pattern of the applied rule
        self.accordanceMsgs = [NSMutableArray arrayWithCapacity:DEFAULT_PATTERN_ACCORDANCE_MESSAGE_NUM];
        
        //normal helper state
        self.helperState = Normal;
        
        //locked cubie list
        for (int i = 0; i < CubieCouldBeLockMaxNum; i++) {
            lockedCubies[0] = nil;
        }
        
        [self setMagicCube:mc];
        //refresh state and rules
        self.state = START_STATE;
        [self reloadRulesAccordingToCurrentStateOfRubiksCube];
    }
    return self;
}

//the magic cube setter has been rewritten
//once you set the magic cube object, state and rules will be refreshed
- (void)setMagicCube:(MCMagicCube *)mc{
    [mc retain];
    [magicCube release];
    magicCube = mc;
    //refresh state and rules
    self.state = START_STATE;
    [self reloadRulesAccordingToCurrentStateOfRubiksCube];
}

- (void)dealloc{
    self.patterns = nil;
    self.rules = nil;
    self.specialPatterns = nil;
    self.specialRules = nil;
    self.states = nil;
    self.state = nil;
    self.applyQueue = nil;
    [self setMagicCube:nil];
    [super dealloc];
}

- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity{
    if (magicCube == nil) {
        NSLog(@"set the magic cube object first.");
        return NO;
    }
    else{
        NSObject<MCCubieDelegate> *targetCubie = [magicCube cubieWithColorCombination:identity];
        BOOL isHome = YES;
        NSDictionary *colorOrientationMapping = [targetCubie getCubieColorInOrientationsWithoutNoColor];
        NSArray *orientations = [colorOrientationMapping allKeys];
        for (NSNumber *orientation in orientations) {
            switch ([magicCube centerMagicCubeFaceInOrientation:(FaceOrientationType)[orientation integerValue]]) {
                case Up:
                    if ([[colorOrientationMapping objectForKey:orientation] integerValue] != UpColor) {
                        isHome = NO;
                    }
                    break;
                case Down:
                    if ([[colorOrientationMapping objectForKey:orientation] integerValue] != DownColor) {
                        isHome = NO;
                    }
                    break;
                case Left:
                    if ([[colorOrientationMapping objectForKey:orientation] integerValue] != LeftColor) {
                        isHome = NO;
                    }
                    break;
                case Right:
                    if ([[colorOrientationMapping objectForKey:orientation] integerValue] != RightColor) {
                        isHome = NO;
                    }
                    break;
                case Front:
                    if ([[colorOrientationMapping objectForKey:orientation] integerValue] != FrontColor) {
                        isHome = NO;
                    }
                    break;
                case Back:
                    if ([[colorOrientationMapping objectForKey:orientation] integerValue] != BackColor) {
                        isHome = NO;
                    }
                    break;
                case WrongOrientation:
                    isHome = NO;
                    break;
            }
            if (!isHome) {
                break;
            }
        }
        return isHome;
    }
}

//Apply the pattern and return result
- (BOOL)applyPatternWihtPatternName:(NSString *)name ofType:(AppliedRuleType)type{
    //Before apply pattern, clear accrodance messages firstly.
    [self.accordanceMsgs removeAllObjects];
    
    // Get the pattern named 'name'
    MCPattern *pattern = nil;
    switch (type) {
        case Special:
            pattern = [self.specialPatterns objectForKey:name];
            break;
        case General:
            pattern = [self.patterns objectForKey:name];
            break;
        default:
            break;
    }
    
    // apply
    if (pattern != nil) {
        return [self treeNodesApply:pattern.root withDeep:0];
    }
    else{
        NSLog(@"Can't find the pattern, the pattern name is wrong");
        return NO;
    }
}

//Apply the action and return result
- (BOOL)applyActionWithPatternName:(NSString *)name ofType:(AppliedRuleType)type{
    // Get the rule name 'name'.
    MCRule *rule = nil;
    switch (type) {
        case Special:
            rule = [self.specialRules objectForKey:name];
            break;
        case General:
            rule = [self.rules objectForKey:name];
            break;
        default:
            break;
    }
    
    // apply
    if (rule != nil) {
        return [self treeNodesApply:rule.root withDeep:0];
    }
    else{
        NSLog(@"Can't find the action, the pattern name is wrong");
        return NO;
    }
}

- (NSInteger)treeNodesApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    switch (root.type) {
        case ExpNode:
        {
            switch (root.value) {
                case And:
                    return [self andNodeApply:root withDeep:deep];
                case Or:
                    return [self orNodeApply:root withDeep:deep];
                case Sequence:
                    return [self sequenceNodeApply:root withDeep:deep];
                case Not:
                    return [self notNodeApply:root withDeep:deep];
                default:
                    break;
            }
        }
            break;
        case PatternNode:
        {
            switch (root.value) {
                case Home:
                {
                    ColorCombinationType value;
                    for (MCTreeNode *child in root.children) {
                        value = (ColorCombinationType)[self treeNodesApply:child withDeep:deep+1];
                        if (![self isCubieAtHomeWithIdentity:value]) {
                            return NO;
                        }
                    }
                    if (deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                             accordingToMagicCube:self.magicCube
                                                                  andLockedCubies:lockedCubies];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                case Check:
                {
                    ColorCombinationType targetCubie = ColorCombinationTypeBound;
                    for (MCTreeNode *subPattern in root.children) {
                        switch (subPattern.value) {
                            case At:
                            {
                                targetCubie = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:0] withDeep:deep+1];
                                ColorCombinationType targetPosition = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:1] withDeep:deep+1];
                                struct Point3i coorValue = [magicCube coordinateValueOfCubieWithColorCombination:(ColorCombinationType)targetCubie];
                                if (coorValue.x + coorValue.y*3 + coorValue.z * 9 + 13 != targetPosition) {
                                    return NO;
                                }
                            }
                                break;
                            case ColorBindOrientation:
                            {
                                NSObject<MCCubieDelegate> *cubie = nil;
                                FaceOrientationType targetOrientation = (FaceOrientationType)[self treeNodesApply:[subPattern.children objectAtIndex:0] withDeep:deep+1];
                                FaceColorType targetColor = (FaceColorType)[self treeNodesApply:[subPattern.children objectAtIndex:1] withDeep:deep+1];
                                if ([subPattern.children count] > 2) {
                                    NSInteger position = [(MCTreeNode *)[subPattern.children objectAtIndex:2] value];
                                    cubie = [magicCube cubieAtCoordinateX:(position%3-1) Y:(position%9/3-1) Z:(position/9-1)];
                                } else {
                                    cubie = [magicCube cubieWithColorCombination:(ColorCombinationType)targetCubie];
                                }
                                return [cubie isFaceColor:targetColor inOrientation:targetOrientation];
                            }
                            case NotAt:
                            {
                                targetCubie = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:0] withDeep:deep+1];
                                ColorCombinationType targetPosition = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:1] withDeep:deep+1];
                                struct Point3i coorValue = [magicCube coordinateValueOfCubieWithColorCombination:(ColorCombinationType)targetCubie];
                                if (coorValue.x + coorValue.y*3 + coorValue.z * 9 + 13 == targetPosition) {
                                    return NO;
                                }
                            }
                                break;
                            default:
                                return NO;
                        }
                    }
                    if (deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                             accordingToMagicCube:self.magicCube
                                                                  andLockedCubies:lockedCubies];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                case CubiedBeLocked:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    
                    if (lockedCubies[index] == nil) return NO;
                    
                    if (deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                             accordingToMagicCube:self.magicCube
                                                                  andLockedCubies:lockedCubies];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                default:
                    return NO;
            }
        }
            break;
        case ActionNode:
        {
            switch (root.value) {
                case Rotate:
                    for (MCTreeNode *child in root.children) {
                        [magicCube rotateWithSingmasterNotation:(SingmasterNotation)child.value];
                    }
                    break;
                case FaceToOrientation:
                {
                    MCTreeNode *elementNode;
                    elementNode = [root.children objectAtIndex:0];
                    ColorCombinationType targetCombination = (ColorCombinationType)elementNode.value;
                    struct Point3i targetCoor = [magicCube coordinateValueOfCubieWithColorCombination:targetCombination];
                    elementNode = [root.children objectAtIndex:1];
                    FaceOrientationType targetOrientation = (FaceOrientationType)elementNode.value;
                    [magicCube rotateWithSingmasterNotation:[MCTransformUtil getPathToMakeCenterCubieAtPosition:targetCoor inOrientation:targetOrientation]];
                }
                    break;
                case LockCubie:
                {
                    MCTreeNode *elementNode = [root.children objectAtIndex:0];
                    int index = 0;
                    if ([root.children count] != 1) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                    }
                    int identity = [self treeNodesApply:elementNode withDeep:deep+1];
                    if (identity == -1) {
                        lockedCubies[index] = nil;
                    }
                    else{
                        lockedCubies[index] = [magicCube cubieWithColorCombination:(ColorCombinationType)identity];
                    }
                }
                    break;
                case UnlockCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    lockedCubies[index] = nil;
                }
                    break;
                default:
                    return NO;
            }
        }
            break;
        case InformationNode:
            switch (root.value) {
                case getCombinationFromOrientation:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ([magicCube centerMagicCubeFaceInOrientation:(FaceOrientationType)child.value]) {
                            case Up:
                                y = 2;
                                break;
                            case Down:
                                y = 0;
                                break;
                            case Left:
                                x = 0;
                                break;
                            case Right:
                                x = 2;
                                break;
                            case Front:
                                z = 2;
                                break;
                            case Back:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getCombinationFromColor:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ((FaceColorType)[self treeNodesApply:child withDeep:deep+1]) {
                            case UpColor:
                                y = 2;
                                break;
                            case DownColor:
                                y = 0;
                                break;
                            case LeftColor:
                                x = 0;
                                break;
                            case RightColor:
                                x = 2;
                                break;
                            case FrontColor:
                                z = 2;
                                break;
                            case BackColor:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getFaceColorFromOrientation:
                {
                    FaceColorType color;
                    FaceOrientationType orientation = (FaceOrientationType)[(MCTreeNode *)[root.children objectAtIndex:0] value];
                    if ([root.children count] == 1) {
                        switch ([magicCube centerMagicCubeFaceInOrientation:orientation]) {
                            case Up:
                                color = UpColor;
                                break;
                            case Down:
                                color = DownColor;
                                break;
                            case Left:
                                color = LeftColor;
                                break;
                            case Right:
                                color = RightColor;
                                break;
                            case Front:
                                color = FrontColor;
                                break;
                            case Back:
                                color = BackColor;
                                break;
                            default:
                                color = NoColor;
                                break;
                        }
                    }
                    else{
                        int value = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                        struct Point3i coordinate = {value%3-1, value%9/3-1, value/9-1};
                        color = [[magicCube cubieAtCoordinatePoint3i:coordinate] faceColorInOrientation:orientation];
                    }
                    
                    //Store the result at the node
                    root.result = color;
                    return root.result;
                }
                case lockedCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    if (lockedCubies[index] == nil) {
                        root.result = -1;
                    }
                    else{
                        root.result = [lockedCubies[index] identity];
                    }
                    
                    return root.result;
                }
                default:
                    break;
            }
            break;
        case ElementNode:
            return root.value;
        default:
            return NO;
    }
    return YES;
}

- (BOOL)andNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        
        //Being a 'and' node,
        //it will be failed whever one of its child is failed.
        if (![self treeNodesApply:node withDeep: deep+1]) {
            return NO;
        }
        
        //While this node is true, we store some accordance messages
        //for several occasions.
        switch (node.type) {
            case ExpNode:
                if (node.value == Not) {
                    //Notice that the node is 'Not' node.
                    //You should get the negative sentence by invoking
                    //'getNegativeSentenceOfContentFromPatternNode'
                    NSString *msg = [MCTransformUtil getNegativeSentenceOfContentFromPatternNode:[node.children objectAtIndex:0]
                                                                            accordingToMagicCube:self.magicCube
                                                                                 andLockedCubies:lockedCubies];
                    if (msg != nil) {
                        [self.accordanceMsgs addObject:msg];
                    } 
                }
                break;
            case PatternNode:
            {
                switch (node.value) {
                    case Home | Check:
                    {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                             accordingToMagicCube:self.magicCube
                                                                  andLockedCubies:lockedCubies];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                        break;
                    case CubiedBeLocked:
                    {
                        if ([node.children count] == 0 ||
                            [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                            NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                                 accordingToMagicCube:self.magicCube
                                                                      andLockedCubies:lockedCubies];
                            if (msg != nil) {
                                [self.accordanceMsgs addObject:msg];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    }
    return YES;
}

- (BOOL)orNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        if ([self treeNodesApply:node withDeep:deep+1]) {
            //While this node is true, we store some accordance messages
            //for several occasions.
            switch (node.type) {
                case ExpNode:
                    if (node.value == Not) {
                        //Notice that the node is 'Not' node.
                        //You should get the negative sentence by invoking
                        //'getNegativeSentenceOfContentFromPatternNode'
                        //The result maybe nil.
                        NSString *msg = [MCTransformUtil getNegativeSentenceOfContentFromPatternNode:[node.children objectAtIndex:0]
                                                                                accordingToMagicCube:self.magicCube
                                                                                     andLockedCubies:lockedCubies];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                        
                    }
                    break;
                case PatternNode:
                {
                    switch (node.value) {
                        case Home | Check:
                        {
                            NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                                 accordingToMagicCube:self.magicCube
                                                                      andLockedCubies:lockedCubies];
                            if (msg != nil) {
                                [self.accordanceMsgs addObject:msg];
                            }
                        }
                            break;
                        case CubiedBeLocked:
                        {
                            if ([node.children count] == 0 ||
                                [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                                NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                                     accordingToMagicCube:self.magicCube
                                                                          andLockedCubies:lockedCubies];
                                if (msg != nil) {
                                    [self.accordanceMsgs addObject:msg];
                                }
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            
            return YES;
        }
    }
    return NO;
}

- (BOOL)sequenceNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        [self treeNodesApply:node withDeep:deep+1];
    }
    return YES;
}

- (BOOL)notNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    return ![self treeNodesApply:[root.children objectAtIndex:0] withDeep:deep+1];
}

- (NSDictionary *)applyRules{
    if (self.magicCube == nil){
        NSLog(@"Set the magic cube before apply rules.");
        return nil;
    }
    
    AppliedRuleType appliedType = Special;
    
    // Check special rules firstly.
    NSString *targetKey = nil;
    for (NSString *key in [self.specialRules allKeys])
    {
        if ([self applyPatternWihtPatternName:key ofType:Special]) {
            targetKey = key;
            appliedType = Special;
            break;
        }
    }
    
    // If no special rules match the state, check general rules.
    if (targetKey == nil) {
        for (NSString *key in [self.rules allKeys])
        {
            if ([self applyPatternWihtPatternName:key ofType:General]) {
                targetKey = key;
                appliedType = General;
                break;
            }
        }
    }
    
#ifdef ONLY_TEST
    NSLog(@"%@", targetKey);
    //error occurs, we can not find the rules to apply and there isn't the finished state.
    if ([self.state compare:END_STATE] != NSOrderedSame && targetKey == nil) {
        NSLog(@"%@", @"There must be something wrong, I don't apply any rules.");
        //save state for debug
        NSString *savedPath = [NSString stringWithFormat:@"ErrorStateForDebug_%f", [[NSDate date] timeInterval]];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [path stringByAppendingPathComponent:savedPath];
        [NSKeyedArchiver archiveRootObject:magicCube toFile:fileName];
        return nil;
    }
    [self applyActionWithPatternName:targetKey ofType:appliedType];
    [self checkStateFromInit:NO];
#else
    //error occurs, we can not find the rules to apply and there isn't the finished state.
    if ([self.state compare:END_STATE] != NSOrderedSame && targetKey == nil) {
        NSLog(@"%@", @"There must be something wrong, I don't apply any rules.");
        //save state for debug
        NSString *savedPath = [NSString stringWithFormat:@"ErrorStateForDebug_%f", [[NSDate date] timeInterval]];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [path stringByAppendingPathComponent:savedPath];
        [NSKeyedArchiver archiveRootObject:magicCube toFile:fileName];
        return nil;
    }
#endif
    
    NSLog(@"State:%@", state);
    NSLog(@"Rules:%@", targetKey);
    
#ifndef ONLY_TEST
    //get the tree of the action according to the pattern name
    MCTreeNode *actionTree = nil;
    switch (appliedType) {
        case Special:
            actionTree = [[self.specialRules objectForKey:targetKey] root];
            break;
        case General:
            actionTree = [[self.rules objectForKey:targetKey] root];
        default:
            break;
    }
    
    //analyse the action and return the result
    switch (actionTree.type) {
        case ExpNode:
        {
            BOOL flag = YES;
            for (MCTreeNode *node in actionTree.children) {
                if (flag) {
                    if (node.type == ActionNode && (node.value == Rotate|| node.value == FaceToOrientation)) {
                        self.applyQueue = [MCApplyQueue applyQueueWithRotationAction:node withMagicCube:self.magicCube];
                        flag = NO;
                    }
                    else{
                        [self treeNodesApply:node withDeep:1];
                    }
                } else {
                    [self.residualActions addObject:node];
                }
            }
        }
            break;
        case ActionNode:
            switch (actionTree.value) {
                case Rotate:
                case FaceToOrientation:
                    self.applyQueue = [MCApplyQueue applyQueueWithRotationAction:actionTree withMagicCube:self.magicCube];
                    break;
                default:
                    [self treeNodesApply:actionTree withDeep:0];
                    break;
            }
            break;
        default:
            break;
    }
    
    NSMutableDictionary *resultDirectory = [NSMutableDictionary dictionaryWithCapacity:DEFAULT_ACTION_INFOMATION_NUM];
    
    //While the apply queue isn't nil, attach it to the result directory.
    if (self.applyQueue != nil) {
        [resultDirectory setObject:[self.applyQueue getQueueWithStringFormat] forKey:KEY_ROTATION_QUEUE];
        self.helperState = ApplyingRotationQueue;
    }
    
    //While the apply queue isn't nil, attach it to the result directory.
    if ([self.accordanceMsgs count] != 0) {
        [resultDirectory setObject:[NSArray arrayWithArray:self.accordanceMsgs] forKey:KEY_TIPS];
        //------------------------------------
        NSLog(@"Tips---");
        for (NSString *msg in self.accordanceMsgs) {
            NSLog(@"%@", msg);
        }
    }
    
    //While there is a cubie is locked at 0 position, add locked cubie info
    if (lockedCubies[0] != nil) {
        [resultDirectory setObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:[lockedCubies[0] identity]]] forKey:KEY_LOCKED_CUBIES];
    }
    
#else
    NSDictionary *resultDirectory = [NSDictionary dictionary];
#endif
    
    // At the end, release the pool.
    
    
    return resultDirectory;
}

//Avoiding to loading all rules into memory,
//every time we just load rules that can be applied at current state.
//Thereby we should reload rules whenever the state of rubik's cube changes.
- (void)reloadRulesAccordingToCurrentStateOfRubiksCube{
    // Every time apply rule, construct a pool for auto releasing.
    NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
    
    self.states = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getStatesOfMethod:ETFF]];
    self.patterns = [NSDictionary dictionaryWithDictionary:
                     [[MCKnowledgeBase getSharedKnowledgeBase] getPatternsWithPreState:state
                                                                               inTable:DB_PATTERN_TABLE_NAME]];
    self.rules = [NSDictionary dictionaryWithDictionary:
                  [[MCKnowledgeBase getSharedKnowledgeBase] getRulesOfMethod:ETFF
                                                                   withState:state
                                                                     inTable:DB_RULE_TABLE_NAME]];
    self.specialPatterns = [NSDictionary dictionaryWithDictionary:
                            [[MCKnowledgeBase getSharedKnowledgeBase] getPatternsWithPreState:state
                                                                                      inTable:DB_SPECIAL_PATTERN_TABLE_NAME]];
    self.specialRules = [NSDictionary dictionaryWithDictionary:
                         [[MCKnowledgeBase getSharedKnowledgeBase] getRulesOfMethod:ETFF
                                                                          withState:state
                                                                            inTable:DB_SPECIAL_RULE_TABLE_NAME]];
    [loopPool release];
}


- (NSString *)checkStateFromInit:(BOOL)isCheckStateFromInit;{
    NSString *goStr;
    //to check from init or not
    if (isCheckStateFromInit) {
        goStr = START_STATE;
        for (int i = 0; i < CubieCouldBeLockMaxNum; i++) {
            lockedCubies[i] = nil;
        }
    }
    else{
        goStr = state;
    }
    //check state
    MCState *tmpState = [states objectForKey:goStr];
    for (; tmpState != nil && [self treeNodesApply:[tmpState root] withDeep:0]; tmpState = [states objectForKey:goStr]) {
        goStr = tmpState.afterState;
    }
    if ([goStr compare:state] != NSOrderedSame) {
        self.state = goStr;
        lockedCubies[0] = nil;
        for (int i = 4; i < CubieCouldBeLockMaxNum; i++) {
            lockedCubies[i] = nil;
        }
        [self reloadRulesAccordingToCurrentStateOfRubiksCube];
    }
    
    return self.state;
}


- (void)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction{
    if (self.magicCube != nil) {
        [self.magicCube rotateOnAxis:axis onLayer:layer inDirection:direction];
        SingmasterNotation currentRotation = [MCTransformUtil getSingmasterNotationFromAxis:axis layer:layer direction:direction];
        //apply rotation and get result
        if (self.applyQueue != nil && self.helperState == ApplyingRotationQueue) {
            self.rotationResult = [self.applyQueue applyRotation:currentRotation];
        }
    }
}

- (void)rotateWithSingmasterNotation:(SingmasterNotation)notation{
    if (self.magicCube != nil) {
        [self.magicCube rotateWithSingmasterNotation:notation];
        //apply rotation and get result
        if (self.applyQueue != nil && self.helperState == ApplyingRotationQueue) {
            self.rotationResult = [self.applyQueue applyRotation:notation];
        }
    }
}


- (RotationResult)getResultOfTheLastRotation{
    return self.rotationResult;
}

- (void)setHelperState:(HelperStateMachine)hs{
    helperState = hs;
    switch (hs) {
        case Normal:
            self.applyQueue = nil;
            self.rotationResult = NoneResult;
            break;
        case ApplyingRotationQueue:
            break;
        default:
            break;
    }
}

- (void)clearResidualActions{
    for (MCTreeNode *node in self.residualActions) {
        [self treeNodesApply:node withDeep:0];
    }
    [self.residualActions removeAllObjects];
    [self checkStateFromInit:NO];
}   //do the clear thing for next rotation queue

@end

