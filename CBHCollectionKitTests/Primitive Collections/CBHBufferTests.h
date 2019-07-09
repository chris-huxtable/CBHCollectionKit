//  CBHBufferTests.h
//  CBHCollectionKitTests
//
//  Created by Christian Huxtable, June 2019.
//  Copyright (c) 2019, Christian Huxtable <chris@huxtable.ca>
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@import XCTest;

@import CBHCollectionKit.CBHBuffer;


@interface CBHBufferTests : XCTestCase
@end


#define CBHAssertBufferState(aBuffer, aCapacity, aCount, aType, anEmpty)\
{\
	XCTAssertEqual([aBuffer capacity], (aCapacity), @"Incorrect capacity.");\
	XCTAssertEqual([aBuffer count], (aCount), @"Incorrect count.");\
	XCTAssertEqual([aBuffer entrySize], sizeof(aType), @"Incorrect entry size.");\
	XCTAssertEqual([aBuffer isEmpty], anEmpty, @"Incorrect empty state.");\
}

#define CBHBufferCreateDefault(aName, aType)\
CBHBuffer *aName = nil; \
{\
	const aType __list[] = {0, 1, 2, 3, 4, 5, 6, 7};\
	aName = [CBHBuffer bufferWithEntrySize:sizeof(aType) copying:8 entriesFromBytes:__list];\
	CBHAssertBufferState(aName, 8, 8, aType, NO);\
}

#define CBHBufferCreateConstant(aName, aType)\
CBHBuffer *aName = nil; \
{\
	const aType __list[] = {8, 8, 8, 8, 8, 8, 8, 8};\
	aName = [CBHBuffer bufferWithEntrySize:sizeof(aType) copying:8 entriesFromBytes:__list];\
	CBHAssertBufferState(aName, 8, 8, aType, NO);\
}


#define CBHAssertBufferDefault(aBuffer, aType, aWord)\
{\
	for (NSUInteger i = 0; i < 8; ++i)\
	{\
		XCTAssertEqual([buffer aWord ## AtIndex:i], (aType)i, @"Fails to return correct value at index %lu.", i);\
	}\
	XCTAssertThrows([buffer aWord ## AtIndex:8], @"Fails to catch out-of-bounds on access to %u.", 8);\
	XCTAssertThrows([buffer aWord ## AtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");\
}

#define CBHAssertBufferConstant(aBuffer, aType, aWord, aValue)\
{\
	for (NSUInteger i = 0; i < 8; ++i)\
	{\
		XCTAssertEqual([buffer aWord ## AtIndex:i], (aType)aValue, @"Fails to return correct value, %lu, at index %lu.", (NSUInteger)(aValue), i);\
	}\
}

#define CBHAssertBufferValueIsIndex(aBuffer, aType, aWord, aCount)\
{\
	for (NSUInteger i = 0; i < aCount; ++i)\
	{\
		XCTAssertEqual([buffer aWord ## AtIndex:i], (aType)i, @"Fails to return correct value, %lu, at index %lu.", i, i);\
	}\
	XCTAssertThrows([buffer aWord ## AtIndex:aCount], @"Fails to catch out-of-bounds on access to %u.", aCount);\
	XCTAssertThrows([buffer aWord ## AtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");\
}
