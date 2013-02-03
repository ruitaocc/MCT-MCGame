//
//  MCCountingPlayInputViewController__1.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputController.h"
#import "MCMultiDigitCounter.h"
@interface MCCountingPlayInputViewController : InputController{
    MCMultiDigitCounter *stepcounter;
}
@property (nonatomic,retain) MCMultiDigitCounter *stepcounter;
//overload
-(void)loadInterface;
//selectors
-(void)mainMenuBtnDown;
-(void)mainMenuPlayBtnUp; 
-(void)rotateTestDown;
-(void)rotateTestUp;
@end
