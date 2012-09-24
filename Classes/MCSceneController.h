//
//  MCSceneController.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCInputViewController;
@class EAGLView;

@interface MCSceneController : NSObject {
	NSMutableArray * sceneObjects;
	
	MCInputViewController * inputController;
	EAGLView * openGLView;
	
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
}

@property (retain) MCInputViewController * inputController;
@property (retain) EAGLView * openGLView;

@property NSTimeInterval animationInterval;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (MCSceneController*)sharedSceneController;
- (void) dealloc;
- (void) loadScene;
- (void) startScene;
- (void)gameLoop;
- (void)renderScene;
- (void)setAnimationInterval:(NSTimeInterval)interval ;
- (void)setAnimationTimer:(NSTimer *)newTimer ;
- (void)startAnimation ;
- (void)stopAnimation ;
- (void)updateModel;

// 11 methods

@end
