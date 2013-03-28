//
//  MCButton.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCInputViewController.h"
@interface MCButton : MCSceneObject{
	BOOL pressed;
	id target;
	SEL buttonDownAction;
	SEL buttonUpAction;
	CGRect screenRect;
    MCPoint originScale;
}

@property (assign) id target;
@property (assign) SEL buttonDownAction;
@property (assign) SEL buttonUpAction;

- (void)awake;
- (void)handleTouches;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;
- (void)touchDown;
- (void)touchUp;
- (void)update;




@end
