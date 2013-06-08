//
//  MCSoundBoard.h
//  MCSoundBoard
//
//  Created by Baglan Dosmagambetov on 7/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MCSoundBoard : NSObject

//sounds
+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key;
+ (void)playSoundForKey:(id)key;


//audioes
+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key;

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval maxVolume:(NSNumber*)maxvolume;
+ (void)playAudioForKey:(id)key maxVolume:(NSNumber*)maxvolume;

+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)stopAudioForKey:(id)key;

+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)pauseAudioForKey:(id)key;

+ (AVAudioPlayer *)audioPlayerForKey:(id)key;

@end
