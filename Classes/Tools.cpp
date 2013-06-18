//
//  TPTools.cpp
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#include "Tools.h"
#include "CoordCube.h"

int Tools::verify(string s) {
    int count[6] = {0};
    try {
        for (int i = 0; i < 54; i++)
        {
            switch (s[i]) {
                case 'U':
                    count[U]++;
                    break;
                case 'R':
                    count[R]++;
                    break;
                case 'F':
                    count[F]++;
                    break;
                case 'D':
                    count[D]++;
                    break;
                case 'L':
                    count[L]++;
                    break;
                case 'B':
                    count[B]++;
                    break;
                default:
                    break;
            }
        }
    } catch (exception e) {
        return -1;
    }
    
    for (int i = 0; i < 6; i++)
        if (count[i] != 9)
            return -1;
    
    FaceCube fc = FaceCube(s);
    auto_ptr<CubieCube> cc = fc.toCubieCube();
    
    return cc->verify();
}


string Tools::randomCube() {
    CubieCube cc = CubieCube();
    srand((unsigned int)clock());
    
    cc.setFlip((short)(rand() % CoordCube::N_FLIP));
    cc.setTwist((short)(rand() % CoordCube::N_TWIST));
    do {
        cc.setURFtoDLB((rand() % CoordCube::N_URFtoDLB));
        cc.setURtoBR((rand() % CoordCube::N_URtoBR));
    } while ((cc.edgeParity() ^ cc.cornerParity()) != 0);
    auto_ptr<FaceCube> fc = cc.toFaceCube();
    return fc->to_String();
}