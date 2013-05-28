//
//  MCTestPatternController.m
//  MagicCubeModel
//
//  Created by Aha on 13-1-2.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCRestoreModelController.h"

@implementation MCRestoreModelController{
    UIButton *clickedButton;
}


@synthesize cubieArray;

- (void)viewDidLoad {
    //all data in dictionaries
    NSMutableDictionary *cubieDics[27];
    for (int i = 0; i < 27; i++) {
        cubieDics[i] = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    
    self.cubieArray = [NSArray arrayWithObjects:cubieDics count:27];
    [super viewDidLoad];
}

- (void)dealloc {
    [super dealloc];
}


- (void)viewDidUnload {
    self.cubieArray = nil;
    [super viewDidUnload];
}


- (IBAction)selectOne:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self toggle:CGPointMake(button.frame.origin.x + button.frame.size.width/2,
                             button.frame.origin.y + button.frame.size.height/2)];
    [self.view bringSubviewToFront:button];
    if ([self isClosed]) {
        clickedButton = button;
    }
    else{
        clickedButton = nil;
    }
}

- (IBAction)saveState:(id)sender {
    MCMagicCube *magicCube = [MCMagicCube magicCubeWithCubiesData:cubieArray];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:TmpMagicCubeData];
    [NSKeyedArchiver archiveRootObject:magicCube toFile:fileName];
}

- (NSInteger)runButtonActions:(id)sender {
    if (clickedButton == nil) return -1;
    NSInteger tag = [super runButtonActions:sender];
    NSString *imageName = [NSString stringWithFormat:kKYICircleMenuButtonImageNameFormat, tag];
    [clickedButton setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    
    NSInteger targetTag = [clickedButton tag];
    NSInteger faceTag =targetTag / 10;
    NSInteger faceIndex = targetTag % 10;
    
    NSInteger targetX = 1, targetY = 1, targetZ = 1;
    
    switch (faceTag) {
        case 0:
            targetY = 2;
            
            targetX = faceIndex%3;
            targetZ = faceIndex/3;
            break;
        case 1:
            targetY = 0;
            
            targetX = faceIndex%3;
            targetZ = faceIndex/3;
            break;
        case 2:
            targetZ = 2;
            
            targetX = faceIndex%3;
            targetY = faceIndex/3;
            break;
        case 3:
            targetZ = 0;
            
            targetX = faceIndex%3;
            targetY = faceIndex/3;
            break;
        case 4:
            targetX = 0;
            
            targetY = faceIndex%3;
            targetZ = faceIndex/3;
            break;
        case 5:
            targetX = 2;
            
            targetY = faceIndex%3;
            targetZ = faceIndex/3;
            break;
    }
    
    [[cubieArray objectAtIndex:(targetX + targetY * 3 + targetZ * 9)] setObject:[NSNumber numberWithInteger:(tag-1)]
                                                                         forKey:[NSNumber numberWithInteger:faceTag]];
    
    return 1;
}




@end
