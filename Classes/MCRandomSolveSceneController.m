//
//  MCRandomSolveViewController.m
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "MCRandomSolveSceneController.h"
#import "MCConfiguration.h"
#import "MCMagicCubeUIModelController.h"
#import "MCRandomSolveViewInputControllerViewController.h"
#import "MCBackGroundTexMesh.h"
#import "MCFonts.h"
@implementation MCRandomSolveSceneController

@synthesize magicCube;
//playHelper
@synthesize selected_face_index;
@synthesize selected_index;

+(MCRandomSolveSceneController*)sharedRandomSolveSceneController {
    static MCRandomSolveSceneController *sharedRandomSolveSceneController;
    @synchronized(self)
    {
        if (!sharedRandomSolveSceneController)
            sharedRandomSolveSceneController = [[MCRandomSolveSceneController alloc] init];
	}
	return sharedRandomSolveSceneController;
}


-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];
    selected_index = -1;
    selected_face_index = -1;
    
    //初始化只有中心小块到魔方
    //NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
   // NSString *filePath = [path stringByAppendingPathComponent:TmpMagicCubeData];
    
    //magicCube=[[MCMagicCube unarchiveMagicCubeWithFile:filePath] retain];
    
    magicCube = [[MCMagicCube magicCubeOnlyWithCenterColor]retain];
    
    //playHelper = [[MCPlayHelper playerHelperWithMagicCube:self.magicCube]retain];
    //背景
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    
    //
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[magicCube getColorInOrientationsOfAllCubie]] ;
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI setUsingMode:SOlVE_Input_MODE];
    [magicCubeUI release];
    
    
    //提示标签
    [self setTipsLabel: [[[UILabel alloc]initWithFrame:CGRectMake(800,120,220,160)] autorelease]];
    [[self tipsLabel] setText:@""];
    [[self tipsLabel]setNumberOfLines:15];
    [[self tipsLabel] setLineBreakMode:UILineBreakModeWordWrap|UILineBreakModeTailTruncation];
    [[self tipsLabel] setOpaque:YES];
    [[self tipsLabel]setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [[self tipsLabel]setFont:[MCFonts customFontWithSize:18]];
    [self tipsLabel].layer.cornerRadius = 10.0;
    
    [openGLView addSubview:[self tipsLabel]];
    [[self tipsLabel]setHidden:NO];
    
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
    
	// reload our interface
	[(MCRandomSolveViewInputControllerViewController*)inputController loadInterface];
    
}

-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [magicCubeUI performSelector:@selector(previousSolution)];
}
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [magicCubeUI performSelector:@selector(nextSolution)];
}

-(void)turnTheMCUI_Into_SOlVE_Play_MODE{
    [magicCubeUI setUsingMode:SOlVE_Play_MODE];
    [magicCubeUI switchToOrignalPlace];
}
-(void)rotateWithSingmasterNotation:(SingmasterNotation)notation isNeedStay:(BOOL)isStay isTwoTimes:(BOOL)isTwoTimes{
    //[self flashSecne];
    RotateNotationType rotate = [MCTransformUtil getRotateNotationTypeWithSingmasterNotation:notation];
    [magicCubeUI rotateOnAxis:rotate.axis onLayer:rotate.layer inDirection:rotate.direction isTribleRotate:NO isTwoTimes:isTwoTimes];
    [magicCube rotateWithSingmasterNotation:notation];
};
-(BOOL)isSelectOneFace:(vec2)touchpoint{
    if ([magicCubeUI isSelectOneFace:touchpoint]) {
        selected_index = [magicCubeUI selected_cube_index];
        selected_face_index = [magicCubeUI selected_cube_face_index];
        return YES;
    }else
        return NO;
};
-(void)flashSecne{
    [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];
};

-(void)clearState{
    //[magicCube release];
    magicCube = [[MCMagicCube magicCubeOnlyWithCenterColor]retain];
    
    [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];

}

-(void)nextSingmasterNotation:(SingmasterNotation)notation{
    //更新下一次spaceindicator方向
    RotateNotationType nextRotateType = [MCTransformUtil getRotateNotationTypeWithSingmasterNotation:notation];
    [magicCubeUI nextSpaceIndicatorWithRotateNotationType:nextRotateType];
}

-(void)closeSingmasterNotation{
    [magicCubeUI closeSpaceIndicator];
}

-(void)releaseSrc{
    [super releaseSrc];
}

- (void)dealloc{
    [super dealloc];
}

@end
