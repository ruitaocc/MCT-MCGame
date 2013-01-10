//
//  MCCollidersController.h
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"

@interface MCCollisionController : MCSceneObject{
    NSArray * sceneObjects;
	NSMutableArray * allColliders;
	NSMutableArray * collidersToCheck;
}
@property (retain) NSArray * sceneObjects;

- (void)awake;
- (void)handleCollisions;
- (void)render;
- (void)update;
@end
