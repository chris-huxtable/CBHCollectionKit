//  CBHWedgeWriteTests.m
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
@import CBHCollectionKit.CBHWedge;

#import "CBHWedgeTestMacros.h"


@interface CBHWedgeWriteTests : XCTestCase
@end


@implementation CBHWedgeWriteTests

#pragma mark - Generic

- (void)testWrite_generic
{
	const NSUInteger list[] = {8, 8, 8, 8, 8, 8, 8, 8};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	NSUInteger testValue = 8;
	XCTAssertThrows([wedge setValue:&testValue atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setValue:&testValue atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger value = *(NSUInteger *)[wedge valueAtIndex:i];
		XCTAssertEqual(value, 8, @"Fails to return correct value at index.");
	}

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger value = i;
		XCTAssertNoThrow([wedge setValue:&value atIndex:i]);
	}

	/// Append a new value.
	NSUInteger newValue = 8;
	XCTAssertNoThrow([wedge appendValue:&newValue], @"Fails to set append value");
	XCTAssertGreaterThan([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	newValue = 9;
	XCTAssertNoThrow([wedge setValue:&newValue atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 10; ++i)
	{
		NSUInteger value = *(NSUInteger *)[wedge valueAtIndex:i];
		XCTAssertEqual(value, i, @"Fails to return correct value at index.");
	}
}


#pragma mark - Bytes

- (void)testWrite_byte
{
	CBHWedgeCreateConstant(wedge, uint8_t);
	
	/// Catch out of bounds.
	XCTAssertThrows([wedge setByte:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, uint8_t, byte, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setByte:(uint8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendByte:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setByte:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, uint8_t, byte, 10);
}

- (void)testWrite_signedByte
{
	CBHWedgeCreateConstant(wedge, int8_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setSignedByte:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setSignedByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, int8_t, signedByte, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setSignedByte:(int8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendSignedByte:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setSignedByte:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, int8_t, signedByte, 10);
}

- (void)testWrite_unsignedByte
{
	CBHWedgeCreateConstant(wedge, uint8_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUnsignedByte:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUnsignedByte:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, uint8_t, unsignedByte, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setUnsignedByte:(uint8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUnsignedByte:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUnsignedByte:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, uint8_t, unsignedByte, 10);
}


#pragma mark - Named Integers

- (void)testWrite_integer
{
	CBHWedgeCreateConstant(wedge, NSInteger);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setInteger:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setInteger:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, NSInteger, integer, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setInteger:(NSInteger)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendInteger:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setInteger:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, NSInteger, integer, 10);
}

- (void)testWrite_unsignedInteger
{
	CBHWedgeCreateConstant(wedge, NSUInteger);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUnsignedInteger:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUnsignedInteger:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, NSUInteger, unsignedInteger, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setUnsignedInteger:(NSUInteger)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUnsignedInteger:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUnsignedInteger:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, NSUInteger, unsignedInteger, 10);
}


#pragma mark - Sized Integers

- (void)testWrite_int8
{
	CBHWedgeCreateConstant(wedge, int8_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setInt8:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setInt8:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, int8_t, int8, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setInt8:(int8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendInt8:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setInt8:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, int8_t, int8, 10);
}

- (void)testWrite_uint8
{
	CBHWedgeCreateConstant(wedge, uint8_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUInt8:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUInt8:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, uint8_t, uint8, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setUInt8:(uint8_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUInt8:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUInt8:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, uint8_t, uint8, 10);
}


- (void)testWrite_int16
{
	CBHWedgeCreateConstant(wedge, int16_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setInt16:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setInt16:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, int16_t, int16, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setInt16:(int16_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendInt16:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setInt16:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, int16_t, int16, 10);
}

- (void)testWrite_uint16
{
	CBHWedgeCreateConstant(wedge, uint16_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUInt16:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUInt16:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, uint16_t, uint16, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setUInt16:(uint16_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUInt16:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUInt16:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, uint16_t, uint16, 10);
}


- (void)testWrite_int32
{
	CBHWedgeCreateConstant(wedge, int32_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setInt32:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setInt32:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, int32_t, int32, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setInt32:(int32_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendInt32:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setInt32:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, int32_t, int32, 10);
}

- (void)testWrite_uint32
{
	CBHWedgeCreateConstant(wedge, uint32_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUInt32:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUInt32:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, uint32_t, uint32, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setUInt32:(uint32_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUInt32:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUInt32:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, uint32_t, uint32, 10);
}


- (void)testWrite_int64
{
	CBHWedgeCreateConstant(wedge, uint64_t);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setInt64:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setInt64:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, int64_t, int64, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setInt64:(int64_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendInt64:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setInt64:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, int64_t, int64, 10);
}

- (void)testWrite_uint64
{
	const uint64_t list[] = {8, 8, 8, 8, 8, 8, 8, 8};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(uint64_t) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUInt64:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUInt64:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, uint64_t, uint64, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setInt64:(int64_t)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUInt64:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUInt64:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, uint64_t, uint64, 10);
}


#pragma mark - Named Floats

- (void)testWrite_cgfloat
{
	CBHWedgeCreateConstant(wedge, CGFloat);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setCGFloat:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setCGFloat:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, CGFloat, cgfloat, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setCGFloat:(CGFloat)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendCGFloat:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setCGFloat:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, CGFloat, cgfloat, 10);
}

- (void)testWrite_float
{
	CBHWedgeCreateConstant(wedge, float);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setFloat:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setFloat:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, float, float, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setFloat:(float)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendFloat:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setFloat:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, float, float, 10);
}

- (void)testWrite_double
{
	CBHWedgeCreateConstant(wedge, double);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setDouble:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setDouble:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, double, double, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setDouble:(double)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendDouble:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setDouble:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, double, double, 10);
}

- (void)testWrite_longDouble
{
	CBHWedgeCreateConstant(wedge, long double);

	/// Catch out of bounds.
	XCTAssertThrows([wedge setLongDouble:8 atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setLongDouble:8 atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt8:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, long double, longDouble, 8);

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setLongDouble:(long double)i atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendLongDouble:8], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setLongDouble:9 atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Contains the correct values.
	CBHAssertWedgeValueIsIndex(wedge, long double, longDouble, 10);
}


#pragma mark - Characters

- (void)testWrite_char
{
	const char list[] = {'h', 'h', 'h', 'h', 'h', 'h', 'h', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(char) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	XCTAssertThrows([wedge setChar:'f' atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setChar:'f' atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, char, char, 'h');

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setChar:(char)('a' + i) atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendChar:'i'], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setChar:'j' atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Check new values.
	for (NSUInteger i = 0; i < 10; ++i)
	{
		XCTAssertEqual([wedge charAtIndex:i], (char)('a' + i), @"Fails to return correct value at index.");
	}
}

- (void)testWrite_unsignedChar
{
	const unsigned char list[] = {'h', 'h', 'h', 'h', 'h', 'h', 'h', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	/// Catch out of bounds.
	XCTAssertThrows([wedge setUnsignedChar:'f' atIndex:9], @"Fails to catch out of bounds on `set`.");
	XCTAssertThrows([wedge setUnsignedChar:'f' atIndex:NSUIntegerMax], @"Fails to catch out of bounds on `set`.");

	/// Write Bad Size
	XCTAssertThrows([wedge setInt64:8 atIndex:0], @"Fails to catch bad write.");

	/// Contains the correct values.
	CBHAssertWedgeConstant(wedge, unsigned char, unsignedChar, 'h');

	/// Set new values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		[wedge setUnsignedChar:(unsigned char)('a' + i) atIndex:i];
	}

	/// Append a new value.
	XCTAssertNoThrow([wedge appendUnsignedChar:'i'], @"Fails to set append value");
	XCTAssertGreaterThanOrEqual([wedge capacity], 8, @"Didn't grow.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Shrink wedge to force growth when new value set at end.
	[wedge shrink];
	XCTAssertEqual([wedge capacity], 9, @"Didn't shrink.");
	XCTAssertEqual([wedge count], 9, @"Incorrect count.");

	/// Set new value at end.
	XCTAssertNoThrow([wedge setUnsignedChar:'j' atIndex:9], @"Fails to set new value at end");
	XCTAssertGreaterThanOrEqual([wedge capacity], 9, @"Didn't grow.");
	XCTAssertEqual([wedge count], 10, @"Incorrect count.");

	/// Check new values.
	for (NSUInteger i = 0; i < 10; ++i)
	{
		XCTAssertEqual([wedge unsignedCharAtIndex:i], (unsigned char)('a' + i), @"Fails to return correct value at index.");
	}
}

@end
