//
//  CCPiece.m
//  CoreChess
//
//  Created by Austen Green on 6/4/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import "CCPiece.h"

BOOL CCPieceIsSlider(CCPiece piece)
{
    return ((piece == BishopPiece) || (piece == QueenPiece) || (piece == RookPiece));
}

BOOL CCPieceIsValid(CCPiece piece)
{
    return piece != NoPiece;
}

BOOL CCPieceEqualToPiece(CCPiece piece1, CCPiece piece2)
{
    return piece1 == piece2;
}

CCPiece CCPieceMake(char c)
{
    CCPiece piece;
    switch (c) {
        case 'K':
            piece = KingPiece;
            break;
        case 'Q':
            piece = QueenPiece;
            break;
        case 'P':
            piece = PawnPiece;
            break;
        case 'B':
            piece = BishopPiece;
            break;
        case 'N':
            piece = KnightPiece;
            break;
        case 'R':
            piece = RookPiece;
            break;
        default:
            piece = NoPiece;
            break;
    }
    return piece;
}

char CCPieceChar(CCPiece piece)
{
    switch (piece)
    {
        case KingPiece:   return 'K';
        case QueenPiece:  return 'Q';
        case PawnPiece:   return 'P';
        case BishopPiece: return 'B';
        case KnightPiece: return 'N';
        case RookPiece:   return 'R';
        default:          return '*';
    }
}

#pragma mark - CCColor

unsigned char CCColorGetIndex(CCColor color)
{
    return (color == CCWhite) ? 0 : 1;
}

CCColor CCColorGetOpposite(CCColor color)
{
    // Since color is implemented as a mask of 0 or 8, we get the opposite by
    // simply subtracting the color from 8.
    return (CCColor)(8-color);
}

#pragma mark - CCColoredPiece

CCColoredPiece CCColoredPieceMake(CCColor color, CCPiece piece)
{
    return (CCColoredPiece)((int)color | (int)piece);
}

CCColoredPiece CCColoredPieceForCharacter(char character)
{
    switch (character) {
        case 'K':  return WK;
        case 'Q':  return WQ;
        case 'R':  return WR;
        case 'B':  return WB;
        case 'N':  return WN;
        case 'P':  return WP;
        case 'k':  return BK;
        case 'q':  return BQ;
        case 'r':  return BR;
        case 'b':  return BB;
        case 'n':  return BN;
        case 'p':  return BP;
        default :  return NoColoredPiece; 
    }
}

CCColor CCColoredPieceGetColor(CCColoredPiece piece)
{
    return (CCColor)(piece & 8);
}

CCPiece CCColoredPieceGetPiece(CCColoredPiece piece)
{
    return (CCPiece)(piece & ~8);
}

BOOL CCColoredPieceIsValid(CCColoredPiece piece)
{
    return CCPieceIsValid(CCColoredPieceGetPiece(piece));
}

BOOL CCColoredPieceIsSlider(CCColoredPiece piece)
{
    return CCPieceIsSlider(CCColoredPieceGetPiece(piece));
}

BOOL CCColoredPieceEqualsColoredPiece(CCColoredPiece piece1, CCColoredPiece piece2)
{
    return piece1 == piece2;
}

BOOL CCColoredPieceIsKindOfPiece(CCColoredPiece piece, CCPiece kind)
{
    return CCColoredPieceGetPiece(piece) == kind;
}

BOOL CCColoredPieceIsKindOfColor(CCColoredPiece piece, CCColor color)
{
    return CCColoredPieceGetColor(piece) == color;
}

char CCColoredPieceGetCharacter(CCColoredPiece piece)
{
    switch (piece)
    {
        case WK: return 'K';
        case WQ: return 'Q';
        case WR: return 'R';
        case WB: return 'B';
        case WN: return 'N';
        case WP: return 'P';
        case BK: return 'k';
        case BQ: return 'q';
        case BR: return 'r';
        case BB: return 'b';
        case BN: return 'n';
        case BP: return 'p';
        default :  return '*';
    }
}

NSIndexSet * CCPieceGetAllPieces()
{
    static NSMutableIndexSet *set = nil;
    if (!set)
    {
        set = [[NSMutableIndexSet alloc] init];
        [set addIndexesInRange:NSMakeRange(WP, WK - WP + 1)];
        [set addIndexesInRange:NSMakeRange(BP, BK - BP + 1)];
    }
    return set;
}