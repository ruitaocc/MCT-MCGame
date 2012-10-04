//
//  MCMobileObject.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMobileObject.h"

@implementation MCMobileObject

@synthesize speed,rotationalSpeed;

// called once every frame, sublcasses need to remember to call this
// method via [super update]
-(void)update
{
	CGFloat deltaTime = [[MCSceneController sharedSceneController] deltaTime];
	translation.x += speed.x * deltaTime;
	translation.y += speed.y * deltaTime;
	translation.z += speed.z * deltaTime;
	
	rotation.x += rotationalSpeed.x * deltaTime;
	rotation.y += rotationalSpeed.y * deltaTime;
	rotation.z += rotationalSpeed.z * deltaTime;
	[self checkArenaBounds];
	[super update];
}

-(void)checkArenaBounds
{
	if (translation.x > (240.0 + CGRectGetWidth(self.meshBounds)/2.0)) translation.x -= 480.0 + CGRectGetWidth(self.meshBounds); 
	if (translation.x < (-240.0 - CGRectGetWidth(self.meshBounds)/2.0)) translation.x += 480.0 + CGRectGetWidth(self.meshBounds); 
    
	if (translation.y > (160.0 + CGRectGetHeight(self.meshBounds)/2.0)) translation.y -= 320.0 + CGRectGetHeight(self.meshBounds); 
	if (translation.y < (-160.0 - CGRectGetHeight(self.meshBounds)/2.0)) translation.y += 320.0 + CGRectGetHeight(self.meshBounds); 
}

@end
