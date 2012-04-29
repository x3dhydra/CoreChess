//
//  CCPiece.h
//  CoreChess
//
//  Created by Austen Green on 6/4/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CCPIECE_H
#define CCPIECE_H

// Piece
enum CCPiece 
{
    NoPiece     = 0, 
    PawnPiece   = 1, 
    KnightPiece = 2, 
    BishopPiece = 3,
    RookPiece   = 4, 
    QueenPiece  = 5, 
    KingPiece   = 6
};
typedef enum CCPiece CCPiece;

BOOL CCPieceIsSlider(CCPiece piece);
BOOL CCPieceIsValid(CCPiece piece);
BOOL CCPieceEqualToPiece(CCPiece piece1, CCPiece piece2);
CCPiece CCPieceMake(char);
char CCPieceChar(CCPiece piece);

// Color
enum CCColorMask
{
    CCWhite = 0,
    CCBlack = 8
};
typedef enum CCColorMask CCColor;

unsigned char CCColorGetIndex(CCColor color);
CCColor CCColorGetOpposite(CCColor color);


// Colored Piece

enum CCColoredPiece
{
    NoColoredPiece = 0, 
    WP = 1, WN = 2,  WB = 3,  WR = 4,  WQ = 5,  WK = 6,
    BP = 9, BN = 10, BB = 11, BR = 12, BQ = 13, BK = 14
};
typedef enum CCColoredPiece CCColoredPiece;

CCColoredPiece CCColoredPieceMake(CCColor color, CCPiece piece);
CCColoredPiece CCColoredPieceForCharacter(char character);

CCColor CCColoredPieceGetColor(CCColoredPiece piece);
CCPiece CCColoredPieceGetPiece(CCColoredPiece piece);

BOOL CCColoredPieceIsValid(CCColoredPiece piece);
BOOL CCColoredPieceIsSlider(CCColoredPiece piece);

BOOL CCColoredPieceEqualsColoredPiece(CCColoredPiece piece1, CCColoredPiece piece2);
BOOL CCColoredPieceIsKindOfPiece(CCColoredPiece piece, CCPiece kind);
BOOL CCColoredPieceIsKindOfColor(CCColoredPiece piece, CCColor color);

char CCColoredPieceGetCharacter(CCColoredPiece piece);

#endif