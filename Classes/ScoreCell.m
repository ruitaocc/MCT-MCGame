//
//  ScoreCell.m
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-13.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "ScoreCell.h"

@implementation ScoreCell
@synthesize rankLabel;
@synthesize userNameLabel;
@synthesize moveLabel;
@synthesize timeLabel;
@synthesize speedLabel;
@synthesize scoreLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [rankLabel release];
    [userNameLabel release];
    [moveLabel release];
    [timeLabel release];
    [speedLabel release];
    [scoreLabel release];
    [super dealloc];
}

-(void)setCellWithRank:(NSString *)_rank Name:(NSString *)_name Move:(NSString *)_move Time:(NSString *)_time Speed:(NSString *)_speed Score:(NSString *)_score
{
    rankLabel.text = _rank;
    userNameLabel.text = _name;
    moveLabel.text = _move;
    timeLabel.text = _time;
    speedLabel.text = _speed;
    scoreLabel.text = _score;
}
@end
