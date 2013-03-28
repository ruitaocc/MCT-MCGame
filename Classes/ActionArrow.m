//
//  ActionArrow.m
//  MCGame
//
//  Created by kwan terry on 13-3-28.
//
//

#import "ActionArrow.h"

@implementation ActionArrow
-(id)initWithNstring:(NSString*)string{
    self =[super init];
    if(self!=nil){
        arrowQuad = [[MCMaterialController sharedMaterialController]quadFromAtlasKey:string];
        [arrowQuad retain];
    }
    return self;
}
-(void)awake{
    self.mesh = arrowQuad;
}
- (void)update{
    [super update];
}
- (void)dealloc{
    [arrowQuad release];
	[super dealloc];
};
@end
