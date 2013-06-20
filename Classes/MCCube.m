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
#import "MCCubieColorConstraintUtil.h"

#define kCoordinateXKey @"CoordinateX"
#define kCoordinateYKey @"CoordinateY"
#define kCoordinateZKey @"CoordinateZ"
#define kSkinNumKey @"SkinNum"
#define kTypeKey @"Type"
#define kCompleteFaceNum @"CompleteNum"
#define kIdentityKey @"Identity"
#define kSingleColorKeyFormat @"Color%d"
#define kSingleOrientationKeyFormat @"Orientation%d"

@implementation MCCubie{
    NSInteger _completeFaceNum;
}

@synthesize coordinateValue;
@synthesize skinNum = _skinNum;
@synthesize type = _type;
@synthesize identity = _identity;
@synthesize faceColors = _faceColors;
@synthesize orientations = _orientations;

//initial the cube's data by orignal coordinate value
- (id)initRightCubeWithCoordinate:(struct Point3i)value{
    if(self = [self init]){
        // Before initiating, clear data
        [self clearData];
        // Detect the skin number and the cube type
        coordinateValue = value;
        _skinNum = abs(coordinateValue.x) + abs(coordinateValue.y) + abs(coordinateValue.z);
        switch (_skinNum) {
            case 1:
                _type = CentralCubie;
                break;
            case 2:
                _type = EdgeCubie;
                break;
            case 3:
                _type = CornerCubie;
                break;
            default:
                break;
        }
        
        // All face will be filled.
        _completeFaceNum = _skinNum;
        
        //allocate memory for the skin
        _faceColors = (FaceColorType*)malloc(_skinNum * sizeof(FaceColorType));
        _orientations = (FaceOrientationType*)malloc(_skinNum * sizeof(FaceOrientationType));
        //intial the skin data
        int currentIndex = 0;
        switch (coordinateValue.x) {
            case -1:
                _faceColors[currentIndex] = LeftColor;
                _orientations[currentIndex] = Left;
                currentIndex++;
                break;
            case 0:
                break;
            case 1:
                _faceColors[currentIndex] = RightColor;
                _orientations[currentIndex] = Right;
                currentIndex++;
                break;
            default:
                break;
        }
        switch (coordinateValue.y) {
            case -1:
                _faceColors[currentIndex] = DownColor;
                _orientations[currentIndex] = Down;
                currentIndex++;
                break;
            case 0:
                break;
            case 1:
                _faceColors[currentIndex] = UpColor;
                _orientations[currentIndex] = Up;
                currentIndex++;
                break;
            default:
                break;
        }
        switch (coordinateValue.z) {
            case -1:
                _faceColors[currentIndex] = BackColor;
                _orientations[currentIndex] = Back;
                currentIndex++;
                break;
            case 0:
                break;
            case 1:
                _faceColors[currentIndex] = FrontColor;
                _orientations[currentIndex] = Front;
                currentIndex++;
                break;
            default:
                break;
        }
        //assign the identity
        _identity = (ColorCombinationType)(coordinateValue.x + coordinateValue.y*3 + coordinateValue.z*9 + 13);
    }
    return self;
}   

- (id)redefinedWithCoordinate:(struct Point3i)value orderedColors:(NSArray *)colors orderedOrientations:(NSArray *)ors{
    if([self init]){
        
        //before initiating, clear data
        [self clearData];
        //detect the skin number and the cube type
        self.coordinateValue = value;
        self.skinNum = [colors count];
        switch (_skinNum) {
            case 1:
                _type = CentralCubie;
                break;
            case 2:
                _type = EdgeCubie;
                break;
            case 3:
                _type = CornerCubie;
                break;
            default:
                break;
        }
        
        // All face will be filled.
        _completeFaceNum = _skinNum;
        
        //allocate memory for the skin
        self.faceColors = (FaceColorType*)malloc(_skinNum * sizeof(FaceColorType));
        self.orientations = (FaceOrientationType*)malloc(_skinNum * sizeof(FaceOrientationType));
        int tmpIdentity = _identity;
        for (int i = 0; i < self.skinNum; i++) {
            self.faceColors[i] = (FaceColorType)[[colors objectAtIndex:i] integerValue];
            self.orientations[i] = (FaceOrientationType)[[ors objectAtIndex:i] integerValue];
            switch (self.faceColors[i]) {
                case UpColor:
                    tmpIdentity += 3;
                    break;
                case DownColor:
                    tmpIdentity -= 3;
                    break;
                case FrontColor:
                    tmpIdentity += 9;
                    break;
                case BackColor:
                    tmpIdentity -= 9;
                    break;
                case LeftColor:
                    tmpIdentity -= 1;
                    break;
                case RightColor:
                    tmpIdentity += 1;
                    break;
                default:
                    break;
            }
        }
        _identity = (ColorCombinationType)tmpIdentity;
    }
    return self;
}

- (id)initOnlyCenterColor:(struct Point3i)value{
    if(self = [self init]){
        //before initiating, clear data
        [self clearData];
        
        //detect the skin number and the cube type
        coordinateValue = value;
        _skinNum = abs(coordinateValue.x) + abs(coordinateValue.y) + abs(coordinateValue.z);
        switch (_skinNum) {
            case 1:
                _type = CentralCubie;
                break;
            case 2:
                _type = EdgeCubie;
                break;
            case 3:
                _type = CornerCubie;
                break;
            default:
                break;
        }
        //allocate memory for the skin
        _faceColors = (FaceColorType*)malloc(_skinNum * sizeof(FaceColorType));
        _orientations = (FaceOrientationType*)malloc(_skinNum * sizeof(FaceOrientationType));
        
        //intial the skin data
        if (_type == CentralCubie) {
            _identity = (ColorCombinationType)(coordinateValue.x + coordinateValue.y*3 + coordinateValue.z*9 + 13);
            
            // The only one face will be filled.
            _completeFaceNum = _skinNum;
            
            int currentIndex = 0;
            switch (coordinateValue.x) {
                case -1:
                    _faceColors[currentIndex] = LeftColor;
                    _orientations[currentIndex] = Left;
                    currentIndex++;
                    break;
                case 0:
                    break;
                case 1:
                    _faceColors[currentIndex] = RightColor;
                    _orientations[currentIndex] = Right;
                    currentIndex++;
                    break;
                default:
                    break;
            }
            switch (coordinateValue.y) {
                case -1:
                    _faceColors[currentIndex] = DownColor;
                    _orientations[currentIndex] = Down;
                    currentIndex++;
                    break;
                case 0:
                    break;
                case 1:
                    _faceColors[currentIndex] = UpColor;
                    _orientations[currentIndex] = Up;
                    currentIndex++;
                    break;
                default:
                    break;
            }
            switch (coordinateValue.z) {
                case -1:
                    _faceColors[currentIndex] = BackColor;
                    _orientations[currentIndex] = Back;
                    currentIndex++;
                    break;
                case 0:
                    break;
                case 1:
                    _faceColors[currentIndex] = FrontColor;
                    _orientations[currentIndex] = Front;
                    currentIndex++;
                    break;
                default:
                    break;
            }
        }
        else{
            _identity = CenterBlank;
            // No face will be filled.
            _completeFaceNum = 0;
            
            int currentIndex = 0;
            switch (coordinateValue.x) {
                case -1:
                    _faceColors[currentIndex] = NoColor;
                    _orientations[currentIndex] = Left;
                    currentIndex++;
                    break;
                case 0:
                    break;
                case 1:
                    _faceColors[currentIndex] = NoColor;
                    _orientations[currentIndex] = Right;
                    currentIndex++;
                    break;
                default:
                    break;
            }
            switch (coordinateValue.y) {
                case -1:
                    _faceColors[currentIndex] = NoColor;
                    _orientations[currentIndex] = Down;
                    currentIndex++;
                    break;
                case 0:
                    break;
                case 1:
                    _faceColors[currentIndex] = NoColor;
                    _orientations[currentIndex] = Up;
                    currentIndex++;
                    break;
                default:
                    break;
            }
            switch (coordinateValue.z) {
                case -1:
                    _faceColors[currentIndex] = NoColor;
                    _orientations[currentIndex] = Back;
                    currentIndex++;
                    break;
                case 0:
                    break;
                case 1:
                    _faceColors[currentIndex] = NoColor;
                    _orientations[currentIndex] = Front;
                    currentIndex++;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}


- (void) dealloc{
    free(_faceColors);
    free(_orientations);
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
                for(int i = 0; i < _skinNum; i++){
                    faceOrientation = _orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            _orientations[i] = Up;
                            break;
                        case Up:
                            _orientations[i] = Back;
                            break;
                        case Back:
                            _orientations[i] = Down;
                            break;
                        case Down:
                            _orientations[i] = Front;
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
                for(int i = 0; i < _skinNum; i++){
                    faceOrientation = _orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            _orientations[i] = Down;
                            break;
                        case Up:
                            _orientations[i] = Front;
                            break;
                        case Back:
                            _orientations[i] = Up;
                            break;
                        case Down:
                            _orientations[i] = Back;
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
                for(int i = 0; i < _skinNum; i++){
                    faceOrientation = _orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            _orientations[i] = Left;
                            break;
                        case Left:
                            _orientations[i] = Back;
                            break;
                        case Back:
                            _orientations[i] = Right;
                            break;
                        case Right:
                            _orientations[i] = Front;
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
                for(int i = 0; i < _skinNum; i++){
                    faceOrientation = _orientations[i];
                    switch (faceOrientation) {
                        case Front:
                            _orientations[i] = Right;
                            break;
                        case Left:
                            _orientations[i] = Front;
                            break;
                        case Back:
                            _orientations[i] = Left;
                            break;
                        case Right:
                            _orientations[i] = Back;
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
                for(int i = 0; i < _skinNum; i++){
                    faceOrientation = _orientations[i];
                    switch (faceOrientation) {
                        case Up:
                            _orientations[i] = Right;
                            break;
                        case Right:
                            _orientations[i] = Down;
                            break;
                        case Down:
                            _orientations[i] = Left;
                            break;
                        case Left:
                            _orientations[i] = Up;
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
                for(int i = 0; i < _skinNum; i++){
                    faceOrientation = _orientations[i];
                    switch (faceOrientation) {
                        case Up:
                            _orientations[i] = Left;
                            break;
                        case Right:
                            _orientations[i] = Up;
                            break;
                        case Down:
                            _orientations[i] = Right;
                            break;
                        case Left:
                            _orientations[i] = Down;
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
    for (i = 0; i < _skinNum; i++) {
        if (orientation == _orientations[i]) {
            return _faceColors[i];
        }
    }
    return NoColor;
}   //get the faceColor in specified orientation

//return wheather the face color on the specified orientation is the specified color
- (BOOL)isFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation{
    int i;
    for (i = 0; i < _skinNum; i++) {
        if (orientation == _orientations[i]) {
            return _faceColors[i] == color;
        }
    }
    return NO;
}


// Set the face color on the specified orientation.
// If the cubie has face on this orientation, set the color.
// Otherwise, return NO.
- (BOOL)setFaceColor:(FaceColorType)color inOrientation:(FaceOrientationType)orientation{
    int i;
    for (i = 0; i < _skinNum; i++) {
        if (orientation == _orientations[i]) {
            // Update identity
            switch (_faceColors[i]) {
                case UpColor:
                    _identity = (ColorCombinationType)((int)_identity - 3);
                    break;
                case DownColor:
                    _identity = (ColorCombinationType)((int)_identity + 3);
                    break;
                case FrontColor:
                    _identity = (ColorCombinationType)((int)_identity - 9);
                    break;
                case BackColor:
                    _identity = (ColorCombinationType)((int)_identity + 9);
                    break;
                case LeftColor:
                    _identity = (ColorCombinationType)((int)_identity + 1);
                    break;
                case RightColor:
                    _identity = (ColorCombinationType)((int)_identity - 1);
                    break;
                default:
                    // NO-ANY increasement.
                    _completeFaceNum++;
                    break;
            }
            
            switch (color) {
                case UpColor:
                    _identity = (ColorCombinationType)((int)_identity + 3);
                    break;
                case DownColor:
                    _identity = (ColorCombinationType)((int)_identity - 3);
                    break;
                case FrontColor:
                    _identity = (ColorCombinationType)((int)_identity + 9);
                    break;
                case BackColor:
                    _identity = (ColorCombinationType)((int)_identity - 9);
                    break;
                case LeftColor:
                    _identity = (ColorCombinationType)((int)_identity - 1);
                    break;
                case RightColor:
                    _identity = (ColorCombinationType)((int)_identity + 1);
                    break;
                default:
                    // Avoid NO-NO increasement.
                    // And NO-YES will increase.
                    _completeFaceNum--;
                    break;
            }
            
            // Assign face color
            _faceColors[i] = color;
            
            if (_completeFaceNum == 2 && _type == CornerCubie) {
                int i;
                for (i = 0; i < _skinNum; i++) {
                    if (_faceColors[i] == NoColor) {
                        break;
                    }
                }
                [MCCubieColorConstraintUtil fillRightFaceColorAtCubie:(NSObject<MCCubieDelegate> *)self
                                                        inOrientation:(FaceOrientationType)_orientations[i]];
            }
            
            return YES;
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
    free(_faceColors);
    free(_orientations);
}

//encode the object
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:coordinateValue.x forKey:kCoordinateXKey];
    [aCoder encodeInteger:coordinateValue.y forKey:kCoordinateYKey];
    [aCoder encodeInteger:coordinateValue.z forKey:kCoordinateZKey];
    [aCoder encodeInteger:_skinNum forKey:kSkinNumKey];
    [aCoder encodeInteger:_type forKey:kTypeKey];
    [aCoder encodeInteger:_completeFaceNum forKey:kCompleteFaceNum];
    [aCoder encodeInteger:_identity forKey:kIdentityKey];
    for (int i = 0; i < _skinNum; i++) {
        [aCoder encodeInteger:_faceColors[i] forKey:[NSString stringWithFormat:kSingleColorKeyFormat, i]];
        [aCoder encodeInteger:_orientations[i] forKey:[NSString stringWithFormat:kSingleOrientationKeyFormat, i]];
    }
}

//decode the object
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        coordinateValue.x = [aDecoder decodeIntegerForKey:kCoordinateXKey];
        coordinateValue.y = [aDecoder decodeIntegerForKey:kCoordinateYKey];
        coordinateValue.z = [aDecoder decodeIntegerForKey:kCoordinateZKey];
        _completeFaceNum = [aDecoder decodeIntegerForKey:kCompleteFaceNum];
        self.skinNum = [aDecoder decodeIntegerForKey:kSkinNumKey];
        self.type = (CubieType)[aDecoder decodeIntegerForKey:kTypeKey];
        self.identity  = (ColorCombinationType)[aDecoder decodeIntegerForKey:kIdentityKey];
        //alloc memory
        _faceColors = (FaceColorType*)malloc(_skinNum * sizeof(FaceColorType));
        _orientations = (FaceOrientationType*)malloc(_skinNum * sizeof(FaceOrientationType));
        for (int i = 0; i < _skinNum; i++) {
            self.faceColors[i] = (FaceColorType)[aDecoder decodeIntegerForKey:[NSString stringWithFormat:kSingleColorKeyFormat, i]];
            self.orientations[i] = (FaceOrientationType)[aDecoder decodeIntegerForKey:[NSString stringWithFormat:kSingleOrientationKeyFormat, i]];
        }
    }
    return self;
}

- (NSArray *)allFaceColors{
    NSMutableArray *mutableColors = [NSMutableArray arrayWithCapacity:_skinNum];
    for (int i = 0; i < _skinNum; i++) {
        [mutableColors addObject:[NSNumber numberWithInteger:_faceColors[i]]];
    }
    
    return [NSArray arrayWithArray:mutableColors];
}


- (NSArray *)allOrientations{
    NSMutableArray *mutableColors = [NSMutableArray arrayWithCapacity:_skinNum];
    for (int i = 0; i < _skinNum; i++) {
        [mutableColors addObject:[NSNumber numberWithInteger:_orientations[i]]];
    }
    
    return [NSArray arrayWithArray:mutableColors];
}


- (NSDictionary *)getCubieColorInOrientations{
    NSMutableDictionary *state = [NSMutableDictionary dictionaryWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        [state setObject:[NSNumber numberWithInteger:NoColor] forKey:[NSNumber numberWithInteger:i]];
    }
    for (int i = 0; i < _skinNum; i++) {
        [state setObject:[NSNumber numberWithInteger:_faceColors[i]] forKey:[NSNumber numberWithInteger:_orientations[i]]];
    }
    return [NSDictionary dictionaryWithDictionary:state];
}

- (NSDictionary *)getCubieOrientationOfAxis{
    NSMutableDictionary *state = [NSMutableDictionary dictionaryWithCapacity:3];
    for (int i = 0; i < _skinNum; i++) {
        switch (_faceColors[i]) {
            case UpColor:
                [state setObject:[NSNumber numberWithInteger:_orientations[i]] forKey:[NSNumber numberWithInteger:Y]];
                break;
            case DownColor:
                [state setObject:[NSNumber numberWithInteger:[MCTransformUtil getContraryOrientation:_orientations[i]]] forKey:[NSNumber numberWithInteger:Y]];
                break;
            case FrontColor:
                [state setObject:[NSNumber numberWithInteger:_orientations[i]] forKey:[NSNumber numberWithInteger:Z]];
                break;
            case BackColor:
                [state setObject:[NSNumber numberWithInteger:[MCTransformUtil getContraryOrientation:_orientations[i]]] forKey:[NSNumber numberWithInteger:Z]];
                break;
            case LeftColor:
                [state setObject:[NSNumber numberWithInteger:[MCTransformUtil getContraryOrientation:_orientations[i]]] forKey:[NSNumber numberWithInteger:X]];
                break;
            case RightColor:
                [state setObject:[NSNumber numberWithInteger:_orientations[i]] forKey:[NSNumber numberWithInteger:X]];
                break;
            default:
                break;
        }
        
    }
    return [NSDictionary dictionaryWithDictionary:state];
}


- (NSDictionary *)getCubieColorInOrientationsWithoutNoColor{
    NSMutableDictionary *state = [NSMutableDictionary dictionaryWithCapacity:self.skinNum];
    for (int i = 0; i < self.skinNum; i++) {
        [state setObject:[NSNumber numberWithInteger:self.faceColors[i]] forKey:[NSNumber numberWithInteger:self.orientations[i]]];
    }
    return [NSDictionary dictionaryWithDictionary:state];
}


- (BOOL)hasAllFacesBeenFilledWithColors{
    return _completeFaceNum == _skinNum;
}


@end
