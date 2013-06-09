//
//  QuadCurveMenuItem.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@protocol QuadCurveMenuItemDelegate;

@interface QuadCurveMenuItem : UIButton
{
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _nearPoint; // near
    CGPoint _farPoint; // far
    
    id<QuadCurveMenuItemDelegate> _delegate;
}

@property (nonatomic) FaceColorType faceColor;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;

@property (nonatomic, assign) id<QuadCurveMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       presentColor:(FaceColorType)color
          withFrame:(CGRect)frame;


@end

@protocol QuadCurveMenuItemDelegate <NSObject>
- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item;
- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item;
@end