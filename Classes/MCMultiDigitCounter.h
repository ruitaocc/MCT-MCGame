//
//  MCMultiDigitCounter.h
//  MCGame
//
//  Created by kwan terry on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCStepCounter.h"
@interface MCMultiDigitCounter : MCSceneObject{
    //计数器值
    NSInteger m_counterValue;
    //计数器位数
    NSInteger m_numberOfDigit;
    //计数器位数组
    NSMutableArray * m_multiDigitCounter;
}
@property (assign) NSInteger m_counterValue;
@property (nonatomic,retain)NSMutableArray * m_multiDigitCounter;
- (id) initWithNumberOfDigit:(NSInteger)bits andKeys:(NSString *[])texturekeys;
- (void)awake;
- (void)update;
-(void)render;
-(void)reset;
//进位逻辑
-(void)carryLogic;
//add
-(void)addCounter;
-(void)minusCounter;
-(void)dealloc;

@end
