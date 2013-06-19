//
//  LearnPagePauseMenu.h
//  MCGame
//
//  Created by kwan terry on 13-6-18.
//
//
#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "sceneController.h"
#import "InputController.h"
#import "CoordinatingController.h"
typedef enum _LearnPagePauseSelectType {
    kLearnPagePauseSelect_GoOn  = 0,
    kLearnPagePauseSelect_GoBack,
    kLearnPagePauseSelect_Restart,
    kLearnPagePauseSelect_default
} LearnPagePauseSelectType;
@interface LearnPagePauseMenu : UATitledModalPanel{
    LearnPagePauseSelectType learnPagePauseSelectType;
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) LearnPagePauseSelectType learnPagePauseSelectType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)goOnBtnPressed:(id)sender;
- (IBAction)restartBtnPressed:(id)sender;
- (IBAction)goBackMainMenuBtnPressed:(id)sender;

@end
