//
//  MCTimer.m
//  MCGame
//
//  Created by kwan terry on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCTimer.h"
#import "CoordinatingController.h"
@implementation MCTimer
@synthesize totalTime;
- (id) initWithTextureKeys:(NSString *[])texturekeys{
    self = [super init];
	if (self != nil) {
        m_hour = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:2 andKeys:texturekeys];
        separater21 = [[MCDotSeparater alloc]initWithUpKeyS:@"dotdot2"];
        m_minute = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:2 andKeys:texturekeys];
        separater22 = [[MCDotSeparater alloc]initWithUpKeyS:@"dotdot2"];
        m_second = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:2 andKeys:texturekeys];
        separater11 = [[MCDotSeparater alloc]initWithUpKeyS:@"dot2"];
        m_millisecond = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:3 andKeys:texturekeys];
        //m_nstimer = [[NSTimer alloc]init];
        totalTime = 0;
        isStop = YES;
    }
	return self;
}
-(void)reset{
    [m_hour reset];
    [m_millisecond reset];
    [m_minute reset];
    [m_second reset];
    totalTime = 0;
};
-(void)setScale:(MCPoint)scales{
    [super setScale:scales];
    MCPoint per = MCPointMake(scales.x/30, scales.y, scales.z);
    [m_hour setScale:MCPointMake(per.x*6, per.y, per.z)];
    [separater21 setScale:per];
    [m_second setScale:MCPointMake(per.x*6, per.y, per.z)];
    [separater22 setScale:per];
    [m_minute setScale:MCPointMake(per.x*6, per.y, per.z)];
    [separater11 setScale:per];
    [m_millisecond setScale:MCPointMake(per.x*9, per.y, per.z)];
}
-(void)setTranslation:(MCPoint)translations{
    [super setTranslation:translations];
    MCPoint perscale = separater11.scale;
    [m_hour setTranslation:MCPointMake(translations.x-perscale.x*15, translations.y, translations.z)];
    [separater21 setTranslation:MCPointMake(translations.x-perscale.x*11.5, translations.y, translations.z)];
    [m_minute setTranslation:MCPointMake(translations.x-perscale.x*8, translations.y, translations.z)];
    [separater22 setTranslation:MCPointMake(translations.x-perscale.x*4.5, translations.y, translations.z)];
    [m_second setTranslation:MCPointMake(translations.x-perscale.x*1, translations.y, translations.z)];
    [separater11 setTranslation:MCPointMake(translations.x+perscale.x*2.5, translations.y, translations.z)];
    [m_millisecond setTranslation:MCPointMake(translations.x+perscale.x*7.5, translations.y, translations.z)];

}

-(void)carryLogic{
    if (m_millisecond.m_counterValue>=999) {
        [m_millisecond reset];
        [m_second addCounter];
    }
    if (m_second.m_counterValue>=60) {
        [m_second reset];
        [m_minute addCounter];
    }
    if (m_minute.m_counterValue>=60) {
        [m_minute reset];
        [m_hour addCounter];
    }
    if (m_hour.m_counterValue>=60) {
        [m_hour reset];
    }
}
-(void)addTimerWithMilisec:(int)milisec{
    totalTime+=milisec;
    for (int i = 0; i<milisec; i++) {
        [m_millisecond addCounter];
        [self carryLogic];
    }
}
-(void)startTimer{
    isStop = NO;
   //m_nstimer = [NSTimer scheduledTimerWithTimeInterval:Interval target:self selector:@selector(addTimer) userInfo:nil repeats:YES];
}
-(void)stopTimer{
    isStop = YES;
    //[m_nstimer invalidate];
    //m_nstimer = nil;
}


-(void)awake{
    [m_hour awake];
    [m_minute awake];
    [m_second awake];
    [m_millisecond awake];
    [separater11 awake];
    [separater21 awake];
    [separater22 awake];
    [super awake];
}

-(void)update{
    if (!isStop) {
        CGFloat deltaTime = [[[CoordinatingController sharedCoordinatingController] currentController] deltaTime];
        [self addTimerWithMilisec:(int)(deltaTime*1000)];
    }
    [m_hour update];
    [m_minute update];
    [m_second update];
    [m_millisecond update];
    [separater11 update];
    [separater21 update];
    [separater22 update];
    [super update];
}
-(void)render{
    [m_hour render];
    [m_minute render];
    [m_second render];
    [m_millisecond render];
    [separater11 render];
    [separater21 render];
    [separater22 render];
    [super update];
    
}
-(void)setActive:(BOOL)actives{
    [m_hour setActive:actives];
    [m_minute setActive:actives];
    [m_second setActive:actives];
    [m_millisecond setActive:actives];
    [separater11 setActive:actives];
    [separater21 setActive:actives];
    [separater22 setActive:actives];
    [super setActive:actives];
}

- (void)dealloc{
    //[m_nstimer release];
    [m_hour release];
    [m_minute release];
    [m_second release];
    [m_millisecond release];
    [separater11 release];
    [separater21 release];
    [separater22 release];
    [super dealloc];
};


- (NSString *)description{
    return [NSString stringWithFormat:@"%02d:%02d:%02d", m_hour.m_counterValue, m_minute.m_counterValue, m_second.m_counterValue];
}
                                      
@end
