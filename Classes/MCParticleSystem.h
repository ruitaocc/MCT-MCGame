//
//  MCPartilcleSystem.h
//  MCGame
//
//  Created by ruitaocc@gmail.com on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCSceneObject.h"
#import "MCPoint.h"
@class MCParticle;
@interface MCParticleSystem : MCSceneObject{
    //three mutable array use to reuse particle objects,which avoid the alloc operation cost too much time.
    NSMutableArray * activeParticles;
    NSMutableArray * particlesToRemove;
    NSMutableArray * particlePool; 
    
    //	
    GLfloat * uvCoordinates;
	GLfloat * vertexes;
    //key material texture.
	NSString * materialKey;	
	NSInteger vertexIndex;
    //
	BOOL emit;
    //
	CGFloat minU;
	CGFloat maxU;
	CGFloat minV;
	CGFloat maxV;
	//emit how many particle at per frame.
	NSInteger emitCounter;
	//
	MCRange emissionRange;
	////set the particle's initial size randomly and its growrate as well.
    MCRange sizeRange;
	MCRange growRange;
    //set the particle's initial velocity randomly and direction as well.
	MCRange xVelocityRange;
	MCRange yVelocityRange;
	//set the particle's lifetime randomly and decaycycle as well .
	MCRange lifeRange;
	MCRange decayRange;
}

@property (retain) NSString * materialKey;

@property (assign) BOOL emit;
@property (assign) NSInteger emitCounter;

@property (assign) MCRange emissionRange;
@property (assign) MCRange sizeRange;
@property (assign) MCRange growRange;
@property (assign) MCRange xVelocityRange;
@property (assign) MCRange yVelocityRange;

@property (assign) MCRange lifeRange;
@property (assign) MCRange decayRange;

- (BOOL)activeParticles;
- (id)init;
- (void)dealloc;
- (void)addVertex:(CGFloat)x y:(CGFloat)y u:(CGFloat)u v:(CGFloat)v;
- (void)awake;
- (void)buildVertexArrays;
- (void)clearDeadQueue;
- (void)emitNewParticles;
- (void)removeChildParticle:(MCParticle*)particle;
- (void)render;
- (void)setDefaultSystem;
- (void)setParticle:(NSString*)atlasKey;
- (void)update;
@end