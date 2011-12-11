//
//  CCBoard.h
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCBOARD_H
#define CCBOARD_H

#ifdef __cplusplus
extern "C" {
#endif

#include "CCBitboard.h"
#include "CCPiece.h"

struct _CCBoard;
typedef const struct _CCBoard* CCBoardRef;
typedef struct _CCBoard* CCMutableBoardRef;
    
// Reference counting
extern CCBoardRef CCBoardRetain(CCBoardRef board);
extern void CCBoardRelease(CCBoardRef board);
extern unsigned int CCBoardRetainCount(CCBoardRef board);

// Initializiation.  Returns +1 retain count
extern CCBoardRef CCBoardCreate(void);
extern CCMutableBoardRef CCBoardCreateMutable(void);

// Copy methods
extern CCBoardRef CCBoardCreateCopy(CCBoardRef board);
extern CCMutableBoardRef CCBoardCreateMutableCopy(CCBoardRef board);

// Mutable Check
extern BOOL CCBoardIsMutable(CCBoardRef board);

// Comparing boards
extern BOOL CCBoardEqualToBoard(CCBoardRef board1, CCBoardRef board2);

// Editing the board
extern void CCBoardClearSquare(CCMutableBoardRef board, CCSquare square);
extern void CCBoardSetSquareWithPiece(CCMutableBoardRef board, CCSquare square, CCColoredPiece piece);
extern void CCBoardMoveFromSquareToSquare(CCMutableBoardRef board, CCSquare from, CCSquare to);


extern CCColoredPiece CCBoardGetPieceAtSquare(CCBoardRef board, CCSquare square);

extern const CCBitboard* CCBoardGetBitboardPtrForSquare(CCBoardRef board, CCSquare square);
extern const CCBitboard* CCBoardGetBitboardPtrForColoredPiece(CCBoardRef board, CCColoredPiece piece);

extern CCBitboard CCBoardGetBitboardForPiece(CCBoardRef board, CCPiece piece);
extern CCBitboard CCBoardGetBitboardForSquare(CCBoardRef board, CCSquare square);
extern CCBitboard CCBoardGetBitboardForColoredPiece(CCBoardRef board, CCColoredPiece piece);

/* Bitboard methods */
extern CCBitboard CCBoardGetOccupiedSquares(CCBoardRef board);
extern CCBitboard CCBoardGetOccupiedSquaresForColor(CCBoardRef board, CCColor color);
extern CCBitboard CCBoardGetEmptySquares(CCBoardRef board);

extern NSString * NSStringFromCCBoard(CCBoardRef board);
    
#ifdef __cplusplus
}
#endif

#endif