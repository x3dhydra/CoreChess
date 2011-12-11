//
//  CCPosition.c
//  CoreChess
//
//  Created by Austen Green on 12/10/11.
//  Copyright (c) 2011 Austen Green Consulting. All rights reserved.
//

#include "CCPosition.h"

struct _CCPosition {
    unsigned int            _retainCount;
    unsigned char           _mutable;          // Mutable flag - YES if the position is mutable
    
    CCMutableBoardRef       _board;
    CCSquare                _epSquare;
    CCCastlingRights        _castlingRights;
    CCColor                 _sideToMove;
    unsigned short          _halfmoveClock; 
};

#pragma mark - Private Declarations

void _CCPositionSetMutable(CCPositionRef position, BOOL mutable);
void _CCPositionFree(CCPositionRef position);

#pragma mark - Creation
CCPositionRef CCPositionCreate()
{
    struct _CCPosition *position = calloc(1, sizeof(struct _CCPosition));
    CCPositionRetain(position);
    return position;
}

CCMutablePositionRef CCPositionCreateMutable()
{
    CCMutablePositionRef position = (CCMutablePositionRef)CCPositionCreate();
    _CCPositionSetMutable(position, YES);
    return position;
}

CCPositionRef CCPositionCreateCopy(CCPositionRef position)
{
    if (!CCPositionIsMutable(position))
        return CCPositionRetain(position);
    
    CCPositionRef copy = CCPositionCreateMutableCopy(position);
    _CCPositionSetMutable(copy, NO);
    return copy;
}

CCMutablePositionRef CCPositionCreateMutableCopy(CCPositionRef position)
{
    CCMutablePositionRef copy = CCPositionCreateMutable();
    
    copy->_board = CCBoardCreateMutableCopy(CCPositionGetBoard(position));
    copy->_epSquare = position->_epSquare;
    copy->_castlingRights = position->_castlingRights;
    copy->_sideToMove = position->_sideToMove;
    copy->_halfmoveClock = position->_halfmoveClock;
    
    return copy;
}


#pragma mark - Reference Counting

inline unsigned int CCPositionGetRetainCount(CCPositionRef position)
{
    return position->_retainCount;
}

inline void * CCPositionRetain(CCPositionRef position)
{
    ((CCMutablePositionRef)position)->_retainCount++;
    return (void *)position;
}

void CCPositionRelease(CCPositionRef position)
{
    ((CCMutablePositionRef)position)->_retainCount--;
    if (CCPositionGetRetainCount(position) == 0)
        _CCPositionFree(position);
}

void _CCPositionFree(CCPositionRef position)
{
    CCBoardRelease(CCPositionGetBoard(position));
    free((void *)position);
}

#pragma mark - Comparison

BOOL CCPositionEqual(CCPositionRef p1, CCPositionRef p2)
{
    return (p1->_castlingRights == p2->_castlingRights &&
            p1->_epSquare == p2->_epSquare &&
            p1->_sideToMove == p2->_sideToMove &&
            p1->_halfmoveClock == p2->_halfmoveClock &&
            CCBoardEqualToBoard(CCPositionGetBoard(p1), CCPositionGetBoard(p2)));
}

#pragma mark - Accessors

CCBoardRef CCPositionGetBoard(CCPositionRef position)
{
    return position->_board;
}

CCMutableBoardRef CCMutablePositionGetBoard(CCMutablePositionRef position)
{
    return position->_board;
}

inline BOOL CCPositionIsMutable(CCPositionRef position)
{
    return position->_mutable;
}

#pragma mark - Validation

extern BOOL CCPositionIsLegal(CCPositionRef position);


#pragma mark - Private
void _CCPositionSetMutable(CCPositionRef position, BOOL mutable)
{
    CCMutablePositionRef p = (CCMutablePositionRef)position;
    p->_mutable = mutable;
}