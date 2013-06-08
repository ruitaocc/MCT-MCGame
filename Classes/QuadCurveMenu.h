//
//  QuadCurveMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenuItem.h"

@protocol QuadCurveMenuDelegate;


@interface QuadCurveMenu : UIView <QuadCurveMenuItemDelegate>
{
    NSArray *_menusArray;
    int _flag;
    NSTimer *_timer;
    id<QuadCurveMenuDelegate> _delegate;

    
}


@property (nonatomic) BOOL isProtection;
@property (nonatomic, retain) NSTimer *closeTimer;
@property (nonatomic, retain) NSTimer *animationProtectionTimer;
@property (nonatomic, copy) NSArray *menusArray;
@property (nonatomic, getter = isExpanding) BOOL expanding;
@property (nonatomic, assign) id<QuadCurveMenuDelegate> delegate;

@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;

- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray;

- (void)setExpanding:(BOOL)expanding;


@end

@protocol QuadCurveMenuDelegate <NSObject>
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx;
@end