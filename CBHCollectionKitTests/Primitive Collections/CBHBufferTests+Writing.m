//  CBHBufferTest+Writing.m
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


@implementation CBHBufferTests (Write)

#pragma mark Generic

- (void)test_write_generic
{
	const NSUInteger list[] = {8, 8, 8, 8, 8, 8, 8, 8};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	NSUInteger testValue = 8;
	XCTAssertThrows([buffer setValue:&testValue atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setValue:&testValue atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger value = *(NSUInteger *)[buffer valueAtIndex:i];
		XCTAssertEqual(value, 8, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger value = i;
		XCTAssertNoThrow([buffer setValue:&value atIndex:i]);
	}

	/// Append a new value.
	NSUInteger newValue = 8;
	XCTAssertNoThrow([buffer appendValue:&newValue], @"Fails to set append value");
	XCTAssertGreaterThan([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	newValue = 9;
	XCTAssertNoThrow([buffer setValue:&newValue atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 10; ++i)
	{
		NSUInteger value = *(NSUInteger *)[buffer valueAtIndex:i];
		XCTAssertEqual(value, i, @"Fails to return correct value at index.");
	}
}


#pragma mark Bytes

- (void)test_write_byte
{
	CBHBufferCreateConstant(buffer, uint8_t);
	
	/// Catch out of bounds.
	XCTAssertThrows([buffer setByte:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, uint8_t, byte, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setByte:(uint8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendByte:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setByte:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, uint8_t, byte, 10);
}

- (void)test_write_signedByte
{
	CBHBufferCreateConstant(buffer, int8_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setSignedByte:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setSignedByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, int8_t, signedByte, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setSignedByte:(int8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendSignedByte:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setSignedByte:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, int8_t, signedByte, 10);
}

- (void)test_write_unsignedByte
{
	CBHBufferCreateConstant(buffer, uint8_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUnsignedByte:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUnsignedByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, uint8_t, unsignedByte, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setUnsignedByte:(uint8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUnsignedByte:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUnsignedByte:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, uint8_t, unsignedByte, 10);
}


#pragma mark - Named Integers

- (void)test_write_integer
{
	CBHBufferCreateConstant(buffer, NSInteger);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setInteger:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setInteger:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, NSInteger, integer, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setInteger:(NSInteger)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendInteger:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setInteger:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, NSInteger, integer, 10);
}

- (void)test_write_unsignedInteger
{
	CBHBufferCreateConstant(buffer, NSUInteger);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUnsignedInteger:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUnsignedInteger:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, NSUInteger, unsignedInteger, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setUnsignedInteger:(NSUInteger)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUnsignedInteger:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUnsignedInteger:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, NSUInteger, unsignedInteger, 10);
}


#pragma mark - Sized Integers

- (void)test_write_int8
{
	CBHBufferCreateConstant(buffer, int8_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setInt8:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setInt8:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, int8_t, int8, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setInt8:(int8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendInt8:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setInt8:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, int8_t, int8, 10);
}

- (void)test_write_uint8
{
	CBHBufferCreateConstant(buffer, uint8_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUInt8:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUInt8:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, uint8_t, uint8, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setUInt8:(uint8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUInt8:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUInt8:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, uint8_t, uint8, 10);
}


- (void)test_write_int16
{
	CBHBufferCreateConstant(buffer, int16_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setInt16:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setInt16:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, int16_t, int16, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setInt16:(int16_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendInt16:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setInt16:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, int16_t, int16, 10);
}

- (void)test_write_uint16
{
	CBHBufferCreateConstant(buffer, uint16_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUInt16:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUInt16:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, uint16_t, uint16, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setUInt16:(uint16_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUInt16:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUInt16:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, uint16_t, uint16, 10);
}


- (void)test_write_int32
{
	CBHBufferCreateConstant(buffer, int32_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setInt32:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setInt32:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, int32_t, int32, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setInt32:(int32_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendInt32:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setInt32:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, int32_t, int32, 10);
}

- (void)test_write_uint32
{
	CBHBufferCreateConstant(buffer, uint32_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUInt32:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUInt32:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, uint32_t, uint32, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setUInt32:(uint32_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUInt32:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUInt32:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, uint32_t, uint32, 10);
}


- (void)test_write_int64
{
	CBHBufferCreateConstant(buffer, uint64_t);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setInt64:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setInt64:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, int64_t, int64, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setInt64:(int64_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendInt64:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setInt64:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, int64_t, int64, 10);
}

- (void)test_write_uint64
{
	const uint64_t list[] = {8, 8, 8, 8, 8, 8, 8, 8};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(uint64_t) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUInt64:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUInt64:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, uint64_t, uint64, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setInt64:(int64_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUInt64:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUInt64:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, uint64_t, uint64, 10);
}


#pragma mark - Named Floats

- (void)test_write_cgfloat
{
	CBHBufferCreateConstant(buffer, CGFloat);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setCGFloat:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setCGFloat:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, CGFloat, cgfloat, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setCGFloat:(CGFloat)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendCGFloat:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setCGFloat:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, CGFloat, cgfloat, 10);
}

- (void)test_write_float
{
	CBHBufferCreateConstant(buffer, float);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setFloat:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setFloat:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, float, float, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setFloat:(float)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendFloat:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setFloat:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, float, float, 10);
}

- (void)test_write_double
{
	CBHBufferCreateConstant(buffer, double);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setDouble:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setDouble:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, double, double, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setDouble:(double)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendDouble:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setDouble:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, double, double, 10);
}

- (void)test_write_longDouble
{
	CBHBufferCreateConstant(buffer, long double);

	/// Catch out of bounds.
	XCTAssertThrows([buffer setLongDouble:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setLongDouble:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, long double, longDouble, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setLongDouble:(long double)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendLongDouble:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setLongDouble:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertBufferValueIsIndex(buffer, long double, longDouble, 10);
}


#pragma mark - Characters

- (void)test_write_char
{
	const char list[] = {'h', 'h', 'h', 'h', 'h', 'h', 'h', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(char) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	XCTAssertThrows([buffer setChar:'f' atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setChar:'f' atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, char, char, 'h');

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setChar:(char)('a' + i) atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendChar:'i'], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setChar:'j' atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Check new values.
	for (NSUInteger i = 0; i < 10; ++i)
	{
		XCTAssertEqual([buffer charAtIndex:i], (char)('a' + i), @"Fails to return correct value at index.");
	}
}

- (void)test_write_unsignedChar
{
	const unsigned char list[] = {'h', 'h', 'h', 'h', 'h', 'h', 'h', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	XCTAssertThrows([buffer setUnsignedChar:'f' atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([buffer setUnsignedChar:'f' atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([buffer setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertBufferConstant(buffer, unsigned char, unsignedChar, 'h');

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[buffer setUnsignedChar:(unsigned char)('a' + i) atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([buffer appendUnsignedChar:'i'], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([buffer capacity], 8, @"Didn't grow.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Shrink buffer to force growth when new value set at end.
	[buffer shrink];
	XCTAssertEqual([buffer capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([buffer count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([buffer setUnsignedChar:'j' atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([buffer capacity], 9, @"Didn't grow.");
	XCTAssertEqual([buffer count], 10, @"Incorrect count.");

	/// Check new values.
	for (NSUInteger i = 0; i < 10; ++i)
	{
		XCTAssertEqual([buffer unsignedCharAtIndex:i], (unsigned char)('a' + i), @"Fails to return correct value at index.");
	}
}

@end
