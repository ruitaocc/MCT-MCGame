//
//  MCInputViewController.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCInputViewController : UIViewController {
	NSMutableSet* touchEvents;
}

@property (retain) NSMutableSet* touchEvents;

- (BOOL)touchesDidBegin;
- (void)clearEvents;
- (void)dealloc ;
- (void)didReceiveMemoryWarning ;
- (void)loadView ;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)viewDidUnload ;

// 7 methods



@end
