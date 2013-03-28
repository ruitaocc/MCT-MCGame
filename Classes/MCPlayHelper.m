//
//  MCPlayHelper.m
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCPlayHelper.h"


@implementation MCPlayHelper{
    MCCubie* lockedCubies[CubieCouldBeLockMaxNum];
    BOOL isCheckStateFromInit;
}

@synthesize magicCube;
@synthesize patterns;
@synthesize rules;
@synthesize states;
@synthesize state;

+ (MCPlayHelper *)getSharedPlayHelper{
    static MCPlayHelper *playHelper;
    @synchronized(self)
    {
        if (!playHelper)
            playHelper = [[MCPlayHelper alloc] init];
        return playHelper;
    }
}

- (id)init{
    if (self = [super init]) {
        //defaultedly, not check state state frome init
        isCheckStateFromInit = NO;
        //locked cubie list
        for (int i = 0; i < CubieCouldBeLockMaxNum; i++) {
            lockedCubies[0] = nil;
        }
        
        magicCube = [MCMagicCube getSharedMagicCube];
        self.state = START_STATE;
        
        self.patterns = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getPatternsWithPreState:state]];
        self.rules = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getRulesOfMethod:ETFF withState:state]];
        self.states = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getStatesOfMethod:ETFF]];
    }
    return self;
}

- (void)dealloc{
    [patterns release];
    [rules release];
    [states release];
    [state release];
    [self setMagicCube:nil];
    [super dealloc];
}

- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity{
    if (magicCube == nil) {
        NSLog(@"set the magic cube object first.");
        return NO;
    }
    else{
        MCCubie *targetCubie = [magicCube cubieWithColorCombination:identity];
        BOOL isHome = YES;
        for (int i = 0; i < targetCubie.skinNum; i++) {
            switch ([magicCube magicCubeFaceInOrientation:targetCubie.orientations[i]]) {
                case Up:
                    if (targetCubie.faceColors[i] != UpColor) {
                        isHome = NO;
                    }
                    break;
                case Down:
                    if (targetCubie.faceColors[i] != DownColor) {
                        isHome = NO;
                    }
                    break;
                case Left:
                    if (targetCubie.faceColors[i] != LeftColor) {
                        isHome = NO;
                    }
                    break;
                case Right:
                    if (targetCubie.faceColors[i] != RightColor) {
                        isHome = NO;
                    }
                    break;
                case Front:
                    if (targetCubie.faceColors[i] != FrontColor) {
                        isHome = NO;
                    }
                    break;
                case Back:
                    if (targetCubie.faceColors[i] != BackColor) {
                        isHome = NO;
                    }
                    break;
            }
            if (!isHome) {
                break;
            }
        }
        return isHome;
    }
}

- (BOOL)applyPatternWihtName:(NSString *)name{
    MCPattern *pattern = [patterns objectForKey:name];
    if (pattern != nil) {
        return [self treeNodesApply:pattern.root];
    }
    else{
        NSLog(@"the pattern name is wrong");
        return NO;
    }
}


#define NO_LOCKED_CUBIE -1
- (NSInteger)treeNodesApply:(MCTreeNode *)root{
    switch (root.type) {
        case ExpNode:
        {
            switch (root.value) {
                case And:
                    return [self andNodeApply:root];
                case Or:
                    return [self orNodeApply:root];
                case Sequence:
                    return [self sequenceNodeApply:root];
                case Not:
                    return [self notNodeApply:root];
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
                        value = [self treeNodesApply:child];
                        if (value == NO_LOCKED_CUBIE) {
                            return NO;
                        }
                        if (![self isCubieAtHomeWithIdentity:value]) {
                            return NO;
                        }
                    }
                }
                    break;
                case Check:
                {
                    NSInteger targetCubie;
                    for (MCTreeNode *subPattern in root.children) {
                        switch (subPattern.value) {
                            case At:
                            {
                                targetCubie = [self treeNodesApply:[subPattern.children objectAtIndex:0]];
                                ColorCombinationType targetPosition = [self treeNodesApply:[subPattern.children objectAtIndex:1]];
                                struct Point3i coorValue = [magicCube coordinateValueOfCubieWithColorCombination:targetCubie];
                                if (coorValue.x + coorValue.y*3 + coorValue.z * 9 + 13 != targetPosition) {
                                    return NO;
                                }
                            }
                                break;
                            case ColorBindOrientation:
                            {
                                MCCubie *cubie = nil;
                                FaceOrientationType targetOrientation = [self treeNodesApply:[subPattern.children objectAtIndex:0]];
                                FaceColorType targetColor = [self treeNodesApply:[subPattern.children objectAtIndex:1]];
                                if ([subPattern.children count] > 2) {
                                    NSInteger position = [(MCTreeNode *)[subPattern.children objectAtIndex:2] value];
                                    cubie = [magicCube cubieAtCoordinateX:(position%3-1) Y:(position%9/3-1) Z:(position/9-1)];
                                } else {
                                    cubie = [magicCube cubieWithColorCombination:targetCubie];
                                }
                                return [cubie isFaceColor:targetColor inOrientation:targetOrientation];
                            }
                            case NotAt:
                            {
                                targetCubie = [self treeNodesApply:[subPattern.children objectAtIndex:0]];
                                ColorCombinationType targetPosition = [self treeNodesApply:[subPattern.children objectAtIndex:1]];
                                struct Point3i coorValue = [magicCube coordinateValueOfCubieWithColorCombination:targetCubie];
                                if (coorValue.x + coorValue.y*3 + coorValue.z * 9 + 13 == targetPosition) {
                                    return NO;
                                }
                            }
                                break;
                            default:
                                return NO;
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
                    return lockedCubies[index] != nil;
                }
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
                    ColorCombinationType targetCombination = elementNode.value;
                    struct Point3i targetCoor = [magicCube coordinateValueOfCubieWithColorCombination:targetCombination];
                    elementNode = [root.children objectAtIndex:1];
                    FaceOrientationType targetOrientation = elementNode.value;
                    [magicCube rotateWithSingmasterNotation:[self getPathToMakeCenterCubieAtPosition:targetCoor inOrientation:targetOrientation]];
                }
                    break;
                case LockCubie:
                {
                    MCTreeNode *elementNode = [root.children objectAtIndex:0];
                    int index = 0;
                    if ([root.children count] != 1) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                    }
                    int identity = [self treeNodesApply:elementNode];
                    if (identity == -1) {
                        lockedCubies[index] = nil;
                    }
                    else{
                        lockedCubies[index] = [magicCube cubieWithColorCombination:identity];
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
                        switch ([magicCube magicCubeFaceInOrientation:child.value]) {
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
                    return x+y*3+z*9;
                }
                case getCombinationFromColor:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ((FaceColorType)[self treeNodesApply:child]) {
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
                    return x+y*3+z*9;
                }
                case getFaceColorFromOrientation:
                {
                    FaceColorType color;
                    FaceOrientationType orientation = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    if ([root.children count] == 1) {
                        switch ([magicCube magicCubeFaceInOrientation:orientation]) {
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
                    return color;
                }
                case LockedCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    if (lockedCubies[index] == nil) {
                        return -1;
                    }
                    else{
                        return lockedCubies[index].identity;
                    }
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

- (BOOL)andNodeApply:(MCTreeNode *)root{
    for (MCTreeNode *node in root.children) {
        if (![self treeNodesApply:node]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)orNodeApply:(MCTreeNode *)root{
    for (MCTreeNode *node in root.children) {
        if ([self treeNodesApply:node]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)sequenceNodeApply:(MCTreeNode *)root{
    for (MCTreeNode *node in root.children) {
        [self treeNodesApply:node];
    }
    return YES;
}

- (BOOL)notNodeApply:(MCTreeNode *)root{
    return ![self treeNodesApply:[root.children objectAtIndex:0]];
}

- (void)applyRules{
    if (magicCube == nil) magicCube = [MCMagicCube getSharedMagicCube];
    NSString *key;
    NSArray *keys = [rules allKeys];
    int count = [rules count];
    
    for (int i = 0; i < count; i++)
    {
        key = [keys objectAtIndex:i];
        if ([self applyPatternWihtName:key]) {
            [self treeNodesApply:[[rules objectForKey:key] root]];
            NSLog(@"%@", key);
            break;
        }
    }
    
    [self checkState];
    NSLog(@"%@", state);
}

- (void)refresh{
    self.states = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getStatesOfMethod:ETFF]];
    self.patterns = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getPatternsWithPreState:state]];
    self.rules = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getRulesOfMethod:ETFF withState:state]];
}

- (void)checkState{
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
    for (MCState *tmpState = [states objectForKey:goStr]; tmpState != nil && [self treeNodesApply:[tmpState root]]; tmpState = [states objectForKey:goStr]) {
        goStr = tmpState.afterState;
    }
    if ([goStr compare:state] != NSOrderedSame) {
        self.state = goStr;
        lockedCubies[0] = nil;
        for (int i = 4; i < CubieCouldBeLockMaxNum; i++) {
            lockedCubies[i] = nil;
        }
        [self refresh];
    }
}

- (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation{
    SingmasterNotation result = SingmasterNotation_DoNothing;
    switch (orientation) {
        case Up:
            switch (coordinate.y) {
                case 1:
                    result = SingmasterNotation_DoNothing;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.z) {
                        case 1:
                            result = x;
                            break;
                        case -1:
                            result = xi;
                            break;
                        case 2:
                            result = zi;
                            break;
                        case -2:
                            result = z;
                            break;
                        default:
                            break;
                    }
                    break;
                case -1:
                    result = x2;
                    break;
                default:
                    break;
            }
            break;
        case Down:
            switch (coordinate.y) {
                case -1:
                    result = SingmasterNotation_DoNothing;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.z) {
                        case 1:
                            result = xi;
                            break;
                        case -1:
                            result = x;
                            break;
                        case 2:
                            result = z;
                            break;
                        case -2:
                            result = zi;
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    result = x2;
                    break;
                default:
                    break;
            }
            break;
        case Left:
            switch (coordinate.x) {
                case -1:
                    result = SingmasterNotation_DoNothing;
                    break;
                case 0:
                    switch (coordinate.y*2+coordinate.z) {
                        case 1:
                            result = y;
                            break;
                        case -1:
                            result = yi;
                            break;
                        case 2:
                            result = zi;
                            break;
                        case -2:
                            result = z;
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        case Right:
            switch (coordinate.x) {
                case 1:
                    result = SingmasterNotation_DoNothing;
                    break;
                case 0:
                    switch (coordinate.y*2+coordinate.z) {
                        case 1:
                            result = yi;
                            break;
                        case -1:
                            result = y;
                            break;
                        case 2:
                            result = z;
                            break;
                        case -2:
                            result = zi;
                            break;
                        default:
                            break;
                    }
                    break;
                case -1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        case Front:
            switch (coordinate.z) {
                case 1:
                    result = SingmasterNotation_DoNothing;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.y) {
                        case 1:
                            result = xi;
                            break;
                        case -1:
                            result = x;
                            break;
                        case 2:
                            result = y;
                            break;
                        case -2:
                            result = yi;
                            break;
                        default:
                            break;
                    }
                    break;
                case -1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        case Back:
            switch (coordinate.z) {
                case -1:
                    result = SingmasterNotation_DoNothing;
                    break;
                case 0:
                    switch (coordinate.x*2+coordinate.y) {
                        case 1:
                            result = x;
                            break;
                        case -1:
                            result = xi;
                            break;
                        case 2:
                            result = yi;
                            break;
                        case -2:
                            result = y;
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    result = y2;
                    break;
                default:
                    break;
            }
            break;
        default:
            result = SingmasterNotation_DoNothing;
            break;
    }
    return result;
}

- (void)setCheckStateFromInit:(BOOL)is{
    isCheckStateFromInit = is;
}

- (void)refreshMagicCube{
    magicCube = [MCMagicCube getSharedMagicCube];
}

@end

