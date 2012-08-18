//
//  CoreChessTests.m
//  CoreChessTests
//
//  Created by Austen Green on 11/11/11.
//  Copyright (c) 2011 Austen Green Consulting. All rights reserved.
//

#import "CoreChessTests.h"
#import "CoreChess.h"

@implementation CoreChessTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAbsolutePinEast
{
	CCMutableBoardRef board = CCBoardCreateMutable();
	CCBoardSetSquareWithPiece(board, g8, BK);
	CCBoardSetSquareWithPiece(board, f8, BN);
	CCBoardSetSquareWithPiece(board, d8, WR);
	CCBoardSetSquareWithPiece(board, g7, BB);
	CCBoardSetSquareWithPiece(board, g6, BP);
	
	CCBitboard bitboard = CCBitboardGetAbsolutePinsOfColor(board, CCBlack);
	CCSquare square = CCSquareForBitboard(bitboard);
	STAssertTrue(square == f8, @"%@", NSStringFromCCBitboard(bitboard));
}

- (void)testAbsolutePinNorth
{
	CCMutableBoardRef board = CCBoardCreateMutable();
	CCBoardSetSquareWithPiece(board, c8, BK);
	CCBoardSetSquareWithPiece(board, d8, BR);
	CCBoardSetSquareWithPiece(board, e8, WR);
	
	CCBitboard bitboard = CCBitboardGetAbsolutePinsOfColor(board, CCBlack);
	CCSquare square = CCSquareForBitboard(bitboard);
	STAssertTrue(square == d8, @"%@", NSStringFromCCBitboard(bitboard));
}

- (void)testAbsolutePinDiagonal
{
	CCMutableBoardRef board = CCBoardCreateMutable();
	CCBoardSetSquareWithPiece(board, g1, WK);
	CCBoardSetSquareWithPiece(board, f2, WP);
	CCBoardSetSquareWithPiece(board, d4, BB);
	
	CCBitboard bitboard = CCBitboardGetAbsolutePinsOfColor(board, CCWhite);
	CCSquare square = CCSquareForBitboard(bitboard);
	STAssertTrue(square == f2, @"%@", NSStringFromCCBitboard(bitboard));
	
	// Add another piece in betwen to double check that absolute pins aren't being calculated when there are multiple pieces interposed
	CCBoardSetSquareWithPiece(board, e3, WP);
	bitboard = CCBitboardGetAbsolutePinsOfColor(board, CCWhite);
	STAssertTrue(CCBitboardPopulationCount(bitboard) == 0, @"%@", NSStringFromCCBitboard(bitboard));
}

@end
