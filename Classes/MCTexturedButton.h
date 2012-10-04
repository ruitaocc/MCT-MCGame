//
//  MCTexturedButton.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCButton.h"


@interface MCTexturedButton : MCButton {
	MCTexturedQuad * upQuad;
	MCTexturedQuad * downQuad;
}

- (id) initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey;
- (void) dealloc;
- (void)awake;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;
- (void)update;

// 6 methods


@end

