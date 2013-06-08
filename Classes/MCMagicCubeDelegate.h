//
//  MCMagicCubeProtocol.h
//  MCGame
//
//  Created by Aha on 13-5-16.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCCubieDelegate.h"
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCMagicCubeOperationDelegate.h"

@protocol MCMagicCubeDelegate <MCMagicCubeDataSouceDelegate, MCMagicCubeOperationDelegate>

@end
