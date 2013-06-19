//
//  MCSystemSettingViewController.h
//  MCGame
//
//  Created by kwan terry on 13-6-3.
//
//

#import <UIKit/UIKit.h>
#import "SoundSettingController.h"
@interface MCSystemSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UISlider *soundEffectSlider;
    IBOutlet UISlider *musicSlider;
    IBOutlet UILabel *settingLabel;
    IBOutlet UILabel *soundEffectLabel;
    IBOutlet UILabel *musicLabel;
    IBOutlet UILabel *magicCubeSkinLabel;
    IBOutlet UIButton *_selectColorItemOne;
    IBOutlet UIButton *_selectColorItemTwo;
    IBOutlet UIButton *_selectColorItemThree;
    
}

-(IBAction)goBackMainMenu:(id)sender;


- (IBAction)selectOneColor:(id)sender;



@end
