//
//  MCCollidersController.h
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"

@interface MCCollisionController : MCSceneObject{
    NSMutableArray * sceneObjects;
	NSMutableArray * allColliders;
	NSMutableArray * collidersToCheck;
}
@property (retain) NSMutableArray * sceneObjects;

- (void)awake;
- (void)handleCollisions;
- (void)render;
- (void)update;
@end
