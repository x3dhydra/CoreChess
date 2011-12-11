//
//  CCSquare.h
//  CoreChess
//
//  Created by Austen Green on 6/3/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCSQUARE_H
#define CCSQUARE_H

#ifdef __cplusplus
extern "C" {
#endif

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

/* Squares are referred to by numbers 0-63, with 0 corresponding
 to a1, and 63 corresponding to h8, where the numbers increment
 along ranks (b1 = 1, etc).  This enumeration is simply for 
 convenience in referencing squares in code. */
enum CCSquare {
    a1, b1, c1, d1, e1, f1, g1, h1,
    a2, b2, c2, d2, e2, f2, g2, h2,
    a3, b3, c3, d3, e3, f3, g3, h3,
    a4, b4, c4, d4, e4, f4, g4, h4,
    a5, b5, c5, d5, e5, f5, g5, h5,
    a6, b6, c6, d6, e6, f6, g6, h6,
    a7, b7, c7, d7, e7, f7, g7, h7,
    a8, b8, c8, d8, e8, f8, g8, h8,
    InvalidSquare
};
typedef enum CCSquare CCSquare;

/* Takes a rank and a file and converts it into a CCSquare */
extern CCSquare CCSquareMake(signed char rank, signed char file);
/* Takes a string of two characters corresponding to the algebraic
 notation and converts it to a CCSquare */
extern CCSquare CCSquareForString(CFStringRef name);
extern CCSquare CCSquareMakeForString(const char * name);
/* Returns the rank of a CCSquare */
extern int CCSquareRank(CCSquare);
/* Returns the file of a CCSquare */
extern int CCSquareFile(CCSquare);

/* Returns true if the square is not InvalidSquare */
extern BOOL CCSquareIsValid(CCSquare square);

/* Returns a string with the algebraic notation representation of a 
 CCSquare corresponding to the passed rank and file. */
extern CFStringRef CCSquareNameForRankAndFile(int rank, int file);
/* Returns a string with the algebraic notation representation of a CCSquare */
extern CFStringRef CCSquareName(CCSquare);

/* Basic shifts for squares */
extern CCSquare CCSquareNorthOne(CCSquare s);
extern CCSquare CCSquareSouthOne(CCSquare s);
extern CCSquare CCSquareEastOne(CCSquare s);
extern CCSquare CCSquareWestOne(CCSquare s);
extern CCSquare CCSquareNorthEastOne(CCSquare s);
extern CCSquare CCSquareNorthWestOne(CCSquare s);
extern CCSquare CCSquareSouthEastOne(CCSquare s);
extern CCSquare CCSquareSouthWestOne(CCSquare s);

/* Validates that the CCSquare is between a1 and h8, and throws an 
 Invalid_Square_Exception otherwise */
inline BOOL in_range(CCSquare s) { return ((a1 <= s) && (h8 >= s)); }

#ifdef __cplusplus
}
#endif

#endif
