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
@interface FinishView : UATitledModalPanel <UIPopoverControllerDelegate>{
    FinishViewType finishViewType;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) FinishViewType finishViewType;
@property (retain, nonatomic) IBOutlet UITextField *userNameEditField;
@property (retain, nonatomic) UIPopoverController *changeUserPopover;
@property (retain, nonatomic) IBOutlet UILabel *learningTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *learningStepCountLabel;
@property (nonatomic) long lastingTime;
@property (nonatomic) NSInteger stepCount;
@property (retain, nonatomic) IBOutlet UIButton *changeUserBtn;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (IBAction)goBackBtnPressed:(id)sender;

- (IBAction)oneMoreBtnPressed:(id)sender;

- (IBAction)goCountingBtnPressed:(id)sender;

- (IBAction)shareBtnPressed:(id)sender;

- (IBAction)changeUserBtn:(id)sender;

@end
