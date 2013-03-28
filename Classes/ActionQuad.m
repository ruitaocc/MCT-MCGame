//
//  ActionQuad.m
//  MCGame
//
//  Created by kwan terry on 13-3-26.
//
//

#import "ActionQuad.h"

@implementation ActionQuad
@synthesize name;
-(id)initWithNstring:(NSString*)string{
    self =[super init];
    if(self!=nil){
        name = string;
        aQuad = [[MCMaterialController sharedMaterialController]quadFromAtlasKey:name];
        [aQuad retain];
    }
    return self;
}
-(void)awake{
    self.mesh = aQuad;
}
- (void)update{
    [super update];
}
- (void)dealloc{
    [aQuad release];
	[super dealloc];
};

@end
