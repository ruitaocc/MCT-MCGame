//
//  Constants.h
//  KYCircleMenuDemo
//
//  Created by Kaijie Yu on 6/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Basic Configuration - prefix: KYC



#pragma mark -
#pragma mark - View  - prefix: KY

// Button Size
#define kKYButtonInMiniSize   12.f
#define kKYButtonInSmallSize  24.f
#define kKYButtonInNormalSize 48.f

#pragma mark - KYCircleMenu Configuration

// Number of buttons around the circle menu
#define kKYCCircleMenuButtonsCount 6
// Circle Menu
// Basic constants
#define kKYCircleMenuSize             210.f
#define kKYCircleMenuButtonSize       kKYButtonInNormalSize
#define kKYCircleMenuCenterButtonSize kKYButtonInNormalSize
// Image
#define kKYICircleMenuCenterButton           @"DefaultButton.png"
#define kKYICircleMenuCenterButtonBackground @"DefaultButtonBg.png"
#define kKYICircleMenuButtonImageNameFormat  @"Color%.2d.png" // %.2d: 1 - 6

@interface Constants : NSObject

@end
