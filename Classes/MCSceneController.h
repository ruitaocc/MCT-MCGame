//
//  MCSceneController.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class MCInputViewController;
@class InputController;
@class EAGLView;
@class MCSceneObject;
@interface MCSceneController : NSObject {
	//maintain all the scene objects
    NSMutableArray * sceneObjects;
    //queue that store object to remove next update gameloop
	NSMutableArray * objectsToRemove;
     //queue that store object to add next update gameloop,and add to the sceneObject array.
	NSMutableArray * objectsToAdd;
    
    //inputcontroller
	InputController * inputController;
	EAGLView * openGLView;
	
    //MCCollisionController * collisionController;
    
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
    
	NSTimeInterval deltaTime;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval thisFrameStartTime;
	NSDate * levelStartDate;
	
	BOOL needToLoadScene;
}

@property (retain) InputController * inputController;
@property (retain) EAGLView * openGLView;
@property (retain) NSDate *levelStartDate;
@property NSTimeInterval deltaTime;
@property NSTimeInterval animationInterval;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (MCSceneController*)sharedSceneController;
- (void)dealloc;
- (void)loadScene;
- (void)startScene;
- (void)addObjectToScene:(MCSceneObject*)sceneObject; 
- (void)gameLoop;
- (void)gameOver;
- (void)removeObjectFromScene:(MCSceneObject*)sceneObject;
- (void)renderScene;
- (void)restartScene;
- (void)setAnimationInterval:(NSTimeInterval)interval ;
- (void)setAnimationTimer:(NSTimer *)newTimer ;
- (void)startAnimation ;
- (void)stopAnimation ;
- (void)updateModel;
- (void)setupLighting;

// 11 methods

@end
