//
//  CCBoard+MoveGeneration.h
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCBOARD_MOVEGENERATION_H
#define CCBOARD_MOVEGENERATION_H

#include "CCBoard.h"

CCBitboard CCBoardGetSlidingAttacksForSquare(CCBoardRef board, CCSquare square);
CCBitboard CCBoardGetPawnAttacksForColor(CCBoardRef board, CCColor color);
CCBitboard CCBoardGetPawnPushesForColor(CCBoardRef board, CCColor color);
CCBitboard CCBoardGetAttacksFromSquare(CCBoardRef board, CCSquare square);
CCBitboard CCBoardGetAttacksToSquare(CCBoardRef board, CCSquare square);

BOOL CCBoardIsSquareAttackedByColor(CCBoardRef board, CCSquare square, CCColor color);

CCSquare CCBoardSquareForKingOfColor(CCBoardRef board, CCColor color);
int CCBoardCountForColoredPiece(CCBoardRef board, CCColoredPiece piece);
int CCBoardCountForColor(CCBoardRef board, CCColor color);
int CCBoardCountForPiece(CCBoardRef board, CCPiece piece);

CCBitboard CCBoardGetPseudoLegalMovesFromSquare(CCBoardRef board, CCSquare square);
CCBitboard CCBoardGetPseudoLegalMovesToSquareForPiece(CCBoardRef board, CCSquare square, CCColoredPiece piece);

/* Returns a bitboard with each piece of Color c that is pinned to it's 
 * own king */
CCBitboard CCBitboardGetAbsolutePinsOfColor(CCBoardRef board, CCColor color);



#endif