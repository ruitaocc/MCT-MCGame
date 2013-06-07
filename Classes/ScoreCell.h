//
//  ScoreCell.h
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-13.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *rankLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *moveLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *speedLabel;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;

- (void) setCellWithRank:(NSString*)_rank Name:(NSString*)_name Move:(NSString*)_move Time:(NSString*)_time Speed:(NSString*)_speed Score:(NSString*)_score;
@end
