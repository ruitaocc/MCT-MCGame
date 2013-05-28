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
@interface FinishView : UATitledModalPanel{
    FinishViewType finishViewType;
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) FinishViewType finishViewType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)goBackBtnPressed:(id)sender;
- (IBAction)changeNameBtnPressed:(id)sender;
- (IBAction)oneMoreBtnPressed:(id)sender;
- (IBAction)goCountingBtnPressed:(id)sender;
- (IBAction)shareBtnPressed:(id)sender;

@end
