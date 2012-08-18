//
//  CCBoard+MoveGeneration.m
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#include "CCBoard+MoveGeneration.h"
#include "CCBitboard+MoveGeneration.h"

CCBitboard CCBoardGetSlidingAttacksForSquare(CCBoardRef board, CCSquare square)
{
    CCBitboard occupied = CCBoardGetOccupiedSquares(board);
    CCPiece piece = CCColoredPieceGetPiece(CCBoardGetPieceAtSquare(board, square));
    return CCBitboardGetSlidingAttacks(occupied, piece, square);
}

CCBitboard CCBoardGetPawnAttacksForColor(CCBoardRef board, CCColor color)
{
    CCColoredPiece piece = (color == CCWhite) ? WP : BP;
    CCBitboard pawns = CCBoardGetBitboardForColoredPiece(board, piece);
    return (color == CCWhite) ? CCBitboardGetWhitePawnAttacks(pawns) : CCBitboardGetBlackPawnAttacks(pawns);
}

CCBitboard CCBoardGetPawnPushesForColor(CCBoardRef board, CCColor color)
{
    CCColoredPiece piece = (color == CCWhite) ? WP : BP;
    CCBitboard empty = CCBoardGetEmptySquares(board);
    CCBitboard pawns = CCBoardGetBitboardForColoredPiece(board, piece);
    return (color == CCWhite) ? CCBitboardGetWhitePawnPushTargets(pawns, empty) : CCBitboardGetBlackPawnPushTargets(pawns, empty);
}

CCBitboard CCBoardGetAttacksFromSquare(CCBoardRef board, CCSquare square)
{
    CCColoredPiece piece = CCBoardGetPieceAtSquare(board, square);
    CCPiece type = CCColoredPieceGetPiece(piece);
    CCBitboard b = EmptyBB;
    
    if (CCPieceIsSlider(type))
        b = CCBoardGetSlidingAttacksForSquare(board, square);
    else if (CCPieceEqualToPiece(type, KnightPiece) || CCPieceEqualToPiece(type, KingPiece))
        b = CCBitboardMovesForPieceAtSquare(type, square);
    else if (CCPieceEqualToPiece(type, PawnPiece))
        b = CCBoardGetPawnAttacksForColor(board, CCColoredPieceGetColor(piece));
        
    return b;
}

/* Returns the Bitboard of squares of pieces attacking square */
CCBitboard CCBoardGetAttacksToSquare(CCBoardRef board, CCSquare square)
{
    CCBitboard attacks = EmptyBB;
    CCBitboard pawnAttacks = CCBitboardGetWhitePawnAttacksToSquare(CCBoardGetBitboardForColoredPiece(board, WP), square) |
                             CCBitboardGetBlackPawnAttacksToSquare(CCBoardGetBitboardForColoredPiece(board, BP), square);
    CCBitboard queens = CCBoardGetBitboardForPiece(board, QueenPiece);
    CCBitboard occupied = CCBoardGetOccupiedSquares(board);
    
    attacks |= pawnAttacks;
    attacks |= CCBitboardGetSlidingAttacks(occupied, RookPiece, square) & (queens | CCBoardGetBitboardForPiece(board, RookPiece));
    attacks |= CCBitboardGetSlidingAttacks(occupied, BishopPiece, square) & (queens | CCBoardGetBitboardForPiece(board, BishopPiece));
    attacks |= CCBoardGetBitboardForPiece(board, KnightPiece) & CCBitboardMovesForPieceAtSquare(KnightPiece, square);
    attacks |= CCBoardGetBitboardForPiece(board, KingPiece) & CCBitboardMovesForPieceAtSquare(KingPiece, square);
    
    return attacks;
}


BOOL CCBoardIsSquareAttackedByColor(CCBoardRef board, CCSquare square, CCColor color)
{
    return (CCBoardGetAttacksToSquare(board, square) & CCBoardGetOccupiedSquaresForColor(board, color)) != 0;
}

CCSquare CCBoardSquareForKingOfColor(CCBoardRef board, CCColor color)
{
    return CCSquareForBitboard(CCBoardGetBitboardForColoredPiece(board, CCColoredPieceMake(color, KingPiece)));
}

int CCBoardCountForColoredPiece(CCBoardRef board, CCColoredPiece piece)
{
    return CCBitboardPopulationCount(CCBoardGetBitboardForColoredPiece(board, piece));
}

int CCBoardCountForColor(CCBoardRef board, CCColor color)
{
    return CCBitboardPopulationCount(CCBoardGetOccupiedSquaresForColor(board, color));
}

int CCBoardCountForPiece(CCBoardRef board, CCPiece piece)
{
    return CCBitboardPopulationCount(CCBoardGetBitboardForPiece(board, piece));
}

CCBitboard CCBoardGetPseudoLegalMovesFromSquare(CCBoardRef board, CCSquare square)
{
    CCColoredPiece piece = CCBoardGetPieceAtSquare(board, square);
    CCBitboard b = EmptyBB;
    
    if (!CCColoredPieceIsValid(piece) || CCColoredPieceEqualsColoredPiece(piece, NoColoredPiece))
        return b;
    
    CCColor color = CCColoredPieceGetColor(piece);
    CCPiece type = CCColoredPieceGetPiece(piece);
    
    if (CCPieceEqualToPiece(type, PawnPiece))
    {
        if (color == CCWhite)
        {
            CCBitboard pushes = CCBitboardGetWhitePawnPushTargets(CCBitboardForSquare(square), CCBoardGetEmptySquares(board));
            CCBitboard attacks = CCBitboardPawnAttacksFromSquareForColor(square, CCWhite) & CCBoardGetOccupiedSquaresForColor(board, CCBlack);
            b = pushes | attacks;
        }
        else
        {
            CCBitboard pushes = CCBitboardGetBlackPawnPushTargets(CCBitboardForSquare(square), CCBoardGetEmptySquares(board));
            CCBitboard attacks = CCBitboardPawnAttacksFromSquareForColor(square, CCBlack) & CCBoardGetOccupiedSquaresForColor(board, CCWhite);
            b = pushes | attacks;
        }
    }
    else
    {
        b = CCBoardGetAttacksFromSquare(board, square);
    }
    
    return b;
}

CCBitboard CCBoardGetPseudoLegalMovesToSquareForPiece(CCBoardRef board, CCSquare square, CCColoredPiece piece)
{
    CCBitboard bitboard = EmptyBB;
    
    // Return empty immediately if piece is invalid
    if (piece == NoColoredPiece || square == InvalidSquare)
        return bitboard;
    
    // Can't move to a square if it's occupied by one of your own pieces
    CCPiece occupant = CCBoardGetPieceAtSquare(board, square);
    if (occupant != NoColoredPiece && CCColoredPieceGetColor(occupant) == CCColoredPieceGetColor(piece))
        return bitboard;
    
    // Pawn moves are irreversible so we have to explicitly calculate them
    if (CCColoredPieceGetPiece(piece) == PawnPiece)
    {
        // There are three cases to consider:
        // 1. square is empty
        // 2. square is occupied by the same color as piece
        // 3. square is occupied by opposing color of piece
        
        // Unoccupied - only interested in pawn push targets
        if (occupant == NoColoredPiece)
        {
            if (CCColoredPieceGetColor(piece) == CCWhite)
            {
                // Check for a pawn that can advance a single square
                CCBitboard whitePawns = CCBoardGetBitboardForColoredPiece(board, WP);
                CCSquare south = CCSquareSouthOne(square);
                bitboard = CCBitboardForSquare(south) & whitePawns;
                
                // If 4th rank, see if a pawn can advance two squares
                if (bitboard == EmptyBB && CCSquareRank(square) == 3)
                    bitboard = CCBitboardForSquare(CCSquareSouthOne(south)) & whitePawns;
            }
            
            else
            {
                // Check for a pawn that can advance a single square
                CCBitboard blackPawns = CCBoardGetBitboardForColoredPiece(board, BP);
                CCSquare north = CCSquareNorthOne(square);
                bitboard = CCBitboardForSquare(north) & blackPawns;
                
                // If 5th rank, see if a pawn can advance two squares
                if (bitboard == EmptyBB && CCSquareRank(square) == 4)
                    bitboard = CCBitboardForSquare(CCSquareNorthOne(north)) & blackPawns;
            }
        }
        
        // Occupied by opposing piece - only interested in capture targets
        else if (CCColoredPieceGetColor(occupant) != CCColoredPieceGetColor(piece))
        {
            bitboard = CCBoardGetAttacksToSquare(board, square);
            bitboard &= CCBoardGetBitboardForColoredPiece(board, piece);
        }
        
        // else - Occupied by friendly - pawn cannot advance to square occupied by
        // a friendly piece, so return an empty bitboard   
    }
    
    // Everything else is reversible, so we can get the pseudo-legal moves from the square and
    // AND them with the bitboard containing the right piece
    else
    {
        CCBitboard occupied = CCBoardGetOccupiedSquares(board);
        
        if (CCColoredPieceGetPiece(piece) == KingPiece)
        {
            bitboard = CCBitboardMovesForPieceAtSquare(KingPiece, square);
        }
        
        else if (CCColoredPieceGetPiece(piece) == KnightPiece)
        {
            bitboard = CCBitboardMovesForPieceAtSquare(KnightPiece, square);
        }
        
        else
        {
            bitboard = CCBitboardGetSlidingAttacks(occupied, CCColoredPieceGetPiece(piece), square);
        }
        
        bitboard &= CCBoardGetBitboardForColoredPiece(board, piece);
        
    }
    
    return bitboard;
}

/* Returns a bitboard with each piece of Color c that is pinned to it's 
 * own king */
CCBitboard CCBitboardGetAbsolutePinsOfColor(CCBoardRef board, CCColor color)
{
    CCSquare square = CCBoardSquareForKingOfColor(board, color);
    CCBitboard pins = EmptyBB;
    CCColor opponent = CCColorGetOpposite(color);
    
    // Bitboards for opposing pieces that can pin
    
    CCBitboard queens = CCBoardGetBitboardForColoredPiece(board, CCColoredPieceMake(opponent, QueenPiece));
    CCBitboard rooksAndQueens = CCBoardGetBitboardForColoredPiece(board, CCColoredPieceMake(opponent, RookPiece)) | queens;
    CCBitboard bishopsAndQueens = CCBoardGetBitboardForColoredPiece(board, CCColoredPieceMake(opponent, BishopPiece)) | queens;
 
    CCBitboard straightAttacks = rooksAndQueens & CCBitboardMovesForPieceAtSquare(RookPiece, square);
    CCBitboard diagonalAttacks = bishopsAndQueens & CCBitboardMovesForPieceAtSquare(BishopPiece, square);
    
    if ((straightAttacks | diagonalAttacks) == 0) return EmptyBB;
    
    CCBitboard ray      = EmptyBB;
    CCBitboard sliders  = EmptyBB;
    CCBitboard blockers = EmptyBB;
    
    CCDirection diags[4] = {noEa, soEa, soWe, noWe};
    CCDirection lines[4] = {nort, sout, east, west};
    
    CCBitboard occ    = CCBoardGetOccupiedSquaresForColor(board, color);
    CCBitboard op_occ = CCBoardGetOccupiedSquaresForColor(board, CCColorGetOpposite(color));
    
    /* Check for pinned pieces on each diagonal */
    for (int i = 0; i < 4; i++)
    {
        ray = generate_ray(square, diags[i]);
        sliders = CCBitboardGetSlidingAttacks(op_occ, BishopPiece, square) & ray;
        if (sliders & diagonalAttacks)
        {
            blockers = sliders & occ;
            if (CCBitboardPopulationCount(blockers) == 1)
                pins |= blockers;
        }
    }
    
    for (int i = 0; i < 4; i++)
    {
        ray = generate_ray(square, lines[i]);
        sliders = CCBitboardGetSlidingAttacks(op_occ, RookPiece, square) & ray;
        if (sliders & straightAttacks)
        {
            blockers = sliders & occ;
            if (CCBitboardPopulationCount(blockers) == 1)
                pins |= blockers;
        }
    }
     
    return pins;
}
