//
//  MCMobileObject.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"

@interface MCMobileObject : MCSceneObject {
	MCPoint speed;
	MCPoint rotationalSpeed;
}

@property (assign) MCPoint speed;
@property (assign) MCPoint rotationalSpeed;

- (void)checkArenaBounds;
- (void)update;

// 2 methods


@end
