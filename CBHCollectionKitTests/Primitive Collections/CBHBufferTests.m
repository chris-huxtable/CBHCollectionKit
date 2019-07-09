//  CBHBufferTests.m
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


@implementation CBHBufferTests

- (void)test_initialization_basic
{
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger)];
	CBHAssertBufferState(buffer, 8, 0, NSUInteger, NO);

	XCTAssertThrows([buffer integerAtIndex:0], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_noCapacity
{
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHAssertBufferState(buffer, 0, 0, NSUInteger, YES);

	XCTAssertThrows([buffer integerAtIndex:0], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_fromSlice
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHBuffer *buffer = [CBHBuffer bufferWithSlice:slice];

	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}
}

- (void)test_initialization_fromSliceAndCapacity
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHBuffer *buffer = [CBHBuffer bufferWithSlice:slice andCapacity:16];

	CBHAssertBufferState(buffer, 16, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}

	XCTAssertThrows([buffer integerAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_fromSliceAndCapacity_capacityTooSmall
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHBuffer *buffer = [CBHBuffer bufferWithSlice:slice andCapacity:4];

	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}

	XCTAssertThrows([buffer integerAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([buffer integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_fail
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	XCTAssertThrows([CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:NSUIntegerMax], @"Fails to catch overflow error.");
	XCTAssertThrows([CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:NSUIntegerMax entriesFromBytes:list], @"Fails to catch overflow error.");
}

@end


@implementation CBHBufferTests (Copying)

- (void)test_copy
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	CBHBuffer *copy = [buffer copy];
	CBHAssertBufferState(copy, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[copy valueAtIndex:i];
		XCTAssertEqual(*value, (NSUInteger)i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([buffer valueAtIndex:8], @"Fails to catch out-of-bounds on access.");

	XCTAssertEqualObjects(buffer, copy);

	[buffer setUnsignedInteger:8 atIndex:4];
	XCTAssertNotEqualObjects(buffer, copy);
}

@end


@implementation CBHBufferTests (Equality)

- (void)test_equality_same
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHBuffer *buffer1 = buffer0;

	XCTAssertEqualObjects(buffer0, buffer1, @"Fails to detect equality.");
	XCTAssertTrue([buffer0 isEqualToBuffer:buffer1], @"Fails to detect equality.");
}

- (void)test_equality_wrongObjectType
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	NSArray *array = [NSArray array];

	XCTAssertNotEqualObjects(buffer, array, @"Fails to detect inequality.");
}

- (void)test_equality_entrySize
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	const uint8_t list1[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHBuffer *buffer1 = [CBHBuffer bufferWithEntrySize:sizeof(uint8_t) copying:8 entriesFromBytes:list1];

	XCTAssertNotEqualObjects(buffer0, buffer1, @"Fails to detect inequality.");
	XCTAssertFalse([buffer0 isEqualToBuffer:buffer1], @"Fails to detect inequality.");
}

- (void)test_equality_empty
{
	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHBuffer *buffer1 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:0];

	XCTAssertEqualObjects(buffer0, buffer1, @"Fails to detect equality.");
	XCTAssertTrue([buffer0 isEqualToBuffer:buffer1], @"Fails to detect equality.");
}

- (void)test_equality_one
{
	const NSUInteger list[] = {4};

	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list];
	CBHBuffer *buffer1 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list];

	XCTAssertEqualObjects(buffer0, buffer1, @"Fails to detect equality.");
	XCTAssertTrue([buffer0 isEqualToBuffer:buffer1], @"Fails to detect equality.");
}

- (void)test_equality_two
{
	const NSUInteger list[] = {4, 5};

	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list];
	CBHBuffer *buffer1 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list];

	XCTAssertEqualObjects(buffer0, buffer1, @"Fails to detect equality.");
	XCTAssertTrue([buffer0 isEqualToBuffer:buffer1], @"Fails to detect equality.");
}

- (void)test_equality_small
{
	const NSUInteger list[] = {4, 5, 6, 7};

	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHBuffer *buffer1 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];

	XCTAssertEqualObjects(buffer0, buffer1, @"Fails to detect equality.");
	XCTAssertTrue([buffer0 isEqualToBuffer:buffer1], @"Fails to detect equality.");
}

- (void)test_equality_full
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	const NSUInteger list1[] = {0, 1, 2, 5, 4, 3, 6, 7};
	const NSUInteger list2[] = {0, 1, 2, 5, 3, 6, 7};

	CBHBuffer *buffer0 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHBuffer *buffer1 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHBuffer *buffer2 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list1];
	CBHBuffer *buffer3 = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:7 entriesFromBytes:list2];

	XCTAssertEqualObjects(buffer0, buffer1, @"Fails to detect equality.");
	XCTAssertTrue([buffer0 isEqualToBuffer:buffer1], @"Fails to detect equality.");

	XCTAssertNotEqualObjects(buffer0, buffer2, @"Fails to detect inequality in entries.");
	XCTAssertFalse([buffer0 isEqualToBuffer:buffer2], @"Fails to detect inequality in entries.");

	XCTAssertNotEqualObjects(buffer0, buffer3, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([buffer0 isEqualToBuffer:buffer3], @"Fails to detect inequality in capacity.");
}

- (void)test_equality_hash
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	const NSUInteger list1[] = {0, 1, 2, 3, 4, 5, 6};
	const NSUInteger list2[] = {0, 1, 2, 3, 4, 5};
	const NSUInteger list3[] = {0, 1, 2, 3, 4};
	const NSUInteger list4[] = {0, 1, 2, 3};
	const NSUInteger list5[] = {0, 1, 2};
	const NSUInteger list6[] = {0, 1};
	const NSUInteger list7[] = {0};
	const NSUInteger list8[] = {0, 1, 2, 3, 4, 5, 6, 8};
	const NSUInteger list9[] = {1, 1, 2, 3, 4, 5, 6, 7};

	const NSUInteger hash0 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0] hash];
	const NSUInteger hash1 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:7 entriesFromBytes:list1] hash];
	const NSUInteger hash2 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:6 entriesFromBytes:list2] hash];
	const NSUInteger hash3 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:5 entriesFromBytes:list3] hash];
	const NSUInteger hash4 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list4] hash];
	const NSUInteger hash5 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:3 entriesFromBytes:list5] hash];
	const NSUInteger hash6 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list6] hash];
	const NSUInteger hash7 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list7] hash];
	const NSUInteger hash8 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list8] hash];
	const NSUInteger hash9 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list9] hash];

	NSUInteger hashes[] = {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9};

	for (NSUInteger i = 0; i <= 9; ++i)
	{
		for (NSUInteger j = 0; j <= 9; ++j)
		{
			if ( i == j ) continue;
			XCTAssertNotEqual(hashes[i], hashes[j], @"Hash too easily collides.");
		}
	}

	const uint16_t list10[] = {0, 1, 2, 3, 4, 5, 6, 8};
	const uint16_t list11[] = {1, 1, 2, 3, 4, 5, 6, 7};

	const NSUInteger hash10 = [[CBHBuffer bufferWithEntrySize:sizeof(uint16_t) copying:8 entriesFromBytes:list10] hash];
	const NSUInteger hash11 = [[CBHBuffer bufferWithEntrySize:sizeof(uint16_t) copying:8 entriesFromBytes:list11] hash];
	XCTAssertNotEqual(hash10, hash11, @"Hash too easily collides.");

	const NSUInteger hash12 = [[CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0] hash];
	XCTAssertEqual(hash0, hash12, @"Hash of the same data should be equal.");
}

@end


@implementation CBHBufferTests (Conversion)

- (void)test_data
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	NSData *data = [buffer data];
	XCTAssertEqualObjects([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @"abcdefgh", @"Fails to convert buffer to string or data.");
}

- (void)test_mutableData
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	NSMutableData *data = [buffer mutableData];
	XCTAssertEqualObjects([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @"abcdefgh", @"Fails to convert buffer to string or data.");
}

- (void)test_slice
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	XCTAssertEqualObjects([buffer slice], slice, @"Fails to convert buffer to string or data.");
}


- (void)test_string
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	NSString *string = [buffer stringWithEncoding:NSUTF8StringEncoding];
	XCTAssertEqualObjects(string, @"abcdefgh", @"Fails to convert buffer to string or data.");
}

- (void)test_bytes
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];

	XCTAssertTrue((memcmp(list, [buffer bytes], 8 * sizeof(NSUInteger)) == 0), @"Comparison failed");
}

- (void)test_buffer
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHBuffer *buffer = [slice buffer];
	CBHBuffer *expected = [CBHBuffer bufferWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	XCTAssertEqualObjects(buffer, expected, @"Fails to convert slice to string or data.");
}

@end


@implementation CBHBufferTests (Resizing)

- (void)test_resize_increase
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 4, 4, NSUInteger, NO);

	[buffer resize:8];
	CBHAssertBufferState(buffer, 8, 4, NSUInteger, NO);

	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");
}

- (void)test_resize_grow
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:6 copying:4 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 6, 4, NSUInteger, NO);

	XCTAssertFalse([buffer grow]);
	CBHAssertBufferState(buffer, 6, 4, NSUInteger, NO);

	[buffer appendUnsignedInteger:4];
	CBHAssertBufferState(buffer, 6, 5, NSUInteger, NO);

	XCTAssertFalse([buffer grow]);
	CBHAssertBufferState(buffer, 6, 5, NSUInteger, NO);

	[buffer appendUnsignedInteger:5];
	CBHAssertBufferState(buffer, 6, 6, NSUInteger, NO);

	XCTAssertTrue([buffer grow]);

	/// Check State
	XCTAssertGreaterThan([buffer capacity], 6, @"Incorrect capacity.");
	XCTAssertEqual([buffer count], 6, @"Incorrect count.");
	XCTAssertEqual([buffer entrySize], sizeof(NSUInteger), @"Incorrect entry size.");
	XCTAssertEqual([buffer isEmpty], NO, @"Incorrect empty state.");

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 6; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:6], @"Fails to catch out-of-bounds on access.");
}

- (void)test_resize_shrink
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:6 copying:4 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 6, 4, NSUInteger, NO);

	[buffer shrink];
	CBHAssertBufferState(buffer, 4, 4, NSUInteger, NO);

	[buffer shrink];
	CBHAssertBufferState(buffer, 4, 4, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");

	[buffer removeLast:4];
	CBHAssertBufferState(buffer, 4, 0, NSUInteger, NO);
	
	[buffer shrink];
	CBHAssertBufferState(buffer, 1, 0, NSUInteger, NO);

	XCTAssertThrows([buffer unsignedIntegerAtIndex:0], @"Fails to catch out-of-bounds on access.");

	[buffer shrink];
	CBHAssertBufferState(buffer, 1, 0, NSUInteger, NO);
}

- (void)test_resize
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:16 copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 16, 8, NSUInteger, NO);

	/// Resize to 4?
	XCTAssertFalse([buffer resize:4]);
	CBHAssertBufferState(buffer, 16, 8, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");

	/// Resize to Zero?
	XCTAssertFalse([buffer resize:0]);
	CBHAssertBufferState(buffer, 16, 8, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");

	/// Resize to Count?
	XCTAssertTrue([buffer resize:8]);
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_resize_overflow
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 4, 4, NSUInteger, NO);

	XCTAssertThrows([buffer resize:NSUIntegerMax], @"Did not catch overflow");
}

- (void)test_resize_growToFit
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 4, 4, NSUInteger, NO);

	XCTAssertFalse([buffer growToFit:0], @"Did not catch size to small");
	XCTAssertFalse([buffer growToFit:4], @"Did not catch size equal");
	XCTAssertTrue([buffer growToFit:8], @"Did not grow");
}



@end


@implementation CBHBufferTests (Clearing)

- (void)test_clearBuffer
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 4, 4, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");

	/// Remove all values
	[buffer clearBuffer];
	CBHAssertBufferState(buffer, 4, 0, NSUInteger, NO);

	/// Check entries
	XCTAssertThrows([buffer unsignedIntegerAtIndex:0], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:1], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:2], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:3], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:4], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:NSUIntegerMax], @"Did not cat out-of-bounds access.");
}

- (void)test_removeLast
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");

	/// Remove values
	[buffer removeLast:4];
	CBHAssertBufferState(buffer, 8, 4, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");

	XCTAssertThrows([buffer unsignedIntegerAtIndex:4], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:5], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:6], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:7], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([buffer unsignedIntegerAtIndex:NSUIntegerMax], @"Did not cat out-of-bounds access.");

	/// Remove values
	[buffer removeLast:4];
	CBHAssertBufferState(buffer, 8, 0, NSUInteger, NO);
}

@end


@implementation CBHBufferTests (CopyValues)

- (void)test_copyValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer copyValueAtIndex:0 toIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i == 4 )
		{
			XCTAssertEqual([buffer unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
		}
		else
		{
			XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		}
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_copyValuesInRange
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer copyValuesInRange:NSMakeRange(0, 4) toIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		XCTAssertEqual([buffer unsignedIntegerAtIndex:i + 4], i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_copySameValue
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer copyValueAtIndex:4 toIndex:4];

	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);
}

- (void)test_copySameValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer copyValuesInRange:NSMakeRange(4, 4) toIndex:4];

	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);
}

@end


@implementation CBHBufferTests (SwapValues)

- (void)test_swapValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer swapValuesAtIndex:0 andIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i == 0 )
		{
			XCTAssertEqual([buffer unsignedIntegerAtIndex:i], 4, @"Fails to return correct value at index.");
		}
		else if ( i == 4 )
		{
			XCTAssertEqual([buffer unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
		}
		else
		{
			XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		}
	}
	XCTAssertThrows([buffer unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_swapSameValue
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer swapValuesAtIndex:4 andIndex:4];

	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);
}

- (void)test_swapValuesInRange
{
	CBHBufferCreateDefault(buffer, NSUInteger);
	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);

	[buffer swapValuesInRange:NSMakeRange(0, 4) andIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i < 4 ) XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i + 4, @"Fails to return correct value at index.");
		else XCTAssertEqual([buffer unsignedIntegerAtIndex:i], i - 4, @"Fails to return correct value at index.");
	}
}

- (void)test_swapSameValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	[buffer swapValuesInRange:NSMakeRange(4, 4) andIndex:4];

	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);
}

- (void)test_swapOverlap
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	XCTAssertFalse([buffer swapValuesInRange:NSMakeRange(3, 4) andIndex:4]);
	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);

	XCTAssertFalse([buffer swapValuesInRange:NSMakeRange(4, 4) andIndex:3]);
	CBHAssertBufferDefault(buffer, NSUInteger, unsignedInteger);
}

@end

@implementation CBHBufferTests (Description)

- (void)test_description
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	NSString *description = [buffer description];
	NSString *expected = @"(\n\t0x00000000,\n\t0x00000001,\n\t0x00000002,\n\t0x00000003,\n\t0x00000000,\n\t0x00000005,\n\t0x00000006,\n\t0x00000007\n)";

	XCTAssertTrue([description compare:expected], @"Description is wrong");
}

- (void)test_debugDescription
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertBufferState(buffer, 8, 8, NSUInteger, NO);

	NSString *description = [buffer debugDescription];
	NSString *expected = [NSString stringWithFormat:@"<%@: %p> %@", [buffer class], (void *)buffer, @"(\n\t0x00000000,\n\t0x00000001,\n\t0x00000002,\n\t0x00000003,\n\t0x00000000,\n\t0x00000005,\n\t0x00000006,\n\t0x00000007\n)"];

	XCTAssertTrue([description compare:expected], @"Description is wrong");
}

@end
