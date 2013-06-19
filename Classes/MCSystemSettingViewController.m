//
//  MCSystemSettingViewController.m
//  MCGame
//
//  Created by kwan terry on 13-6-3.
//
//

#import "MCSystemSettingViewController.h"
#import "MCStringDefine.h"
#import "CoordinatingController.h"
#import <AVFoundation/AVFoundation.h>
#import "MCSoundBoard.h"
#import "SoundSettingController.h"
#import "MCFonts.h"

@interface MCSystemSettingViewController ()

@end

@implementation MCSystemSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [soundEffectSlider setValue:[[[SoundSettingController sharedsoundSettingController] _RotateEffectValume] floatValue]];
    [soundEffectSlider addTarget:self action:@selector(effectsVolume:) forControlEvents:UIControlEventValueChanged];
    
    [musicSlider setValue:[[[SoundSettingController sharedsoundSettingController] _BackGroundMusicValume] floatValue]];
    [musicSlider addTarget:self action:@selector(musicVolume:) forControlEvents:UIControlEventValueChanged];
    
    // set fonts
    [settingLabel setFont:[MCFonts customFontWithSize:50]];
    [soundEffectLabel setFont:[MCFonts customFontWithSize:25]];
    [musicLabel setFont:[MCFonts customFontWithSize:25]];
    [magicCubeSkinLabel setFont:[MCFonts customFontWithSize:25]];
    
    // default color 
    [_selectColorItemOne setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) musicVolume:(id)sender
{
	SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting setBackgroundPlayer_Volume:[(UISlider*)sender value]];
}
- (void) musicSwitch:(id)sender
{
	//soundMgr.backgroundMusicVolume = ((UISlider *)sender).value;
    SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting loopBackGroundAudioFlipSwitch];
}

- (void) effectsVolume:(id)sender
{
	//soundMgr.soundEffectsVolume = ((UISlider *)sender).value;
}
- (void) effectsSwitch:(id)sender
{
	SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting rotateSoundFlipSwitch];
}


-(void)goBackMainMenu:(id)sender{
    CoordinatingController *tmp = [CoordinatingController sharedCoordinatingController];
    [tmp requestViewChangeByObject:kSystemSetting2MainMenu];
}

- (IBAction)selectOneColor:(id)sender {
    NSInteger tag = [sender tag];
    
    [_selectColorItemOne setEnabled:YES];
    [_selectColorItemTwo setEnabled:YES];
    [_selectColorItemThree setEnabled:YES];
    
    switch (tag) {
        case 0:
            [_selectColorItemOne setEnabled:NO];
            break;
        case 1:
            [_selectColorItemTwo setEnabled:NO];
            break;
        case 2:
            [_selectColorItemThree setEnabled:NO];
            break;
        default:
            break;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
};
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{};
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{};
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{};

- (void)dealloc {
    [soundEffectSlider release];
    [musicSlider release];
    [settingLabel release];
    [soundEffectLabel release];
    [musicLabel release];
    [magicCubeSkinLabel release];
    [_selectColorItemOne release];
    [_selectColorItemTwo release];
    [_selectColorItemThree release];
    [super dealloc];
}
- (void)viewDidUnload {
    [soundEffectSlider release];
    soundEffectSlider = nil;
    [musicSlider release];
    musicSlider = nil;
    [settingLabel release];
    settingLabel = nil;
    [soundEffectLabel release];
    soundEffectLabel = nil;
    [musicLabel release];
    musicLabel = nil;
    [magicCubeSkinLabel release];
    magicCubeSkinLabel = nil;
    [_selectColorItemOne release];
    _selectColorItemOne = nil;
    [_selectColorItemTwo release];
    _selectColorItemTwo = nil;
    [_selectColorItemThree release];
    _selectColorItemThree = nil;
    [super viewDidUnload];
}
@end
