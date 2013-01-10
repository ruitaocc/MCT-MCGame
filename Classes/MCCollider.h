//
//  MCCollider.h
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"


@protocol MCCollisionHandlerProtocol
- (void)didCollideWith:(MCSceneObject*)sceneObject; 
@end


@interface MCCollider : MCSceneObject{
    MCPoint transformedCentroid;
	BOOL checkForCollision;
}
@property (assign) BOOL checkForCollision;

+ (MCCollider*)collider;
- (BOOL)doesCollideWithCollider:(MCCollider*)aCollider;
- (BOOL)doesCollideWithMesh:(MCSceneObject*)sceneObject;
- (void)dealloc;
- (void)awake;
- (void)render;
- (void)updateCollider:(MCSceneObject*)sceneObject;

// 6 methods



@end
