//
//  data.hpp
//  HelloCone
//
//  Created by kwan terry on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef HelloCone_data_hpp
#define HelloCone_data_hpp

#define Cube_vertex_count_f		24
#define Cube_polygon_count_f		12
#define Cube_vertex_array_size_f		Cube_polygon_count * 3
/*
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
    
};*/
float Cube_vertex_coordinates_f []={
    //上
    -0.44,0.52,-0.44,//left top(at rear)
    -0.44,0.52,0.44,//left buttom(at front)
    0.44,0.52,-0.44,//top right(at rear)
    -0.44,0.52,0.44,//left buttom(at front)
    0.44,0.52,0.44,//right buttom(at front)
    0.44,0.52,-0.44,//top right(at rear)
    
    
    //下
    -0.44,-0.52,0.44,//buttom left front
    -0.44,-0.52,-0.44,//left rear
    0.44,-0.52,0.44,//rigtht buttom
    -0.44,-0.52,-0.44,//left rear
    0.44,-0.52,-0.44,//right rear
    0.44,-0.52,0.44,//rigtht buttom
    
    
    //前
    -0.44,0.44,0.52,//left top
    -0.44,-0.44,0.52,//left buttom
     0.44,0.44,0.52,//top right
    -0.44,-0.44,0.52,//left buttom
     0.44,-0.44,0.52,//right buttom
    0.44,0.44,0.52,//top right
    
    //后
    0.44,0.44,-0.52,//right top(when viewed from front)
    0.44,-0.44,-0.52,//left top
    -0.44,0.44,-0.52,//rigtht buttom
    0.44,-0.44,-0.52,//rigtht buttom
    -0.44,-0.44,-0.52,//left top
    -0.44,0.44,-0.52,//left buttom
    //左
    -0.52,0.44,-0.44,// top left
    -0.52,-0.44,-0.44,//buttom left
    -0.52,0.44,0.44,// top right
    -0.52,-0.44,-0.44,//buttom left
    -0.52,-0.44,0.44,//buttom right
    -0.52,0.44,0.44,// top right
    
    //右
    0.52,0.44,0.44,//top left
    0.52,-0.44,0.44,//left
    0.52,0.44,-0.44,//top right
    0.52,-0.44,0.44,//left
    0.52,-0.44,-0.44,//right
    0.52,0.44,-0.44//top right

   
       
   
};
float Cube_normal_vectors_f [] = {
    //上
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    0.0,1.0,0.0,
    //下
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,
    0.0,-1.0,0.0,

    //前
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
    0.0,0.0,1.0,
   
    //后
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
    0.0,0.0,-1.0,
   
    //左
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    -1.0,0.0,0.0,
    //右
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0,
    1.0,0.0,0.0
};
float Cube_texture_coordinates_f [] = {
    //上 黄
    0.2890625,0.01171875,
    0.2890625,0.26171875,
    0.5390625,0.01171875,
    0.2890625,0.26171875,
    0.5390625,0.26171875,
    0.5390625,0.01171875,
    //下 白
    0.2890625,0.56640625,//00
    0.5390625,0.56640625,//11
    0.2890625,0.81640625,//01
    0.5390625,0.56640625,//11
    0.5390625,0.81640625,//10
    0.2890625,0.81640625,//01
    
    
    //前 红
    0.01171875,0.01171875,
    0.01171875,0.26171875,
    0.26171875,0.01171875,
    0.01171875,0.26171875,
    0.26171875,0.26171875,
    0.26171875,0.01171875,
   
    //后 橙
    0.01171875,0.56640625,
    0.01171875,0.81640625,
    0.26171875,0.56640625,
    0.01171875,0.81640625,
    0.26171875,0.81640625,
    0.26171875,0.56640625,
    
    //左 蓝
    0.01171875,0.2890625,
    0.01171875,0.5390625,
    0.26171875,0.2890625,
    0.01171875,0.5390625,
    0.26171875,0.5390625,
    0.26171875,0.2890625,
    //右 绿
    0.2890625,0.2890625,
    0.2890625,0.5390625,
    0.5390625,0.2890625,
    0.2890625,0.5390625,
    0.5390625,0.5390625,
    0.5390625,0.2890625,
   
    
    //黑
    0.5625,0.01171875,
    0.5625,0.26171875,
    0.8125,0.01171875,
    0.5625,0.26171875,
    0.8125,0.26171875,
    0.8125,0.01171875
    

};

float Cube_LockSign_vertex_coordinates []={
    //上
    -0.15,0.53,-0.15,//left top(at rear)
    -0.15,0.53,0.15,//left buttom(at front)
    0.15,0.53,-0.15,//top right(at rear)
    -0.15,0.53,0.15,//left buttom(at front)
    0.15,0.53,0.15,//right buttom(at front)
    0.15,0.53,-0.15,//top right(at rear)
    
    
    //下
    -0.15,-0.53,0.15,//buttom left front
    -0.15,-0.53,-0.15,//left rear
    0.15,-0.53,0.15,//rigtht buttom
    0.15,-0.53,0.15,//rigtht buttom
    -0.15,-0.53,-0.15,//left rear
    0.15,-0.53,-0.15,//right rear
    //前
    -0.15,0.15,0.53,//left top
    -0.15,-0.15,0.53,//left buttom
    0.15,0.15,0.53,//top right
    -0.15,-0.15,0.53,//left buttom
    0.15,-0.15,0.53,//right buttom
    0.15,0.15,0.53,//top right
    
    //后
    0.15,0.15,-0.53,//right top(when viewed from front)
    0.15,-0.15,-0.53,//left top
    -0.15,0.15,-0.53,//rigtht buttom
    0.15,-0.15,-0.53,//rigtht buttom
    -0.15,-0.15,-0.53,//left top
    -0.15,0.15,-0.53,//left buttom
    //左
    -0.53,0.15,-0.15,// top left
    -0.53,-0.15,-0.15,//buttom left
    -0.53,0.15,0.15,// top right
    -0.53,-0.15,-0.15,//buttom left
    -0.53,-0.15,0.15,//buttom right
    -0.53,0.15,0.15,// top right
    
    //右
    0.53,0.15,0.15,//top left
    0.53,-0.15,0.15,//left
    0.53,0.15,-0.15,//top right
    0.53,-0.15,0.15,//left
    0.53,-0.15,-0.15,//right
    0.53,0.15,-0.15//top right
};

float Cube_LockSign_vertex_texture_coordinates []={
    0,0,
    1,1,
    0,1,
    0,1,
    1,1,
    1,0
};



#endif
