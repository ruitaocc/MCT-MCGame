//
//  MCTestPatternController.h
//  MagicCubeModel
//
//  Created by Aha on 13-1-2.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCKnowledgeBase.h"
#import "MCPlayHelper.h"
#import "CircleMenuController.h"
#import "Global.h"

@interface MCRestoreModelController : CircleMenuController

@property(nonatomic, retain)NSArray *cubieArray;

- (IBAction)selectOne:(id)sender;

- (IBAction)saveState:(id)sender;

@end