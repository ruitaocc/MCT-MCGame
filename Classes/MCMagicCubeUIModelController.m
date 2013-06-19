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
#import "Global.h"
#import "RotateType.h"
#import "MCTransformUtil.h"
#import "Global.h"
@implementation MCMagicCubeUIModelController
@synthesize array27Cube;
@synthesize stepcounterAddAction,stepcounterMinusAction;
@synthesize target;
@synthesize usingMode = _usingMode;
@synthesize lockedarray;
@synthesize selected_cube_face_index;
@synthesize selected_cube_index;
//@synthesize TIME_PER_ROTATION;
//@synthesize magicCube;
@synthesize undoManger;
-(id)initiate{
    if(self = [super init]){
        if (array27Cube == nil) array27Cube = [[NSMutableArray alloc] init];
        if (lockedarray == nil) {
            lockedarray = [[NSMutableArray alloc]init];
        }
        isAutoRotate = NO;
        //魔方整体三个参数
        scale = MCPointMake(84,84,84);
        translation = MCPointMake(0,10,0);
        rotation = MCPointMake(30,-45,0);
        rotationalSpeed = MCPointMake(0, 30, 0);
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
                    tCube.rotationalSpeed = rotationalSpeed;
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
        isNeededToUpadteTwice = NO;
        isTribleAutoRotateIn_TECH_MODE = NO;
        //  TIME_PER_ROTATION =0.5;
        for (int i =0 ; i<3; i++) {
            twoLayerFlag[i] = NO;
        }
        is_TECH_MODE_Rotate = NO;
        undoManger = [[NSUndoManager alloc]init];
        //default mode play mode;
        [self setUsingMode:PLAY_MODE];
        
        //magicCube = [MCMagicCube getSharedMagicCube];
    }
    
    return self;
};

-(id)initiateWithState:(NSArray *)stateList{
    if(self = [super init]){
        if (array27Cube == nil) array27Cube = [[NSMutableArray alloc] init];
        if (lockedarray == nil) {
            lockedarray = [[NSMutableArray alloc]init];
        }
        //magicCube = [MCMagicCube getSharedMagicCube];
        isAutoRotate = NO;
        //魔方整体三个参数
        scale = MCPointMake(94,94,94);
        translation = MCPointMake(0,0,0);
        rotation = MCPointMake(30,-45,0);
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
                    int index_tmp =  z*9+y*3+x;
                    Cube * tCube = nil;
                    if (x != 1 || y != 1 || z != 1){
                    NSDictionary *cubestate = [stateList objectAtIndex:index_tmp];
                        tCube = [[Cube alloc] initWithState:cubestate];}
                    else{
                        tCube =[[Cube alloc]init];
                    }
                    tCube.index = index_tmp;
                    
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
        is_TECH_MODE_Rotate = NO;
        isTribleAutoRotateIn_TECH_MODE = NO;
        //  TIME_PER_ROTATION =0.5;
        for (int i =0 ; i<3; i++) {
            twoLayerFlag[i] = NO;
        }
        isAddStepWhenUpdateState = YES;
        rrrr = 0;
        //default mode play mode;
        [self setUsingMode:PLAY_MODE];
        undoManger = [[NSUndoManager alloc]init];
    }
    
    return self;
}

-(void)flashWithState:(NSArray *)stateList{
    Cube *centercube = [array27Cube objectAtIndex:13];
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                int index_tmp =  z*9+y*3+x;
                Cube * tCube = nil;
                if (x != 1 || y != 1 || z != 1){
                    NSDictionary *cubestate = [stateList objectAtIndex:index_tmp];
                    //tCube = [[Cube alloc] initWithState:cubestate];
                    tCube = [array27Cube objectAtIndex:index_tmp];
                    [tCube flashWithState:cubestate];
                    [tCube setIsLocked:NO];
                    [tCube setQuaRotation:[centercube quaRotation]];
                }
            }
        }
    }
    if ([target respondsToSelector:@selector(isShowQueue)]) {
        if ([target isShowQueue]) {
            for (int i = 0; i<[lockedarray count]; i++) {
                Cube * tCube = nil;
                Point3i point = [[[MCNormalPlaySceneController sharedNormalPlaySceneController]magicCube]coordinateValueOfCubieWithColorCombination:(ColorCombinationType)[[lockedarray objectAtIndex:i] intValue]];
                tCube = [array27Cube objectAtIndex:point.x+1+(point.y+1)*3+(point.z+1)*9];
                [tCube setIsLocked:YES];
            }
        }
    }
    
    
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


- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction isTribleRotate:(BOOL)is_trible_roate{
    //当前如果有某一自动旋转正在进行，禁止再旋转，直到完成
    if (isAutoRotate) return;
    //当前如果有某一手动旋转正在进行，禁止再旋转，直到完成
    if (isLayerRotating) return;
    //当前如果有某一旋转自动调整正在进行，禁止再旋转，直到完成
    if (isNeededToAdjustment) return;
    isTribleAutoRotateIn_TECH_MODE = is_trible_roate;
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
            if (isTribleAutoRotateIn_TECH_MODE) {
                for (int i =0; i<27; i++) {
                    [MagicCubeIndexState[i] setQuaPreviousRotation:[MagicCubeIndexState[i] quaRotation]];
                    if (i!=13) {
                        
                        [MagicCubeIndexState[i] setQuaRotation:delta.Rotated([MagicCubeIndexState[i] quaPreviousRotation])];
                    }
                }
                //
                current_rotate_layer = NO_SELECTED_LAYER;
                [self updateState];
            }else{
                for (int i= 0 ; i<9; i++) {
                    [layerPtr[i] setQuaPreviousRotation:layerPtr[i].quaRotation];
                    if (current_rotate_layer!=1) {
                        [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                    }else if(i!=4){
                        [layerPtr[i] setQuaRotation: delta.Rotated([layerPtr[i] quaPreviousRotation])];
                    }
                }
                [self updateState];
                //当转过的角度为180时，需要更新模型两次
                if(isNeededToUpadteTwice){
                    [self updateState];
                    isNeededToUpadteTwice = NO;
                }

            }
            if (isTribleAutoRotateIn_TECH_MODE)isTribleAutoRotateIn_TECH_MODE = NO;
            //归零
            rest_rotate_time = 0;
            isAutoRotate = NO;
            
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
            if (isTribleAutoRotateIn_TECH_MODE) {
                for (int i =0; i<27; i++) {
                    [MagicCubeIndexState[i] setQuaPreviousRotation:[MagicCubeIndexState[i] quaRotation]];
                    if (i!=13) {
                        [MagicCubeIndexState[i] setQuaRotation:delta.Rotated([MagicCubeIndexState[i] quaPreviousRotation])];
                    }
                }
            }else{
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
    }
    if (isNeededToAdjustment) {
        
        CGFloat deltaTime = [[[CoordinatingController sharedCoordinatingController] currentController] deltaTime];
        rest_fingerRotate_time -= deltaTime;
        
        if (rest_fingerRotate_time < 0 ) {
            rest_fingerRotate_time += deltaTime;
            
            
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
            //[self finalAdjust];
            if(isNeededToUpdateMagicCubeState){
                if (fingerRotate_angle>90&&fingerRotate_angle_mod90<45) {
                    if (current_rotate_direction == CW) {
                        current_rotate_direction =CCW;
                    }else {
                        current_rotate_direction = CW;
                    }
                }
                [self updateState];
                
                //当转过的角度为180时，需要更新模型两次
                if(isNeededToUpadteTwice){
                    [self updateState];
                    isNeededToUpadteTwice = NO;
                }
            }
            isNeededToAdjustment = NO;
            fingerRotate_angle = 0;
            isNeededToAdjustment = NO;
            //归零
            rest_fingerRotate_time = 0;
            //最后对增强调整方案
            
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
	FSM_Interaction_State fsm_Current_State = [[[CoordinatingController sharedCoordinatingController] currentController].inputController fsm_Current_State];
    FSM_Interaction_State fsm_Previous_State = [[[CoordinatingController sharedCoordinatingController] currentController].inputController fsm_Previous_State];
    if ([touches count] == 0) return;
        
    
    //继续射线拾取
    float V[108] = {
        
        
        -0.5,0.5,0.5,     0.5,0.5,0.5,     0.5,0.5,-0.5,
        0.5,0.5,-0.5,   -0.5,0.5,-0.5,   -0.5,0.5,0.5,//上
        
        -0.5,-0.5,0.5,   -0.5,-0.5,-0.5,   0.5,-0.5,-0.5,
        0.5,-0.5,-0.5,   0.5,-0.5,0.5,    -0.5,-0.5,0.5,//下
        
        -0.5,0.5,0.5,    -0.5,-0.5,0.5,   0.5,-0.5,0.5,
        0.5,-0.5,0.5,    0.5,0.5,0.5,    -0.5,0.5,0.5,//前
        
        0.5,0.5,-0.5,    0.5,-0.5,-0.5,  -0.5,-0.5,-0.5,
        -0.5,-0.5,-0.5,  -0.5,0.5,-0.5,    0.5,0.5,-0.5,//后
        
        -0.5,0.5,-0.5,   -0.5,-0.5,-0.5,  -0.5,-0.5,0.5,
        -0.5,-0.5,0.5,   -0.5,0.5,0.5,    -0.5,0.5,-0.5,//左
        
        0.5,0.5,0.5,     0.5,-0.5,0.5,    0.5,-0.5,-0.5,
        0.5,-0.5,-0.5,   0.5,0.5,-0.5,    0.5,0.5,0.5,//右
        
       
        
        
    };
    
    switch (fsm_Current_State) {
        case kState_S1:{
            touch = [[touches allObjects] objectAtIndex:0];
            //当前如果有某一自动旋转正在进行，禁止再旋转，直到完成
            if (isAutoRotate) return;
            //当前如果有某一旋转自动调整正在进行，禁止再旋转，直到完成
            if (isNeededToAdjustment) return;
            //记录第一个点
            //CGPoint location = [touch locationInView:view];
            CGPoint location = [touch previousLocationInView:view];
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
                        directionVector[0] = [ray pointIntersectWithTriangleMadeUpOfV0:&tmp_dection[0 +i*9]
                                                                                    V1:&tmp_dection[3 +i*9]
                                                                                    V2:&tmp_dection[6 +i*9]];
                        nearest_distance = distance;
                        index = tmp_cube.index;
                        tmp_cube.index_selectedFace = i;
                    }
                }
            }
            if (index != -1) {
                selected = [array27Cube objectAtIndex:index];
                //NSLog(@"selected_index:%d",index);
                //NSLog(@"(0x:%f,0y:%f,0z:%f)",directionVector[0].x,directionVector[0].y,directionVector[0].z);
                //selected.scale = MCPointMake(20, 20, 20);
                if ([self usingMode] == SOlVE_Input_MODE){
                    isLayerRotating = NO;
                }else{
                    isLayerRotating = YES;
                }
                fingerRotate_angle = 0;
            }
            
            break;
        }
            
            
        case kState_M1:{
                touch = [[touches allObjects] objectAtIndex:0];
            if (isLayerRotating == NO) {
                //没选中及时返回
                firstThreePointCount = 0;
                return;
            }
            if (firstThreePointCount > 3) {
                //开始旋转
                //CGPoint location = [touch locationInView:view];
                CGPoint location = [touch previousLocationInView:view];

                vec2 current = vec2(location.x,location.y);
                if (isLayerRotating) {
                    vec3 start = [self MapToLayerCenter:firstThreePoint[0]];
                    vec3 end =[self MapToLayerCenter:current];
                    
                    double alpha = ThetaBetweenV1andV2(start,end);
                    fingerRotate_angle = alpha*180/Pi; //checked
                    //NSLog("fingerRotate_angle%f",fingerRotate_angle);
                    //NSLog(@"fingerRotate_angle:%f",fingerRotate_angle);
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
                //CGPoint location = [touch locationInView:view];
                CGPoint location = [touch previousLocationInView:view];
                firstThreePoint[firstThreePointCount] = vec2(location.x,location.y);
                
                if (firstThreePointCount==2) {
                    //Once function down, update the ray.
                   CGPoint location = [touch locationInView:view];
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
                                
                                directionVector[1] = [ray pointIntersectWithTriangleMadeUpOfV0:&tmp_dection[0 +i*9]
                                                                                            V1:&tmp_dection[3 +i*9]
                                                                                            V2:&tmp_dection[6 +i*9]];
                                nearest_distance = distance;
                                index = tmp_cube.index;
                            }
                        }
                    }
                    if (index != -1) {
                        
                        //NSLog(@"(1x:%f,1y:%f,1z:%f)",directionVector[1].x,directionVector[1].y,directionVector[1].z);
                    }
                
                }
            firstThreePointCount++;
            }else {
                 
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
                 
                vec3 dirtection = directionVector[1]-directionVector[0];
                 float dx = FabsThetaBetweenV1andV2(ox,dirtection);
                  float dy = FabsThetaBetweenV1andV2(oy,dirtection);
                  float dz = FabsThetaBetweenV1andV2(oz,dirtection);
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
                 
                 z = magiccubeStateIndex/9;
                 int tmp = magiccubeStateIndex%9;
                 y = tmp/3;
                 x = tmp%3;
                 if (current_rotate_axis == X) {
                 current_rotate_layer = x;
                 }else if(current_rotate_axis ==Y){
                 current_rotate_layer = y;
                 }else {
                 current_rotate_layer = z;
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
            

            break;
        }
        case kState_F1:{
            //使用上一个数据，可以避免最后最后状态时有两个touch
            //touch = [[touches allObjects] objectAtIndex:0];
            
            //确定旋转方向
            //使用第一点 和 最后一个点 及他们点中间点 在轨迹圆上形成轨迹弧
            //三点确定两个向量，他们进行差乘，再和法向量进行点乘 由正负确定转向
            if(isLayerRotating!=YES)return;
            //CGPoint location = [touch locationInView:view];
            CGPoint location = [touch previousLocationInView:view];
            vec2 lastPoint = vec2(location.x,location.y);
            //vec2 middle = vec2((firstThreePoint[0].x+lastPoint.x)/2,
             //                    (firstThreePoint[0].y+lastPoint.y)/2);
            //NSLog(@"Point22[0]%f %f ",firstThreePoint[0].x,firstThreePoint[0].y);
            //NSLog(@"Point22[1]%f %f ",middle.x,middle.y);
            //NSLog(@"Point22[2]%f %f ",lastPoint.x,lastPoint.y);
            float xyz[9] = {1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0};
            Cube * tmpcuble = [array27Cube objectAtIndex:13];
            GLfloat * XYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmpcuble.matrix);
            vec3 ox = vec3(XYZ[0],XYZ[1],XYZ[2]);
            vec3 oy = vec3(XYZ[3],XYZ[4],XYZ[5]);
            vec3 oz = vec3(XYZ[6],XYZ[7],XYZ[8]);
            
            vec3 firstv = [self MapToLayerCenter:firstThreePoint[0]];
            //vec3 middlev =[self MapToLayerCenter:middle];
            vec3 lastv = [self MapToLayerCenter:lastPoint];
            vec3 middlev = [self middleOfV1:firstv V2:lastv];
            
            //NSLog(@"Point33[0]%f %f %f ",firstv.x,firstv.y,firstv.z);
            //NSLog(@"Point33[1]%f %f %f ",middlev.x,middlev.y,middlev.z);
            //NSLog(@"Point33[2]%f %f %f ",lastv.x,lastv.y,lastv.z);
            //标记启动自动调整
            //double angle = fingerRotate_angle*360/Pi;
            if (fingerRotate_angle>135) {
                isNeededToUpadteTwice = YES;
            }
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
                //NSLog(@"cosay:%f",cosa);
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
            if (isNeededToUpdateMagicCubeState) {
                //加入命令队列
                //添加command到NSUndoManger
                LayerRotationDirectionType commandaxis = current_rotate_direction;
                if (fingerRotate_angle>90&&fingerRotate_angle_mod90<45) {
                    if(commandaxis==CCW){
                        commandaxis=CW;
                    }else {
                        commandaxis=CCW;
                    }
                }
                NSInvocation *doinvocation = [self createInvocationOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:commandaxis isTribleRotate:NO];
                                
                if(commandaxis==CCW){
                    commandaxis=CW;
                }else {
                    commandaxis=CCW;
                }
                NSInvocation *undoinvocation = [self createInvocationOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:commandaxis isTribleRotate:NO];
               [self addInvocation:doinvocation withUndoInvocation:undoinvocation];
                //当旋转180度
                if (isNeededToUpadteTwice) {
                    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatetweice) userInfo:self repeats:NO];
                }

            }
            //标记手动转动结束
            isNeededToAdjustment = YES;
            isLayerRotating = NO;
            firstThreePointCount = 0;
            if (selected != nil) {
                //selected.scale = MCPointMake(30, 30, 30);
                selected = nil;
            }
            
            break;
        }
        case kState_S2:{
            if (isAutoRotate||is_TECH_MODE_Rotate) {
                return;
            }
            isLayerRotating = NO;
            firstThreePointCount = 0;
            if ([self usingMode] == PLAY_MODE||[self usingMode] ==SOlVE_Input_MODE) {
            //自由模式下，无限制操作
                if ([touches count]==2) {
                    UITouch *touch0 = [[touches allObjects] objectAtIndex:0];
                    UITouch *touch1 = [[touches allObjects] objectAtIndex:1];
                    CGPoint location = [touch0 previousLocationInView:view];
                    CGPoint location1 = [touch1 previousLocationInView:view];
                    m_spinning = YES;
                    m_fingerStart.x =(location.x+location1.x)/2;
                    m_fingerStart.y =(location.y+location1.y)/2;
                }else{
                    UITouch *touch0 = [[touches allObjects] objectAtIndex:0];
                    CGPoint location = [touch0 previousLocationInView:view];
                    m_spinning = YES;
                    m_fingerStart.x =location.x;
                    m_fingerStart.y =location.y;
                }
                        
                for (Cube *tmp in array27Cube) {
                    [tmp setQuaPreviousRotation:[tmp quaRotation]];
                }
                
            }
            else if([self usingMode] == TECH_MODE){
                //教学模式下，进行严格限制
                //记录第一个点
                //CGPoint location = [touch locationInView:view];
                //m_spinning = YES;
                //if ([touches count]!=2) return;
                UITouch *touch0 = [[touches allObjects] objectAtIndex:0];
                CGPoint location = [touch0 previousLocationInView:view];
                firstThreePoint[0].x =location.x;
                firstThreePoint[0].y =location.y;
                //firstThreePointCount++;
            }
            break;
        }
        case kState_M2:{
            if (isAutoRotate||is_TECH_MODE_Rotate) {
                return;
            }
            if ([self usingMode] == PLAY_MODE||[self usingMode] ==SOlVE_Input_MODE) {
                //自由模式下，无限制操作
                CGPoint current;
                if ([touches count]==2) {
                    
                    UITouch *touch0 = [[touches allObjects] objectAtIndex:0];
                    UITouch *touch1 = [[touches allObjects] objectAtIndex:1];
                    CGPoint current0 = [touch0 locationInView:view];
                    CGPoint current1 = [touch1 locationInView:view];
                    current = CGPointMake((current0.x+current1.x)/2,(current0.y+current1.y)/2);
                }
                //ivec2 oldLocation = ivec2(previous.x,previous.y);
                ivec2 newLocation = ivec2(current.x,current.y);
                if (fsm_Previous_State == kState_S2) {
                    m_fingerStart = newLocation;
                }
                if (m_spinning) {
                    vec3 start = [self MapToSphere: m_fingerStart];
                    vec3 end =[self MapToSphere:newLocation];
                    Quaternion delta = Quaternion::CreateFromVectors(start, end);
                    for (Cube *tmp in array27Cube) {
                        [tmp setQuaRotation: delta.Rotated([tmp quaPreviousRotation])];
                    }
                }
            }
            else if([self usingMode] == TECH_MODE ){
                //教学模式下，进行严格限制
                //if ([touches count]!=2) return;
            }
        }
        break;
    
    
        case kState_F2:{
            if (isAutoRotate||is_TECH_MODE_Rotate) {
                return;
            }
            if ([self usingMode] == PLAY_MODE||[self usingMode] ==SOlVE_Input_MODE) {
                //自由模式下，无限制操作
                firstThreePointCount = 0;
                m_spinning = NO;
            }
            else if([self usingMode] == TECH_MODE ){
                //教学模式下，进行严格限制
                //确定旋转方向
                //使用第一点 和 最后一个点 及他们点中间点 在轨迹圆上形成轨迹弧
                //三点确定两个向量，他们进行差乘，再和法向量进行点乘 由正负确定转向
                UITouch *touch0 = [[touches allObjects] objectAtIndex:0];
                CGPoint location = [touch0 previousLocationInView:view];
                firstThreePoint[1] = vec2(location.x,location.y);
                AxisType fuzzy_axis_x;
                AxisType fuzzy_axis_y;
                AxisType fuzzy_axis_z;
                AxisType fuzzy_axis;
                LayerRotationDirectionType fuzzy_direction;
                if(MaxDistance<VectorPointDistance(firstThreePoint[0], firstThreePoint[1])){
                    //移动超过预定值旋转！
                    isNeededToUpdateMagicCubeState = YES;
                    
                    vec3 fuzzy_vec3_x;
                    vec3 fuzzy_vec3_y;
                    vec3 fuzzy_vec3_z;
                    //找到fuzzy——y
                    float xyz[9] = {1.0,0.0,0.0,
                        0.0,1.0,0.0,
                        0.0,0.0,1.0};
                    CGFloat * tmp_matrix = (CGFloat *) malloc(16 * sizeof(CGFloat));
                    Cube * centerCube = [array27Cube objectAtIndex:13];
                    GLfloat * XYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, centerCube.matrix);
                    
                    vec3 center_ox = vec3(XYZ[0],XYZ[1],XYZ[2]);
                    vec3 center_oy = vec3(XYZ[3],XYZ[4],XYZ[5]);
                    vec3 center_oz = vec3(XYZ[6],XYZ[7],XYZ[8]);
                    
                    GLfloat *tmpXYZ;
                    vec3 tmp_ox ;
                    vec3 tmp_oy ;
                    vec3 tmp_oz ;
                    glPushMatrix();
                    glLoadIdentity();
                    //mat4 matRotation = centerCube.quaRotation.ToMatrix();
                    //glMultMatrixf(matRotation.Pointer());
                    glRotatef(centerCube.prerotation.x, 1.0f, 0.0f, 0.0f);
                    glRotatef(centerCube.prerotation.y, 0.0f, 1.0f, 0.0f);
                    glRotatef(centerCube.prerotation.z, 0.0f, 0.0f, 1.0f);
                    glRotatef(centerCube.rotation.x, 1.0f, 0.0f, 0.0f);
                    glRotatef(centerCube.rotation.y, 0.0f, 1.0f, 0.0f);
                    glRotatef(centerCube.rotation.z, 0.0f, 0.0f, 1.0f);
                    glScalef(centerCube.scale.x, centerCube.scale.y, centerCube.scale.z);
                    glGetFloatv(GL_MODELVIEW_MATRIX, tmp_matrix);
                    glPopMatrix();
                    tmpXYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmp_matrix);
                    tmp_ox = vec3(tmpXYZ[0],tmpXYZ[1],tmpXYZ[2]);
                    tmp_oy = vec3(tmpXYZ[3],tmpXYZ[4],tmpXYZ[5]);
                    tmp_oz = vec3(tmpXYZ[6],tmpXYZ[7],tmpXYZ[8]);
                    
                    //处理相对于中心x轴的模糊Y轴
                    float angle_centerox_OY = FabsThetaBetweenV1andV2(center_ox, tmp_oy);
                    float angle_centeroy_OY = FabsThetaBetweenV1andV2(center_oy, tmp_oy);
                    float angle_centeroz_OY = FabsThetaBetweenV1andV2(center_oz, tmp_oy);
                    
                    //处理相对于中心x轴的模糊x轴
                    float angle_centerox_OX = FabsThetaBetweenV1andV2(center_ox, tmp_ox);
                    float angle_centeroy_OX = FabsThetaBetweenV1andV2(center_oy, tmp_ox);
                    float angle_centeroz_OX = FabsThetaBetweenV1andV2(center_oz, tmp_ox);
                    
                    //处理相对于中心x轴的模糊x轴
                    float angle_centerox_OZ = FabsThetaBetweenV1andV2(center_ox, tmp_oz);
                    float angle_centeroy_OZ = FabsThetaBetweenV1andV2(center_oy, tmp_oz);
                    float angle_centeroz_OZ = FabsThetaBetweenV1andV2(center_oz, tmp_oz);
                    
                    //fuzzy_y
                    if (angle_centerox_OY<angle_centeroy_OY) {
                        if (angle_centerox_OY<angle_centeroz_OY) {
                            fuzzy_vec3_y = center_ox;
                            fuzzy_axis_y = X;
                        }else{
                            fuzzy_vec3_y = center_oz;
                            fuzzy_axis_y = Z;
                        }
                    }else{
                        if(angle_centeroy_OY<angle_centeroz_OY){
                            fuzzy_vec3_y = center_oy;
                            fuzzy_axis_y = Y;
                        }else{
                            fuzzy_vec3_y = center_oz;
                            fuzzy_axis_y = Z;
                        }
                    }
                    
                    
                    //fuzzy_x
                    if (angle_centerox_OX<angle_centeroy_OX) {
                        if (angle_centerox_OX<angle_centeroz_OX) {
                            fuzzy_vec3_x = center_ox;
                            fuzzy_axis_x = X;
                        }else{
                            fuzzy_vec3_x = center_oz;
                            fuzzy_axis_x = Z;
                        }
                    }else {
                        if(angle_centeroy_OX<angle_centeroz_OX){
                            fuzzy_vec3_x = center_oy;
                            fuzzy_axis_x = Y;
                        }else{
                            fuzzy_vec3_x = center_oz;
                            fuzzy_axis_x = Z;
                        }
                    }
                    
                    //fuzzy_z
                    if (angle_centerox_OZ<angle_centeroy_OZ) {
                        if (angle_centerox_OZ<angle_centeroz_OZ) {
                            fuzzy_vec3_z = center_ox;
                            fuzzy_axis_z = X;
                        }else{
                            fuzzy_vec3_z = center_oz;
                            fuzzy_axis_z = Z;
                        }
                    }else {
                        if(angle_centeroy_OZ<angle_centeroz_OZ){
                            fuzzy_vec3_z = center_oy;
                            fuzzy_axis_z = Y;
                        }else{
                            fuzzy_vec3_z = center_oz;
                            fuzzy_axis_z = Z;
                        }
                    }
                    
                    //确定旋转方向
                    if (fabs((firstThreePoint[0].x-firstThreePoint[1].x))>fabs((firstThreePoint[0].y-firstThreePoint[1].y))) {
                        //横向操作
                        fuzzy_axis = fuzzy_axis_y;
                        if ((firstThreePoint[1].x-firstThreePoint[0].x)>0) {
                            //向右
                            if(fuzzy_vec3_y.Dot(tmp_oy)>0)fuzzy_direction=CCW;
                            else fuzzy_direction=CW;
                        }else{
                            if(fuzzy_vec3_y.Dot(tmp_oy)>0)fuzzy_direction=CW;
                            else fuzzy_direction=CCW;
                        }
                    }else{
                        //素直向操作
                        if (firstThreePoint[1].x>512&&firstThreePoint[0].x>512) {
                            //右边
                            fuzzy_axis = (AxisType)fuzzy_axis_z;
                            if ((firstThreePoint[1].y-firstThreePoint[0].y)>0) {
                                //向下
                                if(fuzzy_vec3_z.Dot(tmp_oz)>0)fuzzy_direction=CW;
                                else fuzzy_direction=CCW;
                            }else{
                                //向上
                                if(fuzzy_vec3_z.Dot(tmp_oz)>0)fuzzy_direction=CCW;
                                else fuzzy_direction=CW;
                            }
                            
                        }else if(firstThreePoint[1].x<512&&firstThreePoint[0].x<512){
                            //左边
                            fuzzy_axis = fuzzy_axis_x;
                            if ((firstThreePoint[1].y-firstThreePoint[0].y)>0) {
                                //向下
                                if(fuzzy_vec3_x.Dot(tmp_ox)>0)fuzzy_direction=CCW;
                                else fuzzy_direction=CW;
                            }else{
                                //向上
                                if(fuzzy_vec3_z.Dot(tmp_oz)>0)fuzzy_direction=CW;
                                else fuzzy_direction=CCW;
                            }
                        }else return;
                        
                    }
                
                    current_rotate_axis = fuzzy_axis;
                    current_rotate_direction = fuzzy_direction;
                //旋转模型
                    [self rotateOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:current_rotate_direction isTribleRotate:YES];
                    if (isNeededToUpdateMagicCubeState) {
                        //加入命令队列
                        //添加command到NSUndoManger
                        LayerRotationDirectionType commandaxis = current_rotate_direction;
                    
                        NSInvocation *doinvocation = [self createInvocationOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:commandaxis isTribleRotate:YES];
                    
                        if(commandaxis==CCW){
                            commandaxis=CW;
                        }else {
                            commandaxis=CCW;
                        }
                        NSInvocation *undoinvocation = [self createInvocationOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:commandaxis isTribleRotate:YES];
                        [self addInvocation:doinvocation withUndoInvocation:undoinvocation];
                    
                    }
                }
                is_TECH_MODE_Rotate = NO;
                //自由模式下，无限制操作
                firstThreePointCount = 0;
                //firstThreePoint[0].x = 512;
                //firstThreePoint[1].x = 512;
                //firstThreePoint[0].y = 384;
                //firstThreePoint[1].y = 384;
                if (selected != nil) {
                    //selected.scale = MCPointMake(30, 30, 30);
                    selected = nil;
                }

            }
            break;
        }
        default:
            break;
    }
}
-(void)updatetweice{
    LayerRotationDirectionType commandaxis = current_rotate_direction;
    if (fingerRotate_angle>90&&fingerRotate_angle_mod90<45) {
        if(commandaxis==CCW){
            commandaxis=CW;
        }else {
            commandaxis=CCW;
        }
    }
    NSInvocation *doinvocation = [self createInvocationOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:commandaxis isTribleRotate:NO];
    
    if(commandaxis==CCW){
        commandaxis=CW;
    }else {
        commandaxis=CCW;
    }
    NSInvocation *undoinvocation = [self createInvocationOnAxis:current_rotate_axis onLayer:current_rotate_layer inDirection:commandaxis isTribleRotate:NO];
    [self addInvocation:doinvocation withUndoInvocation:undoinvocation];
};

-(vec3)MapToSphere:(vec2 )touchpoint
{
    
    //ivec2 m_centerPoint = ivec2(384+translation.y,512+translation.x);
    vec2 m_centerPoint = vec2(512+translation.x,384+translation.y);
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

-(vec3)MapToLayerCenter:(vec2 )touchpoint
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
    vec2 layer_center_2D = vec2(layer_center.x,layer_center.y);
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
    //vec3 mapped = vec3(map.x,map.y,fabs(map.z));
    float ratio = sqrt((mapped.x*mapped.x +mapped.y*mapped.y+ mapped.z*mapped.z)/(radius*radius));
    return (mapped / ratio) / radius;
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
    //target performSelector:<#(SEL)#> withObject:<#(id)#>
}


-(void)updateState{
    if (isTribleAutoRotateIn_TECH_MODE) {
        
    }else{
        if (isAddStepWhenUpdateState) {
            [self stepCounterAdd];
        }else {
            [self stepCounterMinus];
            isAddStepWhenUpdateState = true;
        }
    }
    //通知场景控制器，更新数据模型。
    SingmasterNotation notation;
    if (isTribleAutoRotateIn_TECH_MODE) {
        notation =[MCTransformUtil getSingmasterNotationFromAxis:current_rotate_axis layer:NO_SELECTED_LAYER direction:current_rotate_direction];
    }else{
        notation =[MCTransformUtil getSingmasterNotationFromAxis:current_rotate_axis layer:current_rotate_layer direction:current_rotate_direction];
    }
    
    if ([target respondsToSelector:@selector(rotate:)]) {
       
        RotateNotationType currentRotateType = [MCTransformUtil getRotateNotationTypeWithSingmasterNotation:notation];
        //是否处于两层连动状态
        if (currentRotateType.type == Single||currentRotateType.type == SingleTwoTimes) {
            twoLayerFlag[currentRotateType.layer] = NO;
        }
        RotateType * rotateType = [[RotateType alloc]init];
        [rotateType setNotation:notation];
        [target performSelector:@selector(rotate:) withObject:rotateType];
    }
    
    if (current_rotate_layer == NO_SELECTED_LAYER) {
        //三次更新状态缩影index
        current_rotate_layer = 0;
        [self updateMagicCubeIndexState];
         [self adjustWithCenter];
        current_rotate_layer = 1;
        [self updateMagicCubeIndexState];
         [self adjustWithCenter];
        current_rotate_layer = 2;
        [self updateMagicCubeIndexState];
         [self adjustWithCenter];
        //通知更新数据模型
    }else{
        [self updateMagicCubeIndexState];
        [self adjustWithCenter];
    }
    
}
-(void)updateMagicCubeIndexState{
    return;
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
#pragma mark undo and redo

//创建撤销操作点NSInvocation对象
-(NSInvocation *)createInvocationOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction isTribleRotate:(BOOL)is_trible_roate{
    NSMethodSignature *executeMethodSinature = [self methodSignatureForSelector:@selector(rotateOnAxis:onLayer:inDirection:isTribleRotate:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:executeMethodSinature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(rotateOnAxis:onLayer:inDirection:isTribleRotate:)];
    [invocation setArgument: &axis atIndex:2];
    [invocation setArgument:&layer atIndex:3];
    [invocation setArgument:&direction atIndex:4];
    [invocation setArgument:&is_trible_roate atIndex:5];
    return invocation;
}


//手动转动时 添加但是不执行
-(void)addInvocation:(NSInvocation *)invocation
      withUndoInvocation:(NSInvocation *)undoInvocation{
    [invocation retainArguments];
    [[self.undoManger prepareWithInvocationTarget:self] unexecuteInvocation:undoInvocation withRedoInvocation:invocation];
}
//正常撤销
-(void)executeInvocation:(NSInvocation *)invocation
      withUndoInvocation:(NSInvocation *)undoInvocation{
    [invocation retainArguments];
    [[self.undoManger prepareWithInvocationTarget:self] unexecuteInvocation:undoInvocation withRedoInvocation:invocation];
    [invocation invoke];
}
//正常恢复
-(void)unexecuteInvocation:(NSInvocation *)invocation
      withRedoInvocation:(NSInvocation *)redoInvocation{
    [[self.undoManger prepareWithInvocationTarget:self] executeInvocation:redoInvocation withUndoInvocation:invocation];
    [invocation invoke];
}
#pragma mark final adjust
-(void)adjustWithCenter{
    
    float xyz[9] = {1.0,0.0,0.0,
                    0.0,1.0,0.0,
                    0.0,0.0,1.0};
    Cube * centerCube = [array27Cube objectAtIndex:13];
    GLfloat * XYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, centerCube.matrix);
    vec3 center_ox = vec3(XYZ[0],XYZ[1],XYZ[2]);
    vec3 center_oy = vec3(XYZ[3],XYZ[4],XYZ[5]);
    //vec3 center_oz = vec3(XYZ[6],XYZ[7],XYZ[8]);
    CGFloat * tmp_matrix = (CGFloat *) malloc(16 * sizeof(CGFloat));
    for (int i = 0; i < 9; i++) {
        if (true ) {
            //Cube *tmpCube = [array27Cube objectAtIndex:i];
            Cube *tmpCube = layerPtr[i];
            GLfloat *tmpXYZ;
            vec3 tmp_ox ;
            vec3 tmp_oy ;
            vec3 tmp_oz ;
            if (current_rotate_axis==Y || current_rotate_axis ==Z) {
            
            glPushMatrix();
            glLoadIdentity();
            mat4 matRotation = tmpCube.quaRotation.ToMatrix();
            glMultMatrixf(matRotation.Pointer());
            glRotatef(tmpCube.prerotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(tmpCube.prerotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(tmpCube.prerotation.z, 0.0f, 0.0f, 1.0f);
            glRotatef(tmpCube.rotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(tmpCube.rotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(tmpCube.rotation.z, 0.0f, 0.0f, 1.0f);
            glScalef(tmpCube.scale.x, tmpCube.scale.y, tmpCube.scale.z);
            glGetFloatv(GL_MODELVIEW_MATRIX, tmp_matrix);
            glPopMatrix();
            tmpXYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmp_matrix);
             tmp_ox = vec3(tmpXYZ[0],tmpXYZ[1],tmpXYZ[2]);
             tmp_oy = vec3(tmpXYZ[3],tmpXYZ[4],tmpXYZ[5]);
             tmp_oz = vec3(tmpXYZ[6],tmpXYZ[7],tmpXYZ[8]);
            //处理相对于中心x轴的模糊x轴
            float angle_ox_centerOX = FabsThetaBetweenV1andV2(tmp_ox, center_ox);
            float angle_oy_centerOX = FabsThetaBetweenV1andV2(tmp_oy, center_ox);
            float angle_oz_centerOX = FabsThetaBetweenV1andV2(tmp_oz, center_ox);
            //模糊x轴
            vec3 fuzzy_ox = (angle_ox_centerOX < angle_oy_centerOX )? (angle_ox_centerOX<angle_oz_centerOX)?tmp_ox:tmp_oz : (angle_oy_centerOX < angle_oz_centerOX )? tmp_oy :tmp_oz ;
            
            float signOFfuzzyOXandcenterOX = fuzzy_ox.Dot(center_ox);
            //NSLog(@"signOFfuzzyOXandcenterOX:%f",signOFfuzzyOXandcenterOX);
            if (signOFfuzzyOXandcenterOX<0.0001) {
                //负数代表两向量相反
                //1 获取 fuzzy_ox 的 反向量
                vec3 inverse_fuzzy_ox = (-fuzzy_ox);
                //if (FabsThetaBetweenV1andV2(inverse_fuzzy_ox, center_ox)>0.01)
                {
                    //x1
                Quaternion delta = Quaternion::CreateFromVectors(inverse_fuzzy_ox, center_ox);
                [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                }
            }else{
                //同向，开始微调
                //if (FabsThetaBetweenV1andV2(fuzzy_ox, center_ox)>0.01)
                {
                    //x2
                Quaternion delta = Quaternion::CreateFromVectors(fuzzy_ox, center_ox);
                [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                }
            }
            }
            //continue;
            if (current_rotate_axis==X) {
        
            
            glPushMatrix();
            glLoadIdentity();
            //glTranslatef(pretranslation.x, pretranslation.y, pretranslation.z);
            mat4 matRotation2 = tmpCube.quaRotation.ToMatrix();
            glMultMatrixf(matRotation2.Pointer());
            glRotatef(tmpCube.prerotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(tmpCube.prerotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(tmpCube.prerotation.z, 0.0f, 0.0f, 1.0f);
            //glTranslatef(tmpCube.translation.x, tmpCube.translation.y, tmpCube.translation.z);
            glRotatef(tmpCube.rotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(tmpCube.rotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(tmpCube.rotation.z, 0.0f, 0.0f, 1.0f);
            glScalef(tmpCube.scale.x, tmpCube.scale.y, tmpCube.scale.z);
            glGetFloatv(GL_MODELVIEW_MATRIX, tmp_matrix);
            glPopMatrix();
            tmpXYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmp_matrix);
            tmp_ox = vec3(tmpXYZ[0],tmpXYZ[1],tmpXYZ[2]);
            tmp_oy = vec3(tmpXYZ[3],tmpXYZ[4],tmpXYZ[5]);
            tmp_oz = vec3(tmpXYZ[6],tmpXYZ[7],tmpXYZ[8]);
            float angle_ox_centerOY = FabsThetaBetweenV1andV2(tmp_ox, center_oy);
            float angle_oy_centerOY = FabsThetaBetweenV1andV2(tmp_oy, center_oy);
            float angle_oz_centerOY = FabsThetaBetweenV1andV2(tmp_oz, center_oy);
            vec3 fuzzy_oy = (angle_ox_centerOY < angle_oy_centerOY )? (angle_ox_centerOY<angle_oz_centerOY)?tmp_ox:tmp_oz : (angle_oy_centerOY < angle_oz_centerOY )? tmp_oy :tmp_oz ;
            float signOFfuzzyOYandcenterOY = fuzzy_oy.Dot(center_oy);
            if (signOFfuzzyOYandcenterOY<0.0001) {
                //负数代表两向量相反
                vec3 inverse_fuzzy_oy = (-fuzzy_oy);
               // if (FabsThetaBetweenV1andV2(inverse_fuzzy_oy, center_oy)>0.01)
                {
                    //y1
                Quaternion delta = Quaternion::CreateFromVectors(inverse_fuzzy_oy, center_oy);
                [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                }
            }else{
                //同向，开始微调
              //  if (FabsThetaBetweenV1andV2(fuzzy_oy, center_oy)>0.01)
                {
                    //y2
                Quaternion delta = Quaternion::CreateFromVectors(fuzzy_oy, center_oy);
                [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                    [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                }
            }
            }
        }
        
    }
    free(tmp_matrix);
}
#pragma mark final adjust
-(void)adjustWithCenter_2{
    float xyz[9] = {1.0,0.0,0.0,
        0.0,1.0,0.0,
        0.0,0.0,1.0};
    Cube * centerCube = [array27Cube objectAtIndex:13];
    GLfloat * XYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, centerCube.matrix);
    vec3 center_ox = vec3(XYZ[0],XYZ[1],XYZ[2]);
    vec3 center_oy = vec3(XYZ[3],XYZ[4],XYZ[5]);
    vec3 center_oz = vec3(XYZ[6],XYZ[7],XYZ[8]);
    CGFloat * tmp_matrix = (CGFloat *) malloc(16 * sizeof(CGFloat));
    for (int i = 0; i < 27; i++) {
        if (i!=13 ) {
            //Cube *tmpCube = [array27Cube objectAtIndex:i];
            //Cube *tmpCube = layerPtr[i];
            Cube *tmpCube = MagicCubeIndexState[i];
            GLfloat *tmpXYZ;
            vec3 tmp_ox ;
            vec3 tmp_oy ;
            vec3 tmp_oz ;
            
            //先对齐x轴
                glPushMatrix();
                glLoadIdentity();
                mat4 matRotation = tmpCube.quaRotation.ToMatrix();
                glMultMatrixf(matRotation.Pointer());
                glRotatef(tmpCube.prerotation.x, 1.0f, 0.0f, 0.0f);
                glRotatef(tmpCube.prerotation.y, 0.0f, 1.0f, 0.0f);
                glRotatef(tmpCube.prerotation.z, 0.0f, 0.0f, 1.0f);
                glRotatef(tmpCube.rotation.x, 1.0f, 0.0f, 0.0f);
                glRotatef(tmpCube.rotation.y, 0.0f, 1.0f, 0.0f);
                glRotatef(tmpCube.rotation.z, 0.0f, 0.0f, 1.0f);
                glScalef(tmpCube.scale.x, tmpCube.scale.y, tmpCube.scale.z);
                glGetFloatv(GL_MODELVIEW_MATRIX, tmp_matrix);
                glPopMatrix();
                tmpXYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmp_matrix);
                tmp_ox = vec3(tmpXYZ[0],tmpXYZ[1],tmpXYZ[2]);
                tmp_oy = vec3(tmpXYZ[3],tmpXYZ[4],tmpXYZ[5]);
                tmp_oz = vec3(tmpXYZ[6],tmpXYZ[7],tmpXYZ[8]);
                //处理相对于中心x轴的模糊x轴
                float angle_ox_centerOX = FabsThetaBetweenV1andV2(tmp_ox, center_ox);
                float angle_oy_centerOX = FabsThetaBetweenV1andV2(tmp_oy, center_ox);
                float angle_oz_centerOX = FabsThetaBetweenV1andV2(tmp_oz, center_ox);
                //模糊x轴
                vec3 fuzzy_ox = (angle_ox_centerOX < angle_oy_centerOX )? (angle_ox_centerOX<angle_oz_centerOX)?tmp_ox:tmp_oz : (angle_oy_centerOX < angle_oz_centerOX )? tmp_oy :tmp_oz ;
                
                float signOFfuzzyOXandcenterOX = fuzzy_ox.Dot(center_ox);
                //NSLog(@"signOFfuzzyOXandcenterOX:%f",signOFfuzzyOXandcenterOX);
                if (signOFfuzzyOXandcenterOX<0.0001) {
                    //负数代表两向量相反
                    //1 获取 fuzzy_ox 的 反向量
                    vec3 inverse_fuzzy_ox = (-fuzzy_ox);
                    //if (FabsThetaBetweenV1andV2(inverse_fuzzy_ox, center_ox)>0.01)
                    {
                        //x1
                        Quaternion delta = Quaternion::CreateFromVectors(inverse_fuzzy_ox, center_ox);
                        [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                        [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                    }
                }else{
                    //同向，开始微调
                    //if (FabsThetaBetweenV1andV2(fuzzy_ox, center_ox)>0.01)
                    {
                        //x2
                        Quaternion delta = Quaternion::CreateFromVectors(fuzzy_ox, center_ox);
                        [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                        [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                    }
                }
           
            //对齐y轴
                
                
                glPushMatrix();
                glLoadIdentity();
                //glTranslatef(pretranslation.x, pretranslation.y, pretranslation.z);
                mat4 matRotation2 = tmpCube.quaRotation.ToMatrix();
                glMultMatrixf(matRotation2.Pointer());
                glRotatef(tmpCube.prerotation.x, 1.0f, 0.0f, 0.0f);
                glRotatef(tmpCube.prerotation.y, 0.0f, 1.0f, 0.0f);
                glRotatef(tmpCube.prerotation.z, 0.0f, 0.0f, 1.0f);
                //glTranslatef(tmpCube.translation.x, tmpCube.translation.y, tmpCube.translation.z);
                glRotatef(tmpCube.rotation.x, 1.0f, 0.0f, 0.0f);
                glRotatef(tmpCube.rotation.y, 0.0f, 1.0f, 0.0f);
                glRotatef(tmpCube.rotation.z, 0.0f, 0.0f, 1.0f);
                glScalef(tmpCube.scale.x, tmpCube.scale.y, tmpCube.scale.z);
                glGetFloatv(GL_MODELVIEW_MATRIX, tmp_matrix);
                glPopMatrix();
                tmpXYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmp_matrix);
                tmp_ox = vec3(tmpXYZ[0],tmpXYZ[1],tmpXYZ[2]);
                tmp_oy = vec3(tmpXYZ[3],tmpXYZ[4],tmpXYZ[5]);
                tmp_oz = vec3(tmpXYZ[6],tmpXYZ[7],tmpXYZ[8]);
                float angle_ox_centerOY = FabsThetaBetweenV1andV2(tmp_ox, center_oy);
                float angle_oy_centerOY = FabsThetaBetweenV1andV2(tmp_oy, center_oy);
                float angle_oz_centerOY = FabsThetaBetweenV1andV2(tmp_oz, center_oy);
                vec3 fuzzy_oy = (angle_ox_centerOY < angle_oy_centerOY )? (angle_ox_centerOY<angle_oz_centerOY)?tmp_ox:tmp_oz : (angle_oy_centerOY < angle_oz_centerOY )? tmp_oy :tmp_oz ;
                float signOFfuzzyOYandcenterOY = fuzzy_oy.Dot(center_oy);
                if (signOFfuzzyOYandcenterOY<0.0001) {
                    //负数代表两向量相反
                    vec3 inverse_fuzzy_oy = (-fuzzy_oy);
                    // if (FabsThetaBetweenV1andV2(inverse_fuzzy_oy, center_oy)>0.01)
                    {
                        //y1
                        Quaternion delta = Quaternion::CreateFromVectors(inverse_fuzzy_oy, center_oy);
                        [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                        [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                    }
                }else{
                    //同向，开始微调
                    //  if (FabsThetaBetweenV1andV2(fuzzy_oy, center_oy)>0.01)
                    {
                        //y2
                        Quaternion delta = Quaternion::CreateFromVectors(fuzzy_oy, center_oy);
                        [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                        [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                    }
                }
            
            //对齐z轴
            
            
            glPushMatrix();
            glLoadIdentity();
            //glTranslatef(pretranslation.x, pretranslation.y, pretranslation.z);
            mat4 matRotation3 = tmpCube.quaRotation.ToMatrix();
            glMultMatrixf(matRotation3.Pointer());
            glRotatef(tmpCube.prerotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(tmpCube.prerotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(tmpCube.prerotation.z, 0.0f, 0.0f, 1.0f);
            //glTranslatef(tmpCube.translation.x, tmpCube.translation.y, tmpCube.translation.z);
            glRotatef(tmpCube.rotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(tmpCube.rotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(tmpCube.rotation.z, 0.0f, 0.0f, 1.0f);
            glScalef(tmpCube.scale.x, tmpCube.scale.y, tmpCube.scale.z);
            glGetFloatv(GL_MODELVIEW_MATRIX, tmp_matrix);
            glPopMatrix();
            tmpXYZ = VertexesArray_Matrix_Multiply(xyz, 3, 3, tmp_matrix);
            tmp_ox = vec3(tmpXYZ[0],tmpXYZ[1],tmpXYZ[2]);
            tmp_oy = vec3(tmpXYZ[3],tmpXYZ[4],tmpXYZ[5]);
            tmp_oz = vec3(tmpXYZ[6],tmpXYZ[7],tmpXYZ[8]);
            float angle_ox_centerOZ = FabsThetaBetweenV1andV2(tmp_ox, center_oz);
            float angle_oy_centerOZ = FabsThetaBetweenV1andV2(tmp_oy, center_oz);
            float angle_oz_centerOZ = FabsThetaBetweenV1andV2(tmp_oz, center_oz);
            vec3 fuzzy_oz = (angle_ox_centerOZ < angle_oy_centerOZ )? (angle_ox_centerOZ<angle_oz_centerOZ)?tmp_ox:tmp_oz : (angle_oy_centerOZ < angle_oz_centerOZ )? tmp_oy :tmp_oz ;
            float signOFfuzzyOYandcenterOZ = fuzzy_oz.Dot(center_oz);
            if (signOFfuzzyOYandcenterOZ<0.0001) {
                //负数代表两向量相反
                vec3 inverse_fuzzy_oz = (-fuzzy_oz);
                // if (FabsThetaBetweenV1andV2(inverse_fuzzy_oy, center_oy)>0.01)
                {
                    //y1
                    Quaternion delta = Quaternion::CreateFromVectors(inverse_fuzzy_oz, center_oz);
                    [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                    [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                }
            }else{
                //同向，开始微调
                //  if (FabsThetaBetweenV1andV2(fuzzy_oy, center_oy)>0.01)
                {
                    //y2
                    Quaternion delta = Quaternion::CreateFromVectors(fuzzy_oz, center_oz);
                    [tmpCube setQuaPreviousRotation:[tmpCube quaRotation]];
                    [tmpCube setQuaRotation:delta.Rotated([tmpCube quaPreviousRotation])];
                }
            }

          //  }
        }
        
    }
    free(tmp_matrix);
}
#pragma mark math
-(vec3)middleOfV1:(vec3)v1 V2:(vec3)v2{
    vec3 add = v1+v2;
    add.Normalize();
    return add;
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
double FabsThetaBetweenV1andV2(const vec3& v1,const vec3& v2)
{
    double cosa = v1.Dot(v2)/(v1.Module()*v2.Module());
    if (cosa>1) {
        return acos(1);
    }else if(cosa<-1){
        return acos(1);
    }else
    return acos(fabs(cosa));
}
//检测是否有小块被拾取。
-(BOOL)isSelectOneFace:(vec2)touchpoint{	
    //继续射线拾取
    float V[108] = {
        
        
        -0.5,0.5,0.5,     0.5,0.5,0.5,     0.5,0.5,-0.5,
        0.5,0.5,-0.5,   -0.5,0.5,-0.5,   -0.5,0.5,0.5,//上
        
        -0.5,-0.5,0.5,   -0.5,-0.5,-0.5,   0.5,-0.5,-0.5,
        0.5,-0.5,-0.5,   0.5,-0.5,0.5,    -0.5,-0.5,0.5,//下
        
        -0.5,0.5,0.5,    -0.5,-0.5,0.5,   0.5,-0.5,0.5,
        0.5,-0.5,0.5,    0.5,0.5,0.5,    -0.5,0.5,0.5,//前
        
        0.5,0.5,-0.5,    0.5,-0.5,-0.5,  -0.5,-0.5,-0.5,
        -0.5,-0.5,-0.5,  -0.5,0.5,-0.5,    0.5,0.5,-0.5,//后
        
        -0.5,0.5,-0.5,   -0.5,-0.5,-0.5,  -0.5,-0.5,0.5,
        -0.5,-0.5,0.5,   -0.5,0.5,0.5,    -0.5,0.5,-0.5,//左
        
        0.5,0.5,0.5,     0.5,-0.5,0.5,    0.5,-0.5,-0.5,
        0.5,-0.5,-0.5,   0.5,0.5,-0.5,    0.5,0.5,0.5,//右
        
    };
    
            //记录第一个点
           
    //Once function down, update the ray.
    [ray updateWithScreenX:touchpoint.x
                           screenY:touchpoint.y];
    float nearest_distance = 65535;
    selected_cube_index = -1;
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
                directionVector[0] = [ray pointIntersectWithTriangleMadeUpOfV0:&tmp_dection[0 +i*9]
                                                                                    V1:&tmp_dection[3 +i*9]
                                                                                    V2:&tmp_dection[6 +i*9]];
                nearest_distance = distance;
                selected_cube_index = tmp_cube.index;
                tmp_cube.index_selectedFace = i/2;
                selected_cube_face_index = i/2;
            }
        }
    }
    if (selected_cube_index != -1) {
        return YES;
    }else
        return NO;

};
-(void)closeSpaceIndicator{
    for (Cube *tmp in array27Cube) {
        [tmp setIsNeededToShowSpaceDirection:NO];
        [tmp setIsLocked:NO];
    }
}
- (void) nextSpaceIndicatorWithRotateNotationType:(struct RotateNotationType)rotationNotationType{
    for (Cube *tmp in array27Cube) {
        [tmp setIsNeededToShowSpaceDirection:NO];
    }
    if (rotationNotationType.type==Single || rotationNotationType.type == SingleTwoTimes) {
        //获取layer的对象指针
        switch (rotationNotationType.axis) {
            case X:
                
                for(int z = 0; z < 3; ++z)
                {
                    for(int y = 0; y < 3; ++y)
                    {
                        spaceIndicatorlayerPtr[y+z*3] = MagicCubeIndexState[z*9+y*3+rotationNotationType.layer];
                        
                    }
                }
                break;
            case Y:
                //change data
                for(int z = 0; z < 3; ++z)
                {
                    for(int x = 0; x < 3; ++x)
                    {
                        spaceIndicatorlayerPtr[x+z*3] = MagicCubeIndexState[z*9+rotationNotationType.layer*3+x];
                        
                    }
                }
                break;
            case Z:
                //change data
                for(int y = 0; y < 3; ++y)
                {
                    for(int x = 0; x < 3; ++x)
                    {
                        spaceIndicatorlayerPtr[x+y*3] = MagicCubeIndexState[rotationNotationType.layer*9+y*3+x];
                    }
                }
                break;
            default:
                break;
        }
        for (int i =0; i<9; i++) {
            [spaceIndicatorlayerPtr[i] setIsNeededToShowSpaceDirection:YES];
            [spaceIndicatorlayerPtr[i] setIndicator_axis:rotationNotationType.axis];
            [spaceIndicatorlayerPtr[i] setIndicator_direction:rotationNotationType.direction];

        }
    }else if(rotationNotationType.type == Double || rotationNotationType.type == DoubleTwoTimes){
        //两层
        if (twoLayerFlag[0]==NO&&twoLayerFlag[1]==NO&&twoLayerFlag[2]==NO) {
            twoLayerFlag[rotationNotationType.layer] = YES;
            twoLayerFlag[1] = YES;
        }
        for (int i = 0; i<3; i++) {
            if (twoLayerFlag[i]==YES) {
                RotateNotationType splitRotateNotation;
                splitRotateNotation.axis = rotationNotationType.axis;
                splitRotateNotation.layer = i;
                splitRotateNotation.direction = rotationNotationType.direction;
                splitRotateNotation.type = Single;
                [self nextSpaceIndicatorWithRotateNotationType:splitRotateNotation];
                break;
            }
        }
        
    }else{
        //三层
        for (Cube *tmp in array27Cube) {
            [tmp setIsNeededToShowSpaceDirection:YES];
            [tmp setIndicator_axis:rotationNotationType.axis];
            [tmp setIndicator_direction:rotationNotationType.direction];

        }
    }
   
};
#pragma mark undo redo

-(void)previousSolution{
    if(isAutoRotate)return;
    if (isLayerRotating) return;
    if (isAddStepWhenUpdateState) {
        isAddStepWhenUpdateState = false;
    }
    [[self undoManger] undo];
}
-(void)nextSolution{
    if(isAutoRotate)return;
    if (isLayerRotating) return;
    if (!isAddStepWhenUpdateState) {
        isAddStepWhenUpdateState = true;
    }
    [[self undoManger] redo];
}


@end
