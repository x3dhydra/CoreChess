//
//  CCSquare.c
//  CoreChess
//
//  Created by Austen Green on 6/3/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#include "CCSquare.h"
#include <stdlib.h>
#include <string.h>
#import <Foundation/Foundation.h>

/* Creates a CCSquare from a given rank and file, where rank
 * and file are both between 0 and 7. */
CCSquare CCSquareMake(signed char rank, signed char file) {
    if ((rank < 0) || (rank > 7) ||
        (file < 0) || (file > 7)) {
        return InvalidSquare;       // Invalid if rank or file aren't within correct range
    }
    
    return (CCSquare)(rank * 8 + file);
}

CCSquare CCSquareForString(CFStringRef name)
{
    const char * string = [(__bridge NSString *)name cStringUsingEncoding:NSUTF8StringEncoding];
    return CCSquareMakeForString(string);    
}

/* Creates a CCSquare from a string representation of the CCSquare.  */
CCSquare CCSquareMakeForString(const char * name) {
    if (strlen(name) != 2)
        return InvalidSquare;
    
    signed char file = (signed char)(name[0] - 'a');
    signed char rank = (signed char)(name[1] - '1');
    
    return CCSquareMake(rank, file);
    
}

CFStringRef CCSquareNameForRankAndFile(int rank, int file) { return CCSquareName(CCSquareMake(rank, file)); }

CFStringRef CCSquareName(CCSquare s)
{
    CFStringRef name = NULL;
    char tmp[3];
    tmp[2] = '\0';
    
    if (s == InvalidSquare)
        name = CFSTR("Invalid CCSquare");
    else
    {
        int rank = CCSquareRank(s);
        int file = CCSquareFile(s);
        
        tmp[0] = file + 'a';
        tmp[1] = rank + '1';
        
        name = (__bridge CFStringRef)[NSString stringWithCString:tmp encoding:NSUTF8StringEncoding];
    }
    
    return name;
}

int CCSquareRank(CCSquare s) { return s / 8; }

int CCSquareFile(CCSquare s) { return s % 8; }

BOOL CCSquareIsValid(CCSquare square) { return square != InvalidSquare; }

#pragma mark -
#pragma mark CCSquare shifts

CCSquare CCSquareNorthOne(CCSquare s) { return CCSquareMake(CCSquareRank(s) + 1, CCSquareFile(s)); }
CCSquare CCSquareSouthOne(CCSquare s) { return CCSquareMake(CCSquareRank(s) - 1, CCSquareFile(s)); }
CCSquare CCSquareEastOne(CCSquare s) { return CCSquareMake(CCSquareRank(s), CCSquareFile(s) + 1); }
CCSquare CCSquareWestOne(CCSquare s) { return CCSquareMake(CCSquareRank(s), CCSquareFile(s) - 1); }
CCSquare CCSquareNorthEastOne(CCSquare s) { return CCSquareMake(CCSquareRank(s) + 1, CCSquareFile(s) + 1); }
CCSquare CCSquareNorthWestOne(CCSquare s) { return CCSquareMake(CCSquareRank(s) + 1, CCSquareFile(s) - 1); }
CCSquare CCSquareSouthEastOne(CCSquare s) { return CCSquareMake(CCSquareRank(s) - 1, CCSquareFile(s) + 1); }
CCSquare CCSquareSouthWestOne(CCSquare s) { return CCSquareMake(CCSquareRank(s) - 1, CCSquareFile(s) - 1); }

