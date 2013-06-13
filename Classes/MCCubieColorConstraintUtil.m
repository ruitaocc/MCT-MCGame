//
//  MCCubieColorConstraintUtil.m
//  MCGame
//
//  Created by Aha on 13-6-9.
//
//

#import "MCCubieColorConstraintUtil.h"

@implementation MCCubieColorConstraintUtil

+ (NSMutableArray *)avaiableColorsOfCubie:(NSObject<MCCubieDelegate> *)cubie
                            inOrientation:(FaceOrientationType)orientation{
    // If cubie has no colors, all colors are avaiable.
    BOOL counterTable[6] = {YES, YES, YES, YES, YES, YES};
    
    // All avaiable colors will be here.
    NSMutableArray *avaiableColors = [NSMutableArray arrayWithCapacity:6];
    
    // According to colors owned by cubie, remove some avaiable colors.
    NSArray *allColors = [cubie allFaceColors];
    NSArray *allOrientations = [cubie allOrientations];
    
    // num of completed colors
    int completedColorsNum = 0;
    int skinNum = [cubie skinNum];
    for (int i = 0; i < skinNum; i++) {
        // If the orientation is target orientation, ignore it.
        FaceOrientationType faceOrientation = (FaceOrientationType)[[allOrientations objectAtIndex:i] integerValue];
        if (faceOrientation == orientation) continue;
        
        // If it's NoColor, ignore it.
        FaceColorType faceColor = (FaceColorType)[[allColors objectAtIndex:i] integerValue];
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
    
    switch (completedColorsNum) {
        case 0:
        {
            for (int i = 0; i < 6; i++) {
                [avaiableColors addObject:[NSNumber numberWithInteger:i]];
            }
        }
            break;
        case 1:
        {
            for (int i = 0; i < 6; i++) {
                if (counterTable[i] == NO) {
                    [avaiableColors addObject:[NSNumber numberWithInteger:i]];
                }
            }
        }
            break;
        case 2:
        {
            for (int i = 0; i < 6; i++) {
                if (counterTable[i] == YES) {
                    [avaiableColors addObject:[NSNumber numberWithInteger:i]];
                }
            }
        }
            break;
        default:
            break;
    }
    
    
    return avaiableColors;
}


+ (void)fillRightFaceColorAtCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation{
    NSMutableArray *avaiableColors = [MCCubieColorConstraintUtil avaiableColorsOfCubie:cubie
                                                                         inOrientation:orientation];
    
    FaceColorType faceColors[3];
    FaceOrientationType faceOrientations[3];
    int targetIndex = 0;
    int i = 0;
    
    // Fill colors
    for (NSNumber *color in [cubie allFaceColors]) {
        FaceColorType currentColor = (FaceColorType)[color integerValue];
        faceColors[i] = currentColor;
        
        // Find the position that will be filled the new color.
        if (currentColor == NoColor) targetIndex = i;
        i++;
    }
    
    // Fill orientations
    i = 0;
    for (NSNumber *orientation in [cubie allOrientations]) {
        faceOrientations[i] = (FaceOrientationType)[orientation integerValue];
        i++;
    }
    
    for (NSNumber *color in avaiableColors) {
        faceColors[targetIndex] = (FaceColorType)[color integerValue];
        
        FaceColorType uncertaionOrderedColors[3];
        
        i = 0;
        for (NSNumber *orientation in [MCCubieColorConstraintUtil getFaceOrientationsInColokWiseOrderAtCornerPosition:[cubie coordinateValue]]) {
            FaceOrientationType targetOrientation = (FaceOrientationType)[orientation integerValue];
            for (int j = 0; j < 3; j++) {
                if (targetOrientation == faceOrientations[j]) {
                    uncertaionOrderedColors[i] = faceColors[j];
                    break;
                }
            }
            i++;
        }
        
        //Get origin coordinate of this cubie
        int x=0, y=0, z=0;
        for (int i = 0; i < 3; i++) {
            switch (faceColors[i]) {
                case UpColor:
                    y = 1;
                    break;
                case DownColor:
                    y = -1;
                    break;
                case LeftColor:
                    x = -1;
                    break;
                case RightColor:
                    x = 1;
                    break;
                case FrontColor:
                    z = 1;
                    break;
                case BackColor:
                    z = -1;
                    break;
                default:
                    break;
            }
        }
        
        struct Point3i coordinateValue = {.x = x, .y = y, .z = z};
        FaceColorType rightOrderedColors[3];
        i = 0;
        for (NSNumber *orderedOrientation in [MCCubieColorConstraintUtil getFaceOrientationsInColokWiseOrderAtCornerPosition:coordinateValue]) {
            switch ([orderedOrientation integerValue]) {
                case Up:
                    rightOrderedColors[i] = UpColor;
                    break;
                case Down:
                    rightOrderedColors[i] = DownColor;
                    break;
                case Front:
                    rightOrderedColors[i] = FrontColor;
                    break;
                case Back:
                    rightOrderedColors[i] = BackColor;
                    break;
                case Left:
                    rightOrderedColors[i] = LeftColor;
                    break;
                case Right:
                    rightOrderedColors[i] = RightColor;
                    break;
            }
            i++;
        }
        
        int samePosition;
        for (samePosition = 0; samePosition < 3; samePosition++) {
            if (uncertaionOrderedColors[samePosition] == rightOrderedColors[0]) {
                break;
            }
        }
        int count;
        for (count = 1; count < 3; count++) {
            if (uncertaionOrderedColors[(samePosition+count)%3] != rightOrderedColors[count]) {
                break;
            }
        }
        
        if (count == 3) {
            [cubie setFaceColor:faceColors[targetIndex] inOrientation:orientation];
            return ;
        }
    }

}


+ (NSArray *)getFaceOrientationsInColokWiseOrderAtCornerPosition:(struct Point3i)point{
    switch (point.x) {
        case -1:
        {
            switch (point.y) {
                case -1:
                {
                    switch (point.z) {
                        case -1:
                            return @[@3, @4, @1];
                            break;
                        case 1:
                            return @[@4, @2, @1];
                    }
                }
                    break;
                case 1:
                {
                    switch (point.z) {
                        case -1:
                            return @[@3, @0, @4];
                            break;
                        case 1:
                            return @[@4, @0, @2];
                    }
                }
            }
        }
            break;
        case 1:
        {
            switch (point.y) {
                case -1:
                {
                    switch (point.z) {
                        case -1:
                            return @[@1, @5, @3];
                            break;
                        case 1:
                            return @[@2, @5, @1];
                    }
                }
                    break;
                case 1:
                {
                    switch (point.z) {
                        case -1:
                            return @[@5, @0, @3];
                            break;
                        case 1:
                            return @[@2, @0, @5];
                    }
                }
            }
        }
            break;
    }
    return nil;
}


@end
