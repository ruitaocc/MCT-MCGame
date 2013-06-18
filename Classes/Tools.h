//
//  TPTools.h
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#ifndef __TP__TPTools__
#define __TP__TPTools__

#include <iostream>
#include <string.h>
#include "GlobalDefine.h"
#include "FaceCube.h"

using namespace std;

class Tools {
public:
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	// Check if the cube string s represents a solvable cube.
	// 0: Cube is solvable
	// -1: There is not exactly one facelet of each colour
	// -2: Not all 12 edges exist exactly once
	// -3: Flip error: One edge has to be flipped
	// -4: Not all corners exist exactly once
	// -5: Twist error: One corner has to be twisted
	// -6: Parity error: Two corners or two edges have to be exchanged
	//
	/**
	 * Check if the cube definition string s represents a solvable cube.
	 *
	 * @param s is the cube definition string , see {@link Facelet}
	 * @return 0: Cube is solvable<br>
	 *         -1: There is not exactly one facelet of each colour<br>
	 *         -2: Not all 12 edges exist exactly once<br>
	 *         -3: Flip error: One edge has to be flipped<br>
	 *         -4: Not all 8 corners exist exactly once<br>
	 *         -5: Twist error: One corner has to be twisted<br>
	 *         -6: Parity error: Two corners or two edges have to be exchanged
	 */
	static int verify(string s);
    
    /**
	 * Generates a random cube.
	 * @return A random cube in the string representation. Each cube of the cube space has the same probability.
	 */
	static string randomCube();
    
};

#endif /* defined(__TP__TPTools__) */
