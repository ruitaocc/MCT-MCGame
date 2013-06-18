//
//  UserManagerSystemViewController.h
//  UserManagerSystemXib
//
//  Created by yellow Dai on 13-1-18.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCUserManagerController.h"
#import "PopCreateUserViewController.h"
#import "PopChangeUserViewController.h"
#import "ScoreCell.h"

@interface UserManagerSystemViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate>
{
    MCUserManagerController *userManagerController;
}

@property (retain, nonatomic) IBOutlet UITableView *scoreTable;

@property (retain, nonatomic) IBOutlet UILabel *currentUserLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalFinishLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalGameTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalMovesLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalLearnTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *totalRankBtn;
@property (retain, nonatomic) IBOutlet UIButton *personalRankBtn;


@property (retain, nonatomic) UIPopoverController *createUserPopover;
@property (retain, nonatomic) UIPopoverController *changeUserPopover;

@property (retain, nonatomic) IBOutlet UISegmentedControl *tableSegment;

@property (retain, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)createUserPress:(id)sender;

- (IBAction)changeUserPress:(id)sender;

- (void)updateUserInformation;

- (void)updateScoreInformation;

- (IBAction)segmentChange:(id)sender;


- (IBAction)totalRankBtnUp:(id)sender;

- (IBAction)personalRankBtnUp:(id)sender;

- (IBAction)goBackMainMenu:(id)sender;

@end
