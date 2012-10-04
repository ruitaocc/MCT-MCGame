//
//  MCParticle.m
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCParticle.h"

@implementation MCParticle
@synthesize position,velocity;
@synthesize life,decay;
@synthesize size,grow;


-(void)update{
    position.x += velocity.x;
	position.y += velocity.y;
	position.z += velocity.z;
	
	life -= decay;
	size += grow;
	if (size < 0.0) size = 0.0;
}
@end
