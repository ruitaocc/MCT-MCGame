//
//  MCStepCounter.m
//  MCGame
//
//  Created by kwan terry on 13-2-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCStepCounter.h"

@implementation MCStepCounter
//@synthesize m_stepCounter;
- (id) initWithUpKeyS:(NSString*[])Keys{
    self = [super init];
	if (self != nil) {
        for (int i = 0; i<10; i++) {
            m_numberQuad[i] = [[MCMaterialController sharedMaterialController]quadFromAtlasKey:Keys[i]];
            [m_numberQuad[i] retain];
        }
        //m_stepCounter = 0;
    }
	return self;
};
/*
- (void)addStep{
    m_stepCounter++;
    if (m_stepCounter > 9) {
        m_stepCounter = 0;
    }
    [self setNumberQuad:m_stepCounter];
};

- (void)minusStep{
    m_stepCounter--;
    [self setNumberQuad:m_stepCounter];
};
 */
- (void)awake{
    [self setNumberQuad:0];
};

- (void)update{
    [super update];
};
- (void)setNumberQuad:(NSInteger)index{
    self.mesh = m_numberQuad[index];
};

- (void)dealloc{
    for (int i = 0; i<10; i++) {
        [m_numberQuad[i] release];
    }
	[super dealloc];
};


@end
