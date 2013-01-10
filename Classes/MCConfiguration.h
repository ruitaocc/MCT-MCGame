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
#define DEBUG_DRAW_COLLIDERS 1

// the explosive force applied to the smaller rocks after a big rock has been smashed
#define SMASH_SPEED_FACTOR 40

#define TURN_SPEED_FACTOR 3.0
#define THRUST_SPEED_FACTOR 1.2

// a handy constant to keep around
#define MCRADIANS_TO_DEGREES 57.2958

// material import settings
#define MC_CONVERT_TO_4444 0


// for particles
#define MC_MAX_PARTICLES 100

#define MC_FPS 30.0

// for view transition
typedef enum {
    kCountingPlay,
    kNormalPlay,
    kRandomSolve,
    kSystemSetting,
    kHeroBoard,
    kMainMenu
}ViewTransitionTag;