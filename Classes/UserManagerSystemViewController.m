//
//  UserManagerSystemViewController.m
//  UserManagerSystemXib
//
//  Created by yellow Dai on 13-1-18.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "UserManagerSystemViewController.h"
#import "CoordinatingController.h"

@interface UserManagerSystemViewController ()

- (NSString *)timeInFormatFromTotalSeconds:(NSInteger)totalSeconds;


@end

@implementation UserManagerSystemViewController

@synthesize scoreTable = _scoreTable;
@synthesize currentUserLabel;
@synthesize totalFinishLabel;
@synthesize totalGameTimeLabel;
@synthesize totalMovesLabel;
@synthesize totalLearnTimeLabel;
@synthesize createUserPopover;
@synthesize changeUserPopover;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    userManagerController = [MCUserManagerController allocWithZone:NULL];
    
    //popover
    PopCreateUserViewController *contentForCreateUser = [[PopCreateUserViewController alloc] init];
    createUserPopover = [[UIPopoverController alloc] initWithContentViewController:contentForCreateUser];
    createUserPopover.popoverContentSize = CGSizeMake(320., 216.);
    createUserPopover.delegate = self;
    [contentForCreateUser release];
    
    PopChangeUserViewController *contentForChangeUser = [[PopChangeUserViewController alloc] init];
    changeUserPopover = [[UIPopoverController alloc] initWithContentViewController:contentForChangeUser];
    changeUserPopover.popoverContentSize = CGSizeMake(320., 216.);
    changeUserPopover.delegate = self;
    [contentForChangeUser release];
    
    //init user information
    self.currentUserLabel.text = userManagerController.userModel.currentUser.name;
    self.totalFinishLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalFinish];
    self.totalMovesLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalMoves];
    self.totalGameTimeLabel.text = [self timeInFormatFromTotalSeconds:(NSInteger)(userManagerController.userModel.currentUser.totalGameTime + 0.5)];
    
    self.totalLearnTimeLabel.text = [self timeInFormatFromTotalSeconds:(NSInteger)(userManagerController.userModel.currentUser.totalLearnTime + 0.5)];
    
    
    //observer to refresh the table view
    //notification was sent by user manager controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAndScore) name:@"UserManagerSystemUpdateScore" object:nil];
    
    // Init selector btn
    [_totalRankBtn setEnabled:NO];
    
    // Circular bead
    _scoreTable.layer.cornerRadius = 5.0;
    _staticScrollPanel.layer.cornerRadius = 5.0;
}

- (void)viewDidUnload
{
    [self setScoreTable:nil];
    [self setCurrentUserLabel:nil];
    [self setTotalFinishLabel:nil];
    [self setTotalGameTimeLabel:nil];
    [self setTotalMovesLabel:nil];
    [self setTotalLearnTimeLabel:nil];
    [self setBackBtn:nil];
    [self setTotalRankBtn:nil];
    [self setPersonalRankBtn:nil];
    [self setStaticScrollPanel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (void)dealloc {
    [_scoreTable release];
    [currentUserLabel release];
    [totalFinishLabel release];
    [totalGameTimeLabel release];
    [totalMovesLabel release];
    [totalLearnTimeLabel release];
    [_backBtn release];
    [_totalRankBtn release];
    [_personalRankBtn release];
    [_staticScrollPanel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Tableview delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ScoreCell* cell = (ScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"ScoreCellIdentifier"];
    
    //set score information
    NSInteger scoreIndex = [indexPath row];
    
    if (cell == nil) {
        if (scoreIndex % 2 == 0) {
            if (scoreIndex == 4) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCellBottomDark" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            else{
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCellCenterDark" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
        }
        else {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCellCenterGrey" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
    }
    
    if ([_personalRankBtn isEnabled]) {
        if (scoreIndex < [userManagerController.userModel.topScore count]) {
                    
            MCScore *_scoreRecord = [userManagerController.userModel.topScore objectAtIndex:scoreIndex];
            
            NSString *_rank = [[NSString alloc] initWithFormat:@"%d",scoreIndex+1];
            NSString *_move = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.move];
            NSString *_time = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.time];
            NSString *_speed = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.speed];
            NSString *_score = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.score];
            
            [cell setCellWithRank:_rank Name:_scoreRecord.name Move:_move Time:_time Speed:_speed Score:_score];
            
            [_rank release];
            [_move release];
            [_time release];
            [_speed release];
            [_score release];
        }
        else {
            [cell setCellWithRank:@"" Name:@"" Move:@"" Time:@"" Speed:@"" Score:@""];
        }
            } else {
                if (scoreIndex < [userManagerController.userModel.myScore count]) {
                   
                    MCScore *_scoreRecord = [userManagerController.userModel.myScore objectAtIndex:scoreIndex];
                    
                    NSString *_rank = [[NSString alloc] initWithFormat:@"%d",scoreIndex+1];
                    NSString *_move = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.move];
                    NSString *_time = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.time];
                    NSString *_speed = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.speed];
                    NSString *_score = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.score];
                    
                    [cell setCellWithRank:_rank Name:_scoreRecord.name Move:_move Time:_time Speed:_speed Score:_score];
                    
                    [_rank release];
                    [_move release];
                    [_time release];
                    [_speed release];
                    [_score release];
               }
                else {
                    [cell setCellWithRank:@"" Name:@"" Move:@"" Time:@"" Speed:@"" Score:@""];
                }

                    }
    return cell;
}



#pragma mark -
#pragma mark Popover controller delegates

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //pop over dismiss, and update user information 
    [self updateUserAndScore];
    
    if (popoverController == createUserPopover) {
        
    }
    
    if (popoverController == changeUserPopover) {
        
    }
}

#pragma mark -
#pragma mark user methods
- (void)createUserPress:(id)sender
{
    UIButton *tapbtn = (UIButton*) sender;
    
    [createUserPopover presentPopoverFromRect:tapbtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)changeUserPress:(id)sender
{
    UIButton *tapbtn = (UIButton*) sender;
    
    [changeUserPopover presentPopoverFromRect:tapbtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


- (IBAction)totalRankBtnUp:(id)sender {
    [_totalRankBtn setEnabled:NO];
    [_personalRankBtn setEnabled:YES];
    [_scoreTable reloadData];
}

- (IBAction)personalRankBtnUp:(id)sender {
    [_totalRankBtn setEnabled:YES];
    [_personalRankBtn setEnabled:NO];
    [_scoreTable reloadData];
}


#pragma mark goback
- (IBAction)goBackMainMenu:(id)sender {
    CoordinatingController *tmp = [CoordinatingController sharedCoordinatingController];
    [tmp requestViewChangeByObject:kScoreBoard2MainMenu];
}

- (void) updateUserInformation
{
    //user information
    self.currentUserLabel.text = userManagerController.userModel.currentUser.name;
    self.totalFinishLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalFinish];
    self.totalMovesLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalMoves];
    self.totalGameTimeLabel.text = [NSString stringWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalGameTime];
    self.totalLearnTimeLabel.text = [NSString stringWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalLearnTime];
}

- (void)updateScoreInformation
{
    [_scoreTable reloadData];
}

- (void) updateUserAndScore
{
    [self updateUserInformation];
    [self updateScoreInformation];
}


- (NSString *)timeInFormatFromTotalSeconds:(NSInteger)totalSeconds{
    NSInteger second = totalSeconds % 60;
    NSInteger minute = totalSeconds / 60 % 60;
    NSInteger hour = totalSeconds / 3600 % 100;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}




@end
