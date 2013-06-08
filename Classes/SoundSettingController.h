//
//  SoundSeetingController.h
//  MCGame
//
//  Created by kwan terry on 13-6-6.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundSettingController : NSObject{
    AVAudioPlayer *backgroundPlayer;
}
@property (nonatomic,retain)AVAudioPlayer *backgroundPlayer;
@property (nonatomic,retain)NSNumber *_RotateEffectValume;
@property (nonatomic,retain)NSNumber *_BackGroundMusicValume;
@property (nonatomic,assign)NSNumber *_RotateEffectSwitch;
@property (nonatomic,assign)NSNumber *_BackGroundMusicSwitch;
//singleton
+ (SoundSettingController*)sharedsoundSettingController;
//prtload all sounds
-(void)loadSounds;

-(void)playSoundForKey:(NSString*)key;
-(void)playAudioForKey:(NSString*)key maxVolume:(NSNumber*)maxvolume;
-(void)pauseAudioForKey:(NSString*)key fadeOutInterval:(NSTimeInterval)fadetime;
-(void)playAudioForKey:(NSString*)key fadeInInterval:(NSTimeInterval)fadetime maxVolume:(NSNumber*)maxvolume;

-(void)setBackgroundPlayer_Volume:(float)volume;

-(void)loopBackGroundAudioFlipSwitch;

//load all sound setting from file system.
-(void)loadSoundConfiguration;
//restore sound config
-(void)restoreSoundConfiguration;
-(NSString*)filePath;
@end
