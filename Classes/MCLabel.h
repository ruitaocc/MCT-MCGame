//
//  MCLabel.h
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//

#import "MCSceneObject.h"
#import "MCTexturedQuad.h"
@interface MCLabel : MCSceneObject{
    MCTexturedQuad *labelQuad;

}
-(id)initWithNstring:(NSString*)string;

-(void)awake;
- (void)update;
-(void)dealloc;


@end
