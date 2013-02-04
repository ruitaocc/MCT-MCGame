//
//  MCDotSeparater.h
//  MCGame
//
//  Created by kwan terry on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"

@interface MCDotSeparater : MCSceneObject{
    MCTexturedQuad * quad;
}
- (id) initWithUpKeyS:(NSString*)Key;
- (void)awake;
@end
