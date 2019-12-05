//  CBHQueueTests.m
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

@import CBHCollectionKit.CBHQueue;


#define CBHCreateOffsetEmptyQueue(aName)\
CBHQueue<NSString *> *aName = nil; \
{\
	aName = [CBHQueue queueWithCapacity:8];\
	[aName enqueueObjects:@"0", @"0", @"0", @"0", nil];\
	[aName dequeueObjects:4];\
}

#define CBHAssertQueueState(aQueue, aCapacity, aCount)\
{\
	XCTAssertNotNil(aQueue, @"Queue was nil.");\
	XCTAssertEqual([aQueue capacity], (aCapacity), @"Incorrect capacity.");\
	XCTAssertEqual([aQueue count], (aCount), @"Incorrect count.");\
	XCTAssertEqual([aQueue isEmpty], (aCount <= 0), @"Incorrect empty state.");\
}

#define CBHAssertQueueDefault(aQueue, aCount)\
{\
	XCTAssertNotNil(aQueue, @"Queue was nil.");\
	for (NSUInteger i = 0; i < aCount; ++i)\
	{\
		NSString *__expected = [NSString stringWithFormat:@"%lu", i];\
		XCTAssertEqualObjects([aQueue objectAtIndex:i], __expected, @"Entry is incorrect at index %lu.", i);\
		XCTAssertEqual([aQueue count], (NSUInteger)aCount, @"Incorrect count.");\
		XCTAssertEqual([aQueue isEmpty], (aCount <= 0), @"Incorrect empty state.");\
	}\
}

#define CBHAssertQueueTeardownDefault(aQueue, aCount)\
{\
	XCTAssertNotNil(aQueue, @"Queue was nil.");\
	for (NSUInteger i = 0; i < aCount; ++i)\
	{\
		NSString *__expected = [NSString stringWithFormat:@"%lu", i];\
		XCTAssertEqualObjects([aQueue objectAtIndex:0], __expected, @"Entry is incorrect at top.");\
		XCTAssertEqualObjects([aQueue peekAtObject], __expected, @"Entry is incorrect at top.");\
		XCTAssertEqualObjects([aQueue dequeueObject], __expected, @"Entry is incorrect at index %lu.", i);\
		XCTAssertEqual([aQueue count], (NSUInteger)(aCount-i-1), @"Incorrect count.");\
		XCTAssertEqual([aQueue isEmpty], (i >= (aCount - 1)), @"Incorrect empty state.");\
	}\
	XCTAssertThrows([aQueue objectAtIndex:0], @"Returned non-nil value for index 0 when empty.");\
	XCTAssertNil([aQueue peekAtObject], @"Returned non-nil value for top when empty.");\
	XCTAssertNil([aQueue dequeueObject], @"Returned non-nil value when empty.");\
}


@interface CBHQueueTests : XCTestCase
@end


@implementation CBHQueueTests

- (void)test_initialization
{
	CBHQueue<NSString *> *queue = [CBHQueue queue];
	CBHAssertQueueState(queue, 8, 0);
}

- (void)test_initialization_withCapacity
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	CBHAssertQueueState(queue, 8, 0);
}


- (void)test_initialization_withObjects
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_initialization_withObjects2
{
	CBHQueue<NSString *> *queue = [[CBHQueue alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_initialization_withArray
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_initialization_withOrderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];

	CBHQueue<NSString *> *queue = [CBHQueue queueWithOrderedSet:set];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_initialization_withEnumerator
{
	NSEnumerator *enumerator = [@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"] objectEnumerator];

	CBHQueue<NSString *> *queue = [CBHQueue queueWithEnumerator:enumerator];
	CBHAssertQueueState(queue, 8, 8);

	for (NSInteger i = 0; i < 8; ++i)
	{
		NSString *expected = [NSString stringWithFormat:@"%lu", i];
		XCTAssertEqualObjects([queue peekAtObject], expected, @"Entry is incorrect on peek.");
		XCTAssertEqualObjects([queue dequeueObject], expected, @"Entry is incorrect at index %lu.", i);
		CBHAssertQueueState(queue, 8, (NSUInteger)(7-i));
	}
	XCTAssertNil([queue dequeueObject], @"Returned non-nil value when empty.");
	XCTAssertNil([queue peekAtObject], @"Returned non-nil value when empty.");
}

@end


#pragma mark - Copying
@implementation CBHQueueTests (Copying)

- (void)test_copy
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 8, 8);

	CBHQueue<NSString *> *copy = [queue copy];
	CBHAssertQueueState(copy, 8, 8);

	/// Ensure Equality
	XCTAssertEqualObjects(queue, copy, @"Fails to detect equality.");

	/// Ensure Correctness
	CBHAssertQueueTeardownDefault(queue, 8);
	CBHAssertQueueTeardownDefault(copy, 8);
}

@end


@implementation CBHQueueTests (Equality)

- (void)test_equality_same
{
	CBHQueue<NSString *> *queue0 = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue0, 8, 8);

	CBHQueue<NSString *> *queue1 = queue0;
	CBHAssertQueueState(queue1, 8, 8);

	XCTAssertEqualObjects(queue0, queue1, @"Fails to detect equality.");
	XCTAssertTrue([queue0 isEqualToQueue:queue1], @"Fails to detect equality.");
}

- (void)test_equality_wrongObjectType
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:array];

	XCTAssertNotEqualObjects(queue, array, @"Fails to detect inequality.");
}

- (void)test_equality_empty
{
	CBHQueue<NSString *> *queue0 = [CBHQueue queueWithCapacity:0];
	CBHAssertQueueState(queue0, 1, 0);

	CBHQueue<NSString *> *queue1 = [CBHQueue queueWithCapacity:0];
	CBHAssertQueueState(queue1, 1, 0);

	XCTAssertEqualObjects(queue0, queue1, @"Fails to detect equality.");
	XCTAssertTrue([queue0 isEqualToQueue:queue1], @"Fails to detect equality.");
}

- (void)test_equality_one
{
	CBHQueue<NSString *> *queue0 = [CBHQueue queueWithArray:@[@"0"]];
	CBHAssertQueueState(queue0, 1, 1);

	CBHQueue<NSString *> *queue1 = [CBHQueue queueWithArray:@[@"0"]];
	CBHAssertQueueState(queue1, 1, 1);

	XCTAssertEqualObjects(queue0, queue1, @"Fails to detect equality.");
	XCTAssertTrue([queue0 isEqualToQueue:queue1], @"Fails to detect equality.");

	/// Ensure Correctness
	CBHAssertQueueDefault(queue0, 1);
	CBHAssertQueueDefault(queue1, 1);
}

- (void)test_equality_two
{
	CBHQueue<NSString *> *queue0 = [CBHQueue queueWithArray:@[@"4", @"5"]];
	CBHAssertQueueState(queue0, 2, 2);

	CBHQueue<NSString *> *queue1 = [CBHQueue queueWithArray:@[@"4", @"5"]];
	CBHAssertQueueState(queue1, 2, 2);

	XCTAssertEqualObjects(queue0, queue1, @"Fails to detect equality.");
	XCTAssertTrue([queue0 isEqualToQueue:queue1], @"Fails to detect equality.");
}

- (void)test_equality_small
{
	CBHQueue<NSString *> *queue0 = [CBHQueue queueWithArray:@[@"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue0, 4, 4);

	CBHQueue<NSString *> *queue1 = [CBHQueue queueWithArray:@[@"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue1, 4, 4);

	XCTAssertEqualObjects(queue0, queue1, @"Fails to detect equality.");
	XCTAssertTrue([queue0 isEqualToQueue:queue1], @"Fails to detect equality.");
}

- (void)test_equality_full
{
	CBHQueue<NSString *> *queue0 = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue0, 8, 8);

	CBHQueue<NSString *> *queue1 = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue1, 8, 8);

	CBHQueue<NSString *> *queue2 = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"4", @"5", @"3", @"6", @"7"]];
	CBHAssertQueueState(queue2, 8, 8);

	CBHQueue<NSString *> *queue3 = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"5", @"3", @"6", @"7"]];
	CBHAssertQueueState(queue3, 7, 7);

	XCTAssertEqualObjects(queue0, queue1, @"Fails to detect equality.");
	XCTAssertTrue([queue0 isEqualToQueue:queue1], @"Fails to detect equality.");

	XCTAssertNotEqualObjects(queue0, queue2, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([queue0 isEqualToQueue:queue2], @"Fails to detect inequality in capacity.");

	XCTAssertNotEqualObjects(queue0, queue3, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([queue0 isEqualToQueue:queue3], @"Fails to detect inequality in capacity.");

	/// Ensure Correctness
	CBHAssertQueueDefault(queue0, 8);
	CBHAssertQueueDefault(queue1, 8);
}

- (void)test_equality_hash
{
	NSArray<NSString *> *list0 = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	NSArray<NSString *> *list1 = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6"];
	NSArray<NSString *> *list2 = @[@"0", @"1", @"2", @"3", @"4", @"5"];
	NSArray<NSString *> *list3 = @[@"0", @"1", @"2", @"3", @"4"];
	NSArray<NSString *> *list4 = @[@"0", @"1", @"2", @"3"];
	NSArray<NSString *> *list5 = @[@"0", @"1", @"2"];
	NSArray<NSString *> *list6 = @[@"0", @"1"];
	NSArray<NSString *> *list7 = @[@"0"];
	NSArray<NSString *> *list8 = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"8"];
	NSArray<NSString *> *list9 = @[@"1", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	NSArray<NSString *> *list10 = @[@"0", @"1", @"2", @"3", @"3", @"5", @"6", @"7"];
	NSArray<NSString *> *list11 = @[@"0", @"1", @"2", @"3", @"3", @"5", @"7"];

	const NSUInteger hash0  = [[CBHQueue queueWithArray:list0] hash];
	const NSUInteger hash1  = [[CBHQueue queueWithArray:list1] hash];
	const NSUInteger hash2  = [[CBHQueue queueWithArray:list2] hash];
	const NSUInteger hash3  = [[CBHQueue queueWithArray:list3] hash];
	const NSUInteger hash4  = [[CBHQueue queueWithArray:list4] hash];
	const NSUInteger hash5  = [[CBHQueue queueWithArray:list5] hash];
	const NSUInteger hash6  = [[CBHQueue queueWithArray:list6] hash];
	const NSUInteger hash7  = [[CBHQueue queueWithArray:list7] hash];
	const NSUInteger hash8  = [[CBHQueue queueWithArray:list8] hash];
	const NSUInteger hash9  = [[CBHQueue queueWithArray:list9] hash];
	const NSUInteger hash10 = [[CBHQueue queueWithArray:list10] hash];
	const NSUInteger hash11 = [[CBHQueue queueWithArray:list11] hash];

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

@end


#pragma mark - Fast Enumeration
@implementation CBHQueueTests (FastEnumeration)

- (void)test_fastEnumeration
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 8, 8);

	NSUInteger i = 0;
	for (NSString *string in queue)
	{
		NSString *expected = [NSString stringWithFormat:@"%lu", i];
		NSLog(@"> %@", expected);
		XCTAssertEqualObjects(string, expected, @"Entry is incorrect at index %lu.", i);
		++i;
	}
	XCTAssertEqual(i, 8, @"Iterated wrong number of times.");
}

- (void)test_fastEnumeration_offset
{
	CBHCreateOffsetEmptyQueue(queue);
	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];


	NSUInteger i = 0;
	for (NSString *string in queue)
	{
		NSString *expected = [NSString stringWithFormat:@"%lu", i];
		XCTAssertEqualObjects(string, expected, @"Entry is incorrect at index %lu.", i);
		++i;
	}
	XCTAssertEqual(i, 8, @"Iterated wrong number of times.");
}

@end


#pragma mark - Conversion
@implementation CBHQueueTests (Conversion)

- (void)test_array
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:array];
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue array], array, @"Fails to detect equality.");
}

- (void)test_array_offset
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHCreateOffsetEmptyQueue(queue);
	[queue enqueueObjectsFromArray:array];

	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue array], array, @"Fails to detect equality.");
}

- (void)test_mutableArray
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:array];
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue mutableArray], array, @"Fails to detect equality.");
}

- (void)test_mutableArray_offset
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHCreateOffsetEmptyQueue(queue);
	[queue enqueueObjectsFromArray:array];

	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue mutableArray], array, @"Fails to detect equality.");
}

- (void)test_orderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHQueue<NSString *> *queue = [CBHQueue queueWithOrderedSet:set];
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue orderedSet], set, @"Fails to detect equality.");
}

- (void)test_orderedSet_offset
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHCreateOffsetEmptyQueue(queue);
	[queue enqueueObjectsFromOrderedSet:set];

	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue orderedSet], set, @"Fails to detect equality.");
}

- (void)test_mutableOrderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHQueue<NSString *> *queue = [CBHQueue queueWithOrderedSet:set];
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue mutableOrderedSet], set, @"Fails to detect equality.");
}

- (void)test_mutableOrderedSet_offset
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHCreateOffsetEmptyQueue(queue);
	[queue enqueueObjectsFromOrderedSet:set];

	CBHAssertQueueState(queue, 8, 8);

	XCTAssertEqualObjects([queue mutableOrderedSet], set, @"Fails to detect equality.");
}

@end


#pragma mark - Enqueueing and Dequeueing
@implementation CBHQueueTests (EnqueueDequeue)

- (void)test_enqueue
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	CBHAssertQueueState(queue, 8, 0);

	for (NSInteger i = 0; i < 8; ++i)
	{
		[queue enqueueObject:[NSString stringWithFormat:@"%lu", i]];
	}

	/// Ensure Correctness
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_enqueue_addObject
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	CBHAssertQueueState(queue, 8, 0);

	for (NSInteger i = 0; i < 8; ++i)
	{
		[queue enqueueObject:[NSString stringWithFormat:@"%lu", i]];
	}

	/// Ensure Correctness
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}


- (void)test_enqueue_objects
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:4];
	CBHAssertQueueState(queue, 4, 0);

	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];

	/// Ensure Correctness
	CBHAssertQueueState(queue, 12, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_enqueue_array
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:4];
	CBHAssertQueueState(queue, 4, 0);

	[queue enqueueObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];

	/// Ensure Correctness
	CBHAssertQueueState(queue, 12, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_enqueue_orderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];

	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:4];
	CBHAssertQueueState(queue, 4, 0);

	[queue enqueueObjectsFromOrderedSet:set];

	/// Ensure Correctness
	CBHAssertQueueState(queue, 12, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_enqueue_orderedSet_offset
{
	NSOrderedSet<NSString *> *set0 = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2"]];
	NSOrderedSet<NSString *> *set1 = [NSOrderedSet orderedSetWithArray:@[@"3", @"4", @"5"]];
	NSOrderedSet<NSString *> *set2 = [NSOrderedSet orderedSetWithArray:@[@"6", @"7", @"8"]];

	CBHCreateOffsetEmptyQueue(queue);
	CBHQueue<NSString *> *aName = aName = [CBHQueue queueWithCapacity:8];
	[aName enqueueObjects:@"0", @"0", @"0", @"0", nil];
	[aName dequeueObjects:4];

	[queue enqueueObjectsFromOrderedSet:set0];
	CBHAssertQueueState(queue, 8, 3);

	[queue enqueueObjectsFromOrderedSet:set1];
	CBHAssertQueueState(queue, 8, 6);

	[queue enqueueObjectsFromOrderedSet:set2];
	CBHAssertQueueState(queue, 13, 9);
	CBHAssertQueueDefault(queue, 9)

	/// Ensure Correctness
	CBHAssertQueueTeardownDefault(queue, 9);
}

- (void)test_enqueue_enumerator
{
	NSEnumerator *enumerator = [@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"] objectEnumerator];

	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:4];
	CBHAssertQueueState(queue, 4, 0);

	[queue enqueueObjectsFromEnumerator:enumerator];

	/// Ensure Correctness
	CBHAssertQueueState(queue, 12, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_enqueue_enumerator_Offset
{
	NSEnumerator *enumerator0 = [@[@"0", @"1", @"2"] objectEnumerator];
	NSEnumerator *enumerator1 = [@[@"3", @"4", @"5"] objectEnumerator];
	NSEnumerator *enumerator2 = [@[@"6", @"7", @"8"] objectEnumerator];

	CBHCreateOffsetEmptyQueue(queue);

	[queue enqueueObjectsFromEnumerator:enumerator0];
	CBHAssertQueueState(queue, 8, 3);

	[queue enqueueObjectsFromEnumerator:enumerator1];
	CBHAssertQueueState(queue, 8, 6);

	[queue enqueueObjectsFromEnumerator:enumerator2];
	CBHAssertQueueState(queue, 13, 9);
	CBHAssertQueueDefault(queue, 9)

	/// Ensure Correctness
	CBHAssertQueueTeardownDefault(queue, 9);
}


- (void)test_dequeue_objects
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueDefault(queue, 8);

	NSArray<NSString *> *values = [queue dequeueObjects:4];
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
	CBHAssertQueueState(queue, 8, 4);
	{
		NSUInteger i = 4;
		for (NSString *string in queue)
		{
			NSString *expected = [NSString stringWithFormat:@"%lu", i];
			XCTAssertEqualObjects(string, expected, @"Entry is incorrect at index %lu.", i);
			++i;
		}
		XCTAssertEqual(i, 8, @"Iterated wrong number of times.");
	}

	values = [queue dequeueObjects:4];
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

	values = [queue dequeueObjects:4];
	XCTAssertEqual([values count], 0, @"Failed to dequeue on empty queue correctly.");


	values = [queue dequeueObjects:0];
	XCTAssertEqual([values count], 0, @"Failed to dequeue zero objects correctly.");
}

@end


@implementation CBHQueueTests (Resize)

#pragma mark - Shrink

- (void)test_resize_shrinkEmpty
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];

	XCTAssertEqual([queue count], 0, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 8, @"Incorrect capacity.");

	[queue shrink];

	XCTAssertEqual([queue count], 0, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 1, @"Incorrect capacity.");

	[queue shrink];

	XCTAssertEqual([queue count], 0, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 1, @"Incorrect capacity.");
}

- (void)test_resize_shrinkSingle
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:1];
	[queue enqueueObject:@"0"];

	XCTAssertEqual([queue count], 1, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 1, @"Incorrect capacity.");

	[queue shrink];

	XCTAssertEqual([queue count], 1, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 1, @"Incorrect capacity.");

	[queue dequeueObject];

	[queue shrink];

	XCTAssertEqual([queue count], 0, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 1, @"Incorrect capacity.");
}

- (void)test_resize_grow
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];

	for (NSUInteger i = 0; i < 16; ++i)
	{
		[queue enqueueObject:[NSString stringWithFormat:@"%lu", i]];
	}

	CBHAssertQueueState(queue, 22, 16);
	CBHAssertQueueDefault(queue, 16);

	CBHAssertQueueTeardownDefault(queue, 16);
}

- (void)test_resize_manualGrow
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueDefault(queue, 8);

	[queue grow];

	CBHAssertQueueState(queue, 13, 8);
	CBHAssertQueueDefault(queue, 8);

	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_resize_manualNoGrow
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
	CBHAssertQueueState(queue, 8, 6);
	CBHAssertQueueDefault(queue, 6);

	[queue grow];

	CBHAssertQueueState(queue, 8, 6);
	CBHAssertQueueDefault(queue, 6);

	CBHAssertQueueTeardownDefault(queue, 6);
}

- (void)test_resize
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:16];
	CBHAssertQueueState(queue, 16, 0);

	[queue enqueueObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 16, 8);

	XCTAssertTrue([queue resize:24]);
	CBHAssertQueueState(queue, 24, 8);

	XCTAssertTrue([queue resize:10]);
	CBHAssertQueueState(queue, 10, 8);

	XCTAssertTrue([queue resize:8]);
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertFalse([queue resize:8]);
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertFalse([queue resize:4]);
	CBHAssertQueueState(queue, 8, 8);

	XCTAssertFalse([queue resize:0]);
	CBHAssertQueueState(queue, 8, 8);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 8);

	XCTAssertTrue([queue resize:0]);
	CBHAssertQueueState(queue, 1, 0);
}


- (void)test_resize_head
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];

	/// [ 0 | 1 | 2 | 3 | 4 | 5 | - | - ]
	CBHAssertQueueState(queue, 8, 6);
	CBHAssertQueueDefault(queue, 6);

	[queue shrink];

	/// [ 0 | 1 | 2 | 3 | 4 | 5 ]
	CBHAssertQueueState(queue, 6, 6);
	CBHAssertQueueDefault(queue, 6);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 6);
}

- (void)test_resize_tail
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"0", @"0", @"0", nil];
	[queue dequeueObjects:4];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", nil];

	/// [ - | - | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 8, 4);
	CBHAssertQueueDefault(queue, 4);

	[queue shrink];

	/// [ 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 4, 4);
	CBHAssertQueueDefault(queue, 4);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 4);
}

- (void)test_resize_shiftHead
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"0", @"0", @"0", nil];
	[queue dequeueObjects:4];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];

	/// [ 4 | 5 | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 8, 6);
	CBHAssertQueueDefault(queue, 6);

	[queue shrink];

	/// [ 4 | 5 | 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 6, 6);
	CBHAssertQueueDefault(queue, 6);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 6);
}

- (void)test_resize_wrapTail
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", nil];
	[queue dequeueObjects:1];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];

	/// [ - | 0 | 1 | 2 | 3 | 4 | 5 | - ]
	CBHAssertQueueState(queue, 8, 6);
	CBHAssertQueueDefault(queue, 6);

	[queue shrink];

	/// [ 5 | 0 | 1 | 2 | 3 | 4 ]
	CBHAssertQueueState(queue, 6, 6);
	CBHAssertQueueDefault(queue, 6);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 6);
}

- (void)test_resize_shiftWhole
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"0", @"0", @"0", nil];
	[queue dequeueObjects:4];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", nil];

	/// [ - | - | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 8, 4);
	CBHAssertQueueDefault(queue, 4);

	[queue shrink];

	/// [ 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 4, 4);
	CBHAssertQueueDefault(queue, 4);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 4);
}

- (void)test_resize_tailOut
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"0", nil];
	[queue dequeueObjects:2];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];

	/// [ 6 | 7 | 0 | 1 | 2 | 3 | 4 | 5 ]
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueDefault(queue, 8);

	[queue enqueueObject:@"8"];

	/// [ 6 | 7 | 8 | - | - | - | - | 0 | 1 | 2 | 3 | 4 | 5 ]
	CBHAssertQueueState(queue, 13, 9);
	CBHAssertQueueDefault(queue, 9);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 9);
}

@end


#pragma mark - Enqueueing and Dequeueing
@implementation CBHQueueTests (wrap)

- (void)test_wrap
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"0", @"0", @"0", nil];
	[queue dequeueObjects:4];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", nil];
	[queue enqueueObjects:@"4", @"5", nil];

	/// [ 4 | 5 | - | - | 0 | 1 | 2 | 3 ]
	CBHAssertQueueState(queue, 8, 6);
	CBHAssertQueueDefault(queue, 6);

	/// [ 4 | 5 | 6 | 7 | 0 | 1 | 2 | 3 ]
	[queue enqueueObjects:@"6", @"7", nil];
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueDefault(queue, 8);

	/// [ 4 | 5 | 6 | 7 | 8 | 9 | - | - | 0 | 1 | 2 | 3 ]
	[queue enqueueObjects:@"8", @"9", nil];
	CBHAssertQueueState(queue, 13, 10);
	CBHAssertQueueDefault(queue, 10);

	/// Teardown
	CBHAssertQueueTeardownDefault(queue, 10);
}

- (void)test_wrapAround
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithCapacity:8];
	[queue enqueueObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
	[queue dequeueObjects:7];
	[queue enqueueObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7",  nil];

	/// [ 1 | 2 | 3 | 4 | 5 | 6 | 7 | 0 ]
	CBHAssertQueueState(queue, 8, 8);
	CBHAssertQueueDefault(queue, 8);

	/// [ 1 | 2 | 3 | 4 | 5 | 6 | 7 | - ]
	[queue dequeueObject];
	CBHAssertQueueState(queue, 8, 7);
	for (NSUInteger i = 0; i < 7; ++i)
	{
		NSString *__expected = [NSString stringWithFormat:@"%lu", i + 1];
		XCTAssertEqualObjects([queue objectAtIndex:i], __expected, @"Entry is incorrect at index %lu.", i);
	}

	/// [ - | 2 | 3 | 4 | 5 | 6 | 7 | - ]
	[queue dequeueObject];
	CBHAssertQueueState(queue, 8, 6);
	for (NSUInteger i = 0; i < 6; ++i)
	{
		NSString *__expected = [NSString stringWithFormat:@"%lu", i + 2];
		XCTAssertEqualObjects([queue objectAtIndex:i], __expected, @"Entry is incorrect at index %lu.", i);
	}
}

- (void)test_wrapHeadGrow
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"0", @"0", @"0", @"0"]];
	[queue dequeueObjects:4];
	[queue enqueueObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];

	// [ 1 | 2 | 3 | 4 | 5 | 6 | 7 | - | 0 ]

	CBHAssertQueueState(queue, 9, 8);
	CBHAssertQueueTeardownDefault(queue, 8);
}

- (void)test_wrapTailGrow
{
	CBHQueue<NSString *> *queue = [[CBHQueue alloc] initWithCapacity:8];
	for (NSInteger i = -5; i < 3; ++i) { [queue enqueueObject:[NSString stringWithFormat:@"%lu", i]]; }
	for (NSInteger i = 1; i < 7; ++i) { [queue dequeueObject]; }
	for (NSInteger i = 3; i < 9; ++i){ [queue enqueueObject:[NSString stringWithFormat:@"%lu", i]]; }
	for (NSInteger i = 9; i < 11; ++i) { [queue enqueueObject:[NSString stringWithFormat:@"%lu", i]]; }

	// [ 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | - | 1 | 2 ]

	XCTAssertEqual([queue count], 10, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 13, @"Incorrect capacity.");

	for (NSUInteger i = 1; i < 11; ++i)
	{
		NSString *expected = [NSString stringWithFormat:@"%lu", i];
		NSString *actual = [queue dequeueObject];
		XCTAssertNotNil(actual, @"Entry was nil, expected: %@.", expected);
		XCTAssertEqualObjects(actual, expected, @"Entry was: %@, Expected: %@.", actual, expected);
	}

	XCTAssertEqual([queue count], 0, @"Incorrect count.");
	XCTAssertEqual([queue capacity], 13, @"Incorrect capacity.");
	XCTAssertNil([queue peekAtObject]);
	XCTAssertNil([queue dequeueObject]);
}


@end


#pragma mark - Enqueueing and Dequeueing
@implementation CBHQueueTests (Description)

- (void)test_description
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 8, 8);

	NSString *description = [queue description];
	NSString *expected = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5,\n\t6,\n\t7\n)";

	XCTAssertEqualObjects(description, expected, @"Description is wrong, was: \"%@\", expected: \"%@\"", description, expected);
}

- (void)test_debugDescription
{
	CBHQueue<NSString *> *queue = [CBHQueue queueWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertQueueState(queue, 8, 8);

	NSString *description = [queue debugDescription];
	NSString *properties = @"{\n\tcapacity: 8,\n\tcount: 8,\n\toffset: 0\n},";
	NSString *values = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5,\n\t6,\n\t7\n)";
	NSString *expected = [NSString stringWithFormat:@"<%@: %p>\n%@\n%@", [queue class], (void *)queue, properties, values];

	XCTAssertEqualObjects(description, expected, @"Description is wrong, was: \"%@\", expected: \"%@\"", description, expected);
}

@end
