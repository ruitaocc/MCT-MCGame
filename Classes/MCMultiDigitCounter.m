//
//  MCMultiDigitCounter.m
//  MCGame
//
//  Created by kwan terry on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCMultiDigitCounter.h"
#import "MCStepCounter.h"
@implementation MCMultiDigitCounter
@synthesize m_counterValue;
@synthesize m_multiDigitCounter;
- (id) initWithNumberOfDigit:(NSInteger)bits andKeys:(NSString *[])texturekeys{
    self = [super init];
	if (self != nil) {
        if (m_multiDigitCounter == nil) m_multiDigitCounter = [[NSMutableArray alloc] init];	
        m_numberOfDigit = bits;
        for (int i = 0; i < m_numberOfDigit; i++) {
            MCStepCounter * tmp = [[MCStepCounter alloc]initWithUpKeyS:texturekeys];
            [tmp setScale:MCPointMake(10, 0, 0)];
            [tmp setTranslation:MCPointMake(10, 0, 0)];
            [m_multiDigitCounter addObject:tmp];
            [tmp release];
        }
        m_counterValue = 0;
    }
	return self;
}

//进位逻辑
-(void)carryLogic{
    if (m_counterValue >= pow(10.0, m_numberOfDigit)-0.5) {
        m_counterValue = 0;
    }
    if (m_counterValue<0) {
        m_counterValue=0;
    }
    int  num = m_counterValue;
    for(int i = m_numberOfDigit; i>0;i--){
        MCStepCounter *tmp = [m_multiDigitCounter objectAtIndex:i-1];
        int k = num%10;
        [tmp setNumberQuad:k];
        num = num/10;
    }
}
//add
-(void)addCounter{
    m_counterValue++;
    [self carryLogic];
}
-(void)minusCounter{
    m_counterValue--;
    [self carryLogic];
}
-(void)setScale:(MCPoint)scales{
    //self.scale = scales;
    [super setScale:scales];
    for (int i = 0; i<m_numberOfDigit; i++) {
        MCPoint sub_scale = MCPointMake(scales.x/m_numberOfDigit, scales.y, scales.z);
        MCStepCounter* subcounter = (MCStepCounter*)[m_multiDigitCounter objectAtIndex:i];
        subcounter.scale=sub_scale;
    }
 }
-(void)setTranslation:(MCPoint)translations{
    //self.translation = translations;
    [super setTranslation:translations];
    if (m_numberOfDigit%2==0) {
        NSInteger half = m_numberOfDigit/2;
        for (int i = 0; i<half; i++) {
            MCStepCounter * tmp = (MCStepCounter *)[m_multiDigitCounter objectAtIndex:i];
            MCPoint trans = MCPointMake(translations.x-tmp.scale.x*(half-i)+tmp.scale.x/2, translations.y, translations.z);
            [tmp setTranslation:trans];
        }
        for (int i = half; i<m_numberOfDigit; i++) {
            MCStepCounter * tmp = (MCStepCounter *)[m_multiDigitCounter objectAtIndex:i];
            MCPoint trans = MCPointMake(translations.x+tmp.scale.x*(i - half)+tmp.scale.x/2, translations.y, translations.z);
            [tmp setTranslation:trans];
        }
    }
    if (m_numberOfDigit%2==1) {
        NSInteger half = m_numberOfDigit/2;
        for (int i = 0; i<half; i++) {
            MCStepCounter * tmp = (MCStepCounter *)[m_multiDigitCounter objectAtIndex:i];
            MCPoint trans = MCPointMake(translations.x-tmp.scale.x*(half-i), translations.y, translations.z);
            [tmp setTranslation:trans];
        }
        MCStepCounter * tmp = (MCStepCounter *)[m_multiDigitCounter objectAtIndex:half];
        [tmp setTranslation:translation];
        for (int i = half+1; i<m_numberOfDigit; i++) {
            MCStepCounter * tmp = (MCStepCounter *)[m_multiDigitCounter objectAtIndex:i];
            MCPoint trans = MCPointMake(translations.x+tmp.scale.x*(i - half), translations.y, translations.z);
            [tmp setTranslation:trans];
        }
    }
}
-(void)render{
    [m_multiDigitCounter makeObjectsPerformSelector:@selector(render)];
    [super render];
};
-(void)setActive:(BOOL)actives{
    for (int i = 0; i<m_numberOfDigit; i++) {
        MCStepCounter* subdigit = (MCStepCounter*)[m_multiDigitCounter objectAtIndex:i];
        [subdigit setActive:actives];
    }
    [super setActive:actives];
}

-(void)awake{
    for (MCStepCounter* object in m_multiDigitCounter) {
        if ([object respondsToSelector:@selector(awake)]) {
            [object awake];
        }
    }
    [super awake];
}
-(void)update{
    for (MCStepCounter* object in m_multiDigitCounter) {
        if ([object respondsToSelector:@selector(update)]) {
            [object update];
        }
    }
    [super update];
}

-(void)dealloc{
    [m_multiDigitCounter release];
    [super dealloc];
}

@end
