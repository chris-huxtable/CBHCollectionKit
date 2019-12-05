//  CBHHeapTests.m
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

@import XCTest;

@import CBHCollectionKit.CBHHeap;


#define CBHAssertHeapState(aHeap, aCapacity, aCount)\
{\
	XCTAssertNotNil(aHeap, @"Heap was nil.");\
	XCTAssertEqual([aHeap capacity], (aCapacity), @"Incorrect capacity.");\
	XCTAssertEqual([aHeap count], (aCount), @"Incorrect count.");\
	XCTAssertEqual([aHeap isEmpty], (aCount <= 0), @"Incorrect empty state.");\
}

#define CBHAssertHeapTeardownDefault(aHeap, aCount)\
{\
	XCTAssertNotNil(aHeap, @"Heap was nil.");\
	for (NSUInteger i = 0; i < aCount; ++i)\
	{\
		NSString *__expected = [NSString stringWithFormat:@"%lu", i];\
		XCTAssertEqualObjects([aHeap peekAtObject], __expected, @"Entry is incorrect at top.");\
		XCTAssertEqualObjects([aHeap extractObject], __expected, @"Entry is incorrect at index %lu.", i);\
		XCTAssertEqual([aHeap count], (NSUInteger)(aCount-i-1), @"Incorrect count.");\
		XCTAssertEqual([aHeap isEmpty], (i >= (NSUInteger)(aCount - 1)), @"Incorrect empty state.");\
	}\
	XCTAssertNil([aHeap peekAtObject], @"Returned non-nil value for top when empty.");\
	XCTAssertNil([aHeap extractObject], @"Returned non-nil value when empty.");\
}


@interface CBHHeapTests : XCTestCase
@end


@implementation CBHHeapTests

static NSComparator kComparator = ^NSComparisonResult(NSString *str1, NSString *str2) {
	return [str1 localizedStandardCompare:str2];
};

static NSArray<NSString *> *kArray = nil;

+ (void)initialize
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		kArray = @[@"7", @"0", @"6", @"1", @"5", @"2", @"4", @"3"];
	});
}

- (void)test_initialization
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator];
	CBHAssertHeapState(heap, 8, 0);
}

- (void)test_initialization_withCapacity
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];
	CBHAssertHeapState(heap, 8, 0);
}


- (void)test_initialization_withObjects
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andObjects:@"7", @"0", @"6", @"1", @"5", @"2", @"4", @"3", nil];
	CBHAssertHeapState(heap, 8, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_initialization_withObjects2
{
	CBHHeap<NSString *> *heap = [[CBHHeap alloc] initWithComparator:kComparator andObjects:@"7", @"0", @"6", @"1", @"5", @"2", @"4", @"3", nil];
	CBHAssertHeapState(heap, 8, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_initialization_withArray
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap, 8, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_initialization_withSet
{
	NSSet<NSString *> *set = [NSSet setWithArray:kArray];

	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andSet:set];
	CBHAssertHeapState(heap, 8, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_initialization_withEnumerator
{
	NSEnumerator *enumerator = [kArray objectEnumerator];

	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andEnumerator:enumerator];
	CBHAssertHeapState(heap, 8, 8);

	for (NSInteger i = 0; i < 8; ++i)
	{
		NSString *expected = [NSString stringWithFormat:@"%lu", i];
		XCTAssertEqualObjects([heap peekAtObject], expected, @"Entry is incorrect on peek.");
		XCTAssertEqualObjects([heap extractObject], expected, @"Entry is incorrect at index %lu.", i);
		CBHAssertHeapState(heap, 8, (NSUInteger)(7-i));
	}
	XCTAssertNil([heap peekAtObject], @"Returned non-nil value when empty.");
	XCTAssertNil([heap extractObject], @"Returned non-nil value when empty.");
}


#pragma mark - Copying

- (void)test_copy
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap, 8, 8);

	CBHHeap<NSString *> *copy = [heap copy];
	CBHAssertHeapState(copy, 8, 8);

	/// Ensure Equality
	XCTAssertEqualObjects(heap, copy, @"Fails to detect equality.");

	/// Ensure Correctness
	CBHAssertHeapTeardownDefault(heap, 8);
	CBHAssertHeapTeardownDefault(copy, 8);
}


#pragma mark - Equality

- (void)test_equality
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap0, 8, 8);

	CBHHeap<NSString *> *heap1 = heap0;
	CBHAssertHeapState(heap1, 8, 8);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 8);
}

- (void)test_equality_wrongObjectType
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];

	XCTAssertNotEqualObjects(heap, kArray, @"Fails to detect inequality.");
}

- (void)test_equality_empty
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andCapacity:0];
	CBHAssertHeapState(heap0, 1, 0);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andCapacity:0];
	CBHAssertHeapState(heap1, 1, 0);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 0);
	CBHAssertHeapTeardownDefault(heap1, 0);
}

- (void)test_equality_one
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0"]];
	CBHAssertHeapState(heap0, 1, 1);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0"]];
	CBHAssertHeapState(heap1, 1, 1);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 1);
	CBHAssertHeapTeardownDefault(heap1, 1);
}

- (void)test_equality_two
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1"]];
	CBHAssertHeapState(heap0, 2, 2);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1"]];
	CBHAssertHeapState(heap1, 2, 2);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 2);
	CBHAssertHeapTeardownDefault(heap1, 2);
}

- (void)test_equality_small
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"3"]];
	CBHAssertHeapState(heap0, 4, 4);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"3"]];
	CBHAssertHeapState(heap1, 4, 4);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 4);
	CBHAssertHeapTeardownDefault(heap1, 4);
}

- (void)test_equality_same
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap0, 8, 8);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"4", @"5", @"3", @"6", @"7"]];
	CBHAssertHeapState(heap1, 8, 8);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 8);
	CBHAssertHeapTeardownDefault(heap1, 8);
}

- (void)test_equality_almostStart
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap0, 8, 8);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:@[@"1", @"1", @"2", @"4", @"5", @"3", @"6", @"7"]];
	CBHAssertHeapState(heap1, 8, 8);

	XCTAssertNotEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertFalse([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 8);
}

- (void)test_equality_almostEnd
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap0, 8, 8);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"4", @"5", @"3", @"6", @"8"]];
	CBHAssertHeapState(heap1, 8, 8);

	XCTAssertNotEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertFalse([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	CBHAssertHeapTeardownDefault(heap0, 8);
}

- (void)test_equality_full
{
	CBHHeap<NSString *> *heap0 = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap0, 8, 8);

	CBHHeap<NSString *> *heap1 = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap1, 8, 8);

	CBHHeap<NSString *> *heap2 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"4", @"5", @"3", @"6", @"7"]];
	CBHAssertHeapState(heap2, 8, 8);

	CBHHeap<NSString *> *heap3 = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"4", @"3", @"5", @"6"]];
	CBHAssertHeapState(heap3, 7, 7);

	XCTAssertEqualObjects(heap0, heap1, @"Fails to detect equality.");
	XCTAssertTrue([heap0 isEqualToHeap:heap1], @"Fails to detect equality.");

	XCTAssertEqualObjects(heap0, heap2, @"Fails to detect inequality in capacity.");
	XCTAssertTrue([heap0 isEqualToHeap:heap2], @"Fails to detect inequality in capacity.");

	XCTAssertNotEqualObjects(heap0, heap3, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([heap0 isEqualToHeap:heap3], @"Fails to detect inequality in capacity.");

	/// Ensure Correctness
	CBHAssertHeapTeardownDefault(heap0, 8);
	CBHAssertHeapTeardownDefault(heap1, 8);
	CBHAssertHeapTeardownDefault(heap2, 8);
	CBHAssertHeapTeardownDefault(heap3, 7);
}

- (void)test_equality_hash
{
	NSArray<NSString *> *list0 = kArray;
	NSArray<NSString *> *list1 = @[@"1", @"2", @"3", @"5", @"6", @"4", @"0"];
	NSArray<NSString *> *list2 = @[@"1", @"2", @"3", @"5", @"4", @"0"];
	NSArray<NSString *> *list3 = @[@"1", @"2", @"3", @"4", @"0"];
	NSArray<NSString *> *list4 = @[@"1", @"2", @"3", @"0"];
	NSArray<NSString *> *list5 = @[@"1", @"2", @"0"];
	NSArray<NSString *> *list6 = @[@"1", @"0"];
	NSArray<NSString *> *list7 = @[@"0"];
	NSArray<NSString *> *list8 = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"8"];
	NSArray<NSString *> *list9 = @[@"1", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	NSArray<NSString *> *list10 = @[@"6", @"0", @"1", @"2", @"3", @"3", @"5", @"7"];
	NSArray<NSString *> *list11 = @[@"3", @"0", @"1", @"2", @"3", @"5", @"7"];

	const NSUInteger hash0  = [[CBHHeap heapWithComparator:kComparator andArray:list0] hash];
	const NSUInteger hash1  = [[CBHHeap heapWithComparator:kComparator andArray:list1] hash];
	const NSUInteger hash2  = [[CBHHeap heapWithComparator:kComparator andArray:list2] hash];
	const NSUInteger hash3  = [[CBHHeap heapWithComparator:kComparator andArray:list3] hash];
	const NSUInteger hash4  = [[CBHHeap heapWithComparator:kComparator andArray:list4] hash];
	const NSUInteger hash5  = [[CBHHeap heapWithComparator:kComparator andArray:list5] hash];
	const NSUInteger hash6  = [[CBHHeap heapWithComparator:kComparator andArray:list6] hash];
	const NSUInteger hash7  = [[CBHHeap heapWithComparator:kComparator andArray:list7] hash];
	const NSUInteger hash8  = [[CBHHeap heapWithComparator:kComparator andArray:list8] hash];
	const NSUInteger hash9  = [[CBHHeap heapWithComparator:kComparator andArray:list9] hash];
	const NSUInteger hash10 = [[CBHHeap heapWithComparator:kComparator andArray:list10] hash];
	const NSUInteger hash11 = [[CBHHeap heapWithComparator:kComparator andArray:list11] hash];

	NSUInteger hashes[] = {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11};

	for (NSUInteger i = 0; i <= 10; ++i)
	{
		for (NSUInteger j = 0; j <= 10; ++j)
		{
			if ( i == j ) continue;
			XCTAssertNotEqual(hashes[i], hashes[j], @"Hash too easily collides.");
		}
	}
}


#pragma mark - Conversion

- (void)test_array
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap, 8, 8);

	NSArray<NSString *> *expected = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	XCTAssertEqualObjects([heap array], expected, @"Fails to detect equality.");
}

- (void)test_mutableArray
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap, 8, 8);

	NSArray<NSString *> *expected = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	XCTAssertEqualObjects([heap mutableArray], expected, @"Fails to detect equality.");
}


- (void)test_orderedSet
{
	NSSet<NSString *> *set = [NSSet setWithArray:kArray];
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andSet:set];
	CBHAssertHeapState(heap, 8, 8);

	NSOrderedSet<NSString *> *expected = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	XCTAssertEqualObjects([heap orderedSet], expected, @"Fails to detect equality.");
}

- (void)test_mutableOrderedSet
{
	NSSet<NSString *> *set = [NSSet setWithArray:kArray];
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andSet:set];
	CBHAssertHeapState(heap, 8, 8);

	NSOrderedSet<NSString *> *expected = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	XCTAssertEqualObjects([heap mutableOrderedSet], expected, @"Fails to detect equality.");
}


#pragma mark - Enqueueing and Dequeueing

- (void)test_insert
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:4];
	CBHAssertHeapState(heap, 4, 0);

	for (NSInteger i = 7; i >= 0; --i)
	{
		[heap insertObject:[NSString stringWithFormat:@"%lu", i]];
	}

	/// Ensure Correctness
	CBHAssertHeapState(heap, 12, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_insert_objects
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:4];
	CBHAssertHeapState(heap, 4, 0);

	[heap insertObjects:@"7", @"0", @"6", @"1", @"5", @"2", @"4", @"3", nil];

	/// Ensure Correctness
	CBHAssertHeapState(heap, 12, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_insert_array
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:4];
	CBHAssertHeapState(heap, 4, 0);

	[heap insertObjectsFromArray:kArray];

	/// Ensure Correctness
	CBHAssertHeapState(heap, 12, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_insert_orderedSet
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:4];
	CBHAssertHeapState(heap, 4, 0);

	[heap insertObjectsFromSet:[NSSet setWithArray:kArray]];

	/// Ensure Correctness
	CBHAssertHeapState(heap, 12, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_insert_enumerator
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:4];
	CBHAssertHeapState(heap, 4, 0);

	[heap insertObjectsFromEnumerator:[kArray objectEnumerator]];

	/// Ensure Correctness
	CBHAssertHeapState(heap, 12, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}


- (void)test_extract_objects
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertHeapState(heap, 8, 8);

	NSArray<NSString *> *values;

	values = [heap extractObjects:4];
	{
		NSUInteger i = 0;
		for (NSString *string in values)
		{
			NSString *expected = [NSString stringWithFormat:@"%lu", i];
			XCTAssertEqualObjects(string, expected, @"Entry is incorrect at index %lu.", i);
			++i;
		}
		XCTAssertEqual(i, 4, @"Iterated wrong number of times.");
	}

	/// Ensure Correctness
	CBHAssertHeapState(heap, 8, 4);

	values = [heap extractObjects:4];
	{
		NSUInteger i = 4;
		for (NSString *string in values)
		{
			NSString *expected = [NSString stringWithFormat:@"%lu", i];
			XCTAssertEqualObjects(string, expected, @"Entry is incorrect at index %lu.", i);
			++i;
		}
		XCTAssertEqual(i, 8, @"Iterated wrong number of times.");
	}

	values = [heap extractObjects:4];
	XCTAssertEqual([values count], 0, @"Failed to dequeue on empty queue correctly.");


	values = [heap extractObjects:0];
	XCTAssertEqual([values count], 0, @"Failed to dequeue zero objects correctly.");
}


#pragma mark - Resize

- (void)test_resize_shrinkEmpty
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];

	XCTAssertEqual([heap count], 0, @"Incorrect count.");
	XCTAssertEqual([heap capacity], 8, @"Incorrect capacity.");

	[heap shrink];

	XCTAssertEqual([heap count], 0, @"Incorrect count.");
	XCTAssertEqual([heap capacity], 1, @"Incorrect capacity.");

	[heap shrink];

	XCTAssertEqual([heap count], 0, @"Incorrect count.");
	XCTAssertEqual([heap capacity], 1, @"Incorrect capacity.");
}

- (void)test_resize_shrinkSingle
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:1];
	[heap insertObject:@"0"];

	XCTAssertEqual([heap count], 1, @"Incorrect count.");
	XCTAssertEqual([heap capacity], 1, @"Incorrect capacity.");

	[heap shrink];

	XCTAssertEqual([heap count], 1, @"Incorrect count.");
	XCTAssertEqual([heap capacity], 1, @"Incorrect capacity.");

	[heap extractObject];
	[heap shrink];

	XCTAssertEqual([heap count], 0, @"Incorrect count.");
	XCTAssertEqual([heap capacity], 1, @"Incorrect capacity.");
}

- (void)test_resize_grow
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];

	for (NSUInteger i = 0; i < 16; ++i)
	{
		[heap insertObject:[NSString stringWithFormat:@"%lu", i]];
	}

	CBHAssertHeapState(heap, 22, 16);
	CBHAssertHeapTeardownDefault(heap, 16);
}

- (void)test_resize_manualGrow
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertHeapState(heap, 8, 8);

	[heap grow];

	CBHAssertHeapState(heap, 13, 8);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_resize_manualNoGrow
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
	CBHAssertHeapState(heap, 8, 6);

	[heap grow];

	CBHAssertHeapState(heap, 8, 6);
	CBHAssertHeapTeardownDefault(heap, 6);
}

- (void)test_resize
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:16];
	CBHAssertHeapState(heap, 16, 0);

	[heap insertObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertHeapState(heap, 16, 8);

	XCTAssertTrue([heap resize:10]);
	CBHAssertHeapState(heap, 10, 8);

	XCTAssertTrue([heap resize:8]);
	CBHAssertHeapState(heap, 8, 8);

	XCTAssertFalse([heap resize:8]);
	CBHAssertHeapState(heap, 8, 8);

	XCTAssertFalse([heap resize:4]);
	CBHAssertHeapState(heap, 8, 8);

	XCTAssertFalse([heap resize:0]);
	CBHAssertHeapState(heap, 8, 8);
}

- (void)test_resize_head
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];
	[heap insertObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];

	/// [ 0 | 1 | 2 | 3 | 4 | 5 | - | - ]
	CBHAssertHeapState(heap, 8, 6);

	[heap shrink];

	/// [ 0 | 1 | 2 | 3 | 4 | 5 ]
	CBHAssertHeapState(heap, 6, 6);
	CBHAssertHeapTeardownDefault(heap, 6);
}

- (void)test_resize_tail
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];
	[heap insertObjects:@"0", @"0", @"0", @"0", nil];
	[heap extractObjects:4];
	[heap insertObjects:@"0", @"1", @"2", @"3", nil];

	/// [ - | - | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertHeapState(heap, 8, 4);

	[heap shrink];

	/// [ 0 | 1 | 2 | 3 ]
	CBHAssertHeapState(heap, 4, 4);
	CBHAssertHeapTeardownDefault(heap, 4);
}

- (void)test_resize_shiftHead
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];
	[heap insertObjects:@"0", @"0", @"0", @"0", nil];
	[heap extractObjects:4];
	[heap insertObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];

	/// [ 4 | 5 | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertHeapState(heap, 8, 6);

	[heap shrink];

	/// [ 4 | 5 | 0 | 1 | 2 | 3 ]
	CBHAssertHeapState(heap, 6, 6);
	CBHAssertHeapTeardownDefault(heap, 6);
}

- (void)test_resize_wrapTail
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];
	[heap insertObjects:@"0", nil];
	[heap extractObjects:1];
	[heap insertObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];

	/// [ - | 0 | 1 | 2 | 3 | 4 | 5 | - ]
	CBHAssertHeapState(heap, 8, 6);

	[heap shrink];

	/// [ 5 | 0 | 1 | 2 | 3 | 4 ]
	CBHAssertHeapState(heap, 6, 6);
	CBHAssertHeapTeardownDefault(heap, 6);
}

- (void)test_resize_shiftWhole
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andCapacity:8];
	[heap insertObjects:@"0", @"0", @"0", @"0", nil];
	[heap extractObjects:6];
	[heap insertObjects:@"0", @"1", @"2", @"3", nil];

	/// [ - | - | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertHeapState(heap, 8, 4);

	[heap shrink];

	/// [ 0 | 1 | 2 | 3 ]
	CBHAssertHeapState(heap, 4, 4);
	CBHAssertHeapTeardownDefault(heap, 4);
}


#pragma mark - Description

- (void)test_description
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap, 8, 8);

	NSString *description = [heap description];
	NSString *expected = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5,\n\t6,\n\t7\n)";

	XCTAssertEqualObjects(description, expected, @"Description is wrong, was: \"%@\", expected: \"%@\"", description, expected);
	CBHAssertHeapTeardownDefault(heap, 8);
}

- (void)test_debugDescription
{
	CBHHeap<NSString *> *heap = [CBHHeap heapWithComparator:kComparator andArray:kArray];
	CBHAssertHeapState(heap, 8, 8);

	NSString *description = [heap debugDescription];
	NSString *properties = @"{\n\tcapacity: 8,\n\tcount: 8,\n\toffset: 0\n},";
	NSString *values = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5,\n\t6,\n\t7\n)";
	NSString *expected = [NSString stringWithFormat:@"<%@: %p>\n%@\n%@", [heap class], (void *)heap, properties, values];

	XCTAssertEqualObjects(description, expected, @"Description is wrong, was: \"%@\", expected: \"%@\"", description, expected);
	CBHAssertHeapTeardownDefault(heap, 8);
}

@end
