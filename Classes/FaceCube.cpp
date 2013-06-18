//
//  TPFaceCube.cpp
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#include "FaceCube.h"

Facelet FaceCube::cornerFacelet[8][3] = { { U9, R1, F3 }, { U7, F1, L3 }, { U1, L1, B3 }, { U3, B1, R3 },
    { D3, F9, R7 }, { D1, L9, F7 }, { D7, B9, L7 }, { D9, R9, B7 } };

Facelet FaceCube::edgeFacelet[12][2] = { { U6, R2 }, { U8, F2 }, { U4, L2 }, { U2, B2 }, { D6, R8 }, { D2, F8 },
    { D4, L8 }, { D8, B8 }, { F6, R4 }, { F4, L6 }, { B6, L4 }, { B4, R6 } };

Color FaceCube::cornerColor[8][3] = { { U, R, F }, { U, F, L }, { U, L, B }, { U, B, R }, { D, F, R }, { D, L, F },
    { D, B, L }, { D, R, B } };

Color FaceCube::edgeColor[12][2] = { { U, R }, { U, F }, { U, L }, { U, B }, { D, R }, { D, F }, { D, L }, { D, B },
    { F, R }, { F, L }, { B, L }, { B, R } };

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FaceCube::FaceCube(){
    std::string s = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";
    for (int i = 0; i < 54; i++) {
        switch (s[i]) {
            case 'U':
                f[i] = U;
                break;
            case 'R':
                f[i] = R;
                break;
            case 'F':
                f[i] = F;
                break;
            case 'D':
                f[i] = D;
                break;
            case 'L':
                f[i] = L;
                break;
            case 'B':
                f[i] = B;
                break;
            default:
                break;
        }
    }
    
}


// Construct a facelet cube from a string
FaceCube::FaceCube(std::string cubeString){
    for (int i = 0; i < cubeString.size(); i++) {
        switch (cubeString[i]) {
            case 'U':
                f[i] = U;
                break;
            case 'R':
                f[i] = R;
                break;
            case 'F':
                f[i] = F;
                break;
            case 'D':
                f[i] = D;
                break;
            case 'L':
                f[i] = L;
                break;
            case 'B':
                f[i] = B;
                break;
            default:
                break;
        }
    }
}


// Gives string representation of a facelet cube
std::string FaceCube::to_String(){
    std::string s = "";
    for (int i = 0; i < 54; i++)
    {
        switch (f[i]) {
            case U:
                s += 'U';
                break;
            case R:
                s += 'R';
                break;
            case F:
                s += 'F';
                break;
            case D:
                s += 'D';
                break;
            case L:
                s += 'L';
                break;
            case B:
                s += 'B';
                break;
            default:
                break;
        }
    }
    return s;
}


// Gives CubieCube representation of a faceletcube
//-------------------------------
std::auto_ptr<CubieCube> FaceCube::toCubieCube(){
    std::auto_ptr<CubieCube> ccRet(new CubieCube());
    
    unsigned char ori;
    for (int i = 0; i < 8; i++)
        ccRet->cp[i] = URF;// invalidate corners
    for (int i = 0; i < 12; i++)
        ccRet->ep[i] = UR;// and edges
    Color col1, col2;
    
    for (int i = 0; i < 8; i++) {
        // get the colors of the cubie at corner i, starting with U/D
        for (ori = 0; ori < 3; ori++)
            if (f[cornerFacelet[i][ori]] == U || f[cornerFacelet[i][ori]] == D)
                break;
        col1 = f[cornerFacelet[i][(ori + 1) % 3]];
        col2 = f[cornerFacelet[i][(ori + 2) % 3]];
        
        for (int j = 0; j < 8; j++) {
            if (col1 == cornerColor[j][1] && col2 == cornerColor[j][2]) {
                // in cornerposition i we have cornercubie j
                ccRet->cp[i] = (Corner)j;
                ccRet->co[i] = (unsigned char) (ori % 3);
                break;
            }
        }
        
    }
    
    for (int i = 0; i < 12; i++) {
        for (int j = 0; j < 12; j++) {
            if (f[edgeFacelet[i][0]] == edgeColor[j][0]
                && f[edgeFacelet[i][1]] == edgeColor[j][1]) {
                ccRet->ep[i] = (Edge)j;
                ccRet->eo[i] = 0;
                break;
            }
            if (f[edgeFacelet[i][0]] == edgeColor[j][1]
                && f[edgeFacelet[i][1]] == edgeColor[j][0]) {
                ccRet->ep[i] = (Edge)j;
                ccRet->eo[i] = 1;
                break;
            }
        }
        
    }
    
        
    return ccRet;
    
}



