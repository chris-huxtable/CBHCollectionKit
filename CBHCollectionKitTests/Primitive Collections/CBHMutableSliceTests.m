//  CBHMutableSliceTests.m
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
@import CBHCollectionKit.CBHMutableSlice;

#import "CBHSliceTestMacros.h"


@interface CBHMutableSliceTests : XCTestCase
@end


@implementation CBHMutableSliceTests

#pragma mark - Copy

- (void)test_copy
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);

	CBHSlice *copy = [slice copy];
	CBHAssertSliceState(copy, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i)
	{
		NSUInteger *value = (NSUInteger *)[copy valueAtIndex:i];
		XCTAssertEqual(*value, (NSUInteger)i, @"Fails to return correct value at index.");
	}

	XCTAssertEqualObjects(slice, copy);

	[slice setUnsignedInteger:8 atIndex:4];
	XCTAssertNotEqualObjects(slice, copy);
}

- (void)test_mutableCopy
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	CBHMutableSlice *copy = [slice mutableCopy];
	CBHAssertSliceState(copy, 8, NSUInteger, NO);
	CBHAssertSliceDefault(copy, NSUInteger, unsignedInteger);

	XCTAssertEqualObjects(slice, copy);

	[copy setUnsignedInteger:8 atIndex:4];
	XCTAssertNotEqualObjects(slice, copy);
}

@end


@implementation CBHMutableSliceTests (Clearing)

- (void)test_clearAllValues
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	/// Remove all values
	[slice clearAllValues];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 4; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Entry is incorrectly set.");
}

- (void)test_clearAllValues_empty
{
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(NSUInteger) andCapacity:0];
	CBHAssertSliceState(slice, 0, NSUInteger, YES);

	/// Remove all values
	[slice clearAllValues];
	CBHAssertSliceState(slice, 0, NSUInteger, YES);
}

- (void)test_clearValuesInRange
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	/// Remove all values
	[slice clearValuesInRange:NSMakeRange(4, 4)];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 4; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	for (NSUInteger i = 4; i < 8; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Entry is incorrectly set.");
}

@end


@implementation CBHMutableSliceTests (Resizing)

- (void)test_resize_increase
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice resize:16];
	CBHAssertSliceState(slice, 16, NSUInteger, NO);

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 8; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	for (NSUInteger i = 8; i < 16; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Entry is incorrectly set at index %lu.", i);

	/// Set new values.
	for (NSUInteger i = 8; i < 16; ++i) XCTAssertNoThrow([slice setUnsignedInteger:i atIndex:i], @"Incorrectly flags out of bounds on `set`.");

	/// Contains the correct values.
	for (NSUInteger i = 0; i < 16; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
}


- (void)test_resize_shrink
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice resize:4];
	CBHAssertSliceState(slice, 4, NSUInteger, NO);

	for (NSUInteger i = 0; i < 3; ++i)
	{
		XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	}

	for (NSUInteger i = 4; i < 7; ++i)
	{
		XCTAssertThrows([slice unsignedIntegerAtIndex:i], @"Incorrectly flags out of bounds on `set`.");
	}
}

- (void)test_resize_same
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice resize:8];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);
}

- (void)test_resize_increaseShouldClear
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice resize:16 andClear:YES];
	CBHAssertSliceState(slice, 16, NSUInteger, NO);

	for (NSUInteger i = 0; i < 8; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
	for (NSUInteger i = 8; i < 16; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Entry is incorrectly set at index %lu.", i);

	for (NSUInteger i = 8; i < 16; ++i) XCTAssertNoThrow([slice setUnsignedInteger:i atIndex:i], @"Incorrectly flags out of bounds on `set`.");
	for (NSUInteger i = 0; i < 16; ++i) XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Entry is incorrectly set.");
}

- (void)test_resize_overflow
{
	const NSUInteger list[] = {0, 1, 2, 3};
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(NSUInteger) copying:4 entriesFromBytes:list];
	CBHAssertSliceState(slice, 4, NSUInteger, NO);

	XCTAssertThrows([slice resize:NSUIntegerMax], @"Did not catch overflow");
}

@end


@implementation CBHMutableSliceTests (DuplicateValues)

- (void)test_duplicateValues
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice duplicateValueAtIndex:0 toIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i == 4 )XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
		else XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
	}
}

- (void)test_copyValuesInRange
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice duplicateValuesInRange:NSMakeRange(0, 4) toIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 4; ++i)
	{
		XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
		XCTAssertEqual([slice unsignedIntegerAtIndex:i + 4], i, @"Fails to return correct value at index.");
	}
}

@end


@implementation CBHMutableSliceTests (SwapValues)

- (void)test_swapValues
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice swapValuesAtIndex:0 andIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i == 0 ) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 4, @"Fails to return correct value at index.");
		else if ( i == 4 ) XCTAssertEqual([slice unsignedIntegerAtIndex:i], 0, @"Fails to return correct value at index.");
		else XCTAssertEqual([slice unsignedIntegerAtIndex:i], i, @"Fails to return correct value at index.");
	}
}

- (void)test_swapValuesInRange
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	[slice swapValuesInRange:NSMakeRange(0, 4) andIndex:4];

	/// Check new values
	for (NSUInteger i = 0; i < 8; ++i)
	{
		if ( i < 4 ) XCTAssertEqual([slice unsignedIntegerAtIndex:i], i + 4, @"Fails to return correct value at index.");
		else XCTAssertEqual([slice unsignedIntegerAtIndex:i], i - 4, @"Fails to return correct value at index.");
	}
}

- (void)test_swapSameValues
{
	const NSUInteger list[] = {0, 1, 2, 3, 4, 5, 6, 7};
	CBHMutableSlice *slice = [CBHMutableSlice sliceWithEntrySize:sizeof(NSUInteger) copying:8 entriesFromBytes:list];
	CBHAssertSliceState(slice, 8, NSUInteger, NO);

	[slice swapValuesInRange:NSMakeRange(4, 4) andIndex:4];

	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);
}

- (void)test_swapOverlap
{
	CBHMutableSliceCreateDefault(slice, NSUInteger);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	XCTAssertFalse([slice swapValuesInRange:NSMakeRange(3, 4) andIndex:4]);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);

	XCTAssertFalse([slice swapValuesInRange:NSMakeRange(4, 4) andIndex:3]);
	CBHAssertSliceDefault(slice, NSUInteger, unsignedInteger);
}

@end
