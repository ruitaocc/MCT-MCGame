//
//  Global.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#pragma once
#ifndef RubiksCube_Global_h
#define RubiksCube_Global_h

//the knowledge db name
#define KNOWLEDGE_DB_FILE_NAME @"KnowledgeBase.sqlite3"

struct Point3i{
    int x;
    int y;
    int z;
};



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

//The color mapping file name
#define FACE_COLOR_MAPPING_FILE_NAME @"FaceColorMapping"

//Keys for getting real color
#define KEY_UP_FACE_COLOR      @"UpColor"
#define KEY_DOWN_FACE_COLOR    @"DownColor"
#define KEY_FRONT_FACE_COLOR   @"FrontColor"
#define KEY_BACK_FACE_COLOR    @"BackColor"
#define KEY_LEFT_FACE_COLOR    @"LeftColor"
#define KEY_RIGHT_FACE_COLOR   @"RightColor"


//define the orientation of face
typedef enum _FaceOrientationType {
    Up,
    Down,
    Front,
    Back,
    Left,
    Right,
    WrongOrientation
} FaceOrientationType;

//three types of cubies
typedef enum _CubieType {
    NoType,
    CentralCubie,
    EdgeCubie,
    CornerCubie
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
    FLDColors, FDColors, FRDColors, FLColors, FColor     , FRColors, FLUColors, FUColors, FRUColors,
    ColorCombinationTypeBound
} ColorCombinationType;

//the pattern type
typedef enum _NodeType {
    ExpNode,
    ElementNode,
    PatternNode,
    ActionNode,
    InformationNode
} NodeType;

typedef enum _ExpType {
    And,
    Or,
    Sequence,
    Not
} ExpType;

//the rull action type
typedef enum _ActionType {
    Rotate,
    FaceToOrientation,
    LockCubie,
    UnlockCubie
} ActionType;

//the getting information type
typedef enum _InformationType {
    getCombinationFromOrientation = 0,
    getFaceColorFromOrientation = 1,
    lockedCubie = 2,
    getCombinationFromColor = 3
} InformationType;

//the pattern type
typedef enum _PatternType {
    Home,
    Check,
    ColorBindOrientation,
    At,
    NotAt,
    CubiedBeLocked,
} PatternTyp;

//Token tag
#define Token_And -1
#define Token_Or -2
#define Token_LeftParentheses -3
#define Token_RightParentheses -4
#define Token_Not -5
#define PLACEHOLDER -10000

//the rull action type
typedef enum _SingmasterNotation {
    F, Fi, F2,
    B, Bi, B2,
    R, Ri, R2,
    L, Li, L2,
    U, Ui, U2,
    D, Di, D2,
    x, xi, x2,
    y, yi, y2,
    z, zi, z2,
    Fw,Fwi,Fw2,
    Bw,Bwi,Bw2,
    Rw,Rwi,Rw2,
    Lw,Lwi,Lw2,
    Uw,Uwi,Uw2,
    Dw,Dwi,Dw2,
    M, Mi, M2,
    E, Ei, E2,
    S, Si, S2,
    NoneNotation
} SingmasterNotation;

//the result indicates whether the current rotation accords the required rotation
typedef enum _RotationResult{
    Accord,
    Disaccord,
    StayForATime,
    Finished,
    NoneResult
} RotationResult;


//-------------------------------------------------------------------------------------------

//It indicates that no layer was selected.
#define NO_SELECTED_LAYER -999


//-------------------------------------------------------------------------------------------

#define ETFF 0  //method 0, 8355
//every method's first and last state name
#define START_STATE @"Init"
#define END_STATE @"End"

//-------------------------------------------------------------------------------------------

//the temprorary file store the unfinished magic cube's status
#define TmpMagicCubeData @"tmpMagicCube"

//-------------------------------------------------------------------------------------------

//the keys that get actions
#define KEY_ROTATION_QUEUE @"RotationQueue"
#define KEY_TIPS @"TipsMessage"


//-------------------------------------------------------------------------------------------

//an encapsulation
struct RotationStruct {
    AxisType axis;
    int layer;
    LayerRotationDirectionType direction;
};

//-------------------------------------------------------------------------------------------

//#define ONLY_TEST

//-------------------------------------------------------------------------------------------

#define CubieCouldBeLockMaxNum 26

//-------------------------------------------------------------------------------------------

#endif
