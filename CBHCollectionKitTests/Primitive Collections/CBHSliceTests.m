//  CBHSliceTests.m
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


@interface CBHSliceTests : XCTestCase
@end


@implementation CBHSliceTests

#pragma mark - Initialization

- (void)testInitialization_noInitialValue
{
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:8];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i) XCTAssertEqual([slice integerAtIndex:i], 0, @"Fails to return correct value at index.");
	XCTAssertThrows([slice integerAtIndex:8], @"Fails to catch out-of-bounds error.");
}

- (void)testInitialization_noInitialValueClear
{
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:8 shouldClear:YES];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i) XCTAssertEqual([slice integerAtIndex:i], 0, @"Fails to return correct value at index.");
	XCTAssertThrows([slice integerAtIndex:8], @"Fails to catch out-of-bounds error.");
}

- (void)testInitialization_noInitialValueNoClear
{
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:8 shouldClear:YES];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	/// Contents is undefined, so don't check it.
}

- (void)testInitialization_noCapacity
{
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHAssertSliceState(slice, 0, NSUInteger, YES);
}

- (void)testInitialization_noCapacityWithValue
{
	NSUInteger value = 4;
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:0 initialValue:&value];
	CBHAssertSliceState(slice, 0, NSUInteger, YES);
}

- (void)testInitialization_withValue
{
	NSUInteger value = 4;
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:8 initialValue:&value];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 4, @"Fails to return correct value at index.");
	XCTAssertThrows([slice unsignedIntegerAtIndex:8], @"Fails to catch out-of-bounds error.");
}

- (void)testInitialization_copyFromBytes
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);
}

- (void)testInitialization_ownFromBytes
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	NSUInteger *list1 = calloc(8, sizeof(NSUInteger));
	memcpy(list1, list0, 8 * sizeof(NSUInteger));

	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) owning:8 entriesFromBytes:list1];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	/// Force a dealloc
	slice = nil;
}

- (void)testInitialization_fail
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	XCTAssertThrows([CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:NSUIntegerMax], @"Fails to catch overflow error.");
	XCTAssertThrows([CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:NSUIntegerMax entriesFromBytes:list], @"Fails to catch overflow error.");
}


#pragma mark - Copying

- (void)test_copy
{
	CBHSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	CBHSlice *copy = [slice copy];
	CBHAssertSliceState(copy, 8, NSUInteger, NO);
	CBHAssertSliceDefault(copy, NSUInteger, unsignedInteger);

	/// Ensure Equality
	XCTAssertEqualObjects(slice, copy, @"Fails to detect equality.");
}


#pragma mark - Equality

- (void)testEquality_same
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice0, 8, NSUInteger, NO);

	CBHSlice *slice1 = slice0;
	CBHAssertSliceState(slice1, 8, NSUInteger, NO);

	XCTAssertEqualObjects(slice0, slice1, @"Fails to detect equality.");
	XCTAssertTrue([slice0 isEqualToSlice:slice1], @"Fails to detect equality.");
}

- (void)testEquality_wrongObjectType
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};

	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	NSArray *array = [NSArray array];

	XCTAssertNotEqualObjects(slice, array, @"Fails to detect inequality.");
}

- (void)testEquality_entrySize
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHAssertSliceState(slice0, 8, NSUInteger, NO);

	const uint8_t list1[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice1 = [CBHSlice sliceWithEntrySize:sizeof(uint8_t) copying:8 entriesFromBytes:list1];
	CBHAssertSliceState(slice1, 8, uint8_t, NO);

	XCTAssertNotEqualObjects(slice0, slice1, @"Fails to detect inequality.");
	XCTAssertFalse([slice0 isEqualToSlice:slice1], @"Fails to detect inequality.");
}

- (void)testEquality_empty
{
	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHAssertSliceState(slice0, 0, NSUInteger, YES);

	CBHSlice *slice1 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHAssertSliceState(slice1, 0, NSUInteger, YES);

	XCTAssertEqualObjects(slice0, slice1, @"Fails to detect equality.");
	XCTAssertTrue([slice0 isEqualToSlice:slice1], @"Fails to detect equality.");
}

- (void)testEquality_one
{
	const NSUInteger list[] = {4};

	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list];
	CBHAssertSliceState(slice0, 1, NSUInteger, NO);

	CBHSlice *slice1 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list];
	CBHAssertSliceState(slice1, 1, NSUInteger, NO);

	XCTAssertEqualObjects(slice0, slice1, @"Fails to detect equality.");
	XCTAssertTrue([slice0 isEqualToSlice:slice1], @"Fails to detect equality.");
}

- (void)testEquality_two
{
	const NSUInteger list[] = {4, 5};

	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list];
	CBHAssertSliceState(slice0, 2, NSUInteger, NO);

	CBHSlice *slice1 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list];
	CBHAssertSliceState(slice1, 2, NSUInteger, NO);

	XCTAssertEqualObjects(slice0, slice1, @"Fails to detect equality.");
	XCTAssertTrue([slice0 isEqualToSlice:slice1], @"Fails to detect equality.");
}

- (void)testEquality_small
{
	const NSUInteger list[] = {4, 5, 6, 7};

	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertSliceState(slice0, 4, NSUInteger, NO);

	CBHSlice *slice1 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertSliceState(slice1, 4, NSUInteger, NO);

	XCTAssertEqualObjects(slice0, slice1, @"Fails to detect equality.");
	XCTAssertTrue([slice0 isEqualToSlice:slice1], @"Fails to detect equality.");
}

- (void)testEquality_full
{
	const NSUInteger list0[] = {0, 1, 2, 3, 4, 5, 6, 7};
	const NSUInteger list1[] = {0, 1, 2, 5, 4, 3, 6, 7};
	const NSUInteger list2[] = {0, 1, 2, 5, 3, 6, 7};

	CBHSlice *slice0 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHAssertSliceState(slice0, 8, NSUInteger, NO);

	CBHSlice *slice1 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0];
	CBHAssertSliceState(slice1, 8, NSUInteger, NO);

	CBHSlice *slice2 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list1];
	CBHAssertSliceState(slice2, 8, NSUInteger, NO);

	CBHSlice *slice3 = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:7 entriesFromBytes:list2];
	CBHAssertSliceState(slice3, 7, NSUInteger, NO);

	XCTAssertEqualObjects(slice0, slice1, @"Fails to detect equality.");
	XCTAssertTrue([slice0 isEqualToSlice:slice1], @"Fails to detect equality.");

	XCTAssertNotEqualObjects(slice0, slice2, @"Fails to detect inequality in entries.");
	XCTAssertFalse([slice0 isEqualToSlice:slice2], @"Fails to detect inequality in entries.");

	XCTAssertNotEqualObjects(slice0, slice3, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([slice0 isEqualToSlice:slice3], @"Fails to detect inequality in capacity.");
}

- (void)testEquality_hash
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

	const NSUInteger hash0 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0] hash];
	const NSUInteger hash1 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:7 entriesFromBytes:list1] hash];
	const NSUInteger hash2 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:6 entriesFromBytes:list2] hash];
	const NSUInteger hash3 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:5 entriesFromBytes:list3] hash];
	const NSUInteger hash4 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list4] hash];
	const NSUInteger hash5 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:3 entriesFromBytes:list5] hash];
	const NSUInteger hash6 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:2 entriesFromBytes:list6] hash];
	const NSUInteger hash7 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:1 entriesFromBytes:list7] hash];
	const NSUInteger hash8 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list8] hash];
	const NSUInteger hash9 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list9] hash];

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

	const NSUInteger hash10 = [[CBHSlice sliceWithEntrySize:sizeof(uint16_t) copying:8 entriesFromBytes:list10] hash];
	const NSUInteger hash11 = [[CBHSlice sliceWithEntrySize:sizeof(uint16_t) copying:8 entriesFromBytes:list11] hash];
	XCTAssertNotEqual(hash10, hash11, @"Hash too easily collides.");

	const NSUInteger hash12 = [[CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list0] hash];
	XCTAssertEqual(hash0, hash12, @"Hash of the same data should be equal.");

	const uint16_t list13[] = {0, 1, 2, 3, 4, 5, 6};
	const uint16_t list14[] = {1, 1, 2, 3, 4, 5, 6};

	const NSUInteger hash13 = [[CBHSlice sliceWithEntrySize:sizeof(uint16_t) copying:7 entriesFromBytes:list13] hash];
	const NSUInteger hash14 = [[CBHSlice sliceWithEntrySize:sizeof(uint16_t) copying:7 entriesFromBytes:list14] hash];
	XCTAssertNotEqual(hash13, hash14, @"Hash too easily collides.");
}

#pragma mark - Conversion

- (void)testConversion_data
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, unsigned char, NO);

	NSData *data = [slice data];
	XCTAssertEqualObjects([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @"abcdefgh", @"Fails to convert slice to string or data.");
}

- (void)testConversion_mutableData
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, unsigned char, NO);

	NSMutableData *data = [slice mutableData];
	XCTAssertEqualObjects([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @"abcdefgh", @"Fails to convert slice to string or data.");
}

- (void)testConversion_string
{
	const unsigned char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(unsigned char) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, unsigned char, NO);

	NSString *string = [slice stringWithEncoding:NSUTF8StringEncoding];
	XCTAssertEqualObjects(string, @"abcdefgh", @"Fails to convert slice to string or data.");
}


#pragma mark - Description

- (void)testDescription
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	NSString *description = [slice description];
	NSString *expected = @"(\n\t0x00000000,\n\t0x00000001,\n\t0x00000002,\n\t0x00000003,\n\t0x00000000,\n\t0x00000005,\n\t0x00000006,\n\t0x00000007\n)";

	XCTAssertTrue([description compare:expected], @"Description is wrong");
}

- (void)testDescription_debug
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHSlice *slice = [CBHSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	NSString *description = [slice debugDescription];
	NSString *expected = [NSString stringWithFormat:@"<%@: %p> %@", [slice class], (void *)slice, @"(\n\t0x00000000,\n\t0x00000001,\n\t0x00000002,\n\t0x00000003,\n\t0x00000000,\n\t0x00000005,\n\t0x00000006,\n\t0x00000007\n)"];

	XCTAssertTrue([description compare:expected], @"Description is wrong");
}

@end
