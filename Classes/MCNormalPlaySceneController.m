//
//  MCNormalPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "MCNormalPlaySceneController.h"
#import "MCMagicCubeUIModelController.h"
#import "Cube.h"
#import "MCMultiDigitCounter.h"
#import "MCCollisionController.h"
@implementation MCNormalPlaySceneController
//@synthesize magicCubeUI;
@synthesize magicCube;
+(MCNormalPlaySceneController*)sharedNormalPlaySceneController
{
    static MCNormalPlaySceneController *sharedNormalPlaySceneController;
    @synchronized(self)
    {
        if (!sharedNormalPlaySceneController)
            sharedNormalPlaySceneController = [[MCNormalPlaySceneController alloc] init];
	}
	return sharedNormalPlaySceneController;
}

-(void)rotate:(RotateType *)rotateType{
    [magicCube rotateOnAxis:[rotateType rotate_axis] onLayer:[rotateType rotate_layer] inDirection:[rotateType rotate_direction]];
}

-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];
	
    float scale = 60.0;
    
	magicCube = [MCMagicCube getSharedMagicCube];
    //大魔方
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiate];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    //[magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	// reload our interface
	[inputController loadInterface];
}

-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [inputController stepcounter];
    [tmp addCounter];
}
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [inputController stepcounter];
    [tmp minusCounter];
}

-(void)reloadLastTime{
    [super removeAllObjectFromScene];
    
    //大魔方
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getAxisStates]];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    //[magicCubeUI release];
}



-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [[sceneObjects objectAtIndex:0]performSelector:@selector(nextSolution)];
}

@end
