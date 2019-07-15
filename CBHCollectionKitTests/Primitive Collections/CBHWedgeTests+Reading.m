//  CBHWedgeTests+Reading.m
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

#import "CBHWedgeTests.h"


@implementation CBHWedgeTests (Read)

#pragma mark Generic

- (void)test_read_generic
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[wedge valueAtIndex:i];
		XCTAssertEqual(*value, (NSUInteger)i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([wedge valueAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge valueAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}


#pragma mark Bytes

- (void)test_read_byte
{
	CBHWedgeCreateDefault(wedge, uint8_t);
	CBHAssertWedgeDefault(wedge, uint8_t, byte);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_signedByte
{
	CBHWedgeCreateDefault(wedge, int8_t);
	CBHAssertWedgeDefault(wedge, int8_t, signedByte);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_unsignedByte
{
	CBHWedgeCreateDefault(wedge, uint8_t);
	CBHAssertWedgeDefault(wedge, uint8_t, unsignedByte);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Named Integers

- (void)test_read_integer
{
	CBHWedgeCreateDefault(wedge, NSInteger);
	CBHAssertWedgeDefault(wedge, NSInteger, integer);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_unsignedInteger
{
	CBHWedgeCreateDefault(wedge, NSUInteger);
	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Sized Integers

- (void)test_readOutOfBounds_int8
{
	CBHWedgeCreateDefault(wedge, int8_t);
	CBHAssertWedgeDefault(wedge, int8_t, int8);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint8
{
	CBHWedgeCreateDefault(wedge, uint8_t);
	CBHAssertWedgeDefault(wedge, uint8_t, uint8);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)test_readOutOfBounds_int16
{
	CBHWedgeCreateDefault(wedge, int16_t);
	CBHAssertWedgeDefault(wedge, int16_t, int16);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint16
{
	CBHWedgeCreateDefault(wedge, uint16_t);
	CBHAssertWedgeDefault(wedge, uint16_t, uint16);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)test_readOutOfBounds_int32
{
	CBHWedgeCreateDefault(wedge, int32_t);
	CBHAssertWedgeDefault(wedge, int32_t, int32);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint32
{
	CBHWedgeCreateDefault(wedge, uint32_t);
	CBHAssertWedgeDefault(wedge, uint32_t, uint32);

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)test_readOutOfBounds_int64
{
	CBHWedgeCreateDefault(wedge, int64_t);
	CBHAssertWedgeDefault(wedge, int64_t, int64);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint64
{
	CBHWedgeCreateDefault(wedge, uint64_t);
	CBHAssertWedgeDefault(wedge, uint64_t, uint64);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Named Float

- (void)test_read_cgfloat
{
	CBHWedgeCreateDefault(wedge, CGFloat);
	CBHAssertWedgeDefault(wedge, CGFloat, cgfloat);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_float
{
	CBHWedgeCreateDefault(wedge, float);
	CBHAssertWedgeDefault(wedge, float, float);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_double
{
	CBHWedgeCreateDefault(wedge, double);
	CBHAssertWedgeDefault(wedge, double, double);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_longDouble
{
	CBHWedgeCreateDefault(wedge, long double);
	CBHAssertWedgeDefault(wedge, long double, longDouble);

	/// Read Bad Size
	XCTAssertThrows([wedge int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Characters

- (void)test_read_char
{
	const char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(char) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, char, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge charAtIndex:i], list[i], @"Fails to return correct value at index.");
	}
	XCTAssertThrows([wedge charAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge charAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_unsignedChar
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, unsigned char, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedCharAtIndex:i], list[i], @"Fails to return correct value at index.");
	}
	XCTAssertThrows([wedge unsignedCharAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge unsignedCharAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");

	/// Read Bad Size
	XCTAssertThrows([wedge int64AtIndex:0], @"Fails to catch bad read.");
}

@end

