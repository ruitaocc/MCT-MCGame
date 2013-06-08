//
//  MCExplanationSystem.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCWorkingMemory.h"
#import "MCBasicElement.h"
#import "MCTransformUtil.h"


#define DEFAULT_PATTERN_ACCORDANCE_MESSAGE_NUM 5

@interface MCExplanationSystem : NSObject

//After applying this pattern,
//intermediate informations will be stored here.
//However, these informations are those accordant condictions beacuse
//this pattern maybe not completely corresponding to current state of the rubik's cube.
@property (nonatomic, retain) NSMutableArray *accordanceMsgs;
@property (nonatomic, retain) MCWorkingMemory *workingMemory;

+ (MCExplanationSystem *)explanationSystemWithWorkingMemory:(MCWorkingMemory *)wm;


- (id)initExplanationSystemWithWorkingMemory:(MCWorkingMemory *)wm;


- (NSArray *)translateAgendaPattern;

@end
