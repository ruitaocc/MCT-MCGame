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
#import "MCConfiguration.h"

@implementation MCMagicCubeUIModelController
@synthesize array27Cube;
@synthesize stepcounterAddAction,stepcounterMinusAction;
@synthesize target;

-(id)initiate{
    if(self = [super init]){
        if (array27Cube == nil) array27Cube = [[NSMutableArray alloc] init];	
        isAutoRotate = NO;
        //魔方整体三个参数
        scale = MCPointMake(90,90,90);
        translation = MCPointMake(0,0,0);
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
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    MagicCubeIndexState[x+y*3+z*9] = [array27Cube objectAtIndex:x+y*3+z*9];
                }
            }
        }
        firstThreePointCount = 0;
        fingerRotate_angle = 0;
        select_trackballRadius = 260;
        isAddStepWhenUpdateState = YES;
        rrrr = 0;
    }
    
    return self;
};
-(void)render{
    [array27Cube makeObjectsPerformSelector:@selector(render)];
    [super render];
};

-(void)awake
{
     [array27Cube makeObjectsPerformSelector:@selector(awake)];
    //[[array27Cube objectAtIndex:26] performSelector:@selector(awake)];
    
}
- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction{
    //当前如果有某一自动旋转正在进行，禁止再旋转，直到完成
    if (isAutoRotate) return;
    //当前如果有某一手动旋转正在进行，禁止再旋转，直到完成
    if (isLayerRotating) return;
    //当前如果有某一旋转自动调整正在进行，禁止再旋转，直到完成
    if (isNeededToAdjustment) return;
    
    isAutoRotate = YES;
    rest_rotate_time = TIME_PER_ROTATION;
    rest_rotate_angle = ROTATION_ANGLE;
    cuculated_angle = 0;
    current_rotate_axis = axis;
    current_rotate_direction = direction;
    current_rotate_layer = layer;
    
    //获取layer的对象指针
    switch (axis) {
        case X:
            
            for(int z = 0; z < 3; ++z)
            {
                for(int y = 0; y < 3; ++y)
                {
                    layerPtr[y+z*3] = MagicCubeIndexState[z*9+y*3+layer];
                    
                }
            }
            break;
        case Y:
            //change data
            for(int z = 0; z < 3; ++z)
            {
                for(int x = 0; x < 3; ++x)
                {
                    layerPtr[x+z*3] = MagicCubeIndexState[z*9+layer*3+x];
                   
                }
            }
            break;
        case Z:
            //change data
            for(int y = 0; y < 3; ++y)
            {
                for(int x = 0; x < 3; ++x)
                {
                    layerPtr[x+y*3] = MagicCubeIndexState[layer*9+y*3+x];
                }
            }
            break;
        default:
            break;
    }

    //在下面调用 魔方底层数据模型的 旋转操作 更新数据
    //[MagicCube rotateOnAxis : axis onLayer: layer inDirection:direction];

};


-(void)update{
    [self handleTouches];
    //if (collider != nil) [collider updateCollider:self];
    if (isAutoRotate){
        //
        CGFloat deltaTime = [[[CoordinatingController sharedCoordinatingController] currentController] deltaTime];
        
        rest_rotate_time -= deltaTime;
        
        if (rest_rotate_time < 0 ) {
            rest_rotate_time += deltaTime;
            
            isAutoRotate = NO;
            //做最后一次的调整 保证准确归位
            // 0 2  6 8 角块
            double final_alpha = rest_rotate_time/TIME_PER_ROTATION*ROTATION_ANGLE;
            cuculated_angle = final_alpha;
            double theta = cuculated_angle*Pi/360;
            double sintheta = sin(theta);
            double costheta = cos(theta);
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            MCPoint ox = MCPointMake(1, 0, 0);
            MCPoint oy = MCPointMake(0, 1, 0);
            MCPoint oz = MCPointMake(0, 0, 1);
            MCPoint current;
            MCPoint start;
            MCPoint end;
            switch (current_rotate_axis) {
                case X:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(0, sintheta, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(0, costheta, sintheta);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                    
                }
                    break;
                case Y:
                {   
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(costheta,0 ,sintheta);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(sintheta,0, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                case Z:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(sintheta, costheta,0);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(costheta, sintheta,0);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                default:
                    break;
            }
            Cube *center = [array27Cube objectAtIndex:13];
            MCPoint tmpp = MCPointMatrixMultiply(start, center.matrix);
            vec3 start_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            tmpp = MCPointMatrixMultiply(end, center.matrix);
            vec3 end_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            
            Quaternion delta = Quaternion::CreateFromVectors(start_v, end_v);
            for (int i= 0 ; i<9; i++) {
                [layerPtr[i] setQuaPreviousRotation:layerPtr[i].quaRotation]; 
                if (current_rotate_layer!=1) {
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }else if(i!=4){
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }
            }

            [self updateState];
            //归零
            rest_rotate_time = 0;
            
        }
        else{
            // 0 2  6 8 角块
            double alpha = deltaTime/TIME_PER_ROTATION*ROTATION_ANGLE;
            cuculated_angle = alpha;
            double theta = cuculated_angle*Pi/360;
            double sintheta = sin(theta);
            double costheta = cos(theta);
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            MCPoint ox = MCPointMake(1, 0, 0);
            MCPoint oy = MCPointMake(0, 1, 0);
            MCPoint oz = MCPointMake(0, 0, 1);
            MCPoint current;
            MCPoint start;
            MCPoint end;
            switch (current_rotate_axis) {
                case X:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(0, sintheta, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(0, costheta, sintheta);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                    
                }
                    break;
                case Y:
                {   
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(costheta,0 ,sintheta);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(sintheta,0, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                case Z:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(sintheta, costheta,0);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(costheta, sintheta,0);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                default:
                    break;
            }
            Cube *center = [array27Cube objectAtIndex:13];
            MCPoint tmpp = MCPointMatrixMultiply(start, center.matrix);
            vec3 start_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            tmpp = MCPointMatrixMultiply(end, center.matrix);
            vec3 end_v = vec3(tmpp.x,tmpp.y,tmpp.z);

            Quaternion delta = Quaternion::CreateFromVectors(start_v, end_v);
            for (int i= 0 ; i<9; i++) {
                [layerPtr[i] setQuaPreviousRotation:layerPtr[i].quaRotation]; 
                if (current_rotate_layer!=1) {
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }else if(i!=4){
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }
            }
        }
    }
    if (isNeededToAdjustment) {
        
        CGFloat deltaTime = [[[CoordinatingController sharedCoordinatingController] currentController] deltaTime];
        rest_fingerRotate_time -= deltaTime;
        
        if (rest_fingerRotate_time < 0 ) {
            rest_fingerRotate_time += deltaTime;
            
            isNeededToAdjustment = NO;
            //做最后一次的调整 保证准确归位
            // 0 2  6 8 角块
            double final_alpha = rest_fingerRotate_time/TIME_PER_ROTATION*ROTATION_ANGLE;
            double theta = final_alpha*Pi/360;
            double sintheta = sin(theta);
            double costheta = cos(theta);
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            MCPoint ox = MCPointMake(1, 0, 0);
            MCPoint oy = MCPointMake(0, 1, 0);
            MCPoint oz = MCPointMake(0, 0, 1);
            MCPoint current;
            MCPoint start;
            MCPoint end;
            switch (current_rotate_axis) {
                case X:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(0, sintheta, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(0, costheta, sintheta);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                    
                }
                    break;
                case Y:
                {   
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(costheta,0 ,sintheta);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(sintheta,0, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                case Z:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(sintheta, costheta,0);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(costheta, sintheta,0);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                default:
                    break;
            }
            Cube *center = [array27Cube objectAtIndex:13];
            MCPoint tmpp = MCPointMatrixMultiply(start, center.matrix);
            vec3 start_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            tmpp = MCPointMatrixMultiply(end, center.matrix);
            vec3 end_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            
            Quaternion delta = Quaternion::CreateFromVectors(start_v, end_v);
            for (int i= 0 ; i<9; i++) {
                [layerPtr[i] setQuaPreviousRotation:layerPtr[i].quaRotation]; 
                if (current_rotate_layer!=1) {
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }else if(i!=4){
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }
            }
            if(isNeededToUpdateMagicCubeState){
                if (fingerRotate_angle>90&&fingerRotate_angle_mod90<45) {
                    if (current_rotate_direction == CW) {
                        current_rotate_direction =CCW;
                    }else {
                        current_rotate_direction = CW;
                    }
                }
                [self updateState];
            }
            fingerRotate_angle = 0;
            isNeededToAdjustment = NO;
            //归零
            rest_fingerRotate_time = 0;
            
        }
        else{
            // 0 2  6 8 角块
            double alpha = deltaTime/TIME_PER_ROTATION*ROTATION_ANGLE;
            double theta = alpha*Pi/360;
            double sintheta = sin(theta);
            double costheta = cos(theta);
            //(x*cosθ- y * sinθ, y*cosθ + x * sinθ)
            MCPoint ox = MCPointMake(1, 0, 0);
            MCPoint oy = MCPointMake(0, 1, 0);
            MCPoint oz = MCPointMake(0, 0, 1);
            MCPoint current;
            MCPoint start;
            MCPoint end;
            switch (current_rotate_axis) {
                case X:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(0, sintheta, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(0, costheta, sintheta);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                    
                }
                    break;
                case Y:
                {   
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(costheta,0 ,sintheta);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(sintheta,0, costheta);
                        start = MCPointMake(oz.x,oz.y,oz.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                case Z:
                {
                    if (current_rotate_direction == CW) {
                        current = MCPointMake(sintheta, costheta,0);
                        start = MCPointMake(oy.x,oy.y,oy.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }else {
                        current = MCPointMake(costheta, sintheta,0);
                        start = MCPointMake(ox.x,ox.y,ox.z);
                        end = MCPointMake(current.x,current.y,current.z);
                    }
                }
                    break;
                default:
                    break;
            }
            Cube *center = [array27Cube objectAtIndex:13];
            MCPoint tmpp = MCPointMatrixMultiply(start, center.matrix);
            vec3 start_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            tmpp = MCPointMatrixMultiply(end, center.matrix);
            vec3 end_v = vec3(tmpp.x,tmpp.y,tmpp.z);
            
            Quaternion delta = Quaternion::CreateFromVectors(start_v, end_v);
            for (int i= 0 ; i<9; i++) {
                [layerPtr[i] setQuaPreviousRotation:layerPtr[i].quaRotation]; 
                if (current_rotate_layer!=1) {
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                }else if(i!=4){
                    [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
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
    if ([touches count] >2) return;
    //单手指单层划动
    if ([touches count]==1) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        //CGPoint location = [touch locationInView:view];

        //继续射线拾取
        float V[108] = {-0.5,0.5,0.5,    -0.5,-0.5,0.5,   0.5,-0.5,0.5,
                         0.5,-0.5,0.5,    0.5,0.5,0.5,    -0.5,0.5,0.5,//前
            
                        -0.5,0.5,0.5,     0.5,0.5,0.5,     0.5,0.5,-0.5,
                         0.5,0.5,-0.5,   -0.5,0.5,-0.5,   -0.5,0.5,0.5,//上
            
                        -0.5,0.5,-0.5,   -0.5,-0.5,-0.5,  -0.5,-0.5,0.5,
                        -0.5,-0.5,0.5,   -0.5,0.5,0.5,    -0.5,0.5,-0.5,//左
            
                         0.5,0.5,0.5,     0.5,-0.5,0.5,    0.5,-0.5,-0.5,
                         0.5,-0.5,-0.5,   0.5,0.5,-0.5,    0.5,0.5,0.5,//右
            
                         0.5,0.5,-0.5,    0.5,-0.5,-0.5,  -0.5,-0.5,-0.5,
                        -0.5,-0.5,-0.5,  -0.5,0.5,-0.5,    0.5,0.5,-0.5,//后
            
                        -0.5,-0.5,0.5,   -0.5,-0.5,-0.5,   0.5,-0.5,-0.5,
                         0.5,-0.5,-0.5,   0.5,-0.5,0.5,    -0.5,-0.5,0.5,//下
        };
        
        if (touchEventSate == UITouchPhaseMoved) {
            if (isLayerRotating == NO) {
                //没选中及时返回
                firstThreePointCount = 0;
                return;
            }
            if (firstThreePointCount > 3) {
                //开始旋转
                CGPoint location = [touch locationInView:view];
                ivec2 current = ivec2(location.x,location.y);
                if (isLayerRotating) {
                    vec3 start = [self MapToLayerCenter:firstThreePoint[0]];
                    vec3 end =[self MapToLayerCenter:current];
                    
                    double alpha = ThetaBetweenV1andV2(start,end);
                    fingerRotate_angle = alpha*180/Pi; //checked
                    //NSLog(@"fingerRotate_angle2:%f",fingerRotate_angle);
                    Quaternion delta = Quaternion::CreateFromVectors(start, end);
                    for (int i=0;i<9;i++) {
                        if (current_rotate_layer!=1) {
                             [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                        }else if(i!=4){
                            [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                        }
                        
                    }
                }
                
                
                
                
            }else if (firstThreePointCount < 3){
                //选择三角型切面
                CGPoint location = [touch locationInView:view];
                firstThreePoint[firstThreePointCount] = ivec2(location.x,location.y);
                firstThreePointCount++;
            }else {
                //计算选中层  方案2
                vec3 figer_triangleV0 = vec3(firstThreePoint[0].x,firstThreePoint[0].y,10);
                vec3 figer_triangleV1 = vec3(firstThreePoint[1].x,firstThreePoint[1].y,30);
                vec3 figer_triangleV2 = vec3(firstThreePoint[2].x,firstThreePoint[2].y,10);
                vec3 movedTo0_V0 = figer_triangleV0-figer_triangleV1;
                vec3 movedTo0_V1 = figer_triangleV2-figer_triangleV1;
                
                vec3 select_triangleV0 = vec3(selected_triangle[0],selected_triangle[1],selected_triangle[2]);
                vec3 select_triangleV1 = vec3(selected_triangle[3],selected_triangle[4],selected_triangle[5]);
                vec3 select_triangleV2 = vec3(selected_triangle[6],selected_triangle[7],selected_triangle[8]);
                vec3 select_movedTo0_V0 = select_triangleV0 - select_triangleV1;
                vec3 select_movedTo0_V1 = select_triangleV2 - select_triangleV1;

                float xyz[9] = {1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0};
                Cube * tmpcuble = [array27Cube objectAtIndex:13];
                GLfloat * XYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmpcuble.matrix);
                vec3 ox = vec3(XYZ[0],XYZ[1],XYZ[2]);
                vec3 oy = vec3(XYZ[3],XYZ[4],XYZ[5]);
                vec3 oz = vec3(XYZ[6],XYZ[7],XYZ[8]);
                
                float ox_triangle = [self AngleV0V1withV:ox V0:select_movedTo0_V0 V1:select_movedTo0_V1];
                float oy_triangle = [self AngleV0V1withV:oy V0:select_movedTo0_V0 V1:select_movedTo0_V1];
                float oz_triangle = [self AngleV0V1withV:oz V0:select_movedTo0_V0 V1:select_movedTo0_V1];
                AxisType vertical_axis = (ox_triangle>oy_triangle)? (ox_triangle>oz_triangle)?X:Z:(oy_triangle>oz_triangle)?Y:Z;    

                
                float dx = [self AngleV0V1withV:ox V0:movedTo0_V0 V1:movedTo0_V1];
                float dy = [self AngleV0V1withV:oy V0:movedTo0_V0 V1:movedTo0_V1];
                float dz = [self AngleV0V1withV:oz V0:movedTo0_V0 V1:movedTo0_V1];
                
                if (vertical_axis == X) {
                    current_rotate_axis = (dy>dz)?Y:Z;
                }
                if (vertical_axis == Y) {
                    current_rotate_axis = (dx >dz)?X:Z;
                }
                if (vertical_axis == Z) {
                    current_rotate_axis = (dx>dy)?X:Y;
                }
                if (selected != nil) {
                    //计算选中点层和轴
                    int index = [selected index];
                    int magiccubeStateIndex = -1;
                    for (int i = 0;i<27;i++) {
                        //Cube *tmpcube = //[array27Cube objectAtIndex:i];
                        Cube *tmpcube = MagicCubeIndexState[i];
                        if ([tmpcube index] == index) {
                            magiccubeStateIndex = i;
                        }
                    }
                    int x = -1,y = -1,z= -1;
                    //NSLog(@"magiccubeStateIndex%d",magiccubeStateIndex);
                    z = magiccubeStateIndex/9;
                    int tmp = magiccubeStateIndex%9;
                    y = tmp/3;
                    x = tmp%3;
                    if (current_rotate_axis == X) {
                        current_rotate_layer = x;
                        NSLog(@"X %d",current_rotate_layer);
                    }else if(current_rotate_axis ==Y){
                        current_rotate_layer = y;
                        NSLog(@"Y %d",current_rotate_layer);
                    }else {
                        current_rotate_layer = z;
                        NSLog(@"Z %d",current_rotate_layer);
                    }
                    //选中层
                    [self SelectLayer];
                    for (int i= 0; i<9; i++) {
                        if (current_rotate_layer!=1) {
                            [layerPtr[i] setQuaPreviousRotation:[layerPtr[i] quaRotation]];
                        }else if(i != 4){
                            [layerPtr[i] setQuaPreviousRotation:[layerPtr[i] quaRotation]];
                        }
                    }
                    
                }
                firstThreePointCount++;

            }
            
            
            
        }else if (touchEventSate == UITouchPhaseBegan) {
            
            //当前如果有某一自动旋转正在进行，禁止再旋转，直到完成
            if (isAutoRotate) return;
            //当前如果有某一旋转自动调整正在进行，禁止再旋转，直到完成
            if (isNeededToAdjustment) return;
            
            
            //记录第一个点
            CGPoint location = [touch locationInView:view];
            firstThreePointCount++;
            firstThreePoint[0].x =location.x;
            firstThreePoint[0].y =location.y;
            //Once function down, update the ray.
            [ray updateWithScreenX:location.x
                           screenY:location.y];
            float nearest_distance = 65535;
            int index = -1;
            for (Cube *tmp_cube in array27Cube) {
                GLfloat * tmp_dection = VertexesArray_Matrix_Multiply(V, 3, 36, tmp_cube.matrix);
                for (int i = 0; i < 12; i++) {
                    //OK, check the intersection and return the distance.
                    float distance = [ray intersectWithTriangleMadeUpOfV0:&tmp_dection[0 +i*9]
                                                                       V1:&tmp_dection[3 +i*9]
                                                                       V2:&tmp_dection[6 +i*9]];
                    if (distance < 0) continue;
                    if (distance < nearest_distance) {
                        //存储当前选中的三角形
                        for (int k= 0; k <9 ; k++) {
                            selected_triangle[k] = tmp_dection[i*9+k];
                        }
                        nearest_distance = distance;
                        index = tmp_cube.index;
                    }
                }
            }
            if (index != -1) {
                //dectected
                NSLog(@" single begin拾取第%d个小块： distance：%f",index,nearest_distance);
                selected = [array27Cube objectAtIndex:index];
                selected.scale = MCPointMake(20, 20, 20);
                isLayerRotating = YES;
                fingerRotate_angle = 0;
            }
           // m_previousOrientation = m_orientation;
        }else if (touchEventSate == UITouchPhaseEnded) {
            //确定旋转方向
            //使用第一点 和 最后一个点 及他们点中间点 在轨迹圆上形成轨迹弧
            //三点确定两个向量，他们进行差乘，再和法向量进行点乘 由正负确定转向
            if(isLayerRotating!=YES)return;
            CGPoint location = [touch locationInView:view];
            ivec2 lastPoint = ivec2(location.x,location.y);
            ivec2 middle = ivec2((firstThreePoint[0].x+lastPoint.x)/2,
                                 (firstThreePoint[0].y+lastPoint.y)/2);
            
            float xyz[9] = {1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0};
            Cube * tmpcuble = [array27Cube objectAtIndex:13];
            GLfloat * XYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmpcuble.matrix);
            vec3 ox = vec3(XYZ[0],XYZ[1],XYZ[2]);
            vec3 oy = vec3(XYZ[3],XYZ[4],XYZ[5]);
            vec3 oz = vec3(XYZ[6],XYZ[7],XYZ[8]);
            
            vec3 firstv = [self MapToLayerCenter:firstThreePoint[0]];
            vec3 middlev =[self MapToLayerCenter:middle];
            vec3 lastv = [self MapToLayerCenter:lastPoint];
            
            //标记启动自动调整
            NSLog(@"fingerRotate_angle2:%f",fingerRotate_angle);
            //double angle = fingerRotate_angle*360/Pi;
            int tmpvar = int(fingerRotate_angle)/90;
            fingerRotate_angle_mod90 = fingerRotate_angle - tmpvar*90.0;
            if (fingerRotate_angle_mod90 > 45.0) {
                rest_fingerRotate_angle = 90.0-fingerRotate_angle_mod90;
            }else {
                rest_fingerRotate_angle = fingerRotate_angle_mod90;
            }
            
            rest_fingerRotate_time = (rest_fingerRotate_angle/ROTATION_ANGLE)*TIME_PER_ROTATION;
            
            vec3 V1 = firstv-middlev;
            vec3 V2 = lastv -middlev;
            vec3 corssv1v2 = V1.Cross(V2);
            double cosa = -1;
            if (current_rotate_axis == X) {
                cosa = corssv1v2.Dot(ox)/(corssv1v2.Module()*ox.Module());
            }
            if (current_rotate_axis == Y) {
                cosa = corssv1v2.Dot(oy)/(corssv1v2.Module()*oy.Module());
            }
            if (current_rotate_axis ==Z) {
                cosa = corssv1v2.Dot(oz)/(corssv1v2.Module()*oz.Module());
            }
            if (cosa > 0){
                if (fingerRotate_angle_mod90 > 45) {
                    current_rotate_direction = CW;
                    isNeededToUpdateMagicCubeState = YES;
                }else {
                    current_rotate_direction = CCW;
                    isNeededToUpdateMagicCubeState = NO;
                }
            }else {
                if (fingerRotate_angle_mod90 > 45) {
                    current_rotate_direction = CCW;
                    isNeededToUpdateMagicCubeState = YES;
                }else {
                    current_rotate_direction = CW;
                    isNeededToUpdateMagicCubeState = NO;
                }
            }
            if (fingerRotate_angle>90&&fingerRotate_angle_mod90<45) {
                isNeededToUpdateMagicCubeState = YES;
            }
            //标记手动转动结束
            isNeededToAdjustment = YES;
            isLayerRotating = NO;
            firstThreePointCount = 0;
            NSLog(@"single finish");
            if (selected != nil) {
                selected.scale = MCPointMake(30, 30, 30);
                selected = nil;
            }
        }
    }

    
    //双手变换视角
    if ([touches count] == 2) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        UITouch *touch1 = [[touches allObjects] objectAtIndex:1];
        if (touchEventSate == UITouchPhaseMoved) {
            NSLog(@"moved");
            CGPoint current0 = [touch locationInView:view];
            CGPoint current1 = [touch1 locationInView:view];
            CGPoint current = CGPointMake((current0.x+current1.x)/2,(current0.y+current1.y)/2);
            //ivec2 oldLocation = ivec2(previous.x,previous.y);
            ivec2 newLocation = ivec2(current.x,current.y);
            if (m_spinning) {
                vec3 start = [self MapToSphere: m_fingerStart];
                vec3 end =[self MapToSphere:newLocation];
                Quaternion delta = Quaternion::CreateFromVectors(start, end);
                for (Cube *tmp in array27Cube) {
                    [tmp setQuaRotation: delta.Rotated([tmp quaPreviousRotation])];
                }
            }
        }else if (touchEventSate==UITouchPhaseBegan) {
            NSLog(@"begin");
            CGPoint location = [touch locationInView:view];
            CGPoint location1 = [touch1 locationInView:view];
            m_spinning = YES;
            m_fingerStart.x =(location.x+location1.x)/2;
            m_fingerStart.y =(location.y+location1.y)/2;
            for (Cube *tmp in array27Cube) {
                [tmp setQuaPreviousRotation:[tmp quaRotation]];
            }
        }else if (touchEventSate==UITouchPhaseEnded) {
            NSLog(@"ended");
            m_spinning = NO;
            
        }
    }
}

-(vec3)MapToSphere:(ivec2 )touchpoint
{
    
    //ivec2 m_centerPoint = ivec2(384+translation.y,512+translation.x);
    ivec2 m_centerPoint = ivec2(512+translation.x,384+translation.y);
    //NSLog(@"center:%i %i",m_centerPoint.x,m_centerPoint.y);
    
    vec2 p = touchpoint - m_centerPoint;
     //NSLog(@"p: %f  %f",p.x,p.y);
    // Flip the Y axis because pixel coords increase towards the bottom.
    p.y = -p.y;
    const float radius = m_trackballRadius;
    const float safeRadius = radius - 1;
    
    if (p.Length() > safeRadius) {
        float theta = atan2(p.x, p.y);
        p.y = safeRadius * cos(theta);
        p.x = safeRadius * sin(theta);
    }
    
    float z = sqrt(radius * radius - p.LengthSquared());
    vec3 mapped = vec3(p.x, p.y, z);
    return mapped / radius;
}

-(vec3)MapToLayerCenter:(ivec2 )touchpoint
{
    //ivec2 magiccube_centerPoint = ivec2(512+translation.x,384+translation.y);
    vec3 layer_center;
    
    int layer_center_index;
    if (current_rotate_axis== X) {
        layer_center_index = 12 +current_rotate_layer;
    }else if(current_rotate_axis == Y) {
        layer_center_index = 10 + current_rotate_layer*3;
    }else {
        layer_center_index = 4 + current_rotate_layer*9;
    }
    MCPoint original = MCPointMake(0, 0, 0);
    MCPoint layercenter_original = MCPointMatrixMultiply(original, [[array27Cube objectAtIndex:layer_center_index] matrix]);
    //vec3 layer_direction_N = vec3(layercenter_original.x,layercenter_original.y,layercenter_original.z);
    layer_center = vec3(512+translation.x+layercenter_original.x,384+translation.y+layercenter_original.y,layercenter_original.z);
    ivec2 layer_center_2D = ivec2(layer_center.x,layer_center.y);
    vec2 p = touchpoint - layer_center_2D;
   // vec2 p = touchpoint - magiccube_centerPoint;
    p.y = -p.y;
    const float radius = select_trackballRadius;
    const float safeRadius = radius - 1;
    
    if (p.Length() > safeRadius) {
        float theta = atan2(p.x, p.y);
        p.y = safeRadius * cos(theta);
        p.x = safeRadius * sin(theta);
    }
    
    MCPoint ox = MCPointMake(1, 0, 0);
    MCPoint oy = MCPointMake(0, 1, 0);
    MCPoint oz = MCPointMake(0, 0, 1);
    MCPoint zero ;
    if (current_rotate_axis== X) {
        zero = ox;
    }else if(current_rotate_axis == Y) {
        zero = oy;
    }else {
        zero = oz;
    }
    MCPoint direction_N = MCPointMatrixMultiply(zero, [[array27Cube objectAtIndex:13] matrix]);
    vec3 layer_direction_N;
        layer_direction_N = vec3(direction_N.x,direction_N.y,direction_N.z);
    float z = sqrt(radius * radius - p.LengthSquared()) + layer_center.z;
    vec3 trackVecter = vec3(p.x, p.y, z);
    //NSLog(@"layer_center:  %f ,%f ,%f",layer_center.x,layer_center.y,layer_center.z);
    vec3 crossed = trackVecter.Cross(layer_direction_N);
    vec3 mapped = layer_direction_N.Cross(crossed);
    float ratio = sqrt((mapped.x*mapped.x +mapped.y*mapped.y+mapped.z*mapped.z)/(radius*radius));
    return (mapped / ratio) / radius;
}

-(float)AngleV0V1withV: (vec3)v V0:(vec3) v0 V1:(vec3) v1{
    vec3 v0Xv1 = v0.Cross(v1);
    float d = abs(v0Xv1.Dot(v))/v0Xv1.Module();
    return d;
}

double ThetaBetweenV1andV2(const vec3& v1,const vec3& v2)
{
    double cosa = v1.Dot(v2)/(v1.Module()*v2.Module());
    return acos(cosa);
}


- (void) SelectLayer{
    //获取layer的对象指针
    switch (current_rotate_axis) {
        case X:
            
            for(int z = 0; z < 3; ++z)
            {
                for(int y = 0; y < 3; ++y)
                {
                    layerPtr[y+z*3] = MagicCubeIndexState[z*9+y*3+current_rotate_layer];
                    
                }
            }
            break;
        case Y:
            //change data
            for(int z = 0; z < 3; ++z)
            {
                for(int x = 0; x < 3; ++x)
                {
                    layerPtr[x+z*3] = MagicCubeIndexState[z*9+current_rotate_layer*3+x];
                    
                }
            }
            break;
        case Z:
            //change data
            for(int y = 0; y < 3; ++y)
            {
                for(int x = 0; x < 3; ++x)
                {
                    layerPtr[x+y*3] = MagicCubeIndexState[current_rotate_layer*9+y*3+x];
                }
            }
            break;
        default:
            break;
    }
};

-(void)stepCounterAdd{
    [target performSelector:stepcounterAddAction];
}
-(void)stepCounterMinus{
    [target performSelector:stepcounterMinusAction];
}


-(void)updateState{
    if (isAddStepWhenUpdateState) {
        [self stepCounterAdd];
    }else {
        [self stepCounterMinus];
    }
    Cube *tmp;
    switch (current_rotate_axis) {
        case X:
            if (current_rotate_direction == CW) {
                    //tmp = 0
                    tmp = MagicCubeIndexState[0*9+0*3+current_rotate_layer];
                    //0=2
                    MagicCubeIndexState[0*9+0*3+current_rotate_layer] = MagicCubeIndexState[0*9+2*3+current_rotate_layer];
                    //2=8
                    MagicCubeIndexState[0*9+2*3+current_rotate_layer] = MagicCubeIndexState[2*9+2*3+current_rotate_layer];
                    //8=6
                    MagicCubeIndexState[2*9+2*3+current_rotate_layer] = MagicCubeIndexState[2*9+0*3+current_rotate_layer];
                    //6=0
                    MagicCubeIndexState[2*9+0*3+current_rotate_layer] = tmp;
                    //tmp=1
                    tmp = MagicCubeIndexState[0*9+1*3+current_rotate_layer];
                    // 1=5 
                    MagicCubeIndexState[0*9+1*3+current_rotate_layer] = MagicCubeIndexState[1*9+2*3+current_rotate_layer];
                    //5=7
                    MagicCubeIndexState[1*9+2*3+current_rotate_layer] =  MagicCubeIndexState[2*9+1*3+current_rotate_layer];
                    //4=4
                    //7=3
                    MagicCubeIndexState[2*9+1*3+current_rotate_layer] = MagicCubeIndexState[1*9+0*3+current_rotate_layer];
                    //3=tmp
                    MagicCubeIndexState[1*9+0*3+current_rotate_layer] = tmp;
                }else {
                //tmp = 0
                tmp = MagicCubeIndexState[0*9+0*3+current_rotate_layer];
                //0=6
                MagicCubeIndexState[0*9+0*3+current_rotate_layer] = MagicCubeIndexState[2*9+0*3+current_rotate_layer];
                //6=8
                MagicCubeIndexState[2*9+0*3+current_rotate_layer] = MagicCubeIndexState[2*9+2*3+current_rotate_layer];
                //8=2
                MagicCubeIndexState[2*9+2*3+current_rotate_layer] = MagicCubeIndexState[0*9+2*3+current_rotate_layer];
                //2=0
                MagicCubeIndexState[0*9+2*3+current_rotate_layer] = tmp;
                //tmp=1
                tmp = MagicCubeIndexState[0*9+1*3+current_rotate_layer];
                // 1=3 
                MagicCubeIndexState[0*9+1*3+current_rotate_layer] = MagicCubeIndexState[1*9+0*3+current_rotate_layer];
                //3=7
                MagicCubeIndexState[1*9+0*3+current_rotate_layer] =  MagicCubeIndexState[2*9+1*3+current_rotate_layer];
                //4=4
                //7=5
                MagicCubeIndexState[2*9+1*3+current_rotate_layer] = MagicCubeIndexState[1*9+2*3+current_rotate_layer];
                //5=tmp
                MagicCubeIndexState[1*9+2*3+current_rotate_layer] = tmp;
            }
            break;
        case Y:
            if (current_rotate_direction == CW) {
                //tmp = 0
                tmp = MagicCubeIndexState[0*9+0+3*current_rotate_layer];
                //0=6
                MagicCubeIndexState[0*9+0+3*current_rotate_layer] = MagicCubeIndexState[2*9+0+3*current_rotate_layer];
                //6=8
                MagicCubeIndexState[2*9+0+3*current_rotate_layer] = MagicCubeIndexState[2*9+2+3*current_rotate_layer];
                //8=2
                MagicCubeIndexState[2*9+2+3*current_rotate_layer] = MagicCubeIndexState[0*9+2+3*current_rotate_layer];
                //2=0
                MagicCubeIndexState[0*9+2+3*current_rotate_layer] = tmp;
                //tmp=1
                tmp = MagicCubeIndexState[0*9+1+3*current_rotate_layer];
                // 1=3 
                MagicCubeIndexState[0*9+1+3*current_rotate_layer] = MagicCubeIndexState[1*9+0+3*current_rotate_layer];
                //3=7
                MagicCubeIndexState[1*9+0+3*current_rotate_layer] =  MagicCubeIndexState[2*9+1+3*current_rotate_layer];
                //4=4
                //7=5
                MagicCubeIndexState[2*9+1+3*current_rotate_layer] = MagicCubeIndexState[1*9+2+3*current_rotate_layer];
                //5=tmp
                MagicCubeIndexState[1*9+2+3*current_rotate_layer] = tmp;
            }else {
                //tmp = 0
                tmp = MagicCubeIndexState[0*9+0+current_rotate_layer*3];
                //0=2
                MagicCubeIndexState[0*9+0+current_rotate_layer*3] = MagicCubeIndexState[0*9+2+current_rotate_layer*3];
                //2=8
                MagicCubeIndexState[0*9+2+current_rotate_layer*3] = MagicCubeIndexState[2*9+2+current_rotate_layer*3];
                //8=6
                MagicCubeIndexState[2*9+2+current_rotate_layer*3] = MagicCubeIndexState[2*9+0*3+current_rotate_layer*3];
                //6=0
                MagicCubeIndexState[2*9+0+current_rotate_layer*3] = tmp;
                //tmp=1
                tmp = MagicCubeIndexState[0*9+1+current_rotate_layer*3];
                // 1=5 
                MagicCubeIndexState[0*9+1+current_rotate_layer*3] = MagicCubeIndexState[1*9+2+current_rotate_layer*3];
                //5=7
                MagicCubeIndexState[1*9+2+current_rotate_layer*3] =  MagicCubeIndexState[2*9+1+current_rotate_layer*3];
                //4=4
                //7=3
                MagicCubeIndexState[2*9+1+current_rotate_layer*3] = MagicCubeIndexState[1*9+0+current_rotate_layer*3];
                //3=tmp
                MagicCubeIndexState[1*9+0+current_rotate_layer*3] = tmp;
            }
            break;
        case Z:
            if (current_rotate_direction == CW) {
                //tmp = 0
                tmp = MagicCubeIndexState[0*3+0+9*current_rotate_layer];
                //0=2
                MagicCubeIndexState[0*3+0+9*current_rotate_layer] = MagicCubeIndexState[0*3+2+current_rotate_layer*9];
                //2=8
                MagicCubeIndexState[0*3+2+9*current_rotate_layer] = MagicCubeIndexState[2*3+2+current_rotate_layer*9];
                //8=6
                MagicCubeIndexState[2*3+2+current_rotate_layer*9] = MagicCubeIndexState[2*3+0+current_rotate_layer*9];
                //6=0
                MagicCubeIndexState[2*3+0+current_rotate_layer*9] = tmp;
                //tmp=1
                tmp = MagicCubeIndexState[0*3+1+current_rotate_layer*9];
                // 1=5 
                MagicCubeIndexState[0*3+1+current_rotate_layer*9] = MagicCubeIndexState[1*3+2+current_rotate_layer*9];
                //5=7
                MagicCubeIndexState[1*3+2+current_rotate_layer*9] =  MagicCubeIndexState[2*3+1+current_rotate_layer*9];
                //4=4
                //7=3
                MagicCubeIndexState[2*3+1+current_rotate_layer*9] = MagicCubeIndexState[1*3+0+current_rotate_layer*9];
                //3=tmp
                MagicCubeIndexState[1*3+0+current_rotate_layer*9] = tmp;
            }else {
                //tmp = 0
                tmp = MagicCubeIndexState[0*3+0+current_rotate_layer*9];
                //0=6
                MagicCubeIndexState[0*3+0+current_rotate_layer*9] = MagicCubeIndexState[2*3+0+current_rotate_layer*9];
                //6=8
                MagicCubeIndexState[2*3+0+current_rotate_layer*9] = MagicCubeIndexState[2*3+2+current_rotate_layer*9];
                //8=2
                MagicCubeIndexState[2*3+2+current_rotate_layer*9] = MagicCubeIndexState[0*3+2+current_rotate_layer*9];
                //2=0
                MagicCubeIndexState[0*3+2+current_rotate_layer*9] = tmp;
                //tmp=1
                tmp = MagicCubeIndexState[0*3+1+current_rotate_layer*9];
                // 1=3 
                MagicCubeIndexState[0*3+1+current_rotate_layer*9] = MagicCubeIndexState[1*3+0+current_rotate_layer*9];
                //3=7
                MagicCubeIndexState[1*3+0+current_rotate_layer*9] =  MagicCubeIndexState[2*3+1+current_rotate_layer*9];
                //4=4
                //7=5
                MagicCubeIndexState[2*3+1+current_rotate_layer*9] = MagicCubeIndexState[1*3+2+current_rotate_layer*9];
                //5=tmp
                MagicCubeIndexState[1*3+2+current_rotate_layer*9] = tmp;
            }          
            break;
        default:
            break;
    }
}


-(void)rotateTest{
    if (isAutoRotate) {
        return;
    }
    if (rrrr == 0) {
        [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
        rrrr++;
        return;
    }
    
    if (rrrr == 1) {
        [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
        rrrr++;
        return;
        
    }
    if (rrrr == 2) {
        [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
        rrrr++;
        return;
    }
    if (rrrr == 3) {
        [self rotateOnAxis:Y onLayer:0 inDirection:CW];
        rrrr++;
        return;
        
    }
    if (rrrr == 4) {
        [self rotateOnAxis:Z onLayer:0 inDirection:CW];
        rrrr++;
        return;
    }
    if (rrrr == 5) {
        [self rotateOnAxis:Y onLayer:2 inDirection:CW];
        rrrr=0;
        return;
        
    }
}
@end
