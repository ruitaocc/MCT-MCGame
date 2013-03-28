//
//  RCCube.m
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCCubie.h"
#import <math.h>
#import "MCTransformUtil.h"

#define kCoordinateXKey @"CoordinateX"
#define kCoordinateYKey @"CoordinateY"
#define kCoordinateZKey @"CoordinateZ"
#define kSkinNumKey @"SkinNum"
#define kTypeKey @"Type"
#define kIdentityKey @"Identity"
#define kSingleColorKeyFormat @"Color%d"
#define kSingleOrientationKeyFormat @"Orientation%d"

@implementation MCCubie

@synthesize coordinateValue;
@synthesize skinNum;
@synthesize type;
@synthesize identity;
@synthesize faceColors;
@synthesize orientations;

- (id)initRightCubeWithCoordinate:(struct Point3i)value{
    if(self = [self init]){
        //before initiating, clear data
        [self clearData];
        //detect the skin number and the cube type
        coordinateValue = value;
        skinNum = abs(coordinateValue.x) + abs(coordinateValue.y) + abs(coordinateValue.z);
        switch (skinNum) {
            case 1:
                type = CentralCubie;
                break;
            case 2:
                type = EdgeCubie;
                break;
            case 3:
                type = CornerCubie;
                break;
            default:
                break;
        }
        //allocate memory for the skin
        faceColors = (FaceColorType*)malloc(skinNum * sizeof(FaceColorType));
        orientations = (FaceOrientationType*)malloc(skinNum * sizeof(FaceOrientationType));
        //intial the skin data
        int currentIndex = 0;
        switch (coordinateValue.x) {
            case -1:
                faceColors[currentIndex] = LeftColor;
                orientations[currentIndex] = Left;
                currentIndex++;
                break;
            case 0:
                break;
            case 1:
                faceColors[currentIndex] = RightColor;
                orientations[currentIndex] = Right;
                currentIndex++;
                break;
            default:
                break;
        }
        switch (coordinateValue.y) {
            case -1:
                faceColors[currentIndex] = DownColor;
                orientations[currentIndex] = Down;
                currentIndex++;
                break;
            case 0:
                break;
            case 1:
                faceColors[currentIndex] = UpColor;
                orientations[currentIndex] = Up;
                currentIndex++;
                break;
            default:
                break;
        }
        switch (coordinateValue.z) {
            case -1:
                faceColors[currentIndex] = BackColor;
                orientations[currentIndex] = Back;
                currentIndex++;
                break;
            case 0:
                break;
            case 1:
                faceColors[currentIndex] = FrontColor;
                orientations[currentIndex] = Front;
                currentIndex++;
                break;
            default:
                break;
        }
        //assign the identity
        identity = coordinateValue.x + coordinateValue.y*3 + coordinateValue.z*9 + 13;
    }
    return self;
}   //initial the cube's data by coordinate value

- (id)redefinedWithCoordinate:(struct Point3i)value orderedColors:(NSArray *)colors orderedOrientations:(NSArray *)ors{
    if(self = [self init]){
        //before initiating, clear data
        [self clearData];
        //detect the skin number and the cube type
        self.coordinateValue = value;
        self.skinNum = [colors count];
        switch (skinNum) {
            case 1:
                type = CentralCubie;
                break;
            case 2:
                type = EdgeCubie;
                break;
            case 3:
                type = CornerCubie;
                break;
            default:
                break;
        }
        //allocate memory for the skin
        self.faceColors = (FaceColorType*)malloc(skinNum * sizeof(FaceColorType));
        self.orientations = (FaceOrientationType*)malloc(skinNum * sizeof(FaceOrientationType));
        for (int i = 0; i < self.skinNum; i++) {
            self.faceColors[i] = [[colors objectAtIndex:i] integerValue];
            self.orientations[i] = [[ors objectAtIndex:i] integerValue];
            switch (self.faceColors[i]) {
                case UpColor:
                    identity += 3;
                    break;
                case DownColor:
                    identity -= 3;
                    break;
                case FrontColor:
                    identity += 9;
                    break;
                case BackColor:
                    identity -= 9;
                    break;
                case LeftColor:
                    identity -= 1;
                    break;
                case RightColor:
                    identity += 1;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (void) dealloc{
    free(faceColors);
    free(orientations);
    [super dealloc];
}

- (void) shiftOnAxis : (AxisType)axis inDirection: (LayerRotationDirectionType)direction{
    int temp;
    FaceOrientationType faceOrientation;
    //switch coordinate and face data
    switch (axis) {
        case X:
            if(CW == direction)
            {
                //coordinate change when shift on X axis in CW
                temp = -coordinateValue.y;
                coordinateValue.y = coordinateValue.z;
                coordinateValue.z = temp;
                //skin data change when shift on X axis in CW
                for(int i = 0; i < skinNum; i++){
                    faceOrientation = orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            orientations[i] = Up;
                            break;
                        case Up:
                            orientations[i] = Back;
                            break;
                        case Back:
                            orientations[i] = Down;
                            break;
                        case Down:
                            orientations[i] = Front;
                            break;
                        default:
                            break;
                    }
                }
            }
            else
            {
                //coordinate change when shift on X axis in CCW
                temp = -coordinateValue.z;
                coordinateValue.z = coordinateValue.y;
                coordinateValue.y = temp;
                //skin data change when shift on X axis in CCW
                for(int i = 0; i < skinNum; i++){
                    faceOrientation = orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            orientations[i] = Down;
                            break;
                        case Up:
                            orientations[i] = Front;
                            break;
                        case Back:
                            orientations[i] = Up;
                            break;
                        case Down:
                            orientations[i] = Back;
                            break;
                        default:
                            break;
                    }
                }
            }
            break;
        case Y:
            if(CW == direction)
            {
                //coordinate change when shift on Y axis in CW
                temp = -coordinateValue.z;
                coordinateValue.z = coordinateValue.x;
                coordinateValue.x = temp;
                //skin data change when shift on Y axis in CW
                for(int i = 0; i < skinNum; i++){
                    faceOrientation = orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            orientations[i] = Left;
                            break;
                        case Left:
                            orientations[i] = Back;
                            break;
                        case Back:
                            orientations[i] = Right;
                            break;
                        case Right:
                            orientations[i] = Front;
                            break;
                        default:
                            break;
                    }
                }
            }
            else
            {
                //coordinate change when shift on Y axis in CCW
                temp = -coordinateValue.x;
                coordinateValue.x = coordinateValue.z;
                coordinateValue.z = temp;
                //skin data change when shift on Y axis in CCW
                for(int i = 0; i < skinNum; i++){
                    faceOrientation = orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            orientations[i] = Right;
                            break;
                        case Left:
                            orientations[i] = Front;
                            break;
                        case Back:
                            orientations[i] = Left;
                            break;
                        case Right:
                            orientations[i] = Back;
                            break;
                        default:
                            break;
                    }
                }
            }
            
            break;
        case Z:
            if(CW == direction)
            {
                //coordinate change when shift on Z axis in CW
                temp = -coordinateValue.x;
                coordinateValue.x = coordinateValue.y;
                coordinateValue.y = temp;
                //skin data change when shift on Z axis in CW
                for(int i = 0; i < skinNum; i++){
                    faceOrientation = orientations[i];
                    switch (faceOrientation) {
                        case Up:
                            orientations[i] = Right;
                            break;
                        case Right:
                            orientations[i] = Down;
                            break;
                        case Down:
                            orientations[i] = Left;
                            break;
                        case Left:
                            orientations[i] = Up;
                            break;
                        default:
                            break;
                    }
                }
            }
            else
            {
                //coordinate change when shift on Z axis in CCW
                temp = -coordinateValue.y;
                coordinateValue.y = coordinateValue.x;
                coordinateValue.x = temp;
                //skin data change when shift on Z axis in CCW
                for(int i = 0; i < skinNum; i++){
                    faceOrientation = orientations[i];
                    switch (faceOrientation) {
                        case Up:
                            orientations[i] = Left;
                            break;
                        case Right:
                            orientations[i] = Up;
                            break;
                        case Down:
                            orientations[i] = Right;
                            break;
                        case Left:
                            orientations[i] = Down;
                            break;
                        default:
                            break;
                    }
                }
            }
            break;
        default:
            break;
    }
}   //shift the cube‘s data

- (FaceColorType) faceColorInOrientation: (FaceOrientationType)orientation{
    int i;
    for (i = 0; i < skinNum; i++) {
        if (orientation == orientations[i]) {
            return faceColors[i];
        }
    }
    return NoColor;
}   //get the faceColor in specified orientation

//return wheather the face color on the specified orientation is the specified color
- (BOOL)isFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation{
    int i;
    for (i = 0; i < skinNum; i++) {
        if (orientation == orientations[i]) {
            return faceColors[i] == color;
        }
    }
    return NO;
}

//clear all data, ready for re-initiate
- (void)clearData{
    coordinateValue.x = 0;
    coordinateValue.y = 0;
    coordinateValue.z = 0;
    [self setSkinNum:0];
    [self setType:NoType];
    [self setIdentity:CenterBlank];
    free(faceColors);
    free(orientations);
}

//encode the object
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:coordinateValue.x forKey:kCoordinateXKey];
    [aCoder encodeInteger:coordinateValue.y forKey:kCoordinateYKey];
    [aCoder encodeInteger:coordinateValue.z forKey:kCoordinateZKey];
    [aCoder encodeInteger:skinNum forKey:kSkinNumKey];
    [aCoder encodeInteger:type forKey:kTypeKey];
    [aCoder encodeInteger:identity forKey:kIdentityKey];
    for (int i = 0; i < skinNum; i++) {
        [aCoder encodeInteger:faceColors[i] forKey:[NSString stringWithFormat:kSingleColorKeyFormat, i]];
        [aCoder encodeInteger:orientations[i] forKey:[NSString stringWithFormat:kSingleOrientationKeyFormat, i]];
    }
}

//decode the object
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        coordinateValue.x = [aDecoder decodeIntegerForKey:kCoordinateXKey];
        coordinateValue.y = [aDecoder decodeIntegerForKey:kCoordinateYKey];
        coordinateValue.z = [aDecoder decodeIntegerForKey:kCoordinateZKey];
        self.skinNum = [aDecoder decodeIntegerForKey:kSkinNumKey];
        self.type = [aDecoder decodeIntegerForKey:kTypeKey];
        self.identity = [aDecoder decodeIntegerForKey:kIdentityKey];
        //alloc memory
        faceColors = (FaceColorType*)malloc(skinNum * sizeof(FaceColorType));
        orientations = (FaceOrientationType*)malloc(skinNum * sizeof(FaceOrientationType));
        for (int i = 0; i < skinNum; i++) {
            self.faceColors[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:kSingleColorKeyFormat, i]];
            self.orientations[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:kSingleOrientationKeyFormat, i]];
        }
    }
    return self;
}


- (NSDictionary *)getCubieColorOfEveryOrientation{
    NSMutableDictionary *state = [NSMutableDictionary dictionaryWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        [state setObject:[NSNumber numberWithInteger:NoColor] forKey:[NSNumber numberWithInteger:i]];
    }
    for (int i = 0; i < skinNum; i++) {
        [state setObject:[NSNumber numberWithInteger:faceColors[i]] forKey:[NSNumber numberWithInteger:orientations[i]]];
    }
    return [NSDictionary dictionaryWithDictionary:state];
}

- (NSDictionary *)getCubieOrientationOfAxis{
    NSMutableDictionary *state = [NSMutableDictionary dictionaryWithCapacity:3];
    for (int i = 0; i < skinNum; i++) {
        switch (faceColors[i]) {
            case UpColor:
                [state setObject:[NSNumber numberWithInteger:orientations[i]] forKey:[NSNumber numberWithInteger:Y]];
                break;
            case DownColor:
                [state setObject:[NSNumber numberWithInteger:[MCTransformUtil getContraryOrientation:orientations[i]]] forKey:[NSNumber numberWithInteger:Y]];
                break;
            case FrontColor:
                [state setObject:[NSNumber numberWithInteger:orientations[i]] forKey:[NSNumber numberWithInteger:Z]];
                break;
            case BackColor:
                [state setObject:[NSNumber numberWithInteger:[MCTransformUtil getContraryOrientation:orientations[i]]] forKey:[NSNumber numberWithInteger:Z]];
                break;
            case LeftColor:
                [state setObject:[NSNumber numberWithInteger:[MCTransformUtil getContraryOrientation:orientations[i]]] forKey:[NSNumber numberWithInteger:X]];
                break;
            case RightColor:
                [state setObject:[NSNumber numberWithInteger:orientations[i]] forKey:[NSNumber numberWithInteger:X]];
                break;
            default:
                break;
        }
        
    }
    return [NSDictionary dictionaryWithDictionary:state];
}




@end
