//
//  MCMagicCubeUIModelController.m
//  MCGame
//
//  Created by kwan terry on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMagicCubeUIModelController.h"
#import <math.h>
#import "CoordinatingController.h"
@implementation MCMagicCubeUIModelController
//@synthesize translation,rotation,scale,rotationalSpeed;

-(id)initiate{
    if(self = [super init]){
        if (array27Cube == nil) array27Cube = [[NSMutableArray alloc] init];	
        isRotate = NO;
        //魔方整体三个参数
        scale = MCPointMake(90,90,90);
        translation = MCPointMake(30,0,0);
        rotation = MCPointMake(0,0,0);
        
        MCPoint sub_scale  = MCPointMake(scale.x/3, scale.y/3, scale.z/3);
        for (int  i = 0; i<9; i++) {
            layerPtr[i] = nil;
        }
        float gap = CUBE_CUBE_GAP;
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    //符号
                    int sign_x = x-1;
                    int sign_y = y-1;
                    int sign_z = z-1;
                    TestCube * Cube = [[TestCube alloc] init];
                    Cube.pretranslation = MCPointMake(translation.x, translation.y, translation.z);
                    Cube.prerotation = MCPointMake(rotation.x, rotation.y, rotation.z);
                    Cube.translation = MCPointMake((gap+sub_scale.x)*sign_x, (gap+sub_scale.y)*sign_y, (gap+sub_scale.z)*sign_z);
                    
                    Cube.scale = MCPointMake(sub_scale.x, sub_scale.y, sub_scale.z); 
                    //Cube.rotation = MCPointMake(rotation.x, rotation.y, rotation.z);
                    Cube.rotationalSpeed = MCPointMake(0, 0, 0);
                    [array27Cube addObject: Cube];
                    [Cube release];		
                }
            }
        }
    }
    return self;
};

- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction{
    if (isRotate) return;
    isRotate = YES;
    rest_rotate_time = TIME_PER_ROTATION;
    rest_rotate_angle = ROTATION_ANGLE;
    current_rotate_axis = axis;
    current_rotate_direction = direction;
    current_rotate_layer = layer;
    
    //获取layer的对象指针
    switch (axis) {
        case X:
            
            for(int y = 0; y < 3; ++y)
            {
                for(int z = 0; z < 3; ++z)
                {
                    layerPtr[z+y*3] = [array27Cube objectAtIndex:y*9+z*3+layer];
                    
                }
            }
            break;
        case Y:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int z = 0; z < 3; ++z)
                {
                    layerPtr[z+x*3] = [array27Cube objectAtIndex:x*9+layer*3+z];
                   
                }
            }
            break;
        case Z:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int y = 0; y < 3; ++y)
                {
                    layerPtr[y+x*3] = [array27Cube objectAtIndex:layer*9+x*3+y];
                  
                }
            }
            break;
        default:
            break;
    }

    //在下面调用 魔方底层数据模型的 旋转操作 更新数据
    //[MagicCube rotateOnAxis : axis onLayer: layer inDirection:direction];

};
-(void)render{
    [array27Cube makeObjectsPerformSelector:@selector(render)];
};

-(void)awake
{
    [array27Cube makeObjectsPerformSelector:@selector(awake)];
}

-(void)update{
    if (isRotate){
        //
        CGFloat deltaTime = [[[CoordinatingController sharedCoordinatingController] currentController] deltaTime];
        
        rest_rotate_time -= deltaTime;
        
        if (rest_rotate_time < 0 ) {
            rest_rotate_time += deltaTime;
            
            isRotate = NO;
            //做最后一次的调整 保证准确归位
            // 0 2  6 8 角块
            
            double final_alpha = rest_rotate_time/TIME_PER_ROTATION*ROTATION_ANGLE;
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            for (int i= 0 ; i<9; i++) {
                MCPoint t_rotation = layerPtr[i].rotation;
                switch (current_rotate_axis) {
                    case X:
                    {
                        t_rotation.x += final_alpha;
                    }
                        break;
                    case Y:
                    {   
                        t_rotation.y += final_alpha;
                    }
                        break;
                    case Z:
                    {
                        t_rotation.z += final_alpha;
                    }
                        break;
                    default:
                        break;
                }
                //最后的调整
                [layerPtr[i] setRotation:t_rotation];
            }
             
            //归零
            rest_rotate_time = 0;
        }
        else{
            // 0 2  6 8 角块
            double alpha = deltaTime/TIME_PER_ROTATION*ROTATION_ANGLE;
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            for (int i= 0 ; i<9; i++) {
                MCPoint t_rotation = layerPtr[i].rotation;
                switch (current_rotate_axis) {
                    case X:
                    {
                        t_rotation.x += alpha;
                        [layerPtr[i] setRotation:t_rotation];
                    }
                    break;
                    case Y:
                    {   
                        t_rotation.y += alpha;
                        [layerPtr[i] setRotation:t_rotation];
                    }
                        break;
                    case Z:
                    {
                        t_rotation.z += alpha;
                        [layerPtr[i] setRotation:t_rotation];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    [array27Cube makeObjectsPerformSelector:@selector(update)];

};
-(void)rotateTest{
    
        [self rotateOnAxis:Y onLayer:2 inDirection:CW];
    
};


@end
