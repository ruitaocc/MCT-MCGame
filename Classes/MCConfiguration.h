//
//  MCConfiguration.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  this is the config file
//  it holds all the constants and other various and sundry items that
//  we need and dont want to hardcode in the code


#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

// will draw the circles around the collision radius
// for debugging
#define DEBUG_DRAW_COLLIDERS 0

// the explosive force applied to the smaller rocks after a big rock has been smashed
#define SMASH_SPEED_FACTOR 40

#define TURN_SPEED_FACTOR 3.0
#define THRUST_SPEED_FACTOR 1.2

// a handy constant to keep around
#define MCRADIANS_TO_DEGREES 57.2958

// material import settings
#define MC_CONVERT_TO_4444 0


// for particles
#define MC_MAX_PARTICLES 500

#define MC_FPS 60.0

//
#define Disaccord_Msg @"转错了哈,转回去吧^_^"
#define Accord_Msg @"接着下一步吧"
#define StayForATime_Msg @"再转一次"
#define RandomRotateMaxCount 20

//教学模式下让模型旋转对最大预知
#define MaxDistance 100

// for view transition 视图变换的key
typedef enum {
    kCountingPlay,
    kNormalPlay,
    kRandomSolve,
    kSystemSetting,
    kHeroBoard,
    kMainMenu,
    kScoreBoard2MainMenu
}ViewTransitionTag;

// for 魔方模型交互算法key
typedef enum {
    kState_None,
    kState_S1,
    kState_M1,
    kState_F1,
    kState_A1,
    kState_S2,
    kState_M2,
    kState_F2
}FSM_Interaction_State;





#pragma mark cubre mesh
static NSInteger MCCubreVertexStride = 3;
static NSInteger MCCubreColorStride = 4;
static NSInteger MCCubreOutlineVertexesCount = 36;
static CGFloat MCCubreOutlineVertexes[108] = {    
    //Define the front face
    -0.5,0.5,0.5,//left top
    -0.5,-0.5,0.5,//left buttom
    0.5,0.5,0.5,//top right
    -0.5,-0.5,0.5,//left buttom     
    0.5,-0.5,0.5,//right buttom
    0.5,0.5,0.5,//top right
    //top face
    -0.5,0.5,-0.5,//left top(at rear)
    -0.5,0.5,0.5,//left buttom(at front)
    0.5,0.5,-0.5,//top right(at rear)
    -0.5,0.5,0.5,//left buttom(at front)
    0.5,0.5,0.5,//right buttom(at front)
    0.5,0.5,-0.5,//top right(at rear)
    //rear face
    0.5,0.5,-0.5,//right top(when viewed from front)    
    0.5,-0.5,-0.5,//left top
    -0.5,0.5,-0.5,//rigtht buttom
    0.5,-0.5,-0.5,//rigtht buttom
    -0.5,-0.5,-0.5,//left top
    -0.5,0.5,-0.5,//left buttom
    //buttom face
    -0.5,-0.5,0.5,//buttom left front
    -0.5,-0.5,-0.5,//left rear
    0.5,-0.5,0.5,//rigtht buttom
    0.5,-0.5,0.5,//rigtht buttom
    -0.5,-0.5,-0.5,//left rear
    0.5,-0.5,-0.5,//right rear
    //left face
    -0.5,0.5,-0.5,// top left
    -0.5,-0.5,-0.5,//buttom left
    -0.5,0.5,0.5,// top right
    -0.5,-0.5,-0.5,//buttom left
    -0.5,-0.5,0.5,//buttom right
    -0.5,0.5,0.5,// top right
    //right face
    0.5,0.5,0.5,//top left    
    0.5,-0.5,0.5,//left
    0.5,0.5,-0.5,//top right
    0.5,-0.5,0.5,//left
    0.5,-0.5,-0.5,//right
    0.5,0.5,-0.5//top right
};

static CGFloat MCCubreColorValues[144] = 
{   1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0} ;


static NSInteger MCCubreVertexStride_line = 3;
static NSInteger MCCubreColorStride_line = 4;
static NSInteger MCCubreOutlineVertexesCount_line = 48;
static CGFloat MCCubreOutlineVertexes_line[144] = {    
    //Define the front face
    -0.5,0.5,0.5,//left top
    -0.5,-0.5,0.5,//left buttom
    
    -0.5,0.5,0.5,//left top
    0.5,0.5,0.5,//top right
    
    -0.5,-0.5,0.5,//left buttom     
    0.5,-0.5,0.5,//right buttom
    
    0.5,0.5,0.5,//top right
    0.5,-0.5,0.5,//right buttom
    
    //top face
    
    -0.5,0.5,-0.5,//left top(at rear)
    -0.5,0.5,0.5,//left buttom(at front)
    
    -0.5,0.5,-0.5,//left top(at rear)
    0.5,0.5,-0.5,//top right(at rear)
    
    -0.5,0.5,0.5,//left buttom(at front)
    0.5,0.5,0.5,//right buttom(at front)
    
    0.5,0.5,0.5,//right buttom(at front)
    0.5,0.5,-0.5,//top right(at rear)
    
    //rear face
    0.5,0.5,-0.5,//right top(when viewed from front)    
    0.5,-0.5,-0.5,//left top
    
    0.5,0.5,-0.5,//right top(when viewed from front) 
    -0.5,0.5,-0.5,//rigtht buttom
    
    0.5,-0.5,-0.5,//rigtht buttom
    -0.5,-0.5,-0.5,//left top
    
    -0.5,-0.5,-0.5,//left top
    -0.5,0.5,-0.5,//left buttom
    //buttom face
    -0.5,-0.5,0.5,//buttom left front
    -0.5,-0.5,-0.5,//left rear
    
    -0.5,-0.5,0.5,//buttom left front
    0.5,-0.5,0.5,//rigtht buttom
    
    0.5,-0.5,0.5,//rigtht buttom
    0.5,-0.5,-0.5,//left rear
    
    -0.5,-0.5,-0.5,//left rear
    0.5,-0.5,-0.5,//right rear
    //left face
    -0.5,0.5,-0.5,// top left
    -0.5,-0.5,-0.5,//buttom left
    
    -0.5,0.5,-0.5,// top left
    -0.5,0.5,0.5,// top right
    
    -0.5,-0.5,-0.5,//buttom left
    -0.5,-0.5,0.5,//buttom right
    
    -0.5,-0.5,0.5,//buttom right
    -0.5,0.5,0.5,// top right
    //right face
    0.5,0.5,0.5,//top left    
    0.5,-0.5,0.5,//left
    
    0.5,0.5,0.5,//top left    
    0.5,0.5,-0.5,//top right
    
    0.5,-0.5,0.5,//left
    0.5,-0.5,-0.5,//right
    
    0.5,-0.5,-0.5,//right
    0.5,0.5,-0.5//top right
};

static CGFloat MCCubreColorValues_line[192] = 
{   1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0} ;


