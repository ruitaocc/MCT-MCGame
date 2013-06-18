//
//  TestCube.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"

#import "MCOBJLoader.h"

//#import "data.hpp"
//#import "TestCubeData.h"
#import "MCParticleSystem.h"
#import "CoordinatingController.h"
#import "MCCollider.h"
#import "Global.h"
#import "data.hpp"
#import "MCStringDefine.h"
#import "MCStringDefine.h"
@implementation Cube
@synthesize cube6faces_direction_indicator;
@synthesize isNeededToShowSpaceDirection;
@synthesize indicator_axis;
@synthesize indicator_direction;
@synthesize index,cube6faces;
@synthesize cube6faces_locksign;
@synthesize isLocked=_isLocked;
@synthesize index_selectedFace;
- (id) initWithState:(NSDictionary *)states
{
	self = [super init];
	if (self != nil) {
        MCOBJLoader *OBJ = [MCOBJLoader sharedMCOBJLoader];
        
        GLfloat * Cube_vertex_coordinates = [OBJ Cube_vertex_coordinates];
        GLfloat * Cube_texture_coordinates = [OBJ Cube_texture_coordinates];
        GLfloat * Cube_normal_vectors = [OBJ Cube_normal_vectors];
        
        int Cube_vertex_array_size = [OBJ Cube_vertex_array_size];
        
        mesh = [[MCTexturedMesh alloc] initWithVertexes:Cube_vertex_coordinates
                                            vertexCount:Cube_vertex_array_size
                                             vertexSize:3
                                            renderStyle:GL_TRIANGLES];
        [(MCTexturedMesh*)mesh setMaterialKey:@"cubeTexture3"];
        [(MCTexturedMesh*)mesh setUvCoordinates:Cube_texture_coordinates];
        [(MCTexturedMesh*)mesh setNormals:Cube_normal_vectors];
        [self setIsLocked:NO];
        if (cube6faces==nil) {
            cube6faces = [[NSMutableArray alloc]init];
        }
        for (int i=0; i<6; i++) {
            NSNumber *state = [states objectForKey:[NSNumber numberWithInteger:i ]];
            CubeFace* faces = [[CubeFace alloc]initWithVertexes:&Cube_vertex_coordinates_f[i*6*3] vertexCount:6 vertexSize:3 renderStyle:GL_TRIANGLES];
            [faces setIsNeedRender:YES];
            [(CubeFace*)faces setMaterialKey:@"sixcolor"];
            [(CubeFace*)faces setUvCoordinates:&Cube_texture_coordinates_f[[state integerValue]*6*2]];
            [(CubeFace*)faces setNormals:&Cube_normal_vectors_f[i*6*3]];
            [cube6faces addObject:faces];
            [faces release];
        }
        index_selectedFace = -1;
        if (cube6faces_locksign==nil) {
            cube6faces_locksign = [[NSMutableArray alloc]init];
        }
        for (int i=0; i<6; i++) {
            CubeFace* faces_locksign = [[CubeFace alloc]initWithVertexes:&Cube_LockSign_vertex_coordinates[i*6*3] vertexCount:6 vertexSize:3 renderStyle:GL_TRIANGLES];
            [faces_locksign setIsNeedRender:YES];
            [(CubeFace*)faces_locksign setMaterialKey:@"LockTexture"];
            [(CubeFace*)faces_locksign setUvCoordinates:&Cube_LockSign_vertex_texture_coordinates[0]];
            [(CubeFace*)faces_locksign setNormals:&Cube_normal_vectors_f[i*6*3]];
            [cube6faces_locksign addObject:faces_locksign];
            [faces_locksign release];
        }
        if (cube6faces_direction_indicator==nil) {
            cube6faces_direction_indicator = [[NSMutableArray alloc]init];
        }
        for (int i=0; i<6; i++) {
            CubeFace* faces_direction_indicator = [[CubeFace alloc]initWithVertexes:&Cube_direction_indicator_vertex_coordinates[i*6*3] vertexCount:6 vertexSize:3 renderStyle:GL_TRIANGLES];
            [faces_direction_indicator setIsNeedRender:NO];
            [(CubeFace*)faces_direction_indicator setMaterialKey:kSpaceDirectionIndicatorRight];
            [(CubeFace*)faces_direction_indicator setUvCoordinates:&Cube_LockSign_vertex_texture_coordinates[0]];
            [(CubeFace*)faces_direction_indicator setNormals:&Cube_normal_vectors_f[i*6*3]];
            [cube6faces_direction_indicator addObject:faces_direction_indicator];
            [faces_direction_indicator release];
        }
    }
    
	return self;
}
- (void) flashWithState:(NSDictionary*)states{
    for (int i=0; i<6; i++) {
        NSNumber *state = [states objectForKey:[NSNumber numberWithInteger:i ]];
        CubeFace* faces = [cube6faces objectAtIndex:i];
        [(CubeFace*)faces setUvCoordinates:&Cube_texture_coordinates_f[[state integerValue]*6*2]];
    }
};

-(id)init{
    self = [super init];
	if (self != nil) {
        MCOBJLoader *OBJ = [MCOBJLoader sharedMCOBJLoader];
        GLfloat * Cube_vertex_coordinates = [OBJ Cube_vertex_coordinates];
        GLfloat * Cube_texture_coordinates = [OBJ Cube_texture_coordinates];
        GLfloat * Cube_normal_vectors = [OBJ Cube_normal_vectors];
        
        int Cube_vertex_array_size = [OBJ Cube_vertex_array_size];
        
        mesh = [[MCTexturedMesh alloc] initWithVertexes:Cube_vertex_coordinates
                                            vertexCount:Cube_vertex_array_size
                                             vertexSize:3
                                            renderStyle:GL_TRIANGLES];
        [(MCTexturedMesh*)mesh setMaterialKey:@"cubeTexture3"];/**/
        [(MCTexturedMesh*)mesh setUvCoordinates:Cube_texture_coordinates];
        [(MCTexturedMesh*)mesh setNormals:Cube_normal_vectors];
        [self setIsLocked:NO];
        if (cube6faces==nil) {
            cube6faces = [[NSMutableArray alloc]init];
        }
        index_selectedFace = -1;
        for (int i=0; i<6; i++) {
            //NSNumber *state = [states objectForKey:[NSNumber numberWithInteger:i ]];
            CubeFace* faces = [[CubeFace alloc]initWithVertexes:&Cube_vertex_coordinates_f[i*6*3] vertexCount:6 vertexSize:3 renderStyle:GL_TRIANGLES];
            [faces setIsNeedRender:YES];
            [(CubeFace*)faces setMaterialKey:@"sixcolor"];
            [(CubeFace*)faces setUvCoordinates:&Cube_texture_coordinates_f[i*6*2]];
            [(CubeFace*)faces setNormals:&Cube_normal_vectors_f[i*6*3]];
            [cube6faces addObject:faces];
            [faces release];
        }
        if (cube6faces_locksign==nil) {
            cube6faces_locksign = [[NSMutableArray alloc]init];
        }
        for (int i=0; i<6; i++) {
            CubeFace* faces_locksign = [[CubeFace alloc]initWithVertexes:&Cube_LockSign_vertex_coordinates[i*6*3] vertexCount:6 vertexSize:3 renderStyle:GL_TRIANGLES];
            [faces_locksign setIsNeedRender:YES];
            [(CubeFace*)faces_locksign setMaterialKey:@"LockTexture"];
            [(CubeFace*)faces_locksign setUvCoordinates:&Cube_LockSign_vertex_texture_coordinates[0]];
            [(CubeFace*)faces_locksign setNormals:&Cube_normal_vectors_f[i*6*3]];
            [cube6faces_locksign addObject:faces_locksign];
            [faces_locksign release];
        }
        if (cube6faces_direction_indicator==nil) {
            cube6faces_direction_indicator = [[NSMutableArray alloc]init];
        }
        for (int i=0; i<6; i++) {
            CubeFace* faces_direction_indicator = [[CubeFace alloc]initWithVertexes:&Cube_direction_indicator_vertex_coordinates[i*6*3] vertexCount:6 vertexSize:3 renderStyle:GL_TRIANGLES];
            [faces_direction_indicator setIsNeedRender:NO];
            [(CubeFace*)faces_direction_indicator setMaterialKey:kSpaceDirectionIndicatorRight];
            [(CubeFace*)faces_direction_indicator setUvCoordinates:&Cube_LockSign_vertex_texture_coordinates[0]];
            [(CubeFace*)faces_direction_indicator setNormals:&Cube_normal_vectors_f[i*6*3]];
            [cube6faces_direction_indicator addObject:faces_direction_indicator];
            [faces_direction_indicator release];
        }

    }
    
	return self;

}
// called once every frame
-(void)render
{
    if (!mesh || !active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	glMultMatrixf(matrix);
	[mesh render];
    [cube6faces makeObjectsPerformSelector:@selector(render)];
    if ([self isLocked]) {
        [cube6faces_locksign makeObjectsPerformSelector:@selector(render)];
    }
    [cube6faces_direction_indicator makeObjectsPerformSelector:@selector(render)];
	glPopMatrix();
}
-(void)awake
{
    active = YES;
}




// called once every frame
-(void)update
{
    //self work
    for (CubeFace *tmp in cube6faces_direction_indicator) {
        if ([tmp isNeedRender]==YES) {
            [tmp setIsNeedRender:NO];
        }
    }
    if ([self isNeededToShowSpaceDirection]) {
        switch (indicator_axis) {
            case X:
                for (int i = 0;i<6;i++) {
                    if (((self.index%9)/3==2&&i==0)||((self.index/9)==2&&i==2)) {
                        CubeFace *tmp  =[cube6faces_direction_indicator objectAtIndex:i];
                        if (indicator_direction == CW) {
                            [tmp setMaterialKey:kSpaceDirectionIndicatorUP];
                        }else
                            [tmp setMaterialKey:kSpaceDirectionIndicatorDown];
                        [tmp setIsNeedRender:YES];
                    }
                    
                }
                break;
            case Y:
                for (int i = 0;i<6;i++) {
                    if (((self.index/9)==2&&i==2)||((self.index%3)==2&&i==5)) {
                        CubeFace *tmp  =[cube6faces_direction_indicator objectAtIndex:i];
                        if (indicator_direction == CW) {
                            [tmp setMaterialKey:kSpaceDirectionIndicatorLeft];
                        }else
                            [tmp setMaterialKey:kSpaceDirectionIndicatorRight];
                        [tmp setIsNeedRender:YES];
                    }
                    
                }
                break;
            case Z:
                for (int i = 0;i<6;i++) {
                    if ((((self.index%9)/3)==2&&i==0)||((self.index%3)==2&&i==5)) {
                        CubeFace *tmp  =[cube6faces_direction_indicator objectAtIndex:i];
                         if (i== 0) {
                             if (indicator_direction == CW) {
                                 [tmp setMaterialKey:kSpaceDirectionIndicatorRight];
                             }else
                                 [tmp setMaterialKey:kSpaceDirectionIndicatorLeft];
                         }else{
                             if (indicator_direction == CW) {
                                 [tmp setMaterialKey:kSpaceDirectionIndicatorDown];
                             }else
                                 [tmp setMaterialKey:kSpaceDirectionIndicatorUP];
                         }
                        [tmp setIsNeedRender:YES];
                    }
                    
                }
                break;
                
            default:
                break;
        }
        //
    }
    //super work
    if (collider != nil) [collider updateCollider:self];
    [super update];
       
}

-(void)deadUpdate
{
	if ((particleEmitter.emitCounter <= 0) && (![particleEmitter activeParticles])) {
		[[[CoordinatingController sharedCoordinatingController] currentController] removeObjectFromScene:self];	
		[[[CoordinatingController sharedCoordinatingController] currentController] gameOver];
	}
}



- (void) dealloc
{
    if (particleEmitter != nil) [[[CoordinatingController sharedCoordinatingController] currentController] removeObjectFromScene:particleEmitter];
	[particleEmitter release];
	[super dealloc];
}




@end
