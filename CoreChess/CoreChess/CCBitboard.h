//
//  CCBitboard.h
//  CoreChess
//
//  Created by Austen Green on 6/3/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCBITBOARD_H
#define CCBITBOARD_H
#include <stdint.h>
#include "CCSquare.h"
#include "CCPiece.h"

typedef uint64_t CCBitboard;

enum CCDirection{
    noWe =  7, nort = 8,  noEa = 9,
    west = -1,            east = 1,
    soWe = -9, sout = -8, soEa = -7
};
typedef enum CCDirection CCDirection;

extern const CCBitboard RanksBB[8];
extern const CCBitboard FilesBB[8];
extern const CCBitboard SquaresBB[65];
extern const CCBitboard PieceMovesBB[5][64];
extern const unsigned char occupancy_bitboards[8][256];

extern const CCBitboard EmptyBB;
extern const CCBitboard notAFile;
extern const CCBitboard notHFile;
extern const CCBitboard longDiag; // Long diagonal a1-h8
extern const CCBitboard longAdiag; // Long antidiagonal a8-h1

CCBitboard CCBitboardMovesForPieceAtSquare(CCPiece, CCSquare);

CCBitboard generate_ray(CCSquare, CCDirection);
unsigned char generate_first_rank(unsigned char, signed char);

/* Basic shifts */
inline CCBitboard CCBitboardNorthOne(CCBitboard b);
inline CCBitboard CCBitboardSouthOne(CCBitboard b);
inline CCBitboard CCBitboardEastOne(CCBitboard b);
inline CCBitboard CCBitboardNorthEastOne(CCBitboard b);
inline CCBitboard CCBitboardSouthEastOne(CCBitboard b);
inline CCBitboard CCBitboardWestOne(CCBitboard b); 
inline CCBitboard CCBitboardSouthWestOne(CCBitboard b); 
inline CCBitboard CCBitboardNorthWestOne(CCBitboard b); 

/* Extended shifts */
inline CCBitboard CCBitboardNorthX(CCBitboard b, unsigned char x) {return (x < 8) ? b << (8 * x) : EmptyBB;}
inline CCBitboard CCBitboardSouthX(CCBitboard b, unsigned char x) {return (x < 8) ? b >> (8 * x) : EmptyBB;}
inline CCBitboard CCBitboardEastX(CCBitboard b, unsigned char x) {
    for (int i = 0; i < x; i++) {
        b = CCBitboardEastOne(b);
    }
    return b;
}
inline CCBitboard CCBitboardWestX(CCBitboard b, unsigned char x) {
    for (int i = 0; i < x; i++) {
        b = CCBitboardWestOne(b);
    }
    return b;
}

/* The following four methods use kindergarten CCBitboards to generate a CCBitboard
 * of attacked squares for sliding pieces along a given line (rank, file, or diagonal). 
 * The returned set of squares represents those squares which can be attacked
 * by a sliding piece, and must be filtered based on color to make sure that a sliding
 * piece cannot move to a square occupied by a friendly piece. */
CCBitboard CCBitboardGetRankAttacks(CCBitboard occupied, CCSquare s);
CCBitboard CCBitboardGetFileAttacks(CCBitboard occupied, CCSquare s);
CCBitboard CCBitboardGetDiagonalAttacks(CCBitboard occupied, CCSquare s);
CCBitboard CCBitboardGetAntiDiagonalAttacks(CCBitboard occupied, CCSquare s);

CCBitboard CCBitboardForSquare(CCSquare s);
extern CCBitboard ranksBB(unsigned char rank);
extern CCBitboard filesBB(unsigned char file);

extern CCSquare CCSquareForBitboard(CCBitboard);
extern int CCBitboardPopulationCount(CCBitboard);

extern NSString * NSStringFromCCBitboard(CCBitboard);
extern void print_hex(CCBitboard bb);
extern void print_bitboard(CCBitboard bb);

// Debug
//extern void print_bitboard(const CCBitboard&);

//inline void print_hex(const CCBitboard& bb) {
//    printf("0x%016llXULL,\n", bb);
//}

#endif
