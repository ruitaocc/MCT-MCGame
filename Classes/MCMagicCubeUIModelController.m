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
@synthesize array27Cube;

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
                    Cube * tCube = [[Cube alloc] init];
                    tCube.index = z*9+y*3+x;
                    tCube.pretranslation = MCPointMake(translation.x, translation.y, translation.z);
                    tCube.prerotation = MCPointMake(rotation.x, rotation.y, rotation.z);
                    
                    
                    tCube.translation = MCPointMake((gap+sub_scale.x)*sign_x, (gap+sub_scale.y)*sign_y, (gap+sub_scale.z)*sign_z);
                    
                    tCube.scale = MCPointMake(sub_scale.x, sub_scale.y, sub_scale.z); 
                    //Cube.rotation = MCPointMake(rotation.x, rotation.y, rotation.z);
                    //Cube.rotationalSpeed = MCPointMake(0, 0, 0);
                    tCube.collider = [MCCollider collider];
                    [tCube.collider setCheckForCollision:YES];
                    [array27Cube addObject: tCube];
                    [tCube release];		
                }
            }
        }
        m_trackballRadius = 260;
        m_spinning = NO;
        //self.collider = [MCCollider collider];
        //[self.collider setCheckForCollision:YES];
        ray = [[MCRay alloc] init];

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
    [super render];
};

-(void)awake
{
    [array27Cube makeObjectsPerformSelector:@selector(awake)];
}

-(void)update{
    [self handleTouches];
    //if (collider != nil) [collider updateCollider:self];
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
    [super update];
};
-(void)handleTouches
{
	NSSet * touches = [[[CoordinatingController sharedCoordinatingController] currentController].inputController touchEvents];
    UIView* view= [[[CoordinatingController sharedCoordinatingController] currentController].inputController view ];
	UITouchPhase touchEventSate = [[[CoordinatingController sharedCoordinatingController] currentController].inputController touchEventSate];
    if ([touches count] == 0) return;
    if ([touches count] == 1 && touchEventSate == UITouchPhaseBegan) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:view];
        
        NSLog(@"x:%f",location.x);
        NSLog(@"y:%f",location.y);
        
        //继续射线拾取
        
        float distance = -1;
        float nearest_distance = -1;
        int index = -1;
        //for (Cube *tmp_cube in array27Cube) {
        Cube *tmp_cube = [array27Cube objectAtIndex:24];
        //if (tmp_cube.index == 24) {
        //    tmp_cube.scale = MCPointMake(40, 40, 40);
        //}
        

        //three vertexs of the triangle, just for test.
        float V0[3] = {-0.5,0.5,0.5};
        float V1[3] = {-0.5,-0.5,0.5};
        float V2[3] = {0.5,-0.5,0.5};
        MCPoint v0 = MCPointMatrixMultiply(MCPointMake(-0.5, 0.5, 0.5), tmp_cube.matrix);
        MCPoint v1 = MCPointMatrixMultiply(MCPointMake(-0.5,-0.5,0.5), tmp_cube.matrix);
        MCPoint v2 = MCPointMatrixMultiply(MCPointMake(0.5,-0.5,0.5), tmp_cube.matrix);
        V0[0] = v0.x;V0[1] = v0.y;V0[2] = v0.z;
        V1[0] = v1.x;V1[1] = v1.y;V1[2] = v1.z;
        V2[0] = v2.x;V2[1] = v2.y;V2[2] = v2.z;
        //Once function down, update the ray.
        [ray updateWithScreenX:location.x
                       screenY:location.y];
        
                   //Find the inverse of the model matrix
        
        mat4 tmp;
        glhInvertMatrixf2(tmp_cube.matrix, &(tmp.x.x));
            //Transform the ray by the inverse matrix.
        //[ray transformWithMatrix:tmp];
            
        //OK, check the intersection and return the distance.
        distance = [ray intersectWithTriangleMadeUpOfV0:V0
                                                        V1:V1
                                                        V2:V2];
            
        
        NSLog(@"第%d个小块distance：%f",index,distance);
        
    }

    if ([touches count] == 2) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        UITouch *touch1 = [[touches allObjects] objectAtIndex:1];
        if (touchEventSate == UITouchPhaseMoved) {
            NSLog(@"moved");
            
            //CGPoint previous = [touch previousLocationInView:view];
            CGPoint current0 = [touch locationInView:view];

            CGPoint current1 = [touch1 locationInView:view];

            CGPoint current = CGPointMake((current0.x+current1.x)/2,(current0.y+current1.y)/2);
            //ivec2 oldLocation = ivec2(previous.x,previous.y);
            ivec2 newLocation = ivec2(current.x,current.y);
            
            if (m_spinning) {
                vec3 start = [self MapToSphere: m_fingerStart];
                //NSLog(@"start %f %f %f ",start.x,start.y,start.z );
                vec3 end =[self MapToSphere:newLocation];
                //NSLog(@"end %f %f %f ",end.x,end.y,end.z );
                NSLog(@"start %i %i ",m_fingerStart.x, m_fingerStart.y );
                NSLog(@"current %i %i ",newLocation.x, newLocation.y );
                Quaternion delta = Quaternion::CreateFromVectors(start, end);
                //NSLog(@"delta %f %f %f %f",delta.x,delta.y,delta.z ,delta.w);
                m_orientation = delta.Rotated(m_previousOrientation);
                for (int i = 0; i < 27; i++) {
                    [[array27Cube objectAtIndex:i]setM_orientation:m_orientation];
                }
                
               // NSLog(@"orientation %f %f %f ",m_orientation.x,m_orientation.y,m_orientation.z );
            }
        }else if (touchEventSate==UITouchPhaseBegan) {
            NSLog(@"begin");
            //[self setSpeed:MCPointMake(1, 0, 0)]; 
            CGPoint location = [touch locationInView:view];
            m_spinning = YES;
            m_fingerStart.x =location.x;
            m_fingerStart.y =location.y;
            m_previousOrientation = m_orientation;
        }else if (touchEventSate==UITouchPhaseEnded) {
            //[self setSpeed:MCPointMake(0, 0, 0)]; 
            NSLog(@"ended");
            m_spinning = NO;
        }
    }
}

-(vec3)MapToSphere:(ivec2 )touchpoint
{
    
    ivec2 m_centerPoint = ivec2(384+translation.y,512+translation.x);
    //NSLog(@"center:%i %i",m_centerPoint.x,m_centerPoint.y);
    
    vec2 p = touchpoint - m_centerPoint;
     //NSLog(@"p: %f  %f",p.x,p.y);
    // Flip the Y axis because pixel coords increase towards the bottom.
    //p.y = -p.y;
    const float radius = m_trackballRadius;
    const float safeRadius = radius - 1;
    
    if (p.Length() > safeRadius) {
        float theta = atan2(p.x, p.y);
        p.y = safeRadius * cos(theta);
        p.x = safeRadius * sin(theta);
    }
    
    float z = sqrt(radius * radius - p.LengthSquared());
    vec3 mapped = vec3(p.y, p.x, z);
    return mapped / radius;
}


-(void)rotateTest{
    
        [self rotateOnAxis:Y onLayer:2 inDirection:CW];
    
};


@end
