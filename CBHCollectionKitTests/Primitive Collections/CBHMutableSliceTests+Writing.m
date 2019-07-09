//  CBHMutableSliceTests+Writing.m
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

#import "CBHMutableSliceTests.h"


@implementation CBHMutableSliceTests (Write)

#pragma mark Generic

- (void)test_write_generic
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:8];

	/// Catch out of bounds.
	NSUInteger testValue = 8;
	XCTAssertThrows([slice setValue:&testValue atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setValue:&testValue atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[slice valueAtIndex:i];
		XCTAssertEqual(*value, 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger value = i;
		[slice setValue:&value atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[slice valueAtIndex:i];
		XCTAssertEqual(*value, i, @"Fails to return correct value at index.");
	}
}


#pragma mark Bytes

- (void)test_write_byte
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(uint8_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setByte:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice byteAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setByte:(uint8_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice byteAtIndex:i], (uint8_t)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_signedByte
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(int8_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setSignedByte:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setSignedByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice signedByteAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setSignedByte:(int8_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice signedByteAtIndex:i], (int8_t)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_unsignedByte
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(uint8_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUnsignedByte:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUnsignedByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedByteAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUnsignedByte:(uint8_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedByteAtIndex:i], (uint8_t)i, @"Fails to return correct value at index.");
	}
}


#pragma mark - Named Integers

- (void)test_write_integer
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(NSInteger) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setInteger:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setInteger:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice integerAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setInteger:(NSInteger)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice integerAtIndex:i], (NSInteger)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_unsignedInteger
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUnsignedInteger:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUnsignedInteger:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUnsignedInteger:(NSUInteger)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}
}


#pragma mark - Sized Integers

- (void)test_write_int8
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(int8_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setInt8:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setInt8:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int8AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setInt8:(int8_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int8AtIndex:i], (int8_t)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_uint8
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(uint8_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUInt8:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUInt8:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint8AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUInt8:(uint8_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint8AtIndex:i], (uint8_t)i, @"Fails to return correct value at index.");
	}
}


- (void)test_write_int16
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(int16_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setInt16:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setInt16:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int16AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setInt16:(int16_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int16AtIndex:i], (int16_t)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_uint16
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(uint16_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUInt16:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUInt16:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint16AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUInt16:(uint16_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint16AtIndex:i], (uint16_t)i, @"Fails to return correct value at index.");
	}
}


- (void)test_write_int32
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(int32_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setInt32:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setInt32:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int32AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setInt32:(int32_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int32AtIndex:i], (int32_t)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_uint32
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(uint32_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUInt32:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUInt32:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint32AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUInt32:(uint32_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint32AtIndex:i], (uint32_t)i, @"Fails to return correct value at index.");
	}
}


- (void)test_write_int64
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(int64_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setInt64:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setInt64:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int64AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setInt64:(int64_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice int64AtIndex:i], (int64_t)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_uint64
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(uint64_t) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUInt64:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUInt64:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint64AtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUInt64:(uint64_t)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice uint64AtIndex:i], (uint64_t)i, @"Fails to return correct value at index.");
	}
}


#pragma mark - Named Floats

- (void)test_write_cgfloat
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(CGFloat) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setCGFloat:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setCGFloat:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice cgfloatAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setCGFloat:(CGFloat)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice cgfloatAtIndex:i], (CGFloat)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_float
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(float) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setFloat:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setFloat:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice floatAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setFloat:(float)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice floatAtIndex:i], (float)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_double
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(double) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setDouble:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setDouble:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice doubleAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setDouble:(double)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice doubleAtIndex:i], (double)i, @"Fails to return correct value at index.");
	}
}

- (void)test_write_longDouble
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(long double) andCapacity:8];

	/// Catch out of bounds.
	XCTAssertThrows([slice setLongDouble:8 atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setLongDouble:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice longDoubleAtIndex:i], 0, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setLongDouble:(long double)i atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice longDoubleAtIndex:i], (long double)i, @"Fails to return correct value at index.");
	}
}


#pragma mark - Characters

- (void)test_write_char
{
	char value = 'z';
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(char) andCapacity:8 initialValue:&value];

	/// Catch out of bounds.
	XCTAssertThrows([slice setChar:'f' atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setChar:'f' atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice charAtIndex:i], 'z', @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setChar:(char)('a' + i) atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice charAtIndex:i], (char)('a' + i), @"Fails to return correct value at index.");
	}
}

- (void)test_write_unsignedChar
{
	char value = 'z';
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(unsigned char) andCapacity:8 initialValue:&value];

	/// Catch out of bounds.
	XCTAssertThrows([slice setUnsignedChar:'f' atIndex:8], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([slice setUnsignedChar:'f' atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([slice setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedCharAtIndex:i], 'z', @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[slice setUnsignedChar:(unsigned char)('a' + i) atIndex:i];
	}

	/// Check new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([slice unsignedCharAtIndex:i], (unsigned char)('a' + i), @"Fails to return correct value at index.");
	}
}

@end
