//  CBHSliceTestMacros.h
//  CBHCollectionKitTests
//
//  Created by Christian Huxtable <chris@huxtable.ca>, December 2019.
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

#pragma once


#define CBHAssertSliceState(aBuffer, aCapacity, aType, anEmpty)\
{\
	XCTAssertEqual([aBuffer capacity], (aCapacity), @"Incorrect capacity.");\
	XCTAssertEqual([aBuffer count], (aCapacity), @"Incorrect count.");\
	XCTAssertEqual([aBuffer entrySize], sizeof(aType), @"Incorrect entry size.");\
	XCTAssertEqual([aBuffer isEmpty], anEmpty, @"Incorrect empty state.");\
}

#define CBHSliceCreateDefault(aName, aType)\
CBHSlice *aName = nil; \
{\
	const aType __list[] = {0, 1, 2, 3, 4, 5, 6, 7};\
	aName = [CBHSlice sliceWithEntrySize:sizeof(aType) copying:8 entriesFromBytes:__list];\
	CBHAssertSliceState(aName, 8, aType, NO);\
}

#define CBHMutableSliceCreateDefault(aName, aType)\
CBHMutableSlice *aName = nil; \
{\
const aType __list[] = {0, 1, 2, 3, 4, 5, 6, 7};\
aName = [CBHMutableSlice sliceWithEntrySize:sizeof(aType) copying:8 entriesFromBytes:__list];\
CBHAssertSliceState(aName, 8, aType, NO);\
}

#define CBHAssertSliceDefault(aSlice, aType, aWord)\
{\
	for (NSUInteger i = 0; i < 8; ++i)\
	{\
		XCTAssertEqual([aSlice aWord ## AtIndex:i], (aType)i, @"Fails to return correct value at index %lu.", i);\
	}\
	XCTAssertThrows([aSlice aWord ## AtIndex:8], @"Fails to catch out-of-bounds on access to %u.", 8);\
	XCTAssertThrows([aSlice aWord ## AtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access to NSUIntegerMax.");\
}
