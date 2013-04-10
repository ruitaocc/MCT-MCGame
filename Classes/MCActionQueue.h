//
//  MCActionQueue.h
//  MCGame
//
//  Created by kwan terry on 13-3-26.
//
//

#import <Foundation/Foundation.h>
#import "MCSceneObject.h"
#import "ActionQuad.h"
#import "ActionArrow.h"
@interface MCActionQueue :MCSceneObject{
    //action 队列
    NSMutableArray *actionQuads;
    NSInteger currentActionIndex;
    ActionArrow *currentArrow;
}
-(id)initWithActionList:(NSArray*)actionlist;
-(void)enQueue:(ActionQuad*)quad;
-(void)deQueue:(ActionQuad*)quad;
-(void)insertQueueIndex:(NSInteger)index withQuad:(ActionQuad*)quad;
-(void)insertQueueCurrentIndexWithNmaeList:(NSArray*)insertlist;

-(void)removeAllActions;

-(void)shiftLeft;
-(void)shiftRight;
-(void)render;
- (void)awake;
- (void)update;
- (void)reset;
- (void)dealloc;
@end
