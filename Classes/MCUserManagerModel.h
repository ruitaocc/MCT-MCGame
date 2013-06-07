//
//  MCUserManagerModel.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCUser.h"

@interface MCUserManagerModel : NSObject

@property (retain, nonatomic) MCUser *currentUser;
@property (retain, nonatomic) NSMutableArray *allUser;
@property (retain, nonatomic) NSMutableArray *topScore;
@property (retain, nonatomic) NSMutableArray *myScore;

+ (MCUserManagerModel*) sharedInstance;

@end
