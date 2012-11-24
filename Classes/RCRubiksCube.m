//
//  RCRubiksCube.m
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "RCRubiksCube.h"

@implementation RCRubiksCube{
    RCCube *rubiksCubePtr[3][3][3];
    RCCube *rubiksCube[27];
}


- (id) init{
    if (self = [super init]) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    if (x != 1 || y != 1 || z != 1) {
                        struct Point3i coordinateValue = {.x = x-1, .y = y-1, .z = z-1};
                        rubiksCubePtr[x][y][z] = [[RCCube alloc] initWithCoordinateValue:coordinateValue];
                        rubiksCube[x+y*3+z*9] = rubiksCubePtr[x][y][z];
                    }
                }
            }
        }
    }
    return self;
}   //initial the rubik's cube

- (void) dealloc{
    for (int i = 0; i < 27; i++) {
        [rubiksCube[i] release];
    }
    [super dealloc];
}

- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction{
    RCCube *layerCubes[9];
    switch (axis) {
        case X:
            //change data
            for(int y = 0; y < 3; ++y)
            {
                for(int z = 0; z < 3; ++z)
                {
                    [rubiksCubePtr[layer][y][z] shiftOnAxis:axis inDirection:direction];
                    layerCubes[z+y*3] = rubiksCubePtr[layer][y][z];
                }
            }
            //refresh pointer
            for(int index = 0; index < 9; ++index)
            {
                struct Point3i value = layerCubes[index].coordinateValue;
                rubiksCubePtr[value.x][value.y][value.z] = layerCubes[index];
            }
            break;
        case Y:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int z = 0; z < 3; ++z)
                {
                    [rubiksCubePtr[x][layer][z] shiftOnAxis:axis inDirection:direction];
                    layerCubes[z+x*3] = rubiksCubePtr[x][layer][z];
                }
            }
            //refresh pointer
            for(int index = 0; index < 9; ++index)
            {
                struct Point3i value = layerCubes[index].coordinateValue;
                rubiksCubePtr[value.x][value.y][value.z] = layerCubes[index];
            }
            break;
        case Z:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int y = 0; y < 3; ++y)
                {
                    [rubiksCubePtr[x][y][layer] shiftOnAxis:axis inDirection:direction];
                    layerCubes[y+x*3] = rubiksCubePtr[x][y][layer];
                }
            }
            //refresh pointer
            for(int index = 0; index < 9; ++index)
            {
                struct Point3i value = layerCubes[index].coordinateValue;
                rubiksCubePtr[value.x][value.y][value.z] = layerCubes[index];
            }
            break;
        default:
            break;
    }
}   //rotate operation

- (struct Point3i) coordinateValueOfCubeWithColorCombination : (ColorCombinationType)combination{
    return rubiksCube[combination].coordinateValue;
}   //get coordinate of cube having the color combination


@end
