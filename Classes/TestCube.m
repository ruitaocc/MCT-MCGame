//
//  TestCube.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestCube.h"

#import "MCOBJLoader.h"

//#import "data.hpp"
//#import "TestCubeData.h"
#import "MCParticleSystem.h"
#import "CoordinatingController.h"
@implementation TestCube
@synthesize lastRotation;
@synthesize lastTranslation;
- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

-(void)awake
{
    active = YES;
    MCOBJLoader *OBJ = [MCOBJLoader sharedMCOBJLoader];
   /* vector<float> Cube_vertex_coordinates_v( [OBJ Cube_vertex_coordinates]);
    vector<float> Cube_texture_coordinates_v ([OBJ Cube_texture_coordinates]);
    vector<float> Cube_normal_vectors_v ([OBJ Cube_normal_vectors]);
    
    GLfloat * Cube_vertex_coordinates = &Cube_vertex_coordinates_v[0];
    GLfloat * Cube_texture_coordinates = &Cube_texture_coordinates_v[0];
    GLfloat * Cube_normal_vectors = &Cube_normal_vectors_v[0];
    */
    GLfloat * Cube_vertex_coordinates = [OBJ Cube_vertex_coordinates];
    GLfloat * Cube_texture_coordinates = [OBJ Cube_texture_coordinates];
    GLfloat * Cube_normal_vectors = [OBJ Cube_normal_vectors];
    int Cube_vertex_array_size = [OBJ Cube_vertex_array_size];
    
	mesh = [[MCTexturedMesh alloc] initWithVertexes:Cube_vertex_coordinates
                                        vertexCount:Cube_vertex_array_size
                                         vertexSize:3 
                                        renderStyle:GL_TRIANGLES];
	[(MCTexturedMesh*)mesh setMaterialKey:@"cubeTexture2"];
	[(MCTexturedMesh*)mesh setUvCoordinates:Cube_texture_coordinates];
	[(MCTexturedMesh*)mesh setNormals:Cube_normal_vectors];
	
    
	m_trackballRadius = 100;
	m_spinning = NO;
}




// called once every frame
-(void)update
{
    [self handleTouches];
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


-(void)handleTouches
{
	NSSet * touches = [[[CoordinatingController sharedCoordinatingController] currentController].inputController touchEvents];
    UIView* view= [[[CoordinatingController sharedCoordinatingController] currentController].inputController view ];
	UITouchPhase touchEventSate = [[[CoordinatingController sharedCoordinatingController] currentController].inputController touchEventSate];
    if ([touches count] != 2) return;
    if ([touches count] == 2) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        UITouch *touch1 = [[touches allObjects] objectAtIndex:1];
        if (touchEventSate == UITouchPhaseMoved) {
            NSLog(@"moved");
            
            CGPoint previous = [touch previousLocationInView:view];
            CGPoint current = [touch locationInView:view];
            ivec2 oldLocation = ivec2(previous.x,previous.y);
            ivec2 newLocation = ivec2(current.x,current.y);
            if (m_spinning) {
                vec3 start = [self MapToSphere: m_fingerStart];
                vec3 end =[self MapToSphere:newLocation];
                Quaternion delta = Quaternion::CreateFromVectors(start, end);
                m_orientation = delta.Rotated(m_previousOrientation);
            }
        }else if (touchEventSate==UITouchPhaseBegan) {
            NSLog(@"begin");
            //[self setSpeed:MCPointMake(1, 0, 0)]; 
            CGPoint location = [touch locationInView:view];
            m_spinning = YES;
            m_fingerStart.x =location.x;
            m_fingerStart.y =location.y;
            m_previousOrientation = m_orientation;
        }else if (touchEventSate==UITouchPhaseEnded) {
            //[self setSpeed:MCPointMake(0, 0, 0)]; 
            NSLog(@"ended");
            m_spinning = NO;
        }
    }
}

-(vec3)MapToSphere:(ivec2 )touchpoint
{
    ivec2 m_centerPoint = ivec2(self.translation.x,self.translation.y);
    vec2 p = touchpoint - m_centerPoint;
    
    // Flip the Y axis because pixel coords increase towards the bottom.
    p.y = -p.y;
    
    const float radius = m_trackballRadius;
    const float safeRadius = radius - 1;
    
    if (p.Length() > safeRadius) {
        float theta = atan2(p.y, p.x);
        p.x = safeRadius * cos(theta);
        p.y = safeRadius * sin(theta);
    }
    
    float z = sqrt(radius * radius - p.LengthSquared());
    vec3 mapped = vec3(p.x, p.y, z);
    return mapped / radius;
}


@end
