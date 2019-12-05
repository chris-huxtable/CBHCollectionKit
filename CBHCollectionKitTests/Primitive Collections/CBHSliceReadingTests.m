//  CBHSliceReadingTests.m
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

@import XCTest;
@import CBHCollectionKit.CBHSlice;

#import "CBHSliceTestMacros.h"


@interface CBHSliceReadingTests : XCTestCase
@end


@implementation CBHSliceReadingTests

#pragma mark - Generic

- (void)testRead_generic
{
	CBHSliceCreateDefault(slice, NSUInteger);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[slice valueAtIndex:i];
		XCTAssertEqual(*value, (NSUInteger)i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([slice valueAtIndex:8], @"Fails to catch out of bounds on access.");
	XCTAssertThrows([slice valueAtIndex:NSUIntegerMax], @"Fails to catch out of bounds on access.");
}


#pragma mark - Bytes

- (void)testRead_byte
{
	CBHSliceCreateDefault(slice, uint8_t);
	CBHAssertSliceDefault(slice, uint8_t, byte);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_signedByte
{
	CBHSliceCreateDefault(slice, int8_t);
	CBHAssertSliceDefault(slice, int8_t, signedByte);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_unsignedByte
{
	CBHSliceCreateDefault(slice, uint8_t);
	CBHAssertSliceDefault(slice, uint8_t, unsignedByte);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Named Integers

- (void)testRead_integer
{

	CBHSliceCreateDefault(slice, NSInteger);
	CBHAssertSliceDefault(slice, NSInteger, integer);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_unsignedInteger
{
	CBHSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Sized Integers

- (void)testReadOutOfBounds_int8
{
	CBHSliceCreateDefault(slice, int8_t);
	CBHAssertSliceDefault(slice, int8_t, int8);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)testReadOutOfBounds_uint8
{
	CBHSliceCreateDefault(slice, uint8_t);
	CBHAssertSliceDefault(slice, uint8_t, uint8);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)testReadOutOfBounds_int16
{
	CBHSliceCreateDefault(slice, int16_t);
	CBHAssertSliceDefault(slice, int16_t, int16);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)testReadOutOfBounds_uint16
{
	CBHSliceCreateDefault(slice, uint16_t);
	CBHAssertSliceDefault(slice, uint16_t, uint16);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)testReadOutOfBounds_int32
{
	CBHSliceCreateDefault(slice, int32_t);
	CBHAssertSliceDefault(slice, int32_t, int32);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)testReadOutOfBounds_uint32
{
	CBHSliceCreateDefault(slice, uint32_t);
	CBHAssertSliceDefault(slice, uint32_t, uint32);

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)testReadOutOfBounds_int64
{
	CBHSliceCreateDefault(slice, int64_t);
	CBHAssertSliceDefault(slice, int64_t, int64);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)testReadOutOfBounds_uint64
{
	CBHSliceCreateDefault(slice, uint64_t);
	CBHAssertSliceDefault(slice, uint64_t, uint64);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Named Float

- (void)testRead_cgfloat
{
	CBHSliceCreateDefault(slice, CGFloat);
	CBHAssertSliceDefault(slice, CGFloat, cgfloat);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_float
{
	CBHSliceCreateDefault(slice, float);
	CBHAssertSliceDefault(slice, float, float);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_double
{
	CBHSliceCreateDefault(slice, double);
	CBHAssertSliceDefault(slice, double, double);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_longDouble
{
	CBHSliceCreateDefault(slice, long double);
	CBHAssertSliceDefault(slice, long double, longDouble);

	/// Read Bad Size
	XCTAssertThrows([slice int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Characters

- (void)testRead_char
{
	const char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(char) copying:8 entriesFromBytes:list];

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice charAtIndex:i], list[i], @"Fails to return correct value at index.");
	}
	XCTAssertThrows([slice charAtIndex:8], @"Fails to catch out of bounds on access.");
	XCTAssertThrows([slice charAtIndex:NSUIntegerMax], @"Fails to catch out of bounds on access.");

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)testRead_unsignedChar
{
	const char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];


	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedCharAtIndex:i], list[i], @"Fails to return correct value at index.");
	}
	XCTAssertThrows([slice unsignedCharAtIndex:8], @"Fails to catch out of bounds on access.");
	XCTAssertThrows([slice unsignedCharAtIndex:NSUIntegerMax], @"Fails to catch out of bounds on access.");

	/// Read Bad Size
	XCTAssertThrows([slice int64AtIndex:0], @"Fails to catch bad read.");
}

@end
