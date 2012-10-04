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
@interface MCMaterialController : NSObject{
    //材质库
    NSMutableDictionary * materialLibrary;
	//方形材质
    NSMutableDictionary * quadLibrary;
}

+ (MCMaterialController*)sharedMaterialController;
- (MCAnimatedQuad*)animationFromAtlasKeys:(NSArray*)atlasKeys;
- (MCTexturedQuad*)quadFromAtlasKey:(NSString*)atlasKey;
- (MCTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary*)record 
                                     atlasSize:(CGSize)atlasSize
                                   materialKey:(NSString*)key;;
- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey;
- (id) init;
- (void) dealloc;
- (void)bindMaterial:(NSString*)materialKey;
- (void)loadAtlasData:(NSString*)atlasName;

@end
