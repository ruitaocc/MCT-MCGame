//
//  Global.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#ifndef RubiksCube_Global_h
#define RubiksCube_Global_h

//define the face color type to apart color data from model
typedef enum _FaceColorType {
    UpColor     = 0,
    DownColor   = 1,
    FrontColor  = 2,
    BackColor   = 3,
    LeftColor   = 4,
    RightColor  = 5,
    NoColor     = 6
} FaceColorType;

//define the orientation of face
typedef enum _FaceOrientationType {
    Up      = 0,
    Down    = 1,
    Front   = 2,
    Back    = 3,
    Left    = 4,
    Right   = 5
} FaceOrientationType;

//three types of cubies
typedef enum _CubieType {
    CentralCubie    = 0,
    EdgeCubie       = 1,
    CornerCubie     = 2
} CubieType;

//define the rotation direction, clockwise and anticlockwise
typedef enum _LayerRotationDirectionType {
    CW  = 0,
    CCW = 1
} LayerRotationDirectionType;

//3D coordinate axis
typedef enum _AxisType {
    X   = 0,
    Y   = 1,
    Z   = 2
} AxisType;

//name after direction in this order:front(F), back(B), left(L), right(R), up(U), down(D)
//e.g. BLD is the cube that has three colors:BACK_COLOR, LEFT_COLOR, DOWN_COLOR
typedef enum _ColorCombinationType {
    BLDColors, BDColors, BRDColors, BLColors, BColor     , BRColors, BLUColors, BUColors, BRUColors,
    LDColors , DColor  , RDColors , LColor  , CenterBlank, RColor  , LUColors , UColor  , RUColors ,
    FLDColors, FDColors, FRDColors, FLColors, FColor     , FRColors, FLUColors, FUColors, FRUColors
} ColorCombinationType;



#endif
