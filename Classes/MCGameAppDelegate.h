//
//  MCGameAppDelegate.h
//  MCGame
//
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCGameAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
+ (MCGameAppDelegate*)sharedMCGameAppDelegate;
//程序将退出时，保存数据
@end

