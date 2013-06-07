//
//  SoundSeetingController.h
//  MCGame
//
//  Created by kwan terry on 13-6-6.
//
//

#import <Foundation/Foundation.h>

@interface SoundSettingController : NSObject{
}
//singleton
+ (SoundSettingController*)sharedsoundSettingController;
//prtload all sounds
-(void)loadSounds;
-(void)playSoundForKey:(NSString*)key;
-(void)playAudioForKey:(NSString*)key;
-(void)pauseAudioForKey:(NSString*)key fadeOutInterval:(NSTimeInterval)fadetime;
-(void)playAudioForKey:(NSString*)key fadeOutInterval:(NSTimeInterval)fadetime;
-(void)loopBackGroundAudioFlipSwitch;
@end
