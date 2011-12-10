//
//  CCBoard.h
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCBOARD_H
#define CCBOARD_H

#include "CCBitboard.h"
#include "CCPiece.h"

struct CCBoard
{
    // State Bitboards	
    CCBitboard pawnsBB_[2];	
    CCBitboard knightsBB_[2];
    CCBitboard bishopsBB_[2];
    CCBitboard rooksBB_[2];
    CCBitboard queensBB_[2];
    CCBitboard kingsBB_[2];
    
    // Array for easy identification of a Square's occupancy
    CCColoredPiece pieceForSquare_[64];
};
typedef struct CCBoard* CCBoardRef;
 
CCBoardRef CCBoardCreate();
CCBoardRef CCBoardCreateWithBoard(CCBoardRef board);
void CCBoardFree(CCBoardRef board);
BOOL CCBoardEqualToBoard(CCBoardRef board1, CCBoardRef board2);

void CCBoardClearSquare(CCBoardRef board, CCSquare square);
void CCBoardSetSquareWithPiece(CCBoardRef board, CCSquare square, CCColoredPiece piece);
void CCBoardMoveFromSquareToSquare(CCBoardRef board, CCSquare from, CCSquare to);
CCColoredPiece CCBoardGetPieceAtSquare(CCBoardRef board, CCSquare square);

CCBitboard* CCBoardGetBitboardPtrForSquare(CCBoardRef board, CCSquare square);
CCBitboard* CCBoardGetBitboardPtrForColoredPiece(CCBoardRef board, CCColoredPiece piece);

CCBitboard CCBoardGetBitboardForPiece(CCBoardRef board, CCPiece piece);
CCBitboard CCBoardGetBitboardForSquare(CCBoardRef board, CCSquare square);
CCBitboard CCBoardGetBitboardForColoredPiece(CCBoardRef board, CCColoredPiece piece);

/* Bitboard methods */
CCBitboard CCBoardGetOccupiedSquares(CCBoardRef board);
CCBitboard CCBoardGetOccupiedSquaresForColor(CCBoardRef board, CCColor color);
CCBitboard CCBoardGetEmptySquares(CCBoardRef board);

NSString * NSStringFromCCBoard(CCBoardRef board);

#endif