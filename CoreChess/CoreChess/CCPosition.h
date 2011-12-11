//
//  CCPosition.h
//  CoreChess
//
//  Created by Austen Green on 12/10/11.
//  Copyright (c) 2011 Austen Green Consulting. All rights reserved.
//

#ifndef CoreChess_CCPosition_h
#define CoreChess_CCPosition_h

#import <CoreFoundation/CoreFoundation.h>
#import "CCBoard.h"
#import "CCCastlingRights.h"
#import "CCPiece.h"

struct _CCPosition;
typedef const struct _CCPosition * CCPositionRef;
typedef struct _CCPosition * CCMutablePositionRef;

// Creation
extern CCPositionRef CCPositionCreate(void);
extern CCMutablePositionRef CCPositionCreateMutable(void);

extern CCPositionRef CCPositionCreateCopy(CCPositionRef position);
extern CCMutablePositionRef CCPositionCreateMutableCopy(CCPositionRef position);

// TODO: Create with FEN
//extern CCPositionRef CCPositionCreateWithFEN(CFStringRef FENString);
//extern CCPositionRef CCPositionCreateWithCStringFEN(const char* FENString);
//extern CCMutablePositionRef CCPositionCreateMutableWithFEN(CFStringRef FENString);
//extern CCMutablePositionRef CCPositionCreateMutableWithCStringFEN(const char* FENString);

// Reference Counting
extern unsigned int CCPositionGetRetainCount(CCPositionRef position);
extern void * CCPositionRetain(CCPositionRef position);  // Returns position
extern void CCPositionRelease(CCPositionRef position);

// Comparison
extern BOOL CCPositionEqual(CCPositionRef p1, CCPositionRef p2);

// Accessors
extern CCBoardRef CCPositionGetBoard(CCPositionRef position);
extern CCMutableBoardRef CCMutablePositionGetBoard(CCMutablePositionRef position);

extern BOOL CCPositionIsMutable(CCPositionRef position);

// Validation
extern BOOL CCPositionIsLegal(CCPositionRef position);

#endif
