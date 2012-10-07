//
//  data.hpp
//  HelloCone
//
//  Created by kwan terry on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef HelloCone_data_hpp
#define HelloCone_data_hpp

#define Cube_vertex_count		24 
#define Cube_polygon_count		12
#define Cube_vertex_array_size		Cube_polygon_count * 3

//Define the cubeVertices
const GLfloat cubeVertices[]={
//    //Define the front face
//    -1.0,1.0,1.0,//left top
//    -1.0,-1.0,1.0,//left buttom
//    1.0,-1.0,1.0,//right buttom
//    1.0,1.0,1.0,//top right
//    //top face
//    -1.0,1.0,-1.0,//left top(at rear)
//    -1.0,1.0,1.0,//left buttom(at front)
//    1.0,1.0,1.0,//right buttom(at front)
//    1.0,1.0,-1.0,//top right(at rear)
//    //rear face
//    1.0,1.0,-1.0,//right top(when viewed from front)
//    1.0,-1.0,-1.0,//rigtht buttom
//    -1.0,-1.0,-1.0,//left buttom
//    -1.0,1.0,-1.0,//left top 
//    
//    //buttom face
//    -1.0,-1.0,1.0,//buttom left front
//    1.0,-1.0,1.0,//rigtht buttom
//    1.0,-1.0,-1.0,//right rear
//    -1.0,-1.0,-1.0,//left rear
//    //left face
//    -1.0,1.0,-1.0,// top left
//    -1.0,1.0,1.0,// top right
//    -1.0,-1.0,1.0,//buttom right
//    -1.0,-1.0,-1.0,//buttom left
//    //right face
//    1.0,1.0,1.0,//top left
//    1.0,1.0,-1.0,//top right
//    1.0,-1.0,-1.0,//right
//    1.0,-1.0,1.0//left
    
    
    //Define the front face
    -1.0,1.0,1.0,//left top
    -1.0,-1.0,1.0,//left buttom
    1.0,-1.0,1.0,//right buttom
    -1.0,-1.0,1.0,//left buttom
    1.0,-1.0,1.0,//right buttom
    1.0,1.0,1.0,//top right
    //top face
    -1.0,1.0,-1.0,//left top(at rear)
    -1.0,1.0,1.0,//left buttom(at front)
    1.0,1.0,1.0,//right buttom(at front)
    -1.0,1.0,1.0,//left buttom(at front)
    1.0,1.0,1.0,//right buttom(at front)
    1.0,1.0,-1.0,//top right(at rear)
    //rear face
    1.0,1.0,-1.0,//right top(when viewed from front)
    1.0,-1.0,-1.0,//rigtht buttom
    -1.0,-1.0,-1.0,//left buttom
    1.0,-1.0,-1.0,//rigtht buttom
    -1.0,-1.0,-1.0,//left buttom

    -1.0,1.0,-1.0,//left top 
    
    //buttom face
    -1.0,-1.0,1.0,//buttom left front
    1.0,-1.0,1.0,//rigtht buttom
    1.0,-1.0,-1.0,//right rear
    1.0,-1.0,1.0,//rigtht buttom
    1.0,-1.0,-1.0,//right rear

    -1.0,-1.0,-1.0,//left rear
    //left face
    -1.0,1.0,-1.0,// top left
    -1.0,1.0,1.0,// top right
    -1.0,-1.0,1.0,//buttom right
    -1.0,1.0,1.0,// top right
    -1.0,-1.0,1.0,//buttom right
    -1.0,-1.0,-1.0,//buttom left
    //right face
    1.0,1.0,1.0,//top left
    1.0,1.0,-1.0,//top right
    1.0,-1.0,-1.0,//right
    1.0,1.0,-1.0,//top right
    1.0,-1.0,-1.0,//right

    1.0,-1.0,1.0//left

};
//Define the 
const GLfloat colorss[]={
    //Define the front face
    1.0,0.0,0.0,1.0,
    //top face
    0.0,1.0,0.0,1.0,
    //rear face
    0.0,0.0,1.0,1.0,
    //buttom face
    1.0,1.0,0.0,1.0,
    
    //left face
    0.0,1.0,1.0,1.0,
    //right face
    1.0,0.0,1.0,1.0
    
};
float Cube_vertex_coordinates []={
    //Define the front face
    -1.0,1.0,1.0,//left top
      1.0,1.0,1.0,//top right
    -1.0,-1.0,1.0,//left buttom
    -1.0,-1.0,1.0,//left buttom     
    1.0,1.0,1.0,//top right
     1.0,-1.0,1.0,//right buttom
   

    //top face
    -1.0,1.0,-1.0,//left top(at rear)
     1.0,1.0,-1.0,//top right(at rear)
    -1.0,1.0,1.0,//left buttom(at front)
    -1.0,1.0,1.0,//left buttom(at front)
    1.0,1.0,-1.0,//top right(at rear)
    1.0,1.0,1.0,//right buttom(at front)
    
   
    //rear face
    1.0,1.0,-1.0,//right top(when viewed from front)
    
    -1.0,1.0,-1.0,//rigtht buttom
    1.0,-1.0,-1.0,//left top
    1.0,-1.0,-1.0,//rigtht buttom
        -1.0,1.0,-1.0,//left buttom
    -1.0,-1.0,-1.0,//left top



    
    //buttom face
    -1.0,-1.0,1.0,//buttom left front
     1.0,-1.0,1.0,//rigtht buttom
    -1.0,-1.0,-1.0,//left rear
    1.0,-1.0,1.0,//rigtht buttom
    1.0,-1.0,-1.0,//right rear
    -1.0,-1.0,-1.0,//left rear
    //left face
    -1.0,1.0,-1.0,// top left
    -1.0,1.0,1.0,// top right
    -1.0,-1.0,-1.0,//buttom left
    -1.0,-1.0,-1.0,//buttom left
    -1.0,1.0,1.0,// top right
    -1.0,-1.0,1.0,//buttom right
    
    //right face
    1.0,1.0,1.0,//top left    
    1.0,1.0,-1.0,//top right
    1.0,-1.0,1.0,//left
    1.0,-1.0,1.0,//left
    1.0,1.0,-1.0,//top right
    1.0,-1.0,-1.0//right
    
    
   
};
float Cube_normal_vectors [] = {
    0.0,0.0,1.0,
     0.0,0.0,1.0,
     0.0,0.0,1.0,
     0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0
};
float Cube_texture_coordinates [] = {
    0.0117,0.2891,
    0.2617,0.2891,
    0.0117,0.5391,
    0.0117,0.5391,
    0.2617,0.2891,
    0.2617,0.5391,
   
    
    0.0117,0.0117,
    0.2617,0.0117,
    0.0117,0.2617,
    0.0117,0.2617,
    0.2617,0.0117,
     0.2617,0.2617,
   
    
    0.2891,0.2891,
    0.5391,0.2891,
    0.2891,0.5391,
    0.2891,0.5391,
    0.5391,0.2891,
    0.5391,0.5391,
   
    0.0117,0.5664,
    0.0117,0.8164,
    0.2617,0.5664,
    0.0117,0.8164,    
     0.2617,0.8164,
     0.2617,0.5664,
   
    
    0.2891,0.0117,    
    0.5391,0.0117,
    0.2891,0.2617,
    0.2891,0.2617,    
    0.5391,0.0117,
     0.5391,0.2617,
   
    
    0.2891,0.5664,//00
        0.5391,0.5664,//11
    0.2891,0.8164,//01
    0.2891,0.8164,//01
        0.5391,0.5664,//11
    0.5391,0.8164//10

};



#endif
