//
//  CompositeRotationUtil.h
//  MCGame
//
//  Created by Aha on 13-5-13.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface MCCompositeRotationUtil : NSObject

//all situations but not Bw+Bw=Bw2...
+ (BOOL)isSingmasterNotation:(SingmasterNotation)first andSingmasterNotation:(SingmasterNotation)second equalTo:(SingmasterNotation)target;

//all situations but not Bw+Bw=Bw2...
+ (BOOL)isSingmasterNotation:(SingmasterNotation)part PossiblePartOfSingmasterNotation:(SingmasterNotation)target;

@end
