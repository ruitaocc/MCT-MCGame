//
//  TPSearch.cpp
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#include "Search.h"
#include "CoordCube.h"
#include <sys/time.h>



int Search::ax[31]; // The axis of the move
int Search::po[31]; // The power of the move

int Search::flip[31]; // phase1 coordinates
int Search::twist[31];
int Search::slice[31];

int Search::parity[31]; // phase2 coordinates
int Search::URFtoDLF[31];
int Search::FRtoBR[31];
int Search::URtoUL[31];
int Search::UBtoDF[31];
int Search::URtoDF[31];

int Search::minDistPhase1[31]; // IDA* distance do goal estimations
int Search::minDistPhase2[31];


string Search::solutionToString(int length) {
    string s = "";
    for (int i = 0; i < length; i++) {
        switch (ax[i]) {
			case 0:
				s += "U";
				break;
			case 1:
				s += "R";
				break;
			case 2:
				s += "F";
				break;
			case 3:
				s += "D";
				break;
			case 4:
				s += "L";
				break;
			case 5:
				s += "B";
				break;
        }
        switch (po[i]) {
			case 1:
				s += " ";
				break;
			case 2:
				s += "2 ";
				break;
			case 3:
				s += "' ";
				break;
                
        }
    }
    return s;
}



string Search::solutionToString(int length, int depthPhase1) {
    string s = "";
    for (int i = 0; i < length; i++) {
        switch (ax[i]) {
			case 0:
				s += "U";
				break;
			case 1:
				s += "R";
				break;
			case 2:
				s += "F";
				break;
			case 3:
				s += "D";
				break;
			case 4:
				s += "L";
				break;
			case 5:
				s += "B";
				break;
        }
        switch (po[i]) {
			case 1:
				s += " ";
				break;
			case 2:
				s += "2 ";
				break;
			case 3:
				s += "' ";
				break;
                
        }
    }
    return s;
}



string Search::solution(string facelets, int maxDepth, long timeOut, bool useSeparator) {
    int s = 0;
    
    // +++++++++++++++++++++check for wrong input +++++++++++++++++++++++++++++
    int count[6] = {0};
    try {
        for (int i = 0; i < 54; i++)
        {
            switch (facelets[i]) {
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
        return "Error 1";
    }
    for (int i = 0; i < 6; i++)
        if (count[i] != 9)
            return "Error 1";
    
    FaceCube fc = FaceCube(facelets);
    auto_ptr<CubieCube> cc = fc.toCubieCube();
    if ((s = cc->verify()) != 0){
        string result = "Error ";
        result +=  (char)(abs(s)+'0');
        return result;
    }
    
    // +++++++++++++++++++++++ initialization +++++++++++++++++++++++++++++++++
    //---------------------------
    CoordCube c = CoordCube(*cc);
    
    po[0] = 0;
    ax[0] = 0;
    flip[0] = c.flip;
    twist[0] = c.twist;
    parity[0] = c.parity;
    slice[0] = c.FRtoBR / 24;
    URFtoDLF[0] = c.URFtoDLF;
    FRtoBR[0] = c.FRtoBR;
    URtoUL[0] = c.URtoUL;
    UBtoDF[0] = c.UBtoDF;
    
    minDistPhase1[1] = 1;// else failure for depth=1, n=0
    int mv = 0, n = 0;
    bool busy = false;
    int depthPhase1 = 1;
    
    struct timeval tv;
    gettimeofday(&tv,NULL);
    
    long tStart = tv.tv_sec * 1000 + tv.tv_usec / 1000;
    
    // +++++++++++++++++++ Main loop ++++++++++++++++++++++++++++++++++++++++++
    do {
        do {
            if ((depthPhase1 - n > minDistPhase1[n + 1]) && !busy) {
                
                if (ax[n] == 0 || ax[n] == 3)// Initialize next move
                    ax[++n] = 1;
                else
                    ax[++n] = 0;
                po[n] = 1;
            } else if (++po[n] > 3) {
                do {// increment axis
                    if (++ax[n] > 5) {
                        
                        gettimeofday(&tv,NULL);
                        
                        if ((tv.tv_sec * 1000 + tv.tv_usec / 1000) - tStart > timeOut << 10)
                            return "Error 8";
                        
                        if (n == 0) {
                            if (depthPhase1 >= maxDepth)
                                return "Error 7";
                            else {
                                depthPhase1++;
                                ax[n] = 0;
                                po[n] = 1;
                                busy = false;
                                break;
                            }
                        } else {
                            n--;
                            busy = true;
                            break;
                        }
                        
                    } else {
                        po[n] = 1;
                        busy = false;
                    }
                } while (n != 0 && (ax[n - 1] == ax[n] || ax[n - 1] - 3 == ax[n]));
            } else
                busy = false;
        } while (busy);
        
        // +++++++++++++ compute new coordinates and new minDistPhase1 ++++++++++
        // if minDistPhase1 =0, the H subgroup is reached
        mv = 3 * ax[n] + po[n] - 1;
        flip[n + 1] = CoordCube::flipMove[flip[n]][mv];
        twist[n + 1] = CoordCube::twistMove[twist[n]][mv];
        slice[n + 1] = CoordCube::FRtoBR_Move[slice[n] * 24][mv] / 24;
        minDistPhase1[n + 1] = max(CoordCube::getPruning(CoordCube::Slice_Flip_Prun, CoordCube::N_SLICE1 * flip[n + 1]
                                                             + slice[n + 1]), CoordCube::getPruning(CoordCube::Slice_Twist_Prun, CoordCube::N_SLICE1 * twist[n + 1]
                                                                                                   + slice[n + 1]));
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        if (minDistPhase1[n + 1] == 0 && n >= depthPhase1 - 5) {
            minDistPhase1[n + 1] = 10;// instead of 10 any value >5 is possible
            if (n == depthPhase1 - 1 && (s = totalDepth(depthPhase1, maxDepth)) >= 0) {
                if (s == depthPhase1
                    || (ax[depthPhase1 - 1] != ax[depthPhase1] && ax[depthPhase1 - 1] != ax[depthPhase1] + 3))
                    return useSeparator ? solutionToString(s, depthPhase1) : solutionToString(s);
            }
            
        }
    } while (true);
}


int Search::totalDepth(int depthPhase1, int maxDepth) {
    int mv = 0, d1 = 0, d2 = 0;
    int maxDepthPhase2 = min(10, maxDepth - depthPhase1);// Allow only max 10 moves in phase2
    for (int i = 0; i < depthPhase1; i++) {
        mv = 3 * ax[i] + po[i] - 1;
        URFtoDLF[i + 1] = CoordCube::URFtoDLF_Move[URFtoDLF[i]][mv];
        FRtoBR[i + 1] = CoordCube::FRtoBR_Move[FRtoBR[i]][mv];
        parity[i + 1] = CoordCube::parityMove[parity[i]][mv];
    }
    
    if ((d1 = CoordCube::getPruning(CoordCube::Slice_URFtoDLF_Parity_Prun,
                                   (CoordCube::N_SLICE2 * URFtoDLF[depthPhase1] + FRtoBR[depthPhase1]) * 2 + parity[depthPhase1])) > maxDepthPhase2)
        return -1;
    
    for (int i = 0; i < depthPhase1; i++) {
        mv = 3 * ax[i] + po[i] - 1;
        URtoUL[i + 1] = CoordCube::URtoUL_Move[URtoUL[i]][mv];
        UBtoDF[i + 1] = CoordCube::UBtoDF_Move[UBtoDF[i]][mv];
    }
    URtoDF[depthPhase1] = CoordCube::MergeURtoULandUBtoDF[URtoUL[depthPhase1]][UBtoDF[depthPhase1]];
    
    if ((d2 = CoordCube::getPruning(CoordCube::Slice_URtoDF_Parity_Prun,
                                    (CoordCube::N_SLICE2 * URtoDF[depthPhase1] + FRtoBR[depthPhase1]) * 2 + parity[depthPhase1])) > maxDepthPhase2)
        return -1;
    
    if ((minDistPhase2[depthPhase1] = max(d1, d2)) == 0)// already solved
        return depthPhase1;
    
    // now set up search
    
    int depthPhase2 = 1;
    int n = depthPhase1;
    bool busy = false;
    po[depthPhase1] = 0;
    ax[depthPhase1] = 0;
    minDistPhase2[n + 1] = 1;// else failure for depthPhase2=1, n=0
    // +++++++++++++++++++ end initialization +++++++++++++++++++++++++++++++++
    do {
        do {
            if ((depthPhase1 + depthPhase2 - n > minDistPhase2[n + 1]) && !busy) {
                
                if (ax[n] == 0 || ax[n] == 3)// Initialize next move
                {
                    ax[++n] = 1;
                    po[n] = 2;
                } else {
                    ax[++n] = 0;
                    po[n] = 1;
                }
            } else if ((ax[n] == 0 || ax[n] == 3) ? (++po[n] > 3) : ((po[n] = po[n] + 2) > 3)) {
                do {// increment axis
                    if (++ax[n] > 5) {
                        if (n == depthPhase1) {
                            if (depthPhase2 >= maxDepthPhase2)
                                return -1;
                            else {
                                depthPhase2++;
                                ax[n] = 0;
                                po[n] = 1;
                                busy = false;
                                break;
                            }
                        } else {
                            n--;
                            busy = true;
                            break;
                        }
                        
                    } else {
                        if (ax[n] == 0 || ax[n] == 3)
                            po[n] = 1;
                        else
                            po[n] = 2;
                        busy = false;
                    }
                } while (n != depthPhase1 && (ax[n - 1] == ax[n] || ax[n - 1] - 3 == ax[n]));
            } else
                busy = false;
        } while (busy);
        // +++++++++++++ compute new coordinates and new minDist ++++++++++
        mv = 3 * ax[n] + po[n] - 1;
        
        URFtoDLF[n + 1] = CoordCube::URFtoDLF_Move[URFtoDLF[n]][mv];
        FRtoBR[n + 1] = CoordCube::FRtoBR_Move[FRtoBR[n]][mv];
        parity[n + 1] = CoordCube::parityMove[parity[n]][mv];
        URtoDF[n + 1] = CoordCube::URtoDF_Move[URtoDF[n]][mv];
        
        minDistPhase2[n + 1] = max(CoordCube::getPruning(CoordCube::Slice_URtoDF_Parity_Prun, (CoordCube::N_SLICE2
                                                                                                  * URtoDF[n + 1] + FRtoBR[n + 1])
                                                        * 2 + parity[n + 1]), CoordCube::getPruning(CoordCube::Slice_URFtoDLF_Parity_Prun, (CoordCube::N_SLICE2
                                                                                                                                               * URFtoDLF[n + 1] + FRtoBR[n + 1])
                                                                                                        * 2 + parity[n + 1]));
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    } while (minDistPhase2[n + 1] != 0);
    
    return depthPhase1 + depthPhase2;
}

