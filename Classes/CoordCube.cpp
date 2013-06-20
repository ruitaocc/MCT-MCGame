//
//  TPCoordCube.cpp
//  TP
//
//  Created by Aha on 13-6-15.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#include "CoordCube.h"

short CoordCube::twistMove[N_TWIST][N_MOVE];
short CoordCube::flipMove[N_FLIP][N_MOVE];
short CoordCube::parityMove[2][18] = { { 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1 },
    { 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 } };
short CoordCube::FRtoBR_Move[N_FRtoBR][N_MOVE];
short CoordCube::URFtoDLF_Move[N_URFtoDLF][N_MOVE];
short CoordCube::URtoDF_Move[N_URtoDF][N_MOVE];
short CoordCube::URtoUL_Move[N_URtoUL][N_MOVE];
short CoordCube::UBtoDF_Move[N_UBtoDF][N_MOVE];
short CoordCube::MergeURtoULandUBtoDF[336][336];
unsigned char CoordCube::Slice_URFtoDLF_Parity_Prun[N_SLICE2 * N_URFtoDLF * N_PARITY / 2];
unsigned char CoordCube::Slice_URtoDF_Parity_Prun[N_SLICE2 * N_URtoDF * N_PARITY / 2];
unsigned char CoordCube::Slice_Twist_Prun[N_SLICE1 * N_TWIST / 2 + 1];
unsigned char CoordCube::Slice_Flip_Prun[N_SLICE1 * N_FLIP / 2];



void CoordCube::initAllStaticVariables() {
    
    // Init twistMove
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"twistMove"];
    FILE *fp;
    fp=fopen([filePath UTF8String],"rb");
    fread(twistMove, sizeof(short), sizeof(twistMove)/sizeof(short), fp);
    fclose(fp);
    
    // Init flipMove
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"flipMove"];
    fp=fopen([filePath UTF8String],"rb");
    fread(flipMove, sizeof(short), sizeof(flipMove)/sizeof(short), fp);
    fclose(fp);
    
    // Init FRtoBR_Move
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FRtoBR_Move"];
    fp=fopen([filePath UTF8String],"rb");
    fread(FRtoBR_Move, sizeof(short), sizeof(FRtoBR_Move)/sizeof(short), fp);
    fclose(fp);
    
    // Init URFtoDLF_Move
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"URFtoDLF_Move"];
    fp=fopen([filePath UTF8String],"rb");
    fread(URFtoDLF_Move, sizeof(short), sizeof(URFtoDLF_Move)/sizeof(short), fp);
    fclose(fp);
    
    // Init URtoDF_Move
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"URtoDF_Move"];
    fp=fopen([filePath UTF8String],"rb");
    fread(URtoDF_Move, sizeof(short), sizeof(URtoDF_Move)/sizeof(short), fp);
    fclose(fp);
    
    // Init URtoUL_Move
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"URtoUL_Move"];
    fp=fopen([filePath UTF8String],"rb");
    fread(URtoUL_Move, sizeof(short), sizeof(URtoUL_Move)/sizeof(short), fp);
    fclose(fp);
    
    // Init UBtoDF_Move
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UBtoDF_Move"];
    fp=fopen([filePath UTF8String],"rb");
    fread(UBtoDF_Move, sizeof(short), sizeof(UBtoDF_Move)/sizeof(short), fp);
    fclose(fp);
    
    // for i, j <336 the six edges UR,UF,UL,UB,DR,DF are not in the
    // UD-slice and the index is <20160
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MergeURtoULandUBtoDF"];
    fp=fopen([filePath UTF8String],"rb");
    fread(MergeURtoULandUBtoDF, sizeof(short), sizeof(MergeURtoULandUBtoDF)/sizeof(short), fp);
    fclose(fp);
    
    
    // Init Slice_URFtoDLF_Parity_Prun
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Slice_URFtoDLF_Parity_Prun"];
    fp=fopen([filePath UTF8String],"rb");
    fread(Slice_URFtoDLF_Parity_Prun, sizeof(unsigned char), sizeof(Slice_URFtoDLF_Parity_Prun)/sizeof(unsigned char), fp);
    fclose(fp);
    
    // Init Slice_URtoDF_Parity_Prun
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Slice_URtoDF_Parity_Prun"];
    fp=fopen([filePath UTF8String],"rb");
    fread(Slice_URtoDF_Parity_Prun, sizeof(unsigned char), sizeof(Slice_URtoDF_Parity_Prun)/sizeof(unsigned char), fp);
    fclose(fp);
    
    
    // Init Slice_Twist_Prun
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Slice_Twist_Prun"];
    fp=fopen([filePath UTF8String],"rb");
    fread(Slice_Twist_Prun, sizeof(unsigned char), sizeof(Slice_Twist_Prun)/sizeof(unsigned char), fp);
    fclose(fp);
    
    
    // Init Slice_Flip_Prun
    filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Slice_Flip_Prun"];
    fp=fopen([filePath UTF8String],"rb");
    fread(Slice_Flip_Prun, sizeof(unsigned char), sizeof(Slice_Flip_Prun)/sizeof(unsigned char), fp);
    fclose(fp);
    
}




CoordCube::CoordCube(CubieCube &c) {
    twist = c.getTwist();
    flip = c.getFlip();
    parity = c.cornerParity();
    FRtoBR = c.getFRtoBR();
    URFtoDLF = c.getURFtoDLF();
    URtoUL = c.getURtoUL();
    UBtoDF = c.getUBtoDF();
    URtoDF = c.getURtoDF();// only needed in phase2
}


void CoordCube::move(int m) {
    twist = twistMove[twist][m];
    flip = flipMove[flip][m];
    parity = parityMove[parity][m];
    FRtoBR = FRtoBR_Move[FRtoBR][m];
    URFtoDLF = URFtoDLF_Move[URFtoDLF][m];
    URtoUL = URtoUL_Move[URtoUL][m];
    UBtoDF = UBtoDF_Move[UBtoDF][m];
    if (URtoUL < 336 && UBtoDF < 336)// updated only if UR,UF,UL,UB,DR,DF
        // are not in UD-slice
        URtoDF = MergeURtoULandUBtoDF[URtoUL][UBtoDF];
}

//----------------------------------

void CoordCube::setPruning(unsigned char table[], int index, unsigned char value) {
    if ((index & 1) == 0)
        table[index / 2] &= 0xf0 | value;
    else
        table[index / 2] &= 0x0f | (value << 4);
}


unsigned char CoordCube::getPruning(unsigned char table[], unsigned int index){
    if ((index & 1) == 0)
        return (unsigned char) (table[index / 2] & 0x0f);
    else
        return (unsigned char) ((table[index / 2] & 0xf0) >> 4);
    //------------------------------
    //return (unsigned char) ((table[index / 2] & 0xf0) >>> 4);
}

