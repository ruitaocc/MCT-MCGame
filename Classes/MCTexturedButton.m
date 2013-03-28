//
//  MCTexturedButton.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "MCTexturedButton.h"
#import "sceneController.h"
#import "MCSceneController.h"
#import "CoordinatingController.h"
@implementation MCTexturedButton
@synthesize isNeedToAddParticle;
- (id) initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey
{
	self = [super init];
	if (self != nil) {
		upQuad = [[MCMaterialController sharedMaterialController] quadFromAtlasKey:upKey];
		downQuad = [[MCMaterialController sharedMaterialController] quadFromAtlasKey:downKey];
		[upQuad retain];
		[downQuad retain];
        isNeedToAddParticle = TRUE;
	}
	return self;
}

// called once when the object is first created.
-(void)awake
{
    originScale = self.scale;
	[self setNotPressedVertexes];
	screenRect = [[[CoordinatingController sharedCoordinatingController] currentController].inputController 
                  screenRectFromMeshRect:self.meshBounds 
                  atPoint:CGPointMake(translation.x, translation.y)];
   
    particleEmitter = [[MCParticleSystem alloc]init];
    
    
    particleEmitter.emissionRange = MCRangeMake(80.0, 10.0);
	particleEmitter.sizeRange = MCRangeMake(10.0, 5.0);
	particleEmitter.growRange = MCRangeMake(-0.5, 0.3);
	particleEmitter.xVelocityRange = MCRangeMake(-2, 4);
	particleEmitter.yVelocityRange = MCRangeMake(-2, 4);
	particleEmitter.lifeRange = MCRangeMake(0.0, 6.5);
	particleEmitter.decayRange = MCRangeMake(0.03, 0.05);
    
    particleEmitter.active =YES;
    //particleEmitter.emitCounter = 1;
    [particleEmitter setParticle:@"lightBlur"];
    particleEmitter.translation = MCPointMake(self.translation.x, self.translation.y, -1);
    particleEmitter.emit = NO;
    [[[CoordinatingController sharedCoordinatingController] currentController]addObjectToScene:particleEmitter];

        //CGPoint orih =  screenRect.origin;
    //CGSize size =  screenRect.size;
   // NSLog(@"screenRect.x = %f,screenRect.y = %f",orih.x,orih.y);
   // NSLog(@"screenRect.sizex = %f,screenRect.sizey = %f",size.width,size.height);
   // NSLog(@"translation.x = %f,translation.y = %f",translation.x,translation.y);
	// this is a bit rendundant, but allows for much simpler subclassing
}

// called once every frame
-(void)update
{
	// check for touches
	[self handleTouches];
	[super update];
    
}

-(void)setPressedVertexes
{
	self.mesh = downQuad;
    MCPoint tscale = self.scale;
    self.scale = MCPointMake(tscale.x*1.1, tscale.y*1.1, tscale.z*1.1);
    
    if (particleEmitter.emit==NO) {
        particleEmitter.emit=YES;
        particleEmitter.emitCounter = 1 ;
    }
}

-(void)setNotPressedVertexes
{
    self.scale = originScale;
	self.mesh = upQuad;
}

- (void) dealloc
{
    [upQuad release];
	[downQuad release];
	[super dealloc];
}


@end

