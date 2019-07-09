//  CBHBufferTests+Reading.m
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

#import "CBHBufferTests.h"


@implementation CBHBufferTests (Read)

#pragma mark Generic

- (void)test_read_generic
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[buffer valueAtIndex:i];
		XCTAssertEqual(*value, (NSUInteger)i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([buffer valueAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer valueAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}


#pragma mark Bytes

- (void)test_read_byte
{
	CBHBufferCreateDefault(buffer, uint8_t);
	CBHAssertBufferDefault(buffer, uint8_t, byte);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_signedByte
{
	CBHBufferCreateDefault(buffer, int8_t);
	CBHAssertBufferDefault(buffer, int8_t, signedByte);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_unsignedByte
{
	CBHBufferCreateDefault(buffer, uint8_t);
	CBHAssertBufferDefault(buffer, uint8_t, unsignedByte);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Named Integers

- (void)test_read_integer
{
	CBHBufferCreateDefault(buffer, NSInteger);
	CBHAssertBufferDefault(buffer, NSInteger, integer);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_unsignedInteger
{
	CBHBufferCreateDefault(buffer, NSUInteger);
	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Sized Integers

- (void)test_readOutOfBounds_int8
{
	CBHBufferCreateDefault(buffer, int8_t);
	CBHAssertBufferDefault(buffer, int8_t, int8);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint8
{
	CBHBufferCreateDefault(buffer, uint8_t);
	CBHAssertBufferDefault(buffer, uint8_t, uint8);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)test_readOutOfBounds_int16
{
	CBHBufferCreateDefault(buffer, int16_t);
	CBHAssertBufferDefault(buffer, int16_t, int16);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint16
{
	CBHBufferCreateDefault(buffer, uint16_t);
	CBHAssertBufferDefault(buffer, uint16_t, uint16);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)test_readOutOfBounds_int32
{
	CBHBufferCreateDefault(buffer, int32_t);
	CBHAssertBufferDefault(buffer, int32_t, int32);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint32
{
	CBHBufferCreateDefault(buffer, uint32_t);
	CBHAssertBufferDefault(buffer, uint32_t, uint32);

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}


- (void)test_readOutOfBounds_int64
{
	CBHBufferCreateDefault(buffer, int64_t);
	CBHAssertBufferDefault(buffer, int64_t, int64);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_readOutOfBounds_uint64
{
	CBHBufferCreateDefault(buffer, uint64_t);
	CBHAssertBufferDefault(buffer, uint64_t, uint64);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Named Float

- (void)test_read_cgfloat
{
	CBHBufferCreateDefault(buffer, CGFloat);
	CBHAssertBufferDefault(buffer, CGFloat, cgfloat);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_float
{
	CBHBufferCreateDefault(buffer, float);
	CBHAssertBufferDefault(buffer, float, float);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_double
{
	CBHBufferCreateDefault(buffer, double);
	CBHAssertBufferDefault(buffer, double, double);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_longDouble
{
	CBHBufferCreateDefault(buffer, long double);
	CBHAssertBufferDefault(buffer, long double, longDouble);

	/// Read Bad Size
	XCTAssertThrows([buffer int8AtIndex:0], @"Fails to catch bad read.");
}


#pragma mark - Characters

- (void)test_read_char
{
	const char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(char) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, char, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer charAtIndex:i], list[i], @"Fails to return correct value at index.");
	}
	XCTAssertThrows([buffer charAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer charAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

- (void)test_read_unsignedChar
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, unsigned char, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedCharAtIndex:i], list[i], @"Fails to return correct value at index.");
	}
	XCTAssertThrows([buffer unsignedCharAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer unsignedCharAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");

	/// Read Bad Size
	XCTAssertThrows([buffer int64AtIndex:0], @"Fails to catch bad read.");
}

@end

