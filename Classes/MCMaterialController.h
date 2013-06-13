//
//  MCMaterialController.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCTexturedQuad;
@class MCAnimatedQuad;
#import "MCPoint.h"
@interface MCMaterialController : NSObject{
    //model meterial
    NSMutableDictionary * materialLibrary;
	//button meterial
    NSMutableDictionary * quadLibrary;
}

+ (MCMaterialController*)sharedMaterialController;
- (MCAnimatedQuad*)animationFromAtlasKeys:(NSArray*)atlasKeys;
- (MCTexturedQuad*)quadFromAtlasKey:(NSString*)atlasKey;
//对旧有数据格式的支持
- (MCTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary*)record 
                                     atlasSize:(CGSize)atlasSize
                                   materialKey:(NSString*)key;
//对texturepacker的支持
- (MCTexturedQuad*)texturedQuadFrom_TexturePacker_AtlasRecord:(NSDictionary*)record
                                     atlasSize:(CGSize)atlasSize
                                   materialKey:(NSString*)key;
- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey;
- (id) init;
- (void) reload;
- (void) dealloc;
- (void)bindMaterial:(NSString*)materialKey;
//旧数据plist格式文件
- (void)loadAtlasData:(NSString*)atlasName;
//兼容texturepacker格式文件
- (void)loadAtlas_TexturePacker_Data:(NSString*)atlasName;

//返回某个纹理w和h
+(MCPoint)getWidthAndHeightFromTextureFile:(NSString *)filename forKey:(NSString*)key;
@end
