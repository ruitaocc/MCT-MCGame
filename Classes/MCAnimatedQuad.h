//
//  MCAnimatedQuad.h
//  MCGame
//
//  Created by kwan terry on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCTexturedQuad.h"

@interface MCAnimatedQuad : MCTexturedQuad{
    NSMutableArray * frameQuads;
	CGFloat speed;
	NSTimeInterval elapsedTime;
	BOOL loops;
	BOOL didFinish;
}

@property (assign) CGFloat speed;
@property (assign) BOOL loops;
@property (assign) BOOL didFinish;

- (id) init;
- (void) dealloc;
- (void)addFrame:(MCTexturedQuad*)aQuad;
- (void)setFrame:(MCTexturedQuad*)quad;
- (void)updateAnimation;


@end
