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

@property (retain, nonatomic) IBOutlet UITextField *insertScoreTimeField;
@property (retain, nonatomic) IBOutlet UITextField *insertScoreMoveField;

@property (retain, nonatomic) IBOutlet UILabel *currentUserLabel;

@property (retain, nonatomic) IBOutlet UILabel *totalGamesLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalTimesLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalMovesLabel;

@property (retain, nonatomic) UIPopoverController *createUserPopover;
@property (retain, nonatomic) UIPopoverController *changeUserPopover;

@property (retain, nonatomic) IBOutlet UISegmentedControl *tableSegment;

- (IBAction)createUserPress:(id)sender;
- (IBAction)changeUserPress:(id)sender;
- (IBAction)insertScorePress:(id)sender;
- (void)updateUserInformation;
- (void)updateScoreInformation;
- (IBAction)segmentChange:(id)sender;
@end
