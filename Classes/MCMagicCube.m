//
//  RCRubiksCube.m
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCMagicCube.h"

#define kSingleCubieKeyFormat @"Cubie%d"
#define kSingleOrientationToMagicCubeFaceKeyFormat @"OrientationToFace%d"

@implementation MCMagicCube{
    MCCubie *magicCubies3D[3][3][3];
    MCCubie *magicCubiesList[27];
    FaceOrientationType orientationToMagicCubeFace[6];
}

+ (MCMagicCube *)magicCube{
    return [[[MCMagicCube alloc] init] autorelease];
}

+ (MCMagicCube *)unarchiveMagicCubeWithFile:(NSString *)path{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (id)init{
    if (self = [super init]) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    if (x != 1 || y != 1 || z != 1) {
                        struct Point3i coordinateValue = {.x = x-1, .y = y-1, .z = z-1};
                        BOOL isReatin = NO;
                        if (magicCubies3D[x][y][z] == nil) {
                            magicCubies3D[x][y][z] = [MCCubie alloc];
                            isReatin = YES;
                        }
                        [magicCubies3D[x][y][z] initRightCubeWithCoordinate:coordinateValue];
                        magicCubiesList[x+y*3+z*9] = magicCubies3D[x][y][z];
                        if (isReatin) [magicCubiesList[x+y*3+z*9] retain];
                    }
                }
            }
        }
        for (int i  = 0; i < 6; i++) {
            //At the begining, the orientation and the magic cube face orientation is same
            orientationToMagicCubeFace[i] = (FaceOrientationType)i;
        }
    }
    return self;
}   //initial the rubik's cube

- (void)dealloc{
    for (int i = 0; i < 27; i++) {
        //release twice
        [magicCubiesList[i] release];
        [magicCubiesList[i] release];
    }
    [super dealloc];
}

- (void)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction{
    MCCubie *layerCubes[9];
    switch (axis) {
        case X:
            //change data
            for(int y = 0; y < 3; ++y)
            {
                for(int z = 0; z < 3; ++z)
                {
                    [magicCubies3D[layer][y][z] shiftOnAxis:axis inDirection:direction];
                    layerCubes[z+y*3] = magicCubies3D[layer][y][z];
                }
            }
            break;
        case Y:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int z = 0; z < 3; ++z)
                {
                    [magicCubies3D[x][layer][z] shiftOnAxis:axis inDirection:direction];
                    layerCubes[z+x*3] = magicCubies3D[x][layer][z];
                }
            }
            break;
        case Z:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int y = 0; y < 3; ++y)
                {
                    [magicCubies3D[x][y][layer] shiftOnAxis:axis inDirection:direction];
                    layerCubes[y+x*3] = magicCubies3D[x][y][layer];
                }
            }
            break;
        default:
            break;
    }
    
    //refresh pointer
    for(int index = 0; index < 9; ++index)
    {
        struct Point3i value = layerCubes[index].coordinateValue;
        magicCubies3D[value.x+1][value.y+1][value.z+1] = layerCubes[index];
    }
    
    //change magic cube face orientation
    if (layer == 1) {
        switch (axis) {
            case X:
                if (direction == CW) {
                    FaceOrientationType tmp = orientationToMagicCubeFace[Front];
                    orientationToMagicCubeFace[Front] = orientationToMagicCubeFace[Down];
                    orientationToMagicCubeFace[Down] = orientationToMagicCubeFace[Back];
                    orientationToMagicCubeFace[Back] = orientationToMagicCubeFace[Up];
                    orientationToMagicCubeFace[Up] = tmp;
                }
                else{
                    FaceOrientationType tmp = orientationToMagicCubeFace[Front];
                    orientationToMagicCubeFace[Front] = orientationToMagicCubeFace[Up];
                    orientationToMagicCubeFace[Up] = orientationToMagicCubeFace[Back];
                    orientationToMagicCubeFace[Back] = orientationToMagicCubeFace[Down];
                    orientationToMagicCubeFace[Down] = tmp;
                }
                break;
            case Y:
                if (direction == CW) {
                    FaceOrientationType tmp = orientationToMagicCubeFace[Front];
                    orientationToMagicCubeFace[Front] = orientationToMagicCubeFace[Right];
                    orientationToMagicCubeFace[Right] = orientationToMagicCubeFace[Back];
                    orientationToMagicCubeFace[Back] = orientationToMagicCubeFace[Left];
                    orientationToMagicCubeFace[Left] = tmp;
                } else {
                    FaceOrientationType tmp = orientationToMagicCubeFace[Front];
                    orientationToMagicCubeFace[Front] = orientationToMagicCubeFace[Left];
                    orientationToMagicCubeFace[Left] = orientationToMagicCubeFace[Back];
                    orientationToMagicCubeFace[Back] = orientationToMagicCubeFace[Right];
                    orientationToMagicCubeFace[Right] = tmp;
                }
                break;
            case Z:
                if (direction == CW) {
                    FaceOrientationType tmp = orientationToMagicCubeFace[Up];
                    orientationToMagicCubeFace[Up] = orientationToMagicCubeFace[Left];
                    orientationToMagicCubeFace[Left] = orientationToMagicCubeFace[Down];
                    orientationToMagicCubeFace[Down] = orientationToMagicCubeFace[Right];
                    orientationToMagicCubeFace[Right] = tmp;
                } else {
                    FaceOrientationType tmp = orientationToMagicCubeFace[Up];
                    orientationToMagicCubeFace[Up] = orientationToMagicCubeFace[Right];
                    orientationToMagicCubeFace[Right] = orientationToMagicCubeFace[Down];
                    orientationToMagicCubeFace[Down] = orientationToMagicCubeFace[Left];
                    orientationToMagicCubeFace[Left] = tmp;
                }
                break;
            default:
                break;
        }
    }
}   //rotate operation

- (void)rotateWithSingmasterNotation:(SingmasterNotation)notation{
    switch (notation) {
        case F:
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            break;
        case Fi:
            [self rotateOnAxis:Z onLayer:2 inDirection:CCW];
            break;
        case F2:
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            break;
        case B:
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            break;
        case Bi:
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            break;
        case B2:
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            break;
        case R:
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            break;
        case Ri:
            [self rotateOnAxis:X onLayer:2 inDirection:CCW];
            break;
        case R2:
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            break;
        case L:
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            break;
        case Li:
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            break;
        case L2:
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            break;
        case U:
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            break;
        case Ui:
            [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
            break;
        case U2:
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            break;
        case D:
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            break;
        case Di:
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            break;
        case D2:
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            break;
        case x:
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            break;
        case xi:
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            [self rotateOnAxis:X onLayer:2 inDirection:CCW];
            break;
        case x2:
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            break;
        case y:
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            break;
        case yi:
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
            break;
        case y2:
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            break;
        case z:
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            break;
        case zi:
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CCW];
            break;
        case z2:
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            break;
        case Fw:
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            break;
        case Fwi:
            [self rotateOnAxis:Z onLayer:2 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            break;
        case Fw2:
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            break;
        case Bw:
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            break;
        case Bwi:
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            break;
        case Bw2:
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            break;
        case Rw:
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            break;
        case Rwi:
            [self rotateOnAxis:X onLayer:2 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            break;
        case Rw2:
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            break;
        case Lw:
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            break;
        case Lwi:
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            break;
        case Lw2:
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            break;
        case Uw:
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            break;
        case Uwi:
            [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            break;
        case Uw2:
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            break;
        case Dw:
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            break;
        case Dwi:
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            break;
        case Dw2:
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            break;
        case M:
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            break;
        case Mi:
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            break;
        case M2:
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            break;
        case E:
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            break;
        case Ei:
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            break;
        case E2:
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            break;
        case S:
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            break;
        case Si:
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            break;
        case S2:
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            break;
        default:
            break;
    }
}

- (struct Point3i)coordinateValueOfCubieWithColorCombination:(ColorCombinationType)combination{
    return magicCubiesList[combination].coordinateValue;
}   //get coordinate of cube having the color combination

- (MCCubie *)cubieWithColorCombination:(ColorCombinationType)combination{
    return magicCubiesList[combination];
}

- (MCCubie *)cubieAtCoordinateX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z{
    return magicCubies3D[x+1][y+1][z+1];
}

- (MCCubie *)cubieAtCoordinatePoint3i:(struct Point3i)point{
    return magicCubies3D[point.x+1][point.y+1][point.z+1];
}

- (FaceOrientationType)magicCubeFaceInOrientation:(FaceOrientationType)orientation{
    return orientationToMagicCubeFace[orientation];
}

//encode the object
- (void)encodeWithCoder:(NSCoder *)aCoder{
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    [aCoder encodeObject:magicCubies3D[x][y][z] forKey:[NSString stringWithFormat:kSingleCubieKeyFormat, x+3*y+9*z]];
                }
            }
        }
    }
    for (int i  = 0; i < 6; i++) {
        [aCoder encodeInteger:orientationToMagicCubeFace[i] forKey:[NSString stringWithFormat:kSingleOrientationToMagicCubeFaceKeyFormat, i]];
    }
}

//decode the object
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    if (x != 1 || y != 1 || z != 1) {
                        //get the cubie object
                        magicCubies3D[x][y][z] = [aDecoder decodeObjectForKey:[NSString stringWithFormat:kSingleCubieKeyFormat, x+3*y+9*z]];
                        [magicCubies3D[x][y][z] retain];
                        //set the right pointer
                        NSInteger listIndex = magicCubies3D[x][y][z].identity;
                        magicCubiesList[listIndex] = magicCubies3D[x][y][z];
                        [magicCubiesList[listIndex] retain];
                    }
                }
            }
        }
        for (int i  = 0; i < 6; i++) {
            orientationToMagicCubeFace[i] = (FaceOrientationType)[aDecoder decodeIntegerForKey:[NSString stringWithFormat:kSingleOrientationToMagicCubeFaceKeyFormat, i]];
        }
    }
    return self;
}


- (NSArray *)getAxisStatesOfAllCubie{
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:26];
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    [states addObject:[magicCubies3D[x][y][z] getCubieOrientationOfAxis]];
                }
                else{
                    [states addObject:[NSDictionary dictionary]];
                }
            }
        }
    }
    return  [NSArray arrayWithArray:states];
}

- (NSArray *)getColorInOrientationsOfAllCubie{
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:26];
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    [states addObject:[magicCubies3D[x][y][z] getCubieColorInOrientations]];
                }
                else{
                    [states addObject:[NSDictionary dictionary]];
                }
            }
        }
    }
    return [NSArray arrayWithArray:states];
}

@end
