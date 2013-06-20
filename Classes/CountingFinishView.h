//
//  FinishView.h
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//
/*
 typedef enum _FinishViewType {
 kFinishView_GoBack= 0,
 kFinishView_ChangeName,
 kFinishView_OneMore,
 kFinishView_GoCountingPlay,
 kFinishView_Share,
 kFinishView_Default
 } FinishViewType;

 */

#import "UATitledModalPanel.h"
#import "MCConfiguration.h"
@interface CountingFinishView : UATitledModalPanel <UIPopoverControllerDelegate>{
    FinishViewType finishViewType;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) FinishViewType finishViewType;
@property (retain, nonatomic) IBOutlet UITextField *userNameEditField;
@property (retain, nonatomic) UIPopoverController *changeUserPopover;
@property (retain, nonatomic) IBOutlet UILabel *raceTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *raceStepCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *raceScoreLabel;
@property (nonatomic) long lastingTime;
@property (nonatomic) NSInteger stepCount;
@property (retain, nonatomic) IBOutlet UIButton *changeUserBtn;
@property (retain, nonatomic) IBOutlet UIView *knowledgePanel;
@property (retain, nonatomic) IBOutlet UIView *userNameEditPanel;

@property (retain, nonatomic) IBOutlet UILabel *celebrationLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *raceTimeTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *raceScoreTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *raceStepTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *knowledgeTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *knowLedgeTextView;


- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (IBAction)goBackBtnPressed:(id)sender;

- (IBAction)oneMoreBtnPressed:(id)sender;

- (IBAction)goCountingBtnPressed:(id)sender;

- (IBAction)shareBtnPressed:(id)sender;

- (IBAction)changeUserBtn:(id)sender;

@end
