//
//  MeshRenderEngine.h
//  MCGame
//
//  Created by kwan terry on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <Foundation/Foundation.h>
#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <QuartzCore/QuartzCore.h>
#include <vector>
#include "Quaternion.hpp"
using namespace std;

struct Vertex {
    vec3 Position;
    vec4 Color;
};

class MeshRenderEngine{
public:
    void init(vector<Vertex> vers,vector<GLubyte>indices,GLenum renderstyle);
    void render();
    
    void OnFingerUp(ivec2 location);
    void OnFingerDown(ivec2 location);
    void OnFingerMove(ivec2 oldLocation,ivec2 newLocation);
    vec3 MapToSphere(ivec2 touchpoint) const;
    
private:
    //private data
    vector<Vertex> m_Vertices;
    vector<GLubyte> m_Indices;
    GLuint m_VertexBuffer;
    GLuint m_IndexBuffer;
    GLenum renderStyle;
    //private method
    void genVBO();
    
};

void MeshRenderEngine::init(vector<Vertex> vers,vector<GLubyte>indices,GLenum renderstyle){
    m_Vertices = vers;
    m_Indices = indices;
    renderStyle = renderstyle;
    
    genVBO();
};


void MeshRenderEngine::genVBO(){
    //creat the VBO for vertices
    glGenBuffers(1, &m_VertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, m_VertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, m_Vertices.size()*sizeof(m_Vertices[0]), &m_Vertices[0], GL_STATIC_DRAW);
    //creat the VBO for indices
    glGenBuffers(1, &m_IndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, m_Indices.size()*sizeof(m_Indices[0]), &m_Indices[0], GL_STATIC_DRAW);
};


void MeshRenderEngine::render(){
    
    glClearColor(0.5f, 0.5f, 0.5f, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // Set the model-view transform.
    // mat4 rotation = m_orientation.ToMatrix();
    // mat4 modelview = rotation * m_translation;
    glMatrixMode(GL_MODELVIEW);
    
    glPushMatrix();
    // glLoadMatrixf(modelview.Pointer());
    //glRotatef(30, 1, 1, 0);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    
    
    const GLvoid* colorOffset = (GLvoid*)sizeof(vec3);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IndexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, m_VertexBuffer);
    
    glVertexPointer(3, GL_FLOAT, sizeof(Vertex), 0);
    glColorPointer(4, GL_FLOAT, sizeof(Vertex), colorOffset);
    
    
    for(int i = 0;i<6;i++){
        glDrawElements(GL_TRIANGLE_FAN, 4, GL_UNSIGNED_BYTE, (GLvoid*)(i*4));
    }
    
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glPopMatrix();
    
    
};
void MeshRenderEngine::OnFingerUp(ivec2 location){};
void MeshRenderEngine::OnFingerDown(ivec2 location){};
void MeshRenderEngine::OnFingerMove(ivec2 oldLocation,ivec2 newLocation){};
vec3 MeshRenderEngine::MapToSphere(ivec2 touchpoint) const{
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

};



