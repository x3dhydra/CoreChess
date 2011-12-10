//
//  CCCastlingRights.h
//  CoreChess
//
//  Created by Austen Green on 6/12/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CCCASTLINGRIGHTS_H
#define CCCASTLINGRIGHTS_H

enum CCCastlingRights
{
    CCCastlingRightsNone = 0,
    CCCastlingRightsWhiteKingside  = 1 << 0,
    CCCastlingRightsWhiteQueenside = 1 << 1,
    CCCastlingRightsBlackKingside  = 1 << 2,
    CCCastlingRightsBlackQueenside = 1 << 3,
    
    CCCastlingRightsWhiteBoth = CCCastlingRightsWhiteKingside | CCCastlingRightsWhiteQueenside,
    CCCastlingRightsBlackBoth = CCCastlingRightsBlackKingside | CCCastlingRightsBlackQueenside,
    CCCastlingRightsAll       = CCCastlingRightsWhiteBoth     | CCCastlingRightsBlackBoth
};

typedef enum CCCastlingRights CCCastlingRights;

#endif