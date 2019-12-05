//  CBHWedgeTests.m
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


@implementation CBHWedgeTests

- (void)test_initialization_basic
{
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger)];
	CBHAssertWedgeState(wedge, 8, 0, NSUInteger, NO);

	XCTAssertThrows([wedge integerAtIndex:0], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_noCapacity
{
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHAssertWedgeState(wedge, 0, 0, NSUInteger, YES);

	XCTAssertThrows([wedge integerAtIndex:0], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_fromSlice
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHWedge *wedge = [CBHWedge wedgeWithSlice:slice];

	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}
}

- (void)test_initialization_fromSliceAndCapacity
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHWedge *wedge = [CBHWedge wedgeWithSlice:slice andCapacity:16];

	CBHAssertWedgeState(wedge, 16, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}

	XCTAssertThrows([wedge integerAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_fromSliceAndCapacity_capacityTooSmall
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHWedge *wedge = [CBHWedge wedgeWithSlice:slice andCapacity:4];

	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], (NSUInteger)i, @"Fails to return correct value at index.");
	}

	XCTAssertThrows([wedge integerAtIndex:8], @"Fails to catch out-of-bounds on access.");
	XCTAssertThrows([wedge integerAtIndex:NSUIntegerMax], @"Fails to catch out-of-bounds on access.");
}

- (void)test_initialization_fail
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	XCTAssertThrows([CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:NSUIntegerMax], @"Fails to catch overflow error.");
	XCTAssertThrows([CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:NSUIntegerMax entriesFromBytes:list], @"Fails to catch overflow error.");
}

@end


@implementation CBHWedgeTests (Copying)

- (void)test_copy
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	CBHWedge *copy = [wedge copy];
	CBHAssertWedgeState(copy, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[copy valueAtIndex:i];
		XCTAssertEqual(*value, (NSUInteger)i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([wedge valueAtIndex:8], @"Fails to catch out-of-bounds on access.");

	XCTAssertEqualObjects(wedge, copy);

	[wedge setUnsignedInteger:8 atIndex:4];
	XCTAssertNotEqualObjects(wedge, copy);
}

@end


@implementation CBHWedgeTests (Equality)

- (void)test_equality_same
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHWedge *wedge1 = wedge0;

	XCTAssertEqualObjects(wedge0, wedge1, @"Fails to detect equality.");
	XCTAssertTrue([wedge0 isEqualToWedge:wedge1], @"Fails to detect equality.");
}

- (void)test_equality_wrongObjectType
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	NSArray *array = [NSArray array];

	XCTAssertNotEqualObjects(wedge, array, @"Fails to detect inequality.");
}

- (void)test_equality_entrySize
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	const uint8_t list1[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHWedge *wedge1 = [CBHWedge wedgeWithEntrySize:sizeof(uint8_t) copying:8 entriesFromBytes:list1];

	XCTAssertNotEqualObjects(wedge0, wedge1, @"Fails to detect inequality.");
	XCTAssertFalse([wedge0 isEqualToWedge:wedge1], @"Fails to detect inequality.");
}

- (void)test_equality_empty
{
	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHWedge *wedge1 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) andCapacity:0];

	XCTAssertEqualObjects(wedge0, wedge1, @"Fails to detect equality.");
	XCTAssertTrue([wedge0 isEqualToWedge:wedge1], @"Fails to detect equality.");
}

- (void)test_equality_one
{
	const NSUInteger list[] = {4};

	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list];
	CBHWedge *wedge1 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list];

	XCTAssertEqualObjects(wedge0, wedge1, @"Fails to detect equality.");
	XCTAssertTrue([wedge0 isEqualToWedge:wedge1], @"Fails to detect equality.");
}

- (void)test_equality_two
{
	const NSUInteger list[] = {4, 5};

	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list];
	CBHWedge *wedge1 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list];

	XCTAssertEqualObjects(wedge0, wedge1, @"Fails to detect equality.");
	XCTAssertTrue([wedge0 isEqualToWedge:wedge1], @"Fails to detect equality.");
}

- (void)test_equality_small
{
	const NSUInteger list[] = {4, 5, 6, 7};

	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHWedge *wedge1 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];

	XCTAssertEqualObjects(wedge0, wedge1, @"Fails to detect equality.");
	XCTAssertTrue([wedge0 isEqualToWedge:wedge1], @"Fails to detect equality.");
}

- (void)test_equality_full
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	const NSUInteger list1[] = {0, 1, 2, 5, 4, 3, 6, 7};
	const NSUInteger list2[] = {0, 1, 2, 5, 3, 6, 7};

	CBHWedge *wedge0 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHWedge *wedge1 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHWedge *wedge2 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list1];
	CBHWedge *wedge3 = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:7 entriesFromBytes:list2];

	XCTAssertEqualObjects(wedge0, wedge1, @"Fails to detect equality.");
	XCTAssertTrue([wedge0 isEqualToWedge:wedge1], @"Fails to detect equality.");

	XCTAssertNotEqualObjects(wedge0, wedge2, @"Fails to detect inequality in entries.");
	XCTAssertFalse([wedge0 isEqualToWedge:wedge2], @"Fails to detect inequality in entries.");

	XCTAssertNotEqualObjects(wedge0, wedge3, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([wedge0 isEqualToWedge:wedge3], @"Fails to detect inequality in capacity.");
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

	const NSUInteger hash0 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0] hash];
	const NSUInteger hash1 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:7 entriesFromBytes:list1] hash];
	const NSUInteger hash2 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:6 entriesFromBytes:list2] hash];
	const NSUInteger hash3 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:5 entriesFromBytes:list3] hash];
	const NSUInteger hash4 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list4] hash];
	const NSUInteger hash5 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:3 entriesFromBytes:list5] hash];
	const NSUInteger hash6 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list6] hash];
	const NSUInteger hash7 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list7] hash];
	const NSUInteger hash8 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list8] hash];
	const NSUInteger hash9 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list9] hash];

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

	const NSUInteger hash10 = [[CBHWedge wedgeWithEntrySize:sizeof(uint16_t) copying:8 entriesFromBytes:list10] hash];
	const NSUInteger hash11 = [[CBHWedge wedgeWithEntrySize:sizeof(uint16_t) copying:8 entriesFromBytes:list11] hash];
	XCTAssertNotEqual(hash10, hash11, @"Hash too easily collides.");

	const NSUInteger hash12 = [[CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0] hash];
	XCTAssertEqual(hash0, hash12, @"Hash of the same data should be equal.");
}

@end


@implementation CBHWedgeTests (Conversion)

- (void)test_data
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	NSData *data = [wedge data];
	XCTAssertEqualObjects([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @"abcdefgh", @"Fails to convert wedge to string or data.");
}

- (void)test_mutableData
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	NSMutableData *data = [wedge mutableData];
	XCTAssertEqualObjects([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @"abcdefgh", @"Fails to convert wedge to string or data.");
}

- (void)test_slice
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	XCTAssertEqualObjects([wedge slice], slice, @"Fails to convert wedge to string or data.");
}


- (void)test_string
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	NSString *string = [wedge stringWithEncoding:NSUTF8StringEncoding];
	XCTAssertEqualObjects(string, @"abcdefgh", @"Fails to convert wedge to string or data.");
}

- (void)test_bytes
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];

	XCTAssertTrue((memcmp(list, [wedge bytes], 8 * sizeof(NSUInteger)) == 0), @"Comparison failed");
}

- (void)test_wedge
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHWedge *wedge = [slice wedge];
	CBHWedge *expected = [CBHWedge wedgeWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];

	XCTAssertEqualObjects(wedge, expected, @"Fails to convert slice to string or data.");
}

@end


@implementation CBHWedgeTests (Resizing)

- (void)test_resize_increase
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 4, 4, NSUInteger, NO);

	[wedge resize:8];
	CBHAssertWedgeState(wedge, 8, 4, NSUInteger, NO);

	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");
}

- (void)test_resize_grow
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) andCapacity:6 copying:4 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 6, 4, NSUInteger, NO);

	XCTAssertFalse([wedge grow]);
	CBHAssertWedgeState(wedge, 6, 4, NSUInteger, NO);

	[wedge appendUnsignedInteger:4];
	CBHAssertWedgeState(wedge, 6, 5, NSUInteger, NO);

	XCTAssertFalse([wedge grow]);
	CBHAssertWedgeState(wedge, 6, 5, NSUInteger, NO);

	[wedge appendUnsignedInteger:5];
	CBHAssertWedgeState(wedge, 6, 6, NSUInteger, NO);

	XCTAssertTrue([wedge grow]);

	/// Check State
	XCTAssertGreaterThan([wedge capacity], 6, @"Incorrect capacity.");
	XCTAssertEqual([wedge count], 6, @"Incorrect count.");
	XCTAssertEqual([wedge entrySize], sizeof(NSUInteger), @"Incorrect entry size.");
	XCTAssertEqual([wedge isEmpty], NO, @"Incorrect empty state.");

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 6; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:6], @"Fails to catch out-of-bounds on access.");
}

- (void)test_resize_shrink
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) andCapacity:6 copying:4 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 6, 4, NSUInteger, NO);

	[wedge shrink];
	CBHAssertWedgeState(wedge, 4, 4, NSUInteger, NO);

	[wedge shrink];
	CBHAssertWedgeState(wedge, 4, 4, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");

	[wedge removeLast:4];
	CBHAssertWedgeState(wedge, 4, 0, NSUInteger, NO);
	
	[wedge shrink];
	CBHAssertWedgeState(wedge, 1, 0, NSUInteger, NO);

	XCTAssertThrows([wedge unsignedIntegerAtIndex:0], @"Fails to catch out-of-bounds on access.");

	[wedge shrink];
	CBHAssertWedgeState(wedge, 1, 0, NSUInteger, NO);
}

- (void)test_resize
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) andCapacity:16 copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 16, 8, NSUInteger, NO);

	/// Resize to 4?
	XCTAssertFalse([wedge resize:4]);
	CBHAssertWedgeState(wedge, 16, 8, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");

	/// Resize to Zero?
	XCTAssertFalse([wedge resize:0]);
	CBHAssertWedgeState(wedge, 16, 8, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");

	/// Resize to Count?
	XCTAssertTrue([wedge resize:8]);
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	/// Ensure no data was lost
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_resize_overflow
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 4, 4, NSUInteger, NO);

	XCTAssertThrows([wedge resize:NSUIntegerMax], @"Did not catch overflow");
}

- (void)test_resize_growToFit
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 4, 4, NSUInteger, NO);

	XCTAssertFalse([wedge growToFit:0], @"Did not catch size to small");
	XCTAssertFalse([wedge growToFit:4], @"Did not catch size equal");
	XCTAssertTrue([wedge growToFit:8], @"Did not grow");
}



@end


@implementation CBHWedgeTests (Clearing)

- (void)test_clearWedge
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 4, 4, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");

	/// Remove all values
	[wedge removeAll];
	CBHAssertWedgeState(wedge, 4, 0, NSUInteger, NO);

	/// Check entries
	XCTAssertThrows([wedge unsignedIntegerAtIndex:0], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:1], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:2], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:3], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:4], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:NSUIntegerMax], @"Did not cat out-of-bounds access.");
}

- (void)test_removeLast
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");

	/// Remove values
	[wedge removeLast:4];
	CBHAssertWedgeState(wedge, 8, 4, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:4], @"Fails to catch out-of-bounds on access.");

	XCTAssertThrows([wedge unsignedIntegerAtIndex:4], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:5], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:6], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:7], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Did not catch out-of-bounds access.");
	XCTAssertThrows([wedge unsignedIntegerAtIndex:NSUIntegerMax], @"Did not cat out-of-bounds access.");

	/// Remove values
	[wedge removeLast:4];
	CBHAssertWedgeState(wedge, 8, 0, NSUInteger, NO);
}

@end


@implementation CBHWedgeTests (CopyValues)

- (void)test_copyValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge duplicateValueAtIndex:0 toIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i == 4 )
		{
			XCTAssertEqual([wedge unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
		}
		else
		{
			XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		}
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_copyValuesInRange
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge duplicateValuesInRange:NSMakeRange(0, 4) toIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		XCTAssertEqual([wedge unsignedIntegerAtIndex:i + 4], i, @"Fails to return correct value at index.");
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_copySameValue
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge duplicateValueAtIndex:4 toIndex:4];

	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);
}

- (void)test_copySameValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge duplicateValuesInRange:NSMakeRange(4, 4) toIndex:4];

	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);
}

@end


@implementation CBHWedgeTests (SwapValues)

- (void)test_swapValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge swapValuesAtIndex:0 andIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i == 0 )
		{
			XCTAssertEqual([wedge unsignedIntegerAtIndex:i], 4, @"Fails to return correct value at index.");
		}
		else if ( i == 4 )
		{
			XCTAssertEqual([wedge unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
		}
		else
		{
			XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		}
	}
	XCTAssertThrows([wedge unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds on access.");
}

- (void)test_swapSameValue
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge swapValuesAtIndex:4 andIndex:4];

	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);
}

- (void)test_swapValuesInRange
{
	CBHWedgeCreateDefault(wedge, NSUInteger);
	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);

	[wedge swapValuesInRange:NSMakeRange(0, 4) andIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i < 4 ) XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i + 4, @"Fails to return correct value at index.");
		else XCTAssertEqual([wedge unsignedIntegerAtIndex:i], i - 4, @"Fails to return correct value at index.");
	}
}

- (void)test_swapSameValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	[wedge swapValuesInRange:NSMakeRange(4, 4) andIndex:4];

	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);
}

- (void)test_swapOverlap
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	XCTAssertFalse([wedge swapValuesInRange:NSMakeRange(3, 4) andIndex:4]);
	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);

	XCTAssertFalse([wedge swapValuesInRange:NSMakeRange(4, 4) andIndex:3]);
	CBHAssertWedgeDefault(wedge, NSUInteger, unsignedInteger);
}

@end

@implementation CBHWedgeTests (Description)

- (void)test_description
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	NSString *description = [wedge description];
	NSString *expected = @"(\n\t0x00000000,\n\t0x00000001,\n\t0x00000002,\n\t0x00000003,\n\t0x00000000,\n\t0x00000005,\n\t0x00000006,\n\t0x00000007\n)";

	XCTAssertTrue([description compare:expected], @"Description is wrong");
}

- (void)test_debugDescription
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHWedge *wedge = [CBHWedge wedgeWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertWedgeState(wedge, 8, 8, NSUInteger, NO);

	NSString *description = [wedge debugDescription];
	NSString *expected = [NSString stringWithFormat:@"<%@: %p> %@", [wedge class], (void *)wedge, @"(\n\t0x00000000,\n\t0x00000001,\n\t0x00000002,\n\t0x00000003,\n\t0x00000000,\n\t0x00000005,\n\t0x00000006,\n\t0x00000007\n)"];

	XCTAssertTrue([description compare:expected], @"Description is wrong");
}

@end
