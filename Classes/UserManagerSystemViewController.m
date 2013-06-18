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

@end

@implementation UserManagerSystemViewController

@synthesize scoreTable;
@synthesize currentUserLabel;
@synthesize totalFinishLabel;
@synthesize totalGameTimeLabel;
@synthesize totalMovesLabel;
@synthesize totalLearnTimeLabel;
@synthesize createUserPopover;
@synthesize changeUserPopover;
@synthesize tableSegment;


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
    self.totalGameTimeLabel.text = [NSString stringWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalGameTime];
    self.totalLearnTimeLabel.text = [NSString stringWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalLearnTime];
    
    //observer to refresh the table view
    //notification was sent by user manager controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAndScore) name:@"UserManagerSystemUpdateScore" object:nil];
    
    // Init selector btn
    [_totalRankBtn setEnabled:NO];
}

- (void)viewDidUnload
{
    [self setScoreTable:nil];
    [self setCurrentUserLabel:nil];
    [self setTotalFinishLabel:nil];
    [self setTotalGameTimeLabel:nil];
    [self setTotalMovesLabel:nil];
    [self setTableSegment:nil];
    [self setTotalLearnTimeLabel:nil];
    [self setBackBtn:nil];
    [self setTotalRankBtn:nil];
    [self setPersonalRankBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (void)dealloc {
    [scoreTable release];
    [currentUserLabel release];
    [totalFinishLabel release];
    [totalGameTimeLabel release];
    [totalMovesLabel release];
    [tableSegment release];
    [totalLearnTimeLabel release];
    [_backBtn release];
    [_totalRankBtn release];
    [_personalRankBtn release];
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
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    //set score information
    NSInteger scoreIndex = [indexPath row];
    
    if (tableSegment.selectedSegmentIndex == 0) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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



- (void)segmentChange:(id)sender
{
    [scoreTable reloadData];
}

- (IBAction)totalRankBtnUp:(id)sender {
    [_totalRankBtn setEnabled:NO];
    [_personalRankBtn setEnabled:YES];
    [scoreTable reloadData];
}

- (IBAction)personalRankBtnUp:(id)sender {
    [_totalRankBtn setEnabled:YES];
    [_personalRankBtn setEnabled:NO];
    [scoreTable reloadData];
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
    [scoreTable reloadData];
}

- (void) updateUserAndScore
{
    [self updateUserInformation];
    [self updateScoreInformation];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
};
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{};
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{};
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{};


@end
