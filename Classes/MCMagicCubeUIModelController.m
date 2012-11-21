//
//  MCMagicCubeUIModelController.m
//  MCGame
//
//  Created by kwan terry on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMagicCubeUIModelController.h"
#import "TestCube.h"
@implementation MCMagicCubeUIModelController
@synthesize translation,rotation,scale,rotationalSpeed;

-(void)init{
    
    if (array27Cube == nil) array27Cube = [[NSMutableArray alloc] init];	
    
    scale = MCPointMake(90,90,90);
    translation = MCPointMake(0,0,0);
    //公转
    rotation = MCPointMake(0,0,0);
    
    MCPoint sub_scale  = MCPointMake(scale.x/3, scale.y/3, scale.z/3);
    
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    //符号
                    int sign_x = x-1;
                    int sign_y = y-1;
                    int sign_z = z-1;
                    TestCube * magicCube = [[TestCube alloc] init];
                    magicCube.translation = MCPointMake(sub_scale.x*sign_x+translation.x, sub_scale.y*sign_y+translation.z, sub_scale.z*sign_z+translation.z);
                    magicCube.scale = sub_scale;
                    magicCube.rotation = MCPointMake(0, 0, 0);
                    magicCube.rotationalSpeed = MCPointMake(0, 0, 0);
                    [array27Cube addObject: magicCube];
                    [magicCube release];		
                }
            }
        }
    }
};
-(void)rotate:(int)axis :(int)layer :(int)direction{
};
-(void)render{
};
-(void)update{
};
@end
