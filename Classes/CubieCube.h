//
//  TPCubieCube.h
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#ifndef __TP__TPCubieCube__
#define __TP__TPCubieCube__

#include <iostream>
#include "GlobalDefine.h"

using namespace TP;

class FaceCube;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Cube on the cubie level
class CubieCube {
public:
	// initialize to Id-Cube
    
	// corner permutation
	Corner cp[8] = { URF, UFL, ULB, UBR, DFR, DLF, DBL, DRB};
    
	// corner orientation
	unsigned char co[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
    
	// edge permutation
	Edge ep[12] = { UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR };
    
	// edge orientation
	unsigned char eo[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    
	// ************************************** Moves on the cubie level ***************************************************

    static Corner cpU[];
	static unsigned char coU[];
	static Edge epU[];
	static unsigned char eoU[];
    
	static Corner cpR[];
	static unsigned char coR[];
	static Edge epR[];
    static unsigned char eoR[];
    
    static Corner cpF[];
    static unsigned char coF[];
    static Edge epF[];
    static unsigned char eoF[];
    
    static Corner cpD[];
    static unsigned char coD[];
    static Edge epD[];
    static unsigned char eoD[];
    
    static Corner cpL[];
    static unsigned char coL[];
    static Edge epL[];
    static unsigned char eoL[];
    
    static Corner cpB[];
    static unsigned char coB[];
    static Edge epB[];
    static unsigned char eoB[];
    
	// this CubieCube array represents the 6 basic cube moves
	static CubieCube moveCube[6];
    
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Initial all static variables
    static void initAllStaticVariables();
    
	CubieCube();
    
    
    CubieCube(Corner cp[], unsigned char co[], Edge ep[], unsigned char eo[]);
    

	// n choose k
	static int Cnk(int n, int k);
    

	static void rotateLeft(Corner arr[], int l, int r);
    

	static void rotateRight(Corner arr[], int l, int r);
    

	static void rotateLeft(Edge arr[], int l, int r);
    

	static void rotateRight(Edge arr[], int l, int r);
    

	// return cube in facelet representation

    std::auto_ptr<FaceCube> toFaceCube();
    

	// Multiply this CubieCube with another cubiecube b, restricted to the corners.<br>
	// Because we also describe reflections of the whole cube by permutations, we get a complication with the corners. The
	// orientations of mirrored corners are described by the numbers 3, 4 and 5. The composition of the orientations
	// cannot
	// be computed by addition modulo three in the cyclic group C3 any more. Instead the rules below give an addition in
	// the dihedral group D3 with 6 elements.<br>
	//
	// NOTE: Because we do not use symmetry reductions and hence no mirrored cubes in this simple implementation of the
	// Two-Phase-Algorithm, some code is not necessary here.
	//
	void cornerMultiply(CubieCube &b);
    

	// Multiply this CubieCube with another cubiecube b, restricted to the edges.
	void edgeMultiply(CubieCube &b);
    

	// Multiply this CubieCube with another CubieCube b.
	void multiply(CubieCube &b);
    

	// Compute the inverse CubieCube
	void invCubieCube(CubieCube &c);
    
    // ********************************************* Get and set coordinates *********************************************
    
	// return the twist of the 8 corners. 0 <= twist < 3^7
	short getTwist();
    

	void setTwist(short twist);
    

	// return the flip of the 12 edges. 0<= flip < 2^11
	short getFlip();
    

	void setFlip(short flip);
    

	// Parity of the corner permutation
	short cornerParity();
    

	// Parity of the edges permutation. Parity of corners and edges are the same if the cube is solvable.
	short edgeParity();
    

	// permutation of the UD-slice edges FR,FL,BL and BR
	short getFRtoBR();
    

	void setFRtoBR(short idx);
    

	// Permutation of all corners except DBL and DRB
	short getURFtoDLF();
    

	void setURFtoDLF(short idx);
    

	// Permutation of the six edges UR,UF,UL,UB,DR,DF.
	int getURtoDF();
    

	void setURtoDF(int idx);
    

	// Permutation of the six edges UR,UF,UL,UB,DR,DF
	static int getURtoDF(short idx1, short idx2);
    

	// Permutation of the three edges UR,UF,UL
	short getURtoUL();
    

	void setURtoUL(short idx);
    

	// Permutation of the three edges UB,DR,DF
	short getUBtoDF();
    

	void setUBtoDF(short idx);
    

	int getURFtoDLB();
    

	void setURFtoDLB(int idx);
    
    

	int getURtoBR();
    

	void setURtoBR(int idx);
    

	// Check a cubiecube for solvability. Return the error code.
	// 0: Cube is solvable
	// -2: Not all 12 edges exist exactly once
	// -3: Flip error: One edge has to be flipped
	// -4: Not all corners exist exactly once
	// -5: Twist error: One corner has to be twisted
	// -6: Parity error: Two corners ore two edges have to be exchanged
	int verify();
    
};

#endif /* defined(__TP__TPCubieCube__) */
