//
//  MCStepCounter.h
//  MCGame
//
//  Created by kwan terry on 13-2-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"

@interface MCStepCounter : MCSceneObject{
 //   NSInteger m_stepCounter;
    MCTexturedQuad *m_numberQuad[10];
}
//outside interface;
//@property (assign) NSInteger m_stepCounter;

//-(void)addStep;
//-(void)minusStep;
- (void)setNumberQuad:(NSInteger)index;
//inside function;
- (id) initWithUpKeyS:(NSString*[])Keys;
- (void)awake;
- (void)update;
- (void)reset;
- (void)setNumberQuad:(NSInteger)index;
- (void)dealloc;


@end
