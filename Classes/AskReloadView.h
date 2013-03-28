//
//  AskReloadView.h
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "UATitledModalPanel.h"
typedef enum _AskReloadType {
    kAskReloadView_LoadLastTime  = 0,
    kAskReloadView_Reload,
    kAskReloadView_Cancel,
    kAskReloadView_Default
} AskReloadType;
@interface AskReloadView : UATitledModalPanel{
    AskReloadType askReloadType;
    IBOutlet UIView	*viewLoadedFromXib;

}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) AskReloadType askReloadType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)loadLastTimeBtnPressed:(id)sender;
- (IBAction)reloadBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;

@end
