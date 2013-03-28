//
//  PauseMenu.h
//  MCGame
//
//  Created by kwan terry on 13-3-4.
//
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "sceneController.h"
#import "InputController.h"
#import "CoordinatingController.h"
typedef enum _PauseSelectType {
    kPauseSelect_GoOn  = 0,
    kPauseSelect_GoBack,
    kPauseSelect_Restart,
    kPauseSelect_default
} PauseSelectType;
@interface PauseMenu : UATitledModalPanel{
    PauseSelectType pauseSelectType;
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) PauseSelectType pauseSelectType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)goOnBtnPressed:(id)sender;
- (IBAction)restartBtnPressed:(id)sender;
- (IBAction)goBackMainMenuBtnPressed:(id)sender;

@end
