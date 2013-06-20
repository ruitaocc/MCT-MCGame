//
//  MCTimer.h
//  MCGame
//
//  Created by kwan terry on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCMultiDigitCounter.h"
#import "MCDotSeparater.h"
#define Interval 0.0005
@interface MCTimer : MCSceneObject{
    long  totalTime;//毫秒值
    //NSTimer * m_nstimer;
    MCMultiDigitCounter * m_hour;
    MCDotSeparater * separater21;
    MCMultiDigitCounter * m_minute;
    MCDotSeparater * separater22;
    MCMultiDigitCounter * m_second;
    MCDotSeparater * separater11;
    MCMultiDigitCounter * m_millisecond;
    BOOL isStop;
}
@property (assign)long  totalTime;
- (id) initWithTextureKeys:(NSString *[])texturekeys;
-(void)carryLogic;
-(void)reset;
-(void)startTimer;
-(void)stopTimer;
- (void)awake;
- (void)update;
-(void)render;


@end
