
//
//  SoundSeetingController.m
//  MCGame
//
//  Created by kwan terry on 13-6-6.
//
//

#import "SoundSettingController.h"
#import "MCSoundBoard.h"
#import "MCStringDefine.h"
@implementation SoundSettingController
+(SoundSettingController *)sharedsoundSettingController{
    static SoundSettingController * sharedsoundSettingController;
    @synchronized(self){
        if (!sharedsoundSettingController) {
            sharedsoundSettingController = [[SoundSettingController alloc]init];
        }
    }
    return sharedsoundSettingController;
}

-(void)loadSounds{
    [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:Audio_RotateSound_Ding ofType:nil] forKey:Audio_RotateSound_Ding_key];
    
    [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:Audio_BackGroundSound_Loop ofType:nil] forKey:Audio_BackGroundSound_Loop_key];
    AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:Audio_BackGroundSound_Loop_key];
    player.numberOfLoops = -1;  // Endless
    [MCSoundBoard playAudioForKey:Audio_BackGroundSound_Loop_key fadeInInterval:2.0];

};

-(void)playSoundForKey:(NSString*)key{
    [MCSoundBoard playSoundForKey:key];
};
-(void)playAudioForKey:(NSString*)key{
     [MCSoundBoard playAudioForKey:key];
};
-(void)pauseAudioForKey:(NSString*)key fadeOutInterval:(NSTimeInterval)fadetime{
    [MCSoundBoard pauseAudioForKey:key fadeOutInterval:fadetime];
};
-(void)playAudioForKey:(NSString*)key fadeOutInterval:(NSTimeInterval)fadetime{
    [MCSoundBoard playAudioForKey:key fadeInInterval:fadetime];
    
};
-(void)loopBackGroundAudioFlipSwitch{
    AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:Audio_BackGroundSound_Loop_key];
    if (player.playing) {
        [MCSoundBoard pauseAudioForKey:Audio_BackGroundSound_Loop_key fadeOutInterval:2.0];
    } else {
        [MCSoundBoard playAudioForKey:Audio_BackGroundSound_Loop_key fadeInInterval:2.0];
    }
};

@end
