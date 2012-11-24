//
//  RCCube.m
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "RCCube.h"
#import <math.h>


@implementation RCCube

@synthesize coordinateValue;
@synthesize skinNum;
@synthesize type;
@synthesize faceColors;
@synthesize orientations;

- (id) initWithCoordinateValue : (struct Point3i)value{
    if(self = [self init]){
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
    }
    return self;
}   //initial the cube's data by coordinate value

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

- (FaceColorType) faceColorOnDirection: (FaceOrientationType)orientation{
    int i;
    for (i = 0; i < skinNum; i++) {
        if (orientation == orientations[i]) {
            return faceColors[i];
        }
    }
    return NoColor;
}   //get the faceColor in specified orientation

@end
