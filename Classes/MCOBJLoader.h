//
//  MCOBJLoader.h
//  MCGame
//
//  Created by kwan terry on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOBJLoader : NSObject{
    NSMutableDictionary * objLibrary;
}
+(MCOBJLoader*)sharedMCOBJLoader;
-(void)loadObjFromFile:(NSString*)filename objkey:(NSString*)objkey;

-(int) getVertexCount;
-(int) getTriangleIndexCount;

@end
