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
        scale = MCPointMake(90,90,90);
        translation = MCPointMake(0,0,0);
        //公转
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
                        Cube.translation = MCPointMake((gap+sub_scale.x)*sign_x+translation.x, (gap+sub_scale.y)*sign_y+translation.z, (gap+sub_scale.z)*sign_z+translation.z);
                        Cube.scale = MCPointMake(sub_scale.x, sub_scale.y, sub_scale.z); 
                    
                        Cube.rotation = MCPointMake(0, 0, 0);
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
                    [[array27Cube objectAtIndex:y*9+z*3+layer] setLastTranslation:[[array27Cube objectAtIndex:y*9+z*3+layer] translation]];
                     [(TestCube *)[array27Cube objectAtIndex:y*9+z*3+layer] setLastRotation:[(TestCube *)[array27Cube objectAtIndex:y*9+z*3+layer] rotation]];
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
                    [[array27Cube objectAtIndex:x*9+layer*3+z] setLastTranslation:[[array27Cube objectAtIndex:x*9+layer*3+z] translation]];
                    [(TestCube *)[array27Cube objectAtIndex:x*9+layer*3+z] setLastRotation:[(TestCube *)[array27Cube objectAtIndex:x*9+layer*3+z] rotation]];
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
                    [[array27Cube objectAtIndex:layer*9+x*3+y] setLastTranslation:[[array27Cube objectAtIndex:layer*9+x*3+y] translation]];
                    [(TestCube *)[array27Cube objectAtIndex:layer*9+x*3+y] setLastRotation:[(TestCube *)[array27Cube objectAtIndex:layer*9+x*3+y] rotation]];
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
            double final_alpha_pi = (final_alpha/180)*Pi;
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            for (int i= 0 ; i<9; i++) {
                MCPoint t_tranlation = layerPtr[i].translation;
                MCPoint t_rotation = layerPtr[i].rotation;
                MCPoint t_last_translation = layerPtr[i].lastTranslation;
                MCPoint t_last_rotation = layerPtr[i].lastRotation;
                switch (current_rotate_axis) {
                    case X:
                    {
                        if (current_rotate_direction == CW) {
                            t_tranlation.y = (-t_last_translation.z);
                            t_tranlation.z = t_last_translation.y;
                            t_rotation.x = t_last_rotation.x + ROTATION_ANGLE;
                        }else {
                            t_tranlation.y = (-t_last_translation.z);
                            t_tranlation.z = t_last_translation.y;
                            t_rotation.x = t_last_rotation.x - ROTATION_ANGLE;
                        }
                    }
                        break;
                    case Y:
                    {   
                       
                        
                        if (current_rotate_direction == CW) {
                            t_tranlation.z = (-t_last_translation.x);
                            t_tranlation.x = t_last_translation.z;
                            t_rotation.y = t_last_rotation.y + ROTATION_ANGLE;
                        }else {
                            t_tranlation.z = (-t_last_translation.x);
                            t_tranlation.x = t_last_translation.z;
                            t_rotation.y = t_last_rotation.y - ROTATION_ANGLE;
                        }
                        
                    }
                        break;
                    case Z:
                    {
                        if (current_rotate_direction == CW) {
                            t_tranlation.x = (-t_last_translation.y);
                            t_tranlation.y = t_last_translation.x;
                            t_rotation.z = t_last_rotation.z + ROTATION_ANGLE;
                        }else {
                            t_tranlation.x = (-t_last_translation.y);
                            t_tranlation.y = t_last_translation.x;
                            t_rotation.z = t_last_rotation.z - ROTATION_ANGLE;
                        }
                    }
                        break;
                    default:
                        break;
                }
                //最后的调整
                [layerPtr[i] setRotation:t_rotation];
                [layerPtr[i] setTranslation:t_tranlation];
            }
             
            //归零
            rest_rotate_time = 0;
        }
        else{
            // 0 2  6 8 角块
            double alpha = deltaTime/TIME_PER_ROTATION*ROTATION_ANGLE;
            double alpha_pi = (alpha/180)*Pi;
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            for (int i= 0 ; i<9; i++) {
                MCPoint t_tranlation = layerPtr[i].translation;
                MCPoint t_rotation = layerPtr[i].rotation;
                switch (current_rotate_axis) {
                    case X:
                    {
                        t_tranlation.y = t_tranlation.y* cos(alpha_pi) - t_tranlation.z*sin(alpha_pi);
                        t_tranlation.z = t_tranlation.z* cos(alpha_pi) + t_tranlation.y*sin(alpha_pi);
                        t_rotation.x += alpha;
                        [layerPtr[i] setRotation:t_rotation];
                        [layerPtr[i] setTranslation:t_tranlation];
                    }
                    break;
                    case Y:
                    {   
                        t_tranlation.z = t_tranlation.z* cos(alpha_pi) - t_tranlation.x*sin(alpha_pi);
                        t_tranlation.x = t_tranlation.x* cos(alpha_pi) + t_tranlation.z*sin(alpha_pi);
                        t_rotation.y += alpha;
                        [layerPtr[i] setRotation:t_rotation];
                        [layerPtr[i] setTranslation:t_tranlation];
                    }
                        break;
                    case Z:
                    {
                        t_tranlation.x =(t_tranlation.x* cos(alpha_pi)) - (t_tranlation.y*sin(alpha_pi));
                        t_tranlation.y = (t_tranlation.y* cos(alpha_pi)) + (t_tranlation.x*sin(alpha_pi));
                        t_rotation.z += alpha;
                        [layerPtr[i] setRotation:t_rotation];
                        [layerPtr[i] setTranslation:t_tranlation];
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
    [self rotateOnAxis:X onLayer:2 inDirection:CW];
};


@end
