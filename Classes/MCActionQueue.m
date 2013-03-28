//
//  MCActionQueue.m
//  MCGame
//
//  Created by kwan terry on 13-3-26.
//
//

#import "MCActionQueue.h"
NSString *actionname[45]={@"frontCW",@"frontCCW",@"front2CW",@"backCW",@"backCCW",@"back2CW",@"rightCW",@"rightCCW",@"right2CW",@"leftCW",@"leftCCW",@"left2CW",@"upCW",@"upCCW",@"up2CW",@"downCW",@"downCCW",@"down2CW",@"xCW",@"xCCW",@"x2CW",@"yCW",@"yCCW",@"y2CW",@"zCW",@"zCCW",@"z2CW",@"frontTwoCW",@"frontTwoCCW",@"frontTwo2CW",@"backTwoCW",@"backTwoCCW",@"backTwo2CW",@"rightTwoCW",@"rightTwoCCW",@"rightTwo2CW",@"leftTwoCW",@"leftTwoCCW",@"leftTwo2CW",@"upTwoCW",@"upTwoCCW",@"upTwo2CW",@"downTwoCW",@"downTwoCCW",@"downTwo2CW"};
@implementation MCActionQueue
-(id)initWithActionList:(NSArray*)actionlist{
    self = [super init];
    if (self!=nil) {
        if (actionQuads==nil) {
            actionQuads = [[NSMutableArray alloc]init];
        }
        for (int i=0; i<[actionlist count]; i++) {
            NSString *quadname = [actionlist objectAtIndex:i];
            ActionQuad * actionQ = [[ActionQuad alloc]initWithNstring:quadname];
            [actionQ setScale:MCPointMake(10, 0, 0)];
            [actionQ setTranslation:MCPointMake(10, 0, 0)];
            [actionQuads addObject:actionQ];
            [actionQ release];
        }
        currentActionIndex = 0;
        currentArrow = [[ActionArrow alloc]initWithNstring:@"actionarrow"];
    }
    return self;
}

-(void)shiftLeft{
    if (currentActionIndex>0) {
        currentActionIndex--;
        [self setTranslation:self.translation];
    }
}
-(void)shiftRight{
    if (currentActionIndex<[actionQuads count]) {
        currentActionIndex++;
        [self setTranslation:self.translation];
    }
}

-(void)adaptPositon{
}

-(void)setScale:(MCPoint)scales{
    //self.scale = scales;
    [super setScale:scales];
    [currentArrow setScale:MCPointMake(scales.x, 1.972*scales.y, scales.z)];
    NSInteger count = [actionQuads count];
    for (int i = 0; i<count; i++) {
        ActionQuad* actionQ= (ActionQuad*)[actionQuads objectAtIndex:i];
        if ([[actionQ name] rangeOfString:@"2"].location!=NSNotFound) {
            [actionQ setScale:MCPointMake(1.6056*scales.x, scales.y, scales.z)];
        }else {
            [actionQ setScale:MCPointMake(scales.x, scales.y, scales.z)];
        }
    }
}

-(void)setTranslation:(MCPoint)translations{
    //self.translation = translations;
    [super setTranslation:translations];
    NSInteger count = [actionQuads count];
    NSInteger totallscale_x = 0;
    for (int i = 0; i<count; i++) {
        ActionQuad* actionQ= (ActionQuad*)[actionQuads objectAtIndex:i];
        totallscale_x+=actionQ.scale.x;
    }
    NSInteger half_totallscale_x = -totallscale_x/2;
    for (int i = 0; i<count; i++) {
        ActionQuad * tmp = (ActionQuad *)[actionQuads objectAtIndex:i];
        MCPoint trans = MCPointMake(translations.x+half_totallscale_x+tmp.scale.x/2, translations.y, translations.z);
        [tmp setTranslation:trans];
        half_totallscale_x+=tmp.scale.x;
        if (i==currentActionIndex) {
            [currentArrow setTranslation:MCPointMake(trans.x, trans.y, trans.z-1)];
        }
    }
}

-(void)enQueue:(ActionQuad*)quad{
    [quad retain];
    [actionQuads addObject:quad];
    [self setTranslation:self.translation];
    [quad release];
}
-(void)deQueue:(ActionQuad*)quad{
    [quad retain];
    [actionQuads removeObject:quad];
    [self setTranslation:self.translation];
    [quad release];
}
-(void)insertQueueIndex:(NSInteger)index withQuad:(ActionQuad*)quad{
    [quad retain];
    [actionQuads insertObject:quad atIndex:index];
    [self setTranslation:self.translation];
    [quad release];

}

- (void)awake{
    [currentArrow awake];
    for (ActionQuad* object in actionQuads) {
        if ([object respondsToSelector:@selector(awake)]) {
            [object awake];
        }
    }
    [super awake];

}
-(void)setActive:(BOOL)actives{
    NSInteger count = [actionQuads count];
    [currentArrow setActive:actives];
    for (int i = 0; i<count; i++) {
        ActionQuad* aQuad = (ActionQuad*)[actionQuads objectAtIndex:i];
        [aQuad setActive:actives];
    }
    [super setActive:actives];
}
- (void)update{
    [currentArrow update];
    for (ActionQuad* object in actionQuads) {
        if ([object respondsToSelector:@selector(update)]) {
            [object update];
        }
    }
    [super update];
}
-(void)render{
    [currentArrow render];
    [actionQuads makeObjectsPerformSelector:@selector(render)];
    [super render];
};
- (void)reset{}
- (void)dealloc{
    [currentArrow release];
    [actionQuads release];
    [super dealloc];
}
@end
