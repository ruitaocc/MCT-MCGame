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

//it is a method used 。。。。！妈的！又不会说了  
//用这个函数让可移动的对象能够，当它从屏幕下方（或左方）移出时，回从另外一方滚回来
-(void)checkArenaBounds
{
    float width = 1024;
    float height = 768;
	if (translation.x > (width/2 + CGRectGetWidth(self.meshBounds)/2.0)) translation.x -= width + CGRectGetWidth(self.meshBounds); 
	if (translation.x < (-width/2 - CGRectGetWidth(self.meshBounds)/2.0)) translation.x += width + CGRectGetWidth(self.meshBounds); 
    
	if (translation.y > (height/2 + CGRectGetHeight(self.meshBounds)/2.0)) translation.y -= height + CGRectGetHeight(self.meshBounds); 
	if (translation.y < (-height/2 - CGRectGetHeight(self.meshBounds)/2.0)) translation.y += height + CGRectGetHeight(self.meshBounds); 
}

@end
