//  CBHWedgeTestMacros.h
//  CBHCollectionKitTests
//
//  Created by Christian Huxtable <chris@huxtable.ca>, June 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.
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


#define CBHAssertWedgeState(aWedge, aCapacity, aCount, aType, anEmpty)\
{\
	XCTAssertEqual([aWedge capacity], (aCapacity), @"Incorrect capacity.");\
	XCTAssertEqual([aWedge count], (aCount), @"Incorrect count.");\
	XCTAssertEqual([aWedge entrySize], sizeof(aType), @"Incorrect entry size.");\
	XCTAssertEqual([aWedge isEmpty], anEmpty, @"Incorrect empty state.");\
}

#define CBHWedgeCreateDefault(aName, aType)\
CBHWedge *aName = nil; \
{\
	const aType __list[] = {0, 1, 2, 3, 4, 5, 6, 7};\
	aName = [CBHWedge wedgeWithEntrySize:sizeof(aType) copying:8 entriesFromBytes:__list];\
	CBHAssertWedgeState(aName, 8, 8, aType, NO);\
}

#define CBHWedgeCreateConstant(aName, aType)\
CBHWedge *aName = nil; \
{\
	const aType __list[] = {8, 8, 8, 8, 8, 8, 8, 8};\
	aName = [CBHWedge wedgeWithEntrySize:sizeof(aType) copying:8 entriesFromBytes:__list];\
	CBHAssertWedgeState(aName, 8, 8, aType, NO);\
}


#define CBHAssertWedgeDefault(aWedge, aType, aWord)\
{\
	for (NSUInteger i = 0; i < 8; ++i)\
	{\
		XCTAssertEqual([wedge aWord ## AtIndex:i], (aType)i, @"Fails to return correct value at index %lu.", i);\
	}\
	XCTAssertThrows([wedge aWord ## AtIndex:8], @"Fails to catch out-of-bounds on access to %u.", 8);\
	XCTAssertThrows([wedge aWord ## AtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");\
}

#define CBHAssertWedgeConstant(aWedge, aType, aWord, aValue)\
{\
	for (NSUInteger i = 0; i < 8; ++i)\
	{\
		XCTAssertEqual([wedge aWord ## AtIndex:i], (aType)aValue, @"Fails to return correct value, %lu, at index %lu.", (NSUInteger)(aValue), i);\
	}\
}

#define CBHAssertWedgeValueIsIndex(aWedge, aType, aWord, aCount)\
{\
	for (NSUInteger i = 0; i < aCount; ++i)\
	{\
		XCTAssertEqual([wedge aWord ## AtIndex:i], (aType)i, @"Fails to return correct value, %lu, at index %lu.", i, i);\
	}\
	XCTAssertThrows([wedge aWord ## AtIndex:aCount], @"Fails to catch out-of-bounds on access to %u.", aCount);\
	XCTAssertThrows([wedge aWord ## AtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");\
}
