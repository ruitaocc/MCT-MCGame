//
//  MCCollidersController.m
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCCollisionController.h"

@implementation MCCollisionController 
@synthesize sceneObjects;


-(void)handleCollisions
{
	// two types of colliders
	// ones that need to be checked for collision and ones that do not
	if (allColliders == nil) allColliders = [[NSMutableArray alloc] init];
	[allColliders removeAllObjects];
	if (collidersToCheck == nil) collidersToCheck = [[NSMutableArray alloc] init];
	[collidersToCheck removeAllObjects];
	
	for (MCSceneObject * obj in sceneObjects) {
		if (obj.collider != nil){
			[allColliders addObject:obj];
			//if ([obj.collider checkForCollision]) [collidersToCheck addObject:obj];
		}	
	}
    
	// now check to see if anythign is hitting anything else
	for (MCSceneObject * colliderObject in collidersToCheck) {
		for (MCSceneObject * collideeObject in allColliders) {
			if (colliderObject == collideeObject) continue;
			//if ([colliderObject.collider doesCollideWithCollider:collideeObject.collider]) {
			//	if ([colliderObject respondsToSelector:@selector(didCollideWith:)]) [colliderObject didCollideWith:collideeObject];
			//}
		}
	}
}
#pragma mark BBSceneObject overrides for rendering and debug

-(void)awake
{
}

// called once every frame
-(void)update
{	
}

// called once every frame
-(void)render
{
	if (!active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	for (MCSceneObject * obj in allColliders) {						
		[obj.collider render];
	}
	glPopMatrix();
}

@end
