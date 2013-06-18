//
//  TPCubieCube.cpp
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#include "CubieCube.h"
#include "FaceCube.h"

CubieCube CubieCube::moveCube[6];

Corner CubieCube::cpU[] = { UBR, URF, UFL, ULB, DFR, DLF, DBL, DRB };
unsigned char CubieCube::coU[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
Edge CubieCube::epU[] = { UB, UR, UF, UL, DR, DF, DL, DB, FR, FL, BL, BR };
unsigned char CubieCube::eoU[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

Corner CubieCube::cpR[] = { DFR, UFL, ULB, URF, DRB, DLF, DBL, UBR };
unsigned char CubieCube::coR[] = { 2, 0, 0, 1, 1, 0, 0, 2 };
Edge CubieCube::epR[] = { FR, UF, UL, UB, BR, DF, DL, DB, DR, FL, BL, UR };
unsigned char CubieCube::eoR[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

Corner CubieCube::cpF[] = { UFL, DLF, ULB, UBR, URF, DFR, DBL, DRB };
unsigned char CubieCube::coF[] = { 1, 2, 0, 0, 2, 1, 0, 0 };
Edge CubieCube::epF[] = { UR, FL, UL, UB, DR, FR, DL, DB, UF, DF, BL, BR };
unsigned char CubieCube::eoF[] = { 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0 };

Corner CubieCube::cpD[] = { URF, UFL, ULB, UBR, DLF, DBL, DRB, DFR };
unsigned char CubieCube::coD[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
Edge CubieCube::epD[] = { UR, UF, UL, UB, DF, DL, DB, DR, FR, FL, BL, BR };
unsigned char CubieCube::eoD[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

Corner CubieCube::cpL[] = { URF, ULB, DBL, UBR, DFR, UFL, DLF, DRB };
unsigned char CubieCube::coL[] = { 0, 1, 2, 0, 0, 2, 1, 0 };
Edge CubieCube::epL[] = { UR, UF, BL, UB, DR, DF, FL, DB, FR, UL, DL, BR };
unsigned char CubieCube::eoL[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

Corner CubieCube::cpB[] = { URF, UFL, UBR, DRB, DFR, DLF, ULB, DBL };
unsigned char CubieCube::coB[] = { 0, 0, 1, 2, 0, 0, 2, 1 };
Edge CubieCube::epB[] = { UR, UF, UL, BR, DR, DF, DL, BL, FR, FL, UB, DB };
unsigned char CubieCube::eoB[] = { 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1 };


void CubieCube::initAllStaticVariables() {
    memcpy(moveCube[0].cp, cpU, sizeof(cpU));
    memcpy(moveCube[0].co, coU, sizeof(coU));
    memcpy(moveCube[0].ep, epU, sizeof(epU));
    memcpy(moveCube[0].eo, eoU, sizeof(eoU));
    
    
    memcpy(moveCube[1].cp, cpR, sizeof(cpR));
    memcpy(moveCube[1].co, coR, sizeof(coR));
    memcpy(moveCube[1].ep, epR, sizeof(epR));
    memcpy(moveCube[1].eo, eoR, sizeof(eoR));

    memcpy(moveCube[2].cp, cpF, sizeof(cpF));
    memcpy(moveCube[2].co, coF, sizeof(coF));
    memcpy(moveCube[2].ep, epF, sizeof(epF));
    memcpy(moveCube[2].eo, eoF, sizeof(eoF));
    
    memcpy(moveCube[3].cp, cpD, sizeof(cpD));
    memcpy(moveCube[3].co, coD, sizeof(coD));
    memcpy(moveCube[3].ep, epD, sizeof(epD));
    memcpy(moveCube[3].eo, eoD, sizeof(eoD));
    
    memcpy(moveCube[4].cp, cpL, sizeof(cpL));
    memcpy(moveCube[4].co, coL, sizeof(coL));
    memcpy(moveCube[4].ep, epL, sizeof(epL));
    memcpy(moveCube[4].eo, eoL, sizeof(eoL));
    
    memcpy(moveCube[5].cp, cpB, sizeof(cpB));
    memcpy(moveCube[5].co, coB, sizeof(coB));
    memcpy(moveCube[5].ep, epB, sizeof(epB));
    memcpy(moveCube[5].eo, eoB, sizeof(eoB));
    
}


CubieCube::CubieCube() {}


CubieCube::CubieCube(Corner cp[], unsigned char co[], Edge ep[], unsigned char eo[]) {
    for (int i = 0; i < 8; i++) {
        this->cp[i] = cp[i];
        this->co[i] = co[i];
    }
    for (int i = 0; i < 12; i++) {
        this->ep[i] = ep[i];
        this->eo[i] = eo[i];
    }
}


int CubieCube::Cnk(int n, int k){
    int i, j, s;
    if (n < k)
        return 0;
    if (k > n / 2)
        k = n - k;
    for (s = 1, i = n, j = 1; i != n - k; i--, j++) {
        s *= i;
        s /= j;
    }
    return s;
}



void CubieCube::rotateLeft(Corner arr[], int l, int r) {
    Corner temp = arr[l];
    for (int i = l; i < r; i++)
        arr[i] = arr[i + 1];
    arr[r] = temp;
}


void CubieCube::rotateRight(Corner arr[], int l, int r) {
    Corner temp = arr[r];
    for (int i = r; i > l; i--)
        arr[i] = arr[i - 1];
    arr[l] = temp;
}


void CubieCube::rotateLeft(Edge arr[], int l, int r) {
    Edge temp = arr[l];
    for (int i = l; i < r; i++)
        arr[i] = arr[i + 1];
    arr[r] = temp;
}


void CubieCube::rotateRight(Edge arr[], int l, int r) {
    Edge temp = arr[r];
    for (int i = r; i > l; i--)
        arr[i] = arr[i - 1];
    arr[l] = temp;
}


//---------------------------
std::auto_ptr<FaceCube> CubieCube::toFaceCube() {
    std::auto_ptr<FaceCube> fcRet(new FaceCube());
    
    for (int i = 0; i < 8; i++) {
        int j = cp[i];// cornercubie with index j is at
        // cornerposition with index i
        unsigned char ori = co[i];// Orientation of this cubie
        for (int n = 0; n < 3; n++)
            fcRet->f[FaceCube::cornerFacelet[i][(n + ori) % 3]] = FaceCube::cornerColor[j][n];
    }
    
    for (int i = 0; i < 12; i++) {
        int j = ep[i];// edgecubie with index j is at edgeposition
        // with index i
        unsigned char ori = eo[i];// Orientation of this cubie
        for (int n = 0; n < 2; n++)
            fcRet->f[FaceCube::edgeFacelet[i][(n + ori) % 2]] = FaceCube::edgeColor[j][n];
    }
    
    return fcRet;
}


void CubieCube::cornerMultiply(CubieCube &b) {
    Corner cPerm[8] = {URF};
    unsigned char cOri[8] = {0};
    for (int i = 0; i < 8; i++) {
        cPerm[i] = cp[b.cp[i]];
        unsigned char oriA = co[b.cp[i]];
        unsigned char oriB = b.co[i];
        
        unsigned char ori = 0;
        
        if (oriA < 3 && oriB < 3) // if both cubes are regular cubes...
        {
            ori = (unsigned char) (oriA + oriB); // just do an addition modulo 3 here
            if (ori >= 3)
                ori -= 3; // the composition is a regular cube
            
            // +++++++++++++++++++++not used in this implementation +++++++++++++++++++++++++++++++++++
        } else if (oriA < 3 && oriB >= 3) // if cube b is in a mirrored
			// state...
        {
            ori = (unsigned char) (oriA + oriB);
            if (ori >= 6)
                ori -= 3; // the composition is a mirrored cube
        } else if (oriA >= 3 && oriB < 3) // if cube a is an a mirrored
			// state...
        {
            ori = (unsigned char) (oriA - oriB);
            if (ori < 3)
                ori += 3; // the composition is a mirrored cube
        } else if (oriA >= 3 && oriB >= 3) // if both cubes are in mirrored
			// states...
        {
            ori = (unsigned char) (oriA - oriB);
            if (ori < 0)
                ori += 3; // the composition is a regular cube
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        }
        cOri[i] = ori;
    }
    
    for (int i = 0; i < 8; i++) {
        cp[i] = cPerm[i];
        co[i] = cOri[i];
    }
}


void CubieCube::edgeMultiply(CubieCube &b) {
    Edge ePerm[12] = {UR};
    unsigned char eOri[12] = {0};
    for (int i = 0; i < 12; i++) {
        ePerm[i] = ep[b.ep[i]];
        eOri[i] = (unsigned char) ((b.eo[i] + eo[b.ep[i]]) % 2);
    }

    for (int i = 0; i < 12; i++) {
        ep[i] = ePerm[i];
        eo[i] = eOri[i];
    }
}


void CubieCube::multiply(CubieCube &b) {
    cornerMultiply(b);
}


void CubieCube::invCubieCube(CubieCube &c) {
    for (int i = 0; i < 12; i++) {
        c.ep[ep[i]] = (Edge)i;
    }
    
    for (int i = 0; i < 12; i++) {
        c.eo[i] = eo[c.ep[i]];
    }
    
    for (int i = 0; i < 8; i++) {
        c.cp[cp[i]] = (Corner)i;
    }
    
    
    for (int i = 0; i < 8; i++) {
        unsigned char ori = co[c.cp[i]];
        if (ori >= 3)// Just for completeness. We do not invert mirrored
            // cubes in the program.
            c.co[i] = ori;
        else {// the standard case
            c.co[i] = (unsigned char) -ori;
            if (c.co[i] < 0)
                c.co[i] += 3;
        }
    }
    
}


short CubieCube::getTwist() {
    short ret = 0;
    for (int i = URF; i < DRB; i++)
        ret = (short) (3 * ret + co[i]);
    return ret;
}


void CubieCube::setTwist(short twist) {
    int twistParity = 0;
    for (int i = DRB - 1; i >= URF; i--) {
        twistParity += co[i] = (unsigned char) (twist % 3);
        twist /= 3;
    }
    co[DRB] = (unsigned char) ((3 - twistParity % 3) % 3);
}


short CubieCube::getFlip() {
    short ret = 0;
    for (int i = UR; i < BR; i++)
        ret = (short) (2 * ret + eo[i]);
    return ret;
}


void CubieCube::setFlip(short flip) {
    int flipParity = 0;
    for (int i = BR - 1; i >= UR; i--) {
        flipParity += eo[i] = (unsigned char) (flip % 2);
        flip /= 2;
    }
    eo[BR] = (unsigned char) ((2 - flipParity % 2) % 2);
}


short CubieCube::cornerParity() {
    int s = 0;
    for (int i = DRB; i >= URF + 1; i--)
        for (int j = i - 1; j >= URF; j--)
            if (cp[j] > cp[i])
                s++;
    return (short) (s % 2);
}


short CubieCube::edgeParity() {
    int s = 0;
    for (int i = BR; i >= UR + 1; i--)
        for (int j = i - 1; j >= UR; j--)
            if (ep[j] > ep[i])
                s++;
    return (short) (s % 2);
}


short CubieCube::getFRtoBR() {
    int a = 0, x = 0;
    Edge edge4[4];
    // compute the index a < (12 choose 4) and the permutation array perm.
    for (int j = BR; j >= UR; j--)
        if (FR <= ep[j] && ep[j] <= BR) {
            a += Cnk(11 - j, x + 1);
            edge4[3 - x++] = ep[j];
        }
    
    int b = 0;
    for (int j = 3; j > 0; j--)// compute the index b < 4! for the
		// permutation in perm
    {
        int k = 0;
        while (edge4[j] != j + 8) {
            rotateLeft(edge4, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return (short) (24 * a + b);
}


void CubieCube::setFRtoBR(short idx) {
    int x;
    Edge sliceEdge[] = { FR, FL, BL, BR };
    Edge otherEdge[] = { UR, UF, UL, UB, DR, DF, DL, DB };
    int b = idx % 24; // Permutation
    int a = idx / 24; // Combination
    
    for (int i = 0; i < 12; i++) {
        ep[i] = DB;// Use UR to invalidate all edges
    }
    
    for (int j = 1, k; j < 4; j++)// generate permutation from index b
    {
        k = b % (j + 1);
        b /= j + 1;
        while (k-- > 0)
            rotateRight(sliceEdge, 0, j);
    }
    
    x = 3;// generate combination and set slice edges
    for (int j = UR; j <= BR; j++)
        if (a - Cnk(11 - j, x + 1) >= 0) {
            ep[j] = sliceEdge[3 - x];
            a -= Cnk(11 - j, x-- + 1);
        }
    x = 0; // set the remaining edges UR..DB
    for (int j = UR; j <= BR; j++)
        if (ep[j] == DB)
            ep[j] = otherEdge[x++];

}


short CubieCube::getURFtoDLF() {
    int a = 0, x = 0;
    Corner corner6[6] = {URF};
    // compute the index a < (8 choose 6) and the corner permutation.
    for (int j = URF; j <= DRB; j++)
        if (cp[j] <= DLF) {
            a += Cnk(j, x + 1);
            corner6[x++] = cp[j];
        }
    
    int b = 0;
    for (int j = 5; j > 0; j--)// compute the index b < 6! for the
		// permutation in corner6
    {
        int k = 0;
        while (corner6[j] != j) {
            rotateLeft(corner6, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return (short) (720 * a + b);
}


void CubieCube::setURFtoDLF(short idx) {
    int x;
    Corner corner6[] = { URF, UFL, ULB, UBR, DFR, DLF };
    Corner otherCorner[] = { DBL, DRB };
    int b = idx % 720; // Permutation
    int a = idx / 720; // Combination
    
    for (int i = 0; i < 8; i++) {
        cp[i] = DRB;// Use DRB to invalidate all corners
    }
    
    for (int j = 1, k; j < 6; j++)// generate permutation from index b
    {
        k = b % (j + 1);
        b /= j + 1;
        while (k-- > 0)
            rotateRight(corner6, 0, j);
    }
    x = 5;// generate combination and set corners
    for (int j = DRB; j >= 0; j--)
        if (a - Cnk(j, x + 1) >= 0) {
            cp[j] = corner6[x];
            a -= Cnk(j, x-- + 1);
        }
    x = 0;
    for (int j = URF; j <= DRB; j++)
        if (cp[j] == DRB)
            cp[j] = otherCorner[x++];
}


int CubieCube::getURtoDF() {
    int a = 0, x = 0;
    Edge edge6[6] = {UR};
    // compute the index a < (12 choose 6) and the edge permutation.
    for (int j = UR; j <= BR; j++)
        if (ep[j] <= DF) {
            a += Cnk(j, x + 1);
            edge6[x++] = ep[j];
        }
    
    int b = 0;
    for (int j = 5; j > 0; j--)// compute the index b < 6! for the
		// permutation in edge6
    {
        int k = 0;
        while (edge6[j] != j) {
            rotateLeft(edge6, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return 720 * a + b;
}


void CubieCube::setURtoDF(int idx) {
    int x;
    Edge edge6[] = { UR, UF, UL, UB, DR, DF };
    Edge otherEdge[] = { DL, DB, FR, FL, BL, BR };
    int b = idx % 720; // Permutation
    int a = idx / 720; // Combination
    for (int i = 0; i < 12; i++) {
        ep[i] = BR;// Use BR to invalidate all edges
    }
        
    
    for (int j = 1, k; j < 6; j++)// generate permutation from index b
    {
        k = b % (j + 1);
        b /= j + 1;
        while (k-- > 0)
            rotateRight(edge6, 0, j);
    }
    x = 5;// generate combination and set edges
    for (int j = BR; j >= 0; j--)
        if (a - Cnk(j, x + 1) >= 0) {
            ep[j] = edge6[x];
            a -= Cnk(j, x-- + 1);
        }
    x = 0; // set the remaining edges DL..BR
    for (int j = UR; j <= BR; j++)
        if (ep[j] == BR)
            ep[j] = otherEdge[x++];
}


int CubieCube::getURtoDF(short idx1, short idx2){
    CubieCube a = CubieCube();
    CubieCube b = CubieCube();
    a.setURtoUL(idx1);
    b.setUBtoDF(idx2);
    for (int i = 0; i < 8; i++) {
        if (a.ep[i] != BR)
        {
            if (b.ep[i] != BR)// collision
                return -1;
            else
                b.ep[i] = a.ep[i];
        }
    }
    return b.getURtoDF();
}


short CubieCube::getURtoUL() {
    int a = 0, x = 0;
    Edge edge3[3];
    // compute the index a < (12 choose 3) and the edge permutation.
    for (int j = UR; j <= BR; j++)
        if (ep[j] <= UL) {
            a += Cnk(j, x + 1);
            edge3[x++] = ep[j];
        }
    
    int b = 0;
    for (int j = 2; j > 0; j--)// compute the index b < 3! for the
		// permutation in edge3
    {
        int k = 0;
        while (edge3[j] != j) {
            rotateLeft(edge3, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return (short) (6 * a + b);
}


void CubieCube::setURtoUL(short idx) {
    int x;
    Edge edge3[] = { UR, UF, UL };
    int b = idx % 6; // Permutation
    int a = idx / 6; // Combination
    
    for (int i = 0; i < 12; i++) {
        ep[i] = BR;// Use BR to invalidate all edges
    }
        
    
    for (int j = 1, k; j < 3; j++)// generate permutation from index b
    {
        k = b % (j + 1);
        b /= j + 1;
        while (k-- > 0)
            rotateRight(edge3, 0, j);
    }
    x = 2;// generate combination and set edges
    for (int j = BR; j >= 0; j--)
        if (a - Cnk(j, x + 1) >= 0) {
            ep[j] = edge3[x];
            a -= Cnk(j, x-- + 1);
        }
}


short CubieCube::getUBtoDF() {
    int a = 0, x = 0;
    Edge edge3[3];
    // compute the index a < (12 choose 3) and the edge permutation.
    for (int j = UR; j <= BR; j++)
        if (UB <= ep[j] && ep[j] <= DF) {
            a += Cnk(j, x + 1);
            edge3[x++] = ep[j];
        }
    
    int b = 0;
    for (int j = 2; j > 0; j--)// compute the index b < 3! for the
		// permutation in edge3
    {
        int k = 0;
        while (edge3[j] != UB + j) {
            rotateLeft(edge3, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return (short) (6 * a + b);
}


void CubieCube::setUBtoDF(short idx) {
    int x;
    Edge edge3[] = { UB, DR, DF };
    int b = idx % 6; // Permutation
    int a = idx / 6; // Combination
    
    for (int i = 0; i < 12; i++) {
        ep[i] = BR;// Use BR to invalidate all edges
    }
        
    
    for (int j = 1, k; j < 3; j++)// generate permutation from index b
    {
        k = b % (j + 1);
        b /= j + 1;
        while (k-- > 0)
            rotateRight(edge3, 0, j);
    }
    x = 2;// generate combination and set edges
    for (int j = BR; j >= 0; j--)
        if (a - Cnk(j, x + 1) >= 0) {
            ep[j] = edge3[x];
            a -= Cnk(j, x-- + 1);
        }
}


int CubieCube::getURFtoDLB(){
    Corner perm[8] = {URF};
    int b = 0;
    for (int i = 0; i < 8; i++)
        perm[i] = cp[i];
    for (int j = 7; j > 0; j--)// compute the index b < 8! for the permutation in perm
    {
        int k = 0;
        while (perm[j] != j) {
            rotateLeft(perm, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return b;
}


void CubieCube::setURFtoDLB(int idx) {
    Corner perm[] = { URF, UFL, ULB, UBR, DFR, DLF, DBL, DRB };
    int k;
    for (int j = 1; j < 8; j++) {
        k = idx % (j + 1);
        idx /= j + 1;
        while (k-- > 0)
            rotateRight(perm, 0, j);
    }
    int x = 7;// set corners
    for (int j = 7; j >= 0; j--)
        cp[j] = perm[x--];
}


int CubieCube::getURtoBR() {
    Edge perm[12] = {UR};
    int b = 0;
    for (int i = 0; i < 12; i++)
        perm[i] = ep[i];
    for (int j = 11; j > 0; j--)// compute the index b < 12! for the permutation in perm
    {
        int k = 0;
        while (perm[j] != j) {
            rotateLeft(perm, 0, j);
            k++;
        }
        b = (j + 1) * b + k;
    }
    return b;
}


void CubieCube::setURtoBR(int idx) {
    Edge perm[] = { UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR };
    int k;
    for (int j = 1; j < 12; j++) {
        k = idx % (j + 1);
        idx /= j + 1;
        while (k-- > 0)
            rotateRight(perm, 0, j);
    }
    int x = 11;// set edges
    for (int j = 11; j >= 0; j--)
        ep[j] = perm[x--];
}


int CubieCube::verify() {
    int sum = 0;
    int edgeCount[12] = {0};
    
    for (int i = 0; i < 12; i++) {
        edgeCount[ep[i]]++;
    }
        
    for (int i = 0; i < 12; i++)
        if (edgeCount[i] != 1)
            return -2;
    
    for (int i = 0; i < 12; i++)
        sum += eo[i];
    if (sum % 2 != 0)
        return -3;
    
    int cornerCount[8] = {0};
    for (int i = 0; i < 8; i++) {
        cornerCount[cp[i]]++;
    }
        
    for (int i = 0; i < 8; i++)
        if (cornerCount[i] != 1)
            return -4;// missing corners
    
    sum = 0;
    for (int i = 0; i < 8; i++)
        sum += co[i];
    if (sum % 3 != 0)
        return -5;// twisted corner
    
    if ((edgeParity() ^ cornerParity()) != 0)
        return -6;// parity error
    
    return 0;// cube ok
}

