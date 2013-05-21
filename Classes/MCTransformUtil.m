//
//  MCTransformUtil.m
//  MagicCubeModel
//
//  Created by Aha on 13-3-12.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCTransformUtil.h"

@implementation MCTransformUtil

+ (FaceOrientationType)getContraryOrientation:(FaceOrientationType)orientation{
    FaceOrientationType result;
    switch (orientation) {
        case Up:
            result = Down;
            break;
        case Down:
            result = Up;
            break;
        case Front:
            result = Back;
            break;
        case Back:
            result = Front;
            break;
        case Left:
            result = Right;
            break;
        case Right:
            result = Left;
            break;
        default:
            return WrongOrientation;
    }
    return result;
}

+ (NSString *)getRotationTagFromSingmasterNotation:(SingmasterNotation)notation{
    NSString *names[54] = {
        @"frontCW",     @"frontCCW",    @"front2CW",
        @"backCW",      @"backCCW",     @"back2CW",
        @"rightCW",     @"rightCCW",    @"right2CW",
        @"leftCW",      @"leftCCW",     @"left2CW",
        @"upCW",        @"upCCW",       @"up2CW",
        @"downCW",      @"downCCW",     @"down2CW",
        @"xCW",         @"xCCW",        @"x2CW",
        @"yCW",         @"yCCW",        @"y2CW",
        @"zCW",         @"zCCW",        @"z2CW",
        @"frontTwoCW",  @"frontTwoCCW", @"frontTwo2CW",
        @"backTwoCW",   @"backTwoCCW",  @"backTwo2CW",
        @"rightTwoCW",  @"rightTwoCCW", @"rightTwo2CW",
        @"leftTwoCW",   @"leftTwoCCW",  @"leftTwo2CW",
        @"upTwoCW",     @"upTwoCCW",    @"upTwo2CW",
        @"downTwoCW",   @"downTwoCCW",  @"downTwo2CW"
        @"mxCW",        @"mxCCW",       @"mx2CW",
        @"myCW",        @"myCCW",       @"my2CW",
        @"mzCW",        @"mzCCW",       @"mz2CW"
    };
    return names[notation];
}

+ (SingmasterNotation)getSingmasterNotationFromAxis:(AxisType)axis layer:(int)layer direction:(LayerRotationDirectionType)direction{
    SingmasterNotation notation = NoneNotation;
    switch (axis) {
        case X:
        {
            switch (layer) {
                case 0:
                    if (direction == CW) {
                        return Li;
                    } else {
                        return L;
                    }
                    break;
                case 1:
                    if (direction == CW) {
                        return Mi;
                    } else {
                        return M;
                    }
                case 2:
                    if (direction == CW) {
                        return R;
                    } else {
                        return Ri;
                    }
                case NO_SELECTED_LAYER:{
                    if (direction == CW) {
                        return x;
                    }
                    else{
                        return xi;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case Y:
        {
            switch (layer) {
                case 0:
                    if (direction == CW) {
                        return Di;
                    } else {
                        return D;
                    }
                    break;
                case 1:
                    if (direction == CW) {
                        return Ei;
                    } else {
                        return E;
                    }
                case 2:
                    if (direction == CW) {
                        return U;
                    } else {
                        return Ui;
                    }
                case NO_SELECTED_LAYER:{
                    if (direction == CW) {
                        return y;
                    }
                    else{
                        return yi;
                    }
                }
                default:
                    break;
            }
        }
            break;
        case Z:
        {
            switch (layer) {
                case 0:
                    if (direction == CW) {
                        return Bi;
                    } else {
                        return B;
                    }
                    break;
                case 1:
                    if (direction == CW) {
                        return S;
                    } else {
                        return Si;
                    }
                case 2:
                    if (direction == CW) {
                        return F;
                    } else {
                        return Fi;
                    }
                case NO_SELECTED_LAYER:{
                    if (direction == CW) {
                        return z;
                    }
                    else{
                        return zi;
                    }
                }
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return notation;
}

+ (SingmasterNotation)getContrarySingmasterNotation:(SingmasterNotation)notation{
    if (notation == NoneNotation) {
        return NoneNotation;
    }
    SingmasterNotation result;
    int remainder = notation % 3;
    switch (remainder) {
        case 0:
            result = (SingmasterNotation)((int)notation + 1);
            break;
        case 1:
            result = (SingmasterNotation)((int)notation - 1);
            break;
        case 2:
            result = notation;
            break;
        default:
            result = NoneNotation;
            break;
    }
    return result;
}

+ (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation{
    SingmasterNotation result = NoneNotation;
    switch (orientation) {
        case Up:
            switch (coordinate.y) {
                case 1:
                    result = NoneNotation;
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
                    result = NoneNotation;
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
                    result = NoneNotation;
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
                    result = NoneNotation;
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
                    result = NoneNotation;
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
                    result = NoneNotation;
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
            result = NoneNotation;
            break;
    }
    return result;
}

+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node
                  accordingToMagicCube:(NSObject<MCMagicCubeDelegate> *)mc
                       andLockedCubies:(NSObject<MCCubieDelegate> **)lockedCubies{
    NSString *result = nil;
    
    //Before generate the content,
    //detect the wrong type.
    if ([node type] != PatternNode) {
        return nil;
    }
    
    //Generate the content of pattern node
    switch ([node value]) {
        case Home:
        {
            NSMutableString *tmpResult = [NSMutableString stringWithCapacity:24];
            ColorCombinationType identity;
            MCTreeNode *child;
            for (int i = 0; i < [node.children count]; i++) {
                //Get the child
                child = [node.children objectAtIndex:i];
                
                //The target value varies by type of child
                if (child.type == ElementNode) {
                    identity = (ColorCombinationType)[child value];
                }
                else if (child.type == InformationNode){
                    identity = (ColorCombinationType)[child result];
                }
                
                //Add target cubie description
                [tmpResult appendString:[MCTransformUtil getConcreteDescriptionOfCubie:identity fromMgaicCube:mc]];
                
                if (i < [node.children count] - 1) {
                    [tmpResult appendFormat:@","];
                }
            }
            
            //Add suffix
            [tmpResult appendFormat:@"已经归位。"];
            
            result = [NSString stringWithString:tmpResult];
        }
            break;
        case Check:
        {
            NSMutableString *tmpResult = [NSMutableString stringWithCapacity:24];
            ColorCombinationType targetCubie;
            for (MCTreeNode *subPattern in node.children) {
                switch (subPattern.value) {
                    case At:
                    {
                        Point3i targetPosition;
                        
                        //First child node - target cubie
                        MCTreeNode *child = [subPattern.children objectAtIndex:0];
                        //The target value varies by type of child
                        if (child.type == ElementNode) {
                            targetCubie = (ColorCombinationType)[child value];
                        }
                        else if (child.type == InformationNode){
                            targetCubie = (ColorCombinationType)[child result];
                        }
                        
                        //Second child node - target position
                        child = [subPattern.children objectAtIndex:1];
                        //The target value varies by type of child
                        if (child.type == ElementNode) {
                            targetPosition.x = [child value]%3-1;
                            targetPosition.y = [child value]%9/3-1;
                            targetPosition.z = [child value]/9-1;
                        }
                        else if (child.type == InformationNode){
                            targetPosition.x = [child result]%3-1;
                            targetPosition.y = [child result]%9/3-1;
                            targetPosition.z = [child result]/9-1;
                        }
                        
                        [tmpResult appendFormat:@"%@在%@",
                                     [MCTransformUtil getConcreteDescriptionOfCubie:targetCubie fromMgaicCube:mc],
                                     [MCTransformUtil getPositionDescription:targetPosition]];
                        
                        result = [NSString stringWithString:tmpResult];
                    }
                        break;
                    case ColorBindOrientation:
                    {
                        FaceOrientationType targetOrientation;
                        FaceColorType targetColor;
                        
                        //First child node - target cubie
                        MCTreeNode *child = [subPattern.children objectAtIndex:0];
                        if (child.type == ElementNode) {
                            targetOrientation = (FaceOrientationType)[child value];
                        }
                        else if (child.type == InformationNode){
                            targetOrientation = (FaceOrientationType)[child result];
                        }
                        
                        //Second child node - target position
                        child = [subPattern.children objectAtIndex:1];
                        //The target value varies by type of child
                        if (child.type == ElementNode) {
                            targetColor = (FaceColorType)[child value];
                        }
                        else if (child.type == InformationNode){
                            targetColor = (FaceColorType)[child result];
                        }
                        
                        //If need, add conjunction
                        if ([subPattern.children count] > 2) {
                            ColorCombinationType targetCubieIdentity = (ColorCombinationType)[(MCTreeNode *)[subPattern.children objectAtIndex:2] value];
                            [tmpResult appendFormat:@"%@%@色面朝%@",
                             [MCTransformUtil getConcreteDescriptionOfCubie:targetCubieIdentity fromMgaicCube:mc],
                             [MCTransformUtil getDescriptionOfFaceColorType:targetColor accordingToMagicCube:mc],
                             [MCTransformUtil getDescriptionOfFaceOrientationType:targetOrientation]];
                        }
                        else{
                            [tmpResult appendFormat:@"且%@色面朝%@",
                                [MCTransformUtil getDescriptionOfFaceColorType:targetColor accordingToMagicCube:mc],
                                [MCTransformUtil getDescriptionOfFaceOrientationType:targetOrientation]];
                            
                        }
                        
                        result = [NSString stringWithString:tmpResult];;
                    }
                        break;
                    case NotAt:
                    {
                        Point3i targetPosition;
                        
                        //First child node - target cubie
                        MCTreeNode *child = [subPattern.children objectAtIndex:0];
                        //The target value varies by type of child
                        if (child.type == ElementNode) {
                            targetCubie = (ColorCombinationType)[child value];
                        }
                        else if (child.type == InformationNode){
                            targetCubie = (ColorCombinationType)[child result];
                        }
                        
                        //Second child node - target position
                        child = [subPattern.children objectAtIndex:1];
                        //The target value varies by type of child
                        if (child.type == ElementNode) {
                            targetPosition.x = [child value]%3-1;
                            targetPosition.y = [child value]%9/3-1;
                            targetPosition.z = [child value]/9-1;
                        }
                        else if (child.type == InformationNode){
                            targetPosition.x = [child result]%3-1;
                            targetPosition.y = [child result]%9/3-1;
                            targetPosition.z = [child result]/9-1;
                        }
                        
                        [tmpResult appendFormat:@"%@不在%@",
                         [MCTransformUtil getConcreteDescriptionOfCubie:targetCubie fromMgaicCube:mc],
                         [MCTransformUtil getPositionDescription:targetPosition]];
                        
                        result = [NSString stringWithString:tmpResult];
                    }
                        break;
                }
            }
        }
            break;
        case CubiedBeLocked:
        {
            
            if ([node.children count] == 0 ||
                [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                
                //Avoid no cubie locked
                if (lockedCubies[0] == nil) return nil;
                
                //Get the description of target cubie
                NSString *targetCubie = [MCTransformUtil getConcreteDescriptionOfCubie:[lockedCubies[0] identity] fromMgaicCube:mc];
                
                //If no nil, return message
                if (targetCubie != nil) {
                    result = [NSString stringWithFormat:@"锁定目标小块:%@", targetCubie];
                }
            }
            else{
                return nil;
            }
        }
            break;
        default:
            result = @"Unrecongized pattern node!!!";
            break;
    }
    return result;
}

+ (NSString *)getNegativeSentenceOfContentFromPatternNode:(MCTreeNode *)node
                                     accordingToMagicCube:(NSObject<MCMagicCubeDelegate> *)mc
                                          andLockedCubies:(NSObject<MCCubieDelegate> **)lockedCubies{
    NSString *positiveSentence = [MCTransformUtil getContenFromPatternNode:node
                                                      accordingToMagicCube:mc
                                                           andLockedCubies:lockedCubies];
    return positiveSentence == nil ? nil : [NSString stringWithFormat:@"%@ 不符合", positiveSentence];
}


+ (void)convertToTreeByExpandingNotSentence:(MCTreeNode *)node{
    //Just expand 'ExpNode' node
    if (node.type != ExpNode) return;
    
    switch (node.value) {
        //Expand 'And' or 'Or' node's children.
        case And | Or:
            for (MCTreeNode *child in node.children) {
                [MCTransformUtil convertToTreeByExpandingNotSentence:child];
            }
            break;
        //Expand 'Not' Node
        case Not:
        {
            //Get its child(only one)
            MCTreeNode *child = [node.children objectAtIndex:0];
            [child retain];
            
            //Before expanding, avoid unexpected node type.
            if (child.type != ExpNode){
                [child release];
                return;
            }
            
            //Process three occasions
            switch (child.value) {
                //Occasion @1 and @2
                case And | Or:
                {
                    //Ancestor node transfer to 'Or' or 'And' node
                    [node setValue:(child.value == And ? Or : And)];
                    
                    //break the relationship not-and or not-or
                    [node.children removeAllObjects];
                    
                    //add new ancestor node's children
                    for (MCTreeNode *andsChild in child.children) {
                        //Construct new 'Not' node.
                        MCTreeNode *newChild = [[MCTreeNode alloc] initNodeWithType:ExpNode];
                        [newChild setValue:Not];
                        
                        [newChild.children addObject:andsChild];
                        //Attach the new node to ancestor node.
                        [node.children addObject:newChild];
                        
                        //count--
                        [newChild release];
                    }
                    break;
                }
                //Occasion @3
                case Not:
                {
                    //Get the node's grandchild
                    MCTreeNode *grandChild = [child.children objectAtIndex:0];
                    [grandChild retain];
                    
                    //Eliminate not-not
                    [node setType:grandChild.type];
                    [node setValue:grandChild.value];
                    [node setChildren:grandChild.children];
                    
                    //Release the hold of grandchild object
                    [grandChild release];
                    
                }
                    break;
                default:
                    break;
            }
            
            //Release the hold of child object
            [child release];
            
            //Deeper Expanding
            [MCTransformUtil convertToTreeByExpandingNotSentence:node];
        }
        default:
            break;
    }
}


+ (NSString *)getConcreteDescriptionOfCubie:(ColorCombinationType)identity fromMgaicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    //Check bounds
    if (identity >= ColorCombinationTypeBound || identity < 0) return @"";
    
    //Cubie description length
    const NSInteger cubieDescriptionLength = 12;
    
    //Description result
    NSMutableString *result = [NSMutableString stringWithCapacity:cubieDescriptionLength];
    
    //Get the target cubie by identity(retain once) and skin colors
    NSArray *faceColors = [[[[mc cubieWithColorCombination:identity] getCubieColorInOrientationsWithoutNoColor] allValues] retain];
    
    //Transfer face color type to real color
    for (NSNumber *faceColor in faceColors) {
        [result appendString:[MCTransformUtil getDescriptionOfFaceColorType:(FaceColorType)[faceColor integerValue]
                                                       accordingToMagicCube:mc]];
    }
    
    //Append suffix
    switch ([faceColors count]) {
        case 1:
            [result appendString:@"色中心块"];
            break;
        case 2:
            [result appendString:@"色棱块"];
            break;
        case 3:
            [result appendString:@"色角块"];
            break;
    }
    
    
    //release once
    [faceColors release];
    
    return result;
}


+ (NSString *)getPositionDescription:(Point3i)position{
    switch (position.z) {
        case 1:
            switch (position.y) {
                case 1:
                    switch (position.x) {
                        case 1:
                            return @"前右上角";
                        case 0:
                            return @"前上方";
                        case -1:
                            return @"前左上角";
                    }
                    break;
                case 0:
                    switch (position.x) {
                        case 1:
                            return @"前面右边";
                        case 0:
                            return @"前正中央";
                        case -1:
                            return @"前面左边";
                    }
                    break;
                case -1:
                    switch (position.x) {
                        case 1:
                            return @"前右下角";
                        case 0:
                            return @"前下方";
                        case -1:
                            return @"前左下角";
                    }
                    break;
                default:
                    break;
            }
            break;
        case 0:
            switch (position.y) {
                case 1:
                    switch (position.x) {
                        case 1:
                            return @"中间右上角";
                        case 0:
                            return @"顶面中心";
                        case -1:
                            return @"中间左上角";
                    }
                    break;
                case 0:
                    switch (position.x) {
                        case 1:
                            return @"右面中心";
                        case -1:
                            return @"左面中心";
                    }
                    break;
                case -1:
                    switch (position.x) {
                        case 1:
                            return @"中间右下角";
                        case 0:
                            return @"底面中心";
                        case -1:
                            return @"中间左下角";
                    }
                    break;
            }
            break;
        case -1:
            switch (position.y) {
                case 1:
                    switch (position.x) {
                        case 1:
                            return @"背面右上角";
                        case 0:
                            return @"背面上方";
                        case -1:
                            return @"背面左上角";
                    }
                    break;
                case 0:
                    switch (position.x) {
                        case 1:
                            return @"背面右边";
                        case 0:
                            return @"背面中央";
                        case -1:
                            return @"背面左边";
                    }
                    break;
                case -1:
                    switch (position.x) {
                        case 1:
                            return @"背面右下角";
                        case 0:
                            return @"背面下方";
                        case -1:
                            return @"背面左下角";
                    }
                    break;
            }
            break;
    }
    return @"";
}

//Internal method
//FaceColorType to real color string(Chinese)
+ (NSString *)getDescriptionOfFaceColorType:(FaceColorType)faceColor
                       accordingToMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    NSString *realColor = [mc getRealColor:faceColor];
    if ([realColor compare:@"Yellow"] == NSOrderedSame) {
        return @"黄";
    }
    else if ([realColor compare:@"White"] == NSOrderedSame){
        return @"白";
    }
    else if ([realColor compare:@"Red"] == NSOrderedSame){
        return @"红";
    }
    else if ([realColor compare:@"Orange"] == NSOrderedSame){
        return @"橙";
    }
    else if ([realColor compare:@"Blue"] == NSOrderedSame){
        return @"蓝";
    }
    else if ([realColor compare:@"Green"] == NSOrderedSame){
        return @"绿";
    }
    else{
        return @"";
    }
}

+ (NSString *)getDescriptionOfFaceOrientationType:(FaceOrientationType)orientation{
    switch (orientation) {
        case Up:
            return @"上";
        case Down:
            return @"下";
        case Front:
            return @"前";
        case Back:
            return @"后";
        case Left:
            return @"左";
        case Right:
            return @"右";
        default:
            return @"";
    }
}

@end
