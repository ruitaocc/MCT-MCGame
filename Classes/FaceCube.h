//
//  TPFaceCube.h
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#ifndef __TP__TPFaceCube__
#define __TP__TPFaceCube__

#include <string.h>
#include "GlobalDefine.h"
#include "CubieCube.h"

using namespace TP;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Cube on the facelet level
class FaceCube {
public:
    Color f[54];
    

	// Map the corner positions to facelet positions. cornerFacelet[URF.ordinal()][0] e.g. gives the position of the
	// facelet in the URF corner position, which defines the orientation.<br>
	// cornerFacelet[URF.ordinal()][1] and cornerFacelet[URF.ordinal()][2] give the position of the other two facelets
	// of the URF corner (clockwise).
	static Facelet cornerFacelet[8][3];
    

	// Map the edge positions to facelet positions. edgeFacelet[UR.ordinal()][0] e.g. gives the position of the facelet in
	// the UR edge position, which defines the orientation.<br>
	// edgeFacelet[UR.ordinal()][1] gives the position of the other facelet
	static Facelet edgeFacelet[12][2];
    

	// Map the corner positions to facelet colors.
	static Color cornerColor[8][3];
    

	// Map the edge positions to facelet colors.
	static Color edgeColor[12][2];

	// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
	FaceCube();
    

	// Construct a facelet cube from a string
	FaceCube(std::string cubeString);
    

	// Gives string representation of a facelet cube
	std::string to_String();
    

	// Gives CubieCube representation of a faceletcube
	std::auto_ptr<CubieCube> toCubieCube();
};


#endif /* defined(__TP__TPFaceCube__) */
