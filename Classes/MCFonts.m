//
//  MCFonts.m
//  MCGame
//
//  Created by kwan terry on 13-6-18.
//
//

#import "MCFonts.h"

@implementation MCFonts
+(UIFont*)customFontWithSize:(int)size{// 你的字体路径
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"fzzzhonghjw" ofType:@"ttf"];
    NSURL *url = [NSURL fileURLWithPath:fontPath];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL(( CFURLRef)url);
    if (fontDataProvider == NULL)        return nil;
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);    if (newFont == NULL) return nil;
    NSString *fontName = ( NSString *)CGFontCopyFullName(newFont);
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(newFont);        return font;
}
@end
