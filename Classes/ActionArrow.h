//
//  ActionArrow.h
//  MCGame
//
//  Created by kwan terry on 13-3-28.
//
//

#import <Foundation/Foundation.h>
#import "MCSceneObject.h"
@interface ActionArrow : MCSceneObject{
    MCTexturedQuad *arrowQuad;
}
-(id)initWithNstring:(NSString*)string;

-(void)awake;
- (void)update;
-(void)dealloc;

@end
