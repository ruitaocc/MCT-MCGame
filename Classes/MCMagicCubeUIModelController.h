//
//  MCMagicCubeUIModelController.h
//  MCGame
//
//  Created by kwan terry on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPoint.h"
#import "Global.h"
#import "Cube.h"
@class MCSceneObject;
//旋转速度 帧率无关设计 2秒
#define TIME_PER_ROTATION 1
#define ROTATION_ANGLE 90
#define CUBE_CUBE_GAP 0.3;
#import "MCRay.h"
#include "MCCollider.h"
@interface MCMagicCubeUIModelController : MCSceneObject{
    NSMutableArray* array27Cube; 
    Cube * layerPtr[9];

    //auto rotate 
    BOOL isAutoRotate;
    double rest_rotate_time;
    double rest_rotate_angle;
    
    AxisType current_rotate_axis;
    LayerRotationDirectionType current_rotate_direction;
    int current_rotate_layer;
    
    //以下三个参数用于 视角变换
    BOOL m_spinning;
    float m_trackballRadius;
    ivec2 m_fingerStart;    
    
    MCRay *ray;
    
    double cuculated_angle;
    
    ivec2 firstThreePoint[3];
    Cube *selected;
    float select_trackballRadius;
    int firstThreePointCount;
    //是否正在执行单层任务
    BOOL isLayerRotating;
    
    //自动调整机制
    //手动转动点角度
    double fingerRotate_angle;
    double rest_fingerRotate_angle;
    double rest_fingerRotate_time;
    BOOL isNeededToAdjustment;
    BOOL isNeededToUpdateMagicCubeState;
    //当前整个魔方索引的状态，存储索引值
    Cube * MagicCubeIndexState[27];
    
    
    
    
    
    
    int rrrr;
    
}

@property (retain) NSMutableArray* array27Cube;
-(id)initiate;
- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction;
-(void)awake;
-(void)render;
-(void)update;

-(void)rotateTest;
-(vec3)MapToSphere:(ivec2 )touchpoint;

@end
