//
//  CCBoard.m
//  CoreChess
//
//  Created by Austen Green on 6/5/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import "CCBoard.h"


struct _CCBoard
{
    unsigned short _retainCount;
    unsigned char  _mutable;
    
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

// More declarations
void CCBoardFree(CCBoardRef board);
CCBitboard * _CCBoardGetBitboardPtrForColoredPiece(CCMutableBoardRef board, CCColoredPiece coloredPiece);

#pragma mark - Reference Counting

CCBoardRef CCBoardRetain(CCBoardRef board)
{
    ((CCMutableBoardRef)board)->_retainCount += 1;
    return board;
}

void CCBoardRelease(CCBoardRef board)
{
    ((CCMutableBoardRef)board)->_retainCount -= 1;
    if (board->_retainCount == 0)
        CCBoardFree(board);
}

unsigned int CCBoardRetainCount(CCBoardRef board)
{
    return board->_retainCount;
}

void CCBoardClearSquare(CCMutableBoardRef board, CCSquare square)
{
    CCColoredPiece piece = CCBoardGetPieceAtSquare(board, square);
    if (!CCColoredPieceIsValid(piece)) return; // Break early if the square is unoccupied
    
    CCBitboard *bitboard = _CCBoardGetBitboardPtrForColoredPiece(board, piece);
    CCBitboard squareBitboard = CCBitboardForSquare(square);
    (*bitboard) &= ~squareBitboard;
    board->pieceForSquare_[(int)square] = NoColoredPiece;
}

void CCBoardSetSquareWithPiece(CCMutableBoardRef board, CCSquare square, CCColoredPiece piece)
{
    CCBoardClearSquare(board, square);
    if (!CCColoredPieceIsValid(piece)) return; // Break early if piece is invalid - equivalent to just a call to clear the square
    
    CCBitboard *bitboard = _CCBoardGetBitboardPtrForColoredPiece(board, piece);
    CCBitboard squareBitboard = CCBitboardForSquare(square);
    (*bitboard) |= squareBitboard;
    board->pieceForSquare_[(int)square] = piece;
}

void CCBoardMoveFromSquareToSquare(CCMutableBoardRef board, CCSquare from, CCSquare to)
{
    CCColoredPiece piece = CCBoardGetPieceAtSquare(board, from);
    if (!CCColoredPieceIsValid(piece)) return; // Has to be a piece at the from square
    
    CCBoardClearSquare(board, to);
    CCBoardSetSquareWithPiece(board, to, piece);
    CCBoardClearSquare(board, from);
}

// Returns the CCColoredPiece at square, but doesn't do any bounds checking
CCColoredPiece CCBoardGetPieceAtSquare(CCBoardRef board, CCSquare square)
{
    return board->pieceForSquare_[(int)square];
}

const CCBitboard* CCBoardGetBitboardPtrForSquare(CCBoardRef board, CCSquare square)
{
    CCColoredPiece piece = CCBoardGetPieceAtSquare(board, square);
    if (!CCPieceIsValid((CCPiece)piece)) return nil;
    
    return CCBoardGetBitboardPtrForColoredPiece(board, piece);
}

const CCBitboard* CCBoardGetBitboardPtrForColoredPiece(CCBoardRef board, CCColoredPiece coloredPiece)
{
    return _CCBoardGetBitboardPtrForColoredPiece((CCMutableBoardRef)board, coloredPiece);
}

CCBitboard * _CCBoardGetBitboardPtrForColoredPiece(CCMutableBoardRef board, CCColoredPiece coloredPiece)
{
    int index = CCColorGetIndex(CCColoredPieceGetColor(coloredPiece));
    CCPiece piece = CCColoredPieceGetPiece(coloredPiece);
    
    switch (piece)
    {
        case RookPiece:
            return &(board->rooksBB_[index]);
        case KnightPiece:
            return &(board->knightsBB_[index]);
        case BishopPiece:
            return &(board->bishopsBB_[index]);
        case QueenPiece:
            return &(board->queensBB_[index]);
        case KingPiece:
            return &(board->kingsBB_[index]);
        case PawnPiece:
            return  &(board->pawnsBB_[index]);
        default:
            return nil;
    }

}

CCBitboard CCBoardGetBitboardForPiece(CCBoardRef board, CCPiece piece)
{
    return CCBoardGetBitboardForColoredPiece(board, CCColoredPieceMake(CCWhite, piece)) |
           CCBoardGetBitboardForColoredPiece(board, CCColoredPieceMake(CCBlack, piece));
}

CCBitboard CCBoardGetBitboardForSquare(CCBoardRef board, CCSquare square)
{
    return *CCBoardGetBitboardPtrForSquare(board, square);
}

CCBitboard CCBoardGetBitboardForColoredPiece(CCBoardRef board, CCColoredPiece piece)
{
    return *CCBoardGetBitboardPtrForColoredPiece(board, piece);
}


#pragma mark -

CCBitboard CCBoardGetOccupiedSquares(CCBoardRef board)
{
    return CCBoardGetOccupiedSquaresForColor(board, CCWhite) | CCBoardGetOccupiedSquaresForColor(board, CCBlack);
}

CCBitboard CCBoardGetOccupiedSquaresForColor(CCBoardRef board, CCColor color)
{
    int i = CCColorGetIndex(color);
    return board->pawnsBB_[i] | board->kingsBB_[i] | board->rooksBB_[i] |
    board->queensBB_[i] | board->knightsBB_[i] | board->bishopsBB_[i];
}

CCBitboard CCBoardGetEmptySquares(CCBoardRef board)
{
    return ~CCBoardGetOccupiedSquares(board);
}

#pragma mark - Equality

BOOL CCBoardEqualToBoard(CCBoardRef board1, CCBoardRef board2)
{
    return (board1->pawnsBB_[0]   == board2->pawnsBB_[0]   &&
            board1->pawnsBB_[1]   == board2->pawnsBB_[1]   &&
            board1->kingsBB_[0]   == board2->kingsBB_[0]   &&
            board1->kingsBB_[1]   == board2->kingsBB_[1]   &&
            board1->rooksBB_[0]   == board2->rooksBB_[0]   &&
            board1->rooksBB_[1]   == board2->rooksBB_[1]   &&
            board1->queensBB_[0]  == board2->queensBB_[0]  &&
            board1->queensBB_[1]  == board2->queensBB_[1]  &&
            board1->knightsBB_[0] == board2->knightsBB_[0] &&
            board1->knightsBB_[1] == board2->knightsBB_[1] &&
            board1->bishopsBB_[0] == board2->bishopsBB_[0] &&
            board1->bishopsBB_[1] == board2->bishopsBB_[1]
            );

}

#pragma mark - Creation/Destruction

CCBoardRef CCBoardCreate()
{
    CCBoardRef board = (CCBoardRef)calloc(1, sizeof(struct _CCBoard));
    CCBoardRetain(board);
    return board;
}

CCMutableBoardRef CCBoardCreateMutable()
{
    CCMutableBoardRef board = (CCMutableBoardRef)CCBoardCreate();
    board->_mutable = YES;
    return board;
}

inline CCBoardRef CCBoardCreateCopy(CCBoardRef otherBoard)
{
    if (!CCBoardIsMutable(otherBoard))
        return CCBoardRetain(otherBoard);
    
    CCMutableBoardRef board = CCBoardCreateMutableCopy(otherBoard);
    board->_mutable = NO;
    
    return board;
}

CCMutableBoardRef CCBoardCreateMutableCopy(CCBoardRef otherBoard)
{
    CCMutableBoardRef board = CCBoardCreateMutable();
    
    board->pawnsBB_[0]   = otherBoard->pawnsBB_[0];
    board->pawnsBB_[1]   = otherBoard->pawnsBB_[1];   
    board->kingsBB_[0]   = otherBoard->kingsBB_[0];   
    board->kingsBB_[1]   = otherBoard->kingsBB_[1];   
    board->rooksBB_[0]   = otherBoard->rooksBB_[0];   
    board->rooksBB_[1]   = otherBoard->rooksBB_[1];   
    board->queensBB_[0]  = otherBoard->queensBB_[0];  
    board->queensBB_[1]  = otherBoard->queensBB_[1];  
    board->knightsBB_[0] = otherBoard->knightsBB_[0]; 
    board->knightsBB_[1] = otherBoard->knightsBB_[1]; 
    board->bishopsBB_[0] = otherBoard->bishopsBB_[0]; 
    board->bishopsBB_[1] = otherBoard->bishopsBB_[1];
    
    for (int i = 0; i < 64; i++)
    {
        CCColoredPiece piece = CCBoardGetPieceAtSquare(otherBoard, (CCSquare)i);
        board->pieceForSquare_[i] = piece;
    }
    
    return board;
}

void CCBoardFree(CCBoardRef board)
{
    free((void *)board);
}

#pragma mark - Mutability

inline BOOL CCBoardIsMutable(CCBoardRef board)
{
    return board->_mutable;
}

#pragma mark - NSString

NSString * NSStringFromCCBoard(CCBoardRef board)
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"\n"];
    
    /* Loop over each rank and file and print the piece, starting with the 
     * 8th rank */
    for (int r = 7; r >= 0 ; r--) {
        for (int f = 0; f < 8; f++) {
            CCColoredPiece piece = CCBoardGetPieceAtSquare(board, CCSquareMake(r, f));
            [string appendFormat:@"%c ", CCColoredPieceGetCharacter(piece)];
        } 
        [string appendFormat:@"\n"];
    }
    [string appendFormat:@"\n"];
    return string;
}
