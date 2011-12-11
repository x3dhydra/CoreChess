//
//  CCBitboard+MoveGeneration.h
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCBITBOARD_MOVEGENERATION_H
#define CCBITBOARD_MOVEGENERATION_H

#include "CCBitboard.h"
#include "CCPiece.h"
#include "CCSquare.h"

// Sliding attacks for a given piece type on a square with an occupancy bitboard
extern CCBitboard CCBitboardGetSlidingAttacks(CCBitboard occupied, CCPiece pieceType, CCSquare square);
//Bitboard sliding_attacks(const Bitboard& occupied, Piece pt, Square s);

//inline Bitboard sliding_attacks(const Bitboard& occupied, ColoredPiece p, Square s) {return sliding_attacks(occupied, p.piece(), s);}

/* Bitboards for intermediate calculations of pawn attacks */

/* Pawn attacks */
extern CCBitboard CCBitboardGetWhitePawnAttacks(CCBitboard whitePawns);
extern CCBitboard CCBitboardGetBlackPawnAttacks(CCBitboard blackPawns);

//inline Bitboard w_pawn_attacks(const Bitboard& wpawns) {return noEaOne(wpawns) | noWeOne(wpawns);}
//inline Bitboard b_pawn_attacks(const Bitboard& bpawns) {return soEaOne(bpawns) | soWeOne(bpawns); }

extern CCBitboard CCBitboardGetWhitePawnAttacksToSquare(CCBitboard whitePawns, CCSquare square);
extern CCBitboard CCBitboardGetBlackPawnAttacksToSquare(CCBitboard blackPawns, CCSquare square);

//Bitboard w_pawn_attacks_to(const Bitboard& wpawns, Square s);
//Bitboard b_pawn_attacks_to(const Bitboard& bpawns, Square s);

extern CCBitboard CCBitboardPawnAttacksFromSquareForColor(CCSquare square, CCColor color);
//Bitboard pawn_attacks_from_square(Square s, Color c);

/* Pawn pushes intermediate values */
extern CCBitboard CCBitboardGetWhitePawnSinglePushTargets(CCBitboard whitePawns, CCBitboard empty);
extern CCBitboard CCBitboardGetWhitePawnDoublePushTargets(CCBitboard whitePawns, CCBitboard empty);
extern CCBitboard CCBitboardGetBlackPawnSinglePushTargets(CCBitboard blackPawns, CCBitboard empty);
extern CCBitboard CCBitboardGetBlackPawnDoublePushTargets(CCBitboard blackPawns, CCBitboard empty);

//Bitboard w_pawn_single_push_targets(const Bitboard& wpawns, const Bitboard& empty);
//Bitboard w_pawn_double_push_targets(const Bitboard& wpawns, const Bitboard& empty);
//Bitboard b_pawn_single_push_targets(const Bitboard& bpawns, const Bitboard& empty);
//Bitboard b_pawn_double_push_targets(const Bitboard& bpawns, const Bitboard& empty);

/* Pawn pushes */
extern CCBitboard CCBitboardGetWhitePawnPushTargets(CCBitboard whitePawns, CCBitboard empty);
extern CCBitboard CCBitboardGetBlackPawnPushTargets(CCBitboard blackPawns, CCBitboard empty);

//inline Bitboard w_pawn_push_targets(const Bitboard& wpawns, const Bitboard& empty) {
//    return w_pawn_single_push_targets(wpawns, empty) | w_pawn_double_push_targets(wpawns, empty); }

//inline Bitboard b_pawn_push_targets(const Bitboard& bpawns, const Bitboard& empty) {
//    return b_pawn_single_push_targets(bpawns, empty) | b_pawn_double_push_targets(bpawns, empty); }

/* Pawns able to push */
extern CCBitboard CCBitboardGetWhitePawnsAbleToPush(CCBitboard whitePawns, CCBitboard empty);
extern CCBitboard CCBitboardGetWhitePawnsAbleToDoublePush(CCBitboard whitePawns, CCBitboard empty);
extern CCBitboard CCBitboardGetBlackPawnsAbleToPush(CCBitboard blackPawns, CCBitboard empty);
extern CCBitboard CCBitboardGetBlackPawnsAbleToDoublePush(CCBitboard blackPawns, CCBitboard empty);

//Bitboard w_pawns_able_to_push(const Bitboard& wpawns, const Bitboard& empty);
//Bitboard w_pawns_able_to_double_push(const Bitboard& wpawns, const Bitboard& empty);
//Bitboard b_pawns_able_to_push(const Bitboard& bpawns, const Bitboard& empty);
//Bitboard b_pawns_able_to_double_push(const Bitboard& bpawns, const Bitboard& empty);


#endif