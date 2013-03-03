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
@synthesize backBtn;
@synthesize scoreTable;
@synthesize insertScoreTimeField;
@synthesize insertScoreMoveField;

@synthesize currentUserLabel;
@synthesize totalGamesLabel;
@synthesize totalTimesLabel;
@synthesize totalMovesLabel;
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
    
    PopChangeUserViewController *contentForChangeUser = [[PopChangeUserViewController alloc] init];
    
    changeUserPopover = [[UIPopoverController alloc] initWithContentViewController:contentForChangeUser];
    changeUserPopover.popoverContentSize = CGSizeMake(320., 216.);
    changeUserPopover.delegate = self;
    
    //init user information
    currentUserLabel.text = userManagerController.userModel.currentUser.name;
    totalGamesLabel.text = [[NSString alloc] initWithFormat:@"%d",userManagerController.userModel.currentUser.totalGames];
    totalMovesLabel.text = [[NSString alloc] initWithFormat:@"%d",userManagerController.userModel.currentUser.totalMoves];
    totalTimesLabel.text = [[NSString alloc] initWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalTimes];
    
    //observer to refresh the table view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAndScore) name:@"UserManagerSystemUpdateScore" object:nil];
}

- (void)viewDidUnload
{
    [self setScoreTable:nil];
    [self setCurrentUserLabel:nil];
    [self setTotalGamesLabel:nil];
    [self setTotalTimesLabel:nil];
    [self setTotalMovesLabel:nil];
    [self setInsertScoreTimeField:nil];
    [self setInsertScoreMoveField:nil];
    [self setTableSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (void)dealloc {
    [scoreTable release];
    [currentUserLabel release];
    [totalGamesLabel release];
    [totalTimesLabel release];
    [totalMovesLabel release];
    [insertScoreTimeField release];
    [insertScoreMoveField release];
    
    [tableSegment release];
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
    NSInteger row = [indexPath row];
    
    if (tableSegment.selectedSegmentIndex == 0) {
        if (row < [userManagerController.userModel.topScore count]) {
            
            MCScore *_scoreRecord = [userManagerController.userModel.topScore objectAtIndex:row];
            
            NSString *_rank = [[NSString alloc] initWithFormat:@"%d",row+1];
            NSString *_move = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.move];
            NSString *_time = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.time];
            NSString *_speed = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.speed];
            NSString *_score = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.score];
            
            [cell setCellWithRank:_rank Name:_scoreRecord.name Move:_move Time:_time Speed:_speed Score:_score];
            
            [_rank release];
            [_scoreRecord release];
            [_move release];
            [_time release];
            [_speed release];
            [_score release];
        }
            } else {
                if (row < [userManagerController.userModel.myScore count]) {
                    
                    MCScore *_scoreRecord = [userManagerController.userModel.myScore objectAtIndex:row];
                    
                    NSString *_rank = [[NSString alloc] initWithFormat:@"%d",row+1];
                    NSString *_move = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.move];
                    NSString *_time = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.time];
                    NSString *_speed = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.speed];
                    NSString *_score = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.score];
                    
                    [cell setCellWithRank:_rank Name:_scoreRecord.name Move:_move Time:_time Speed:_speed Score:_score];
                    
                    [_rank release];
                    [_scoreRecord release];
                    [_move release];
                    [_time release];
                    [_speed release];
                    [_score release];
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
    [self updateUserInformation];
    
    if (popoverController == createUserPopover) {
        
    }
    
    if (popoverController == changeUserPopover) {
        
    }
}
#pragma mark goback
-(IBAction)goBackMainMenu:(id)sender{
    CoordinatingController *tmp = [CoordinatingController sharedCoordinatingController];
    [tmp requestViewChangeByObject:kScoreBoard2MainMenu];
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

- (void)insertScorePress:(id)sender
{
    [userManagerController createNewScoreWithMove:[insertScoreMoveField.text integerValue] Time:[insertScoreTimeField.text floatValue]];
}

- (void)segmentChange:(id)sender
{
    [scoreTable reloadData];
}

- (void) updateUserInformation
{
    //user information
    currentUserLabel.text = userManagerController.userModel.currentUser.name;
    totalGamesLabel.text = [[NSString alloc] initWithFormat:@"%d",userManagerController.userModel.currentUser.totalGames];
    totalMovesLabel.text = [[NSString alloc] initWithFormat:@"%d",userManagerController.userModel.currentUser.totalMoves];
    totalTimesLabel.text = [[NSString alloc] initWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalTimes];
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


@end
