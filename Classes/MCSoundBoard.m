//
//  MCSoundBoard.m
//  MCSoundBoard
//
//  Created by Baglan Dosmagambetov on 7/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCSoundBoard.h"
#import <AudioToolbox/AudioToolbox.h>

#define MCSOUNDBOARD_AUDIO_FADE_STEPS   30

@implementation MCSoundBoard {
    NSMutableDictionary *_sounds;
    NSMutableDictionary *_audio;
}

// Sound board singleton
// Taken from http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
+ (MCSoundBoard *)sharedInstance
{
     static MCSoundBoard* _sharedObject = nil;
    @synchronized(self)
    {
        if (!_sharedObject)
            _sharedObject = [[MCSoundBoard alloc] init];
	}
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _sounds = [[NSMutableDictionary alloc]init];
        _audio = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((CFURLRef)fileURL, &soundId);
    
    [_sounds setObject:[NSNumber numberWithInt:soundId] forKey:key];
}

+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addSoundAtPath:filePath forKey:key];
}

- (void)playSoundForKey:(id)key
{
    SystemSoundID soundId = [(NSNumber *)[_sounds objectForKey:key] intValue];
    AudioServicesPlaySystemSound(soundId);
}

+ (void)playSoundForKey:(id)key
{
    [[self sharedInstance] playSoundForKey:key];
}

- (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [_audio setObject:player forKey:key];
}

+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addAudioAtPath:filePath forKey:key];
}

- (void)fadeIn:(NSTimer *)timer
{
    AVAudioPlayer *player = [timer.userInfo objectForKey:@"player"];
    float maxvolume = [[timer.userInfo objectForKey:@"maxvolume"]floatValue];;
    float volume = player.volume;
    volume = volume + 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume > maxvolume ? maxvolume : volume;
    player.volume = volume;
    
    if (volume == maxvolume) {
        [timer invalidate];
    }
}

- (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval maxVolume:(NSNumber*)maxvolume
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeInInterval > 0.0) {
        player.volume = 0.0;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:player forKey:@"player"];
        [dic setObject:maxvolume forKey:@"maxvolume"];
        NSTimeInterval interval = fadeInInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeIn:)
                                       userInfo:dic
                                        repeats:YES];
    }
    
    [player play];
}

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval maxVolume:(NSNumber*)maxvolume
{
    [[self sharedInstance] playAudioForKey:key fadeInInterval:fadeInInterval maxVolume:maxvolume];
}

+ (void)playAudioForKey:(id)key maxVolume:(NSNumber*)maxvolume
{
    [[self sharedInstance] playAudioForKey:key fadeInInterval:0.0 maxVolume:maxvolume];
}


- (void)fadeOutAndStop:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo ;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [player pause];
    }
}

- (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndStop:)
                                       userInfo:player
                                        repeats:YES];
    } else {
        [player stop];
    }
}

+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self sharedInstance] stopAudioForKey:key fadeOutInterval:fadeOutInterval];
}

+ (void)stopAudioForKey:(id)key
{
    [[self sharedInstance] stopAudioForKey:key fadeOutInterval:0.0];
}


- (void)fadeOutAndPause:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [player stop];
    }
}

- (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndPause:)
                                       userInfo:player
                                        repeats:YES];
    } else {
        [player pause];
    }
}


+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self sharedInstance] pauseAudioForKey:key fadeOutInterval:fadeOutInterval];
}

+ (void)pauseAudioForKey:(id)key
{
    [[self sharedInstance] pauseAudioForKey:key fadeOutInterval:0.0];
}


- (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [_audio objectForKey:key];
}

+ (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [[self sharedInstance] audioPlayerForKey:key];
}

@end
