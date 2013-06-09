
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
#import "MCStringDefine.h"
@implementation SoundSettingController
@synthesize backgroundPlayer;
@synthesize _BackGroundMusicValume;
@synthesize _RotateEffectValume;
@synthesize _RotateEffectSwitch;
@synthesize _BackGroundMusicSwitch;
+(SoundSettingController *)sharedsoundSettingController{
    static SoundSettingController * sharedsoundSettingController;
    @synchronized(self){
        if (!sharedsoundSettingController) {
            sharedsoundSettingController = [[SoundSettingController alloc]init];
        }
    }
    return sharedsoundSettingController;
}
//加载声音配置
-(void)loadSoundConfiguration{
    NSString * filepath = [self filePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filepath]) {
        NSDictionary * configDic = [[NSDictionary alloc]initWithContentsOfFile:filepath];
        [self set_BackGroundMusicSwitch: [configDic objectForKey:S_L_BackGroundMusicSwitch]];
        [self set_RotateEffectSwitch: [configDic objectForKey:S_L_RotateEffectSwitch]];
        [self set_BackGroundMusicValume:[configDic objectForKey:S_L_BackGroundMusicValume]];
        [self set_RotateEffectValume:[configDic objectForKey:S_L_RotateEffectValume]];
        [configDic release];

    }else{
        [self set_BackGroundMusicValume:[[[NSNumber alloc] initWithFloat:1.0] autorelease]];
        [self set_RotateEffectValume:[[[NSNumber alloc] initWithFloat:1.0] autorelease]];
        [self set_RotateEffectSwitch :[[[NSNumber alloc] initWithBool:YES] autorelease]];
        [self set_BackGroundMusicSwitch:[[[NSNumber alloc] initWithBool:YES] autorelease]];
    }
    if ([[self _BackGroundMusicSwitch]boolValue]) {
        backgroundPlayer = [MCSoundBoard audioPlayerForKey:Audio_BackGroundSound_Loop_key];
        backgroundPlayer.numberOfLoops = -1;  // Endless
        backgroundPlayer.volume  = [[self _BackGroundMusicValume] floatValue];
        NSNumber *maxvolume = [[[NSNumber alloc]initWithFloat:backgroundPlayer.volume] autorelease];
        [MCSoundBoard playAudioForKey:Audio_BackGroundSound_Loop_key fadeInInterval:2.0 maxVolume:maxvolume];
    }
};
//restore sound config
-(void)restoreSoundConfiguration{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[self _BackGroundMusicValume] forKey:S_L_BackGroundMusicValume];
    [dic setObject:[self _RotateEffectValume] forKey:S_L_RotateEffectValume];
    [dic setObject:[self _RotateEffectSwitch] forKey:S_L_RotateEffectSwitch];
    [dic setObject:[self _BackGroundMusicSwitch] forKey:S_L_BackGroundMusicSwitch];
    [dic writeToFile:[self filePath] atomically:YES];
    [dic release];
};
-(NSString*)filePath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:Congig_Sound_File];
};
-(void)loadSounds{
    [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:Audio_RotateSound_Ding ofType:nil] forKey:Audio_RotateSound_Ding_key];
    
    [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:Audio_BackGroundSound_Loop ofType:nil] forKey:Audio_BackGroundSound_Loop_key];
    
    backgroundPlayer = [MCSoundBoard audioPlayerForKey:Audio_BackGroundSound_Loop_key];
};
-(void)setBackgroundPlayer_Volume:(float)volume{
    [self set_BackGroundMusicValume:[[[NSNumber alloc] initWithFloat:volume] autorelease]];
    backgroundPlayer.volume = volume;
    [self restoreSoundConfiguration];
};
-(void)playSoundForKey:(NSString*)key{
    if ((![self _RotateEffectSwitch])&&[key isEqualToString:Audio_RotateSound_Ding_key]) {
        return;
    }
    [MCSoundBoard playSoundForKey:key];
};
-(void)playAudioForKey:(NSString*)key maxVolume:(NSNumber *)maxvolume{
     [MCSoundBoard playAudioForKey:key maxVolume:[[[NSNumber alloc]initWithFloat:1.0] autorelease]];
};
-(void)pauseAudioForKey:(NSString*)key fadeOutInterval:(NSTimeInterval)fadetime{
    [MCSoundBoard pauseAudioForKey:key fadeOutInterval:fadetime];
};

-(void)playAudioForKey:(NSString*)key fadeInInterval:(NSTimeInterval)fadetime maxVolume:(NSNumber*)maxvolume{
    [MCSoundBoard playAudioForKey:key fadeInInterval:fadetime maxVolume:maxvolume];
    
};
-(void)loopBackGroundAudioFlipSwitch{
    
    backgroundPlayer.numberOfLoops = -1;  // Endless
    if (backgroundPlayer.playing) {
        [MCSoundBoard pauseAudioForKey:Audio_BackGroundSound_Loop_key fadeOutInterval:2.0];
        [self set_BackGroundMusicSwitch:[[[NSNumber alloc] initWithBool:NO] autorelease]];
        [self restoreSoundConfiguration];
    } else {
        [MCSoundBoard playAudioForKey:Audio_BackGroundSound_Loop_key fadeInInterval:0.8 maxVolume:[self _BackGroundMusicValume]];
        [self set_BackGroundMusicSwitch:[[[NSNumber alloc] initWithBool:YES] autorelease]];
        [self restoreSoundConfiguration];
    }
};
-(void)rotateSoundFlipSwitch{
    NSNumber *flip = [[NSNumber alloc]initWithBool:(![[self _RotateEffectSwitch] boolValue])];
    [self set_RotateEffectSwitch:flip];
    [flip release];
    [self restoreSoundConfiguration];
}
@end
