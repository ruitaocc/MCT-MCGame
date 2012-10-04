//
//  MCAnimatedQuad.m
//  MCGame
//
//  Created by kwan terry on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCAnimatedQuad.h"
#import "MCSceneController.h"
@implementation MCAnimatedQuad
@synthesize speed,loops,didFinish;
- (id) init{
    self = [super init];
	if (self != nil) {
		self.speed = 12; // 12 fps
		self.loops = NO;
		self.didFinish = NO;
		elapsedTime = 0.0;
	}
	return self;
}
- (void) dealloc{
    uvCoordinates = 0;
	[super dealloc];
    
}
- (void)addFrame:(MCTexturedQuad*)aQuad{
    if (frameQuads == nil) frameQuads = [[NSMutableArray alloc] init];
	[frameQuads addObject:aQuad];
}
- (void)setFrame:(MCTexturedQuad*)quad{
    self.uvCoordinates = quad.uvCoordinates;
	self.materialKey = quad.materialKey;
}
- (void)updateAnimation{
    elapsedTime += [MCSceneController sharedSceneController].deltaTime;
	NSInteger frame = (int)(elapsedTime/(1.0/speed));
	if (loops) frame = frame % [frameQuads count];
	if (frame >= [frameQuads count]) {
		didFinish = YES;
		return;
	}
	[self setFrame:[frameQuads objectAtIndex:frame]];

}

@end
