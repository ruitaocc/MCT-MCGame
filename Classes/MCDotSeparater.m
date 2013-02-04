//
//  MCDotSeparater.m
//  MCGame
//
//  Created by kwan terry on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCDotSeparater.h"

@implementation MCDotSeparater
- (id) initWithUpKeyS:(NSString*)Key{
    self = [super init];
    if (self != nil) {
        quad = [[MCMaterialController sharedMaterialController]quadFromAtlasKey:Key];
        [quad retain];
    }
    return self;
}
- (void)awake{
    self.mesh = quad;
};
- (void)dealloc{
    [quad release];
	[super dealloc];
};
@end
