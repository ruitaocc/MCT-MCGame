//
//  MCCubieColorConstraintUtil.m
//  MCGame
//
//  Created by Aha on 13-6-9.
//
//

#import "MCCubieColorConstraintUtil.h"

@implementation MCCubieColorConstraintUtil

+ (NSArray *)avaiableColorsOfCubie:(NSObject<MCCubieDelegate> *)cubie{
    // If cubie has no colors, all colors are avaiable.
    BOOL counterTable[6] = {YES};
    
    // All avaiable colors will be here.
    NSMutableArray *avaiableColors = [NSMutableArray arrayWithCapacity:6];
    
    // According to colors owned by cubie, remove some avaiable colors.
    NSArray *allColors = [cubie allFaceColors];
    
    // num of completed colors
    int completedColorsNum = 0;
    for (NSNumber *color in allColors) {
        FaceColorType faceColor = (FaceColorType)[color integerValue];
        
        // no color
        if (faceColor == NoColor) continue;
        
        // Increase num of completed colors
        completedColorsNum++;
        for (int i = 0; i < 6; i++) {
            counterTable[i] = !counterTable[i];
        }
        if (faceColor % 2 == 0) {
            counterTable[faceColor+1] = !counterTable[faceColor+1];
        }
        else{
            counterTable[faceColor-1] = !counterTable[faceColor-1];
        }
        counterTable[faceColor] = !counterTable[faceColor];
    }
    
    if (completedColorsNum == 3) {
        return [NSArray arrayWithArray:avaiableColors];
    }
    
    for (int i = 0; i < 6; i++) {
        if (counterTable[i] == ((completedColorsNum == 2) ? YES : NO)) {
            [avaiableColors addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    return [NSArray arrayWithArray:avaiableColors];
}

@end
