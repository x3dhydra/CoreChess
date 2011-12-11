//
//  CCBitboard+MoveGeneration.m
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#include "CCBitboard+MoveGeneration.h"

// Sliding attacks for a given piece type on a square with an occupancy bitboard
CCBitboard CCBitboardGetSlidingAttacks(CCBitboard occupied, CCPiece pieceType, CCSquare square)
{
    switch (pieceType)
    {
        case RookPiece:
            return CCBitboardGetRankAttacks(occupied, square) | CCBitboardGetFileAttacks(occupied, square);
        case BishopPiece:
            return CCBitboardGetDiagonalAttacks(occupied, square) | CCBitboardGetAntiDiagonalAttacks(occupied, square);
        case QueenPiece:
            return CCBitboardGetSlidingAttacks(occupied, RookPiece, square) | 
                   CCBitboardGetSlidingAttacks(occupied, BishopPiece, square);
        default:
            return EmptyBB;
    }
}

/* Bitboards for intermediate calculations of pawn attacks */

/* Pawn attacks */
CCBitboard CCBitboardGetWhitePawnAttacks(CCBitboard whitePawns)
{
    return CCBitboardNorthEastOne(whitePawns) | CCBitboardNorthWestOne(whitePawns);
}

CCBitboard CCBitboardGetBlackPawnAttacks(CCBitboard blackPawns)
{
    return CCBitboardSouthWestOne(blackPawns) | CCBitboardSouthEastOne(blackPawns);
}

CCBitboard CCBitboardGetWhitePawnAttacksToSquare(CCBitboard whitePawns, CCSquare square)
{
    CCBitboard squareBB = CCBitboardForSquare(square);
    return (CCBitboardSouthEastOne(squareBB) | CCBitboardSouthWestOne(squareBB)) & whitePawns;
}

CCBitboard CCBitboardGetBlackPawnAttacksToSquare(CCBitboard blackPawns, CCSquare square)
{
    CCBitboard squareBB = CCBitboardForSquare(square);
    return (CCBitboardNorthEastOne(squareBB) | CCBitboardNorthWestOne(squareBB)) & blackPawns;
}

CCBitboard CCBitboardPawnAttacksFromSquareForColor(CCSquare square, CCColor color)
{
    CCBitboard squareBB = CCBitboardForSquare(square);
    if (color == White) 
        return CCBitboardGetWhitePawnAttacks(squareBB);
    else
        return CCBitboardGetBlackPawnAttacks(squareBB);
}


/* Pawn pushes intermediate values */
CCBitboard CCBitboardGetWhitePawnSinglePushTargets(CCBitboard whitePawns, CCBitboard empty)
{
    return CCBitboardNorthOne(whitePawns) & empty;
}

CCBitboard CCBitboardGetWhitePawnDoublePushTargets(CCBitboard whitePawns, CCBitboard empty)
{
    // Single push targets shifted 1 rank AND empty AND fourth rank
    CCBitboard single = CCBitboardGetWhitePawnSinglePushTargets(whitePawns, empty);
    return CCBitboardNorthOne(single) & empty & RanksBB[3];
}

CCBitboard CCBitboardGetBlackPawnSinglePushTargets(CCBitboard blackPawns, CCBitboard empty)
{
    return CCBitboardSouthOne(blackPawns) & empty;
}

CCBitboard CCBitboardGetBlackPawnDoublePushTargets(CCBitboard blackPawns, CCBitboard empty)
{
    // Single push targets shifted 1 rank AND empty AND fifth rank
    CCBitboard single = CCBitboardGetBlackPawnSinglePushTargets(blackPawns, empty);
    return CCBitboardSouthOne(single) & empty & RanksBB[4];
}

/* Pawn pushes */
CCBitboard CCBitboardGetWhitePawnPushTargets(CCBitboard whitePawns, CCBitboard empty)
{
    return CCBitboardGetWhitePawnSinglePushTargets(whitePawns, empty) |
    CCBitboardGetWhitePawnDoublePushTargets(whitePawns, empty);
}

CCBitboard CCBitboardGetBlackPawnPushTargets(CCBitboard blackPawns, CCBitboard empty)
{
    return CCBitboardGetBlackPawnSinglePushTargets(blackPawns, empty) |
    CCBitboardGetBlackPawnDoublePushTargets(blackPawns, empty);
}

#pragma mark - Pawns Able to Push

CCBitboard CCBitboardGetWhitePawnsAbleToPush(CCBitboard whitePawns, CCBitboard empty)
{
    return CCBitboardSouthOne(empty) & whitePawns;
}

CCBitboard CCBitboardGetWhitePawnsAbleToDoublePush(CCBitboard whitePawns, CCBitboard empty)
{
    CCBitboard emptyRank3 = CCBitboardSouthOne(empty & RanksBB[3]) & empty;
    return CCBitboardGetWhitePawnsAbleToPush(whitePawns, emptyRank3);
}

CCBitboard CCBitboardGetBlackPawnsAbleToPush(CCBitboard blackPawns, CCBitboard empty)
{
    return CCBitboardNorthOne(empty) & blackPawns;
}

CCBitboard CCBitboardGetBlackPawnsAbleToDoublePush(CCBitboard blackPawns, CCBitboard empty)
{
    CCBitboard emptyRank6 = CCBitboardNorthOne(empty & RanksBB[5]) & empty;
    return CCBitboardGetBlackPawnsAbleToPush(blackPawns, emptyRank6);
}
