//
//  TestCube.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestCube.h"



//#import "data.hpp"
#import "TestCubeData.h"
#import "MCParticleSystem.h"
@implementation TestCube

- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

-(void)awake
{
	mesh = [[MCTexturedMesh alloc] initWithVertexes:Cube_vertex_coordinates 
                                        vertexCount:Cube_vertex_array_size
                                         vertexSize:3 
                                        renderStyle:GL_TRIANGLES];
	[(MCTexturedMesh*)mesh setMaterialKey:@"cubeTexture"];
	[(MCTexturedMesh*)mesh setUvCoordinates:Cube_texture_coordinates];
	[(MCTexturedMesh*)mesh setNormals:Cube_normal_vectors];
	
	
	
//	mesh.radius = 0.5;
//	
//	//self.collider = [MCCollider collider];
//	
//	particleEmitter = [[MCParticleSystem alloc] init];
//	particleEmitter.emissionRange = MCRangeMake(50.0, 0.0);
//	
//	if (smashCount == 0) {
//		particleEmitter.sizeRange = MCRangeMake(18.0, 3.0);		
//	} else {
//		particleEmitter.sizeRange = MCRangeMake(8.0, 3.0);		
//	}
//	
//	particleEmitter.growRange = MCRangeMake(-0.8, 0.5);
//	
//	particleEmitter.xVelocityRange = MCRangeMake(-2, 4);
//	particleEmitter.yVelocityRange = MCRangeMake(-2, 4);
//	
//	particleEmitter.lifeRange = MCRangeMake(0.0, 5.5);
//	particleEmitter.decayRange = MCRangeMake(0.03, 0.05);
//    
//	[particleEmitter setParticle:@"greenBlur"];
//	particleEmitter.emit = YES;
//	particleEmitter.emitCounter = 6;
//	
//	smashed = NO;
}


-(void)fireMissile
{
	// need to spawn a missile
	
    //MCMissile * missile = [[MCMissile alloc] init];
	//missile.scale = MCPointMake(5, 5, 5);
	
    // we need to position it at the tip of our ship
	//CGFloat radians = rotation.z/MCRADIANS_TO_DEGREES;
	//CGFloat speedX = -sinf(radians) * 3.0 * 60;
	//CGFloat speedY = cosf(radians) * 3.0 * 60;
    
	//missile.speed = MCPointMake(speedX, speedY, 0.0);
	
	//missile.translation = MCPointMatrixMultiply(MCPointMake(0.0, 1.0, 0.0), matrix);
    //	missile.translation = MCPointMake(translation.x + missile.speed.x * 3.0, translation.y + missile.speed.y * 3.0, 0.0);
	//missile.rotation = MCPointMake(0.0, 0.0, self.rotation.z);
    
	//[[MCSceneController sharedSceneController] addObjectToScene:missile];
	//[missile release];
	
	//[[MCSceneController sharedSceneController].inputController setFireMissile:NO];
}


// called once every frame
-(void)update
{
    
    	[super update];
    
//	if (dead) {
//		[self deadUpdate];
//		return;		
//	}
    
//	particleEmitter.translation = MCPointMatrixMultiply(MCPointMake(0.0, -0.4, 0.0), matrix);
//    
//	CGFloat radians = rotation.z/MCRADIANS_TO_DEGREES;
//	CGFloat speedX = sinf(radians);
//	CGFloat speedY = -cosf(radians);
//	particleEmitter.xVelocityRange = MCRangeMake(speedX * 2 , speedX * 2);
//	particleEmitter.yVelocityRange = MCRangeMake(speedY * 2 , speedY * 2);	
//	
//	
//	CGFloat rightTurn = [[MCSceneController sharedSceneController].inputController rightMagnitude];
//	CGFloat leftTurn = [[MCSceneController sharedSceneController].inputController leftMagnitude];
//    
//	rotation.z += ((rightTurn * -1.0) + leftTurn) * TURN_SPEED_FACTOR * 2.0;
//	
//	if ([[MCSceneController sharedSceneController].inputController fireMissile]) [self fireMissile];
//    
//	
//	CGFloat forwardMag = [[MCSceneController sharedSceneController].inputController forwardMagnitude] * THRUST_SPEED_FACTOR;
//    
//	particleEmitter.emissionRange = MCRangeMake([[MCSceneController sharedSceneController].inputController forwardMagnitude] * 5, [[MCSceneController sharedSceneController].inputController forwardMagnitude] * 5);
//	if (forwardMag <= 0.0001) return; // we are not moving so return early
//	
//	// now we need to do the thrusters
//	// figure out the components of the speed
//	speed.x += sinf(radians) * -forwardMag;
//	speed.y += cosf(radians) * forwardMag;
    
    
}

-(void)deadUpdate
{
	if ((particleEmitter.emitCounter <= 0) && (![particleEmitter activeParticles])) {
		[[MCSceneController sharedSceneController] removeObjectFromScene:self];	
		[[MCSceneController sharedSceneController] gameOver];
	}
}



- (void) dealloc
{
    if (particleEmitter != nil) [[MCSceneController sharedSceneController] removeObjectFromScene:particleEmitter];
	[particleEmitter release];
	[super dealloc];
}


@end
