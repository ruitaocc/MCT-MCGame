//
//  CompositeRotationUtil.m
//  MCGame
//
//  Created by Aha on 13-5-13.
//
//

#import "MCCompositeRotationUtil.h"

@implementation MCCompositeRotationUtil


+ (BOOL)isSingmasterNotation:(SingmasterNotation)first andSingmasterNotation:(SingmasterNotation)second equalTo:(SingmasterNotation)target{
    //F+F / F'+F' == F2...
    if (first == second && first/3*3+2 == target) {
        return YES;
    }
    //two layers rotation as single SingmasterNotation
    BOOL result = NO;
    switch (target) {
        case Fw:
            if ((first == F && second == S) || (first == S && second == F)) result = YES;
            break;
        case Fwi:
            if ((first == Fi && second == Si) || (first == Si && second == Fi)) result = YES;
            break;
        case Bw:
            if ((first == B && second == Si) || (first == Si && second == B)) result = YES;
            break;
        case Bwi:
            if ((first == Bi && second == S) || (first == S && second == Bi)) result = YES;
            break;
        case Rw:
            if ((first == R && second == Mi) || (first == Mi && second == R)) result = YES;
            break;
        case Rwi:
            if ((first == Ri && second == M) || (first == M && second == Ri)) result = YES;
            break;
        case Lw:
            if ((first == L && second == M) || (first == M && second == L)) result = YES;
            break;
        case Lwi:
            if ((first == Li && second == Mi) || (first == Mi && second == Li)) result = YES;
            break;
        case Uw:
            if ((first == U && second == Ei) || (first == Ei && second == U)) result = YES;
            break;
        case Uwi:
            if ((first == Ui && second == E) || (first == E && second == Ui)) result = YES;
            break;
        case Dw:
            if ((first == D && second == E) || (first == E && second == F)) result = YES;
            break;
        case Dwi:
            if ((first == Di && second == Ei) || (first == Ei && second == F)) result = YES;
            break;
        default:
            break;
    }
    return result;
}

+ (BOOL)isSingmasterNotation:(SingmasterNotation)part PossiblePartOfSingmasterNotation:(SingmasterNotation)target{
    //F / F' is part of F2...
    if (part != target  && (target+1)%3 == 0 && target/3 == part/3) {
        return YES;
    }
    //
    BOOL result = NO;
    switch (target) {
        case Fw:
            if (part == F || part == S) result = YES;
            break;
        case Fwi:
            if (part == Fi || part == Si) result = YES;
            break;
        case Bw:
            if (part == B || part == Si) result = YES;
            break;
        case Bwi:
            if (part == Bi || part == S) result = YES;
            break;
        case Rw:
            if (part == R || part == Mi) result = YES;
            break;
        case Rwi:
            if (part == Ri || part == M) result = YES;
            break;
        case Lw:
            if (part == L || part == M) result = YES;
            break;
        case Lwi:
            if (part == Li || part == Mi) result = YES;
            break;
        case Uw:
            if (part == U || part == Ei) result = YES;
            break;
        case Uwi:
            if (part == Ui || part == E) result = YES;
            break;
        case Dw:
            if (part == D || part == E) result = YES;
            break;
        case Dwi:
            if (part == Di || part == Ei) result = YES;
            break;
        default:
            break;
    }
    return result;
}

@end
