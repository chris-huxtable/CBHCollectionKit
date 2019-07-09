//  CBHStackTests.m
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

@import CBHCollectionKit.CBHStack;


#define CBHAssertStackState(aStack, aCapacity, aCount)\
{\
	XCTAssertEqual([aStack capacity], (aCapacity), @"Incorrect capacity.");\
	XCTAssertEqual([aStack count], (aCount), @"Incorrect count.");\
	XCTAssertEqual([aStack isEmpty], (aCount <= 0), @"Incorrect empty state.");\
}

#define CBHAssertStackDefault(aStack, aCount)\
{\
	for (NSInteger i = (aCount - 1); i >= 0; --i)\
	{\
		NSString *__expected = [NSString stringWithFormat:@"%lu", i];\
		XCTAssertEqualObjects([aStack peekAtObject], __expected, @"Entry is incorrect at top.");\
		XCTAssertEqualObjects([aStack popObject], __expected, @"Entry is incorrect at index %lu.", i);\
		XCTAssertEqual([aStack count], (NSUInteger)(i), @"Incorrect count.");\
		XCTAssertEqual([aStack isEmpty], (i <= 0), @"Incorrect empty state.");\
	}\
	XCTAssertNil([aStack peekAtObject], @"Returned non-nil value for top when empty.");\
	XCTAssertNil([aStack popObject], @"Returned non-nil value when empty.");\
}


@interface CBHStackTests : XCTestCase
@end


@implementation CBHStackTests

- (void)test_initialization
{
	CBHStack<NSString *> *stack = [CBHStack stack];
	CBHAssertStackState(stack, 8, 0);
}

- (void)test_initialization_withCapacity
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:8];
	CBHAssertStackState(stack, 8, 0);
}


- (void)test_initialization_withObjects
{
	CBHStack<NSString *> *stack = [CBHStack stackWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertStackState(stack, 8, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_initialization_withObjects2
{
	CBHStack<NSString *> *stack = [[CBHStack alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertStackState(stack, 8, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_initialization_withArray
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_initialization_withOrderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];

	CBHStack<NSString *> *stack = [CBHStack stackWithOrderedSet:set];
	CBHAssertStackState(stack, 8, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_initialization_withEnumerator
{
	NSEnumerator *enumerator = [@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"] objectEnumerator];

	CBHStack<NSString *> *stack = [CBHStack stackWithEnumerator:enumerator];
	CBHAssertStackState(stack, 8, 8);
	CBHAssertStackDefault(stack, 8);
}

@end


@implementation CBHStackTests (Copying)

- (void)test_copy
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	CBHStack<NSString *> *copy = [stack copy];
	CBHAssertStackState(copy, 8, 8);

	/// Ensure Equality
	XCTAssertEqualObjects(stack, copy, @"Fails to detect equality.");


	for (NSInteger i = (8 - 1); i >= 0; --i)
	{
		NSString *__expected = [NSString stringWithFormat:@"%lu", i];
		XCTAssertEqualObjects([stack peekAtObject], __expected, @"Entry is incorrect at top.");
		XCTAssertEqualObjects([stack popObject], __expected, @"Entry is incorrect at index %lu.", i);
		XCTAssertEqual([stack count], (NSUInteger)(i), @"Incorrect count.");
		XCTAssertEqual([stack isEmpty], (i <= 0), @"Incorrect empty state.");
	}
	XCTAssertNil([stack peekAtObject], @"Returned non-nil value for top when empty.");
	XCTAssertNil([stack popObject], @"Returned non-nil value when empty.");

	/// Ensure Correctness
	//CBHAssertStackDefault(stack, 8);
	CBHAssertStackDefault(copy, 8);
}

@end


@implementation CBHStackTests (Equality)

- (void)test_equality_same
{
	CBHStack<NSString *> *stack0 = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack0, 8, 8);

	CBHStack<NSString *> *stack1 = stack0;
	CBHAssertStackState(stack1, 8, 8);

	XCTAssertEqualObjects(stack0, stack1, @"Fails to detect equality.");
	XCTAssertTrue([stack0 isEqualToStack:stack1], @"Fails to detect equality.");
}

- (void)test_equality_wrongObjectType
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHStack<NSString *> *slice = [CBHStack stackWithArray:array];

	XCTAssertNotEqualObjects(slice, array, @"Fails to detect inequality.");
}

- (void)test_equality_empty
{
	CBHStack<NSString *> *stack0 = [CBHStack stackWithCapacity:0];
	CBHAssertStackState(stack0, 0, 0);

	CBHStack<NSString *> *stack1 = [CBHStack stackWithCapacity:0];
	CBHAssertStackState(stack1, 0, 0);

	XCTAssertEqualObjects(stack0, stack1, @"Fails to detect equality.");
	XCTAssertTrue([stack0 isEqualToStack:stack1], @"Fails to detect equality.");
}

- (void)test_equality_one
{
	CBHStack<NSString *> *stack0 = [CBHStack stackWithArray:@[@"0"]];
	CBHAssertStackState(stack0, 1, 1);

	CBHStack<NSString *> *stack1 = [CBHStack stackWithArray:@[@"0"]];
	CBHAssertStackState(stack1, 1, 1);

	XCTAssertEqualObjects(stack0, stack1, @"Fails to detect equality.");
	XCTAssertTrue([stack0 isEqualToStack:stack1], @"Fails to detect equality.");

	/// Ensure Correctness
	CBHAssertStackDefault(stack0, 1);
	CBHAssertStackDefault(stack1, 1);
}

- (void)test_equality_two
{
	CBHStack<NSString *> *stack0 = [CBHStack stackWithArray:@[@"4", @"5"]];
	CBHAssertStackState(stack0, 2, 2);

	CBHStack<NSString *> *stack1 = [CBHStack stackWithArray:@[@"4", @"5"]];
	CBHAssertStackState(stack1, 2, 2);

	XCTAssertEqualObjects(stack0, stack1, @"Fails to detect equality.");
	XCTAssertTrue([stack0 isEqualToStack:stack1], @"Fails to detect equality.");
}

- (void)test_equality_small
{
	CBHStack<NSString *> *stack0 = [CBHStack stackWithArray:@[@"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack0, 4, 4);

	CBHStack<NSString *> *stack1 = [CBHStack stackWithArray:@[@"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack1, 4, 4);

	XCTAssertEqualObjects(stack0, stack1, @"Fails to detect equality.");
	XCTAssertTrue([stack0 isEqualToStack:stack1], @"Fails to detect equality.");
}

- (void)test_equality_full
{
	CBHStack<NSString *> *stack0 = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack0, 8, 8);

	CBHStack<NSString *> *stack1 = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack1, 8, 8);

	CBHStack<NSString *> *stack2 = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"4", @"5", @"3", @"6", @"7"]];
	CBHAssertStackState(stack2, 8, 8);

	CBHStack<NSString *> *stack3 = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"5", @"3", @"6", @"7"]];
	CBHAssertStackState(stack3, 7, 7);

	XCTAssertEqualObjects(stack0, stack1, @"Fails to detect equality.");
	XCTAssertTrue([stack0 isEqualToStack:stack1], @"Fails to detect equality.");

	XCTAssertNotEqualObjects(stack0, stack2, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([stack0 isEqualToStack:stack2], @"Fails to detect inequality in capacity.");

	XCTAssertNotEqualObjects(stack0, stack3, @"Fails to detect inequality in capacity.");
	XCTAssertFalse([stack0 isEqualToStack:stack3], @"Fails to detect inequality in capacity.");

	/// Ensure Correctness
	CBHAssertStackDefault(stack0, 8);
	CBHAssertStackDefault(stack1, 8);
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

	const NSUInteger hash0  = [[CBHStack stackWithArray:list0] hash];
	const NSUInteger hash1  = [[CBHStack stackWithArray:list1] hash];
	const NSUInteger hash2  = [[CBHStack stackWithArray:list2] hash];
	const NSUInteger hash3  = [[CBHStack stackWithArray:list3] hash];
	const NSUInteger hash4  = [[CBHStack stackWithArray:list4] hash];
	const NSUInteger hash5  = [[CBHStack stackWithArray:list5] hash];
	const NSUInteger hash6  = [[CBHStack stackWithArray:list6] hash];
	const NSUInteger hash7  = [[CBHStack stackWithArray:list7] hash];
	const NSUInteger hash8  = [[CBHStack stackWithArray:list8] hash];
	const NSUInteger hash9  = [[CBHStack stackWithArray:list9] hash];
	const NSUInteger hash10 = [[CBHStack stackWithArray:list10] hash];
	const NSUInteger hash11 = [[CBHStack stackWithArray:list11] hash];

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
@implementation CBHStackTests (FastEnumeration)

- (void)test_fastEnumeration
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:16];
	CBHAssertStackState(stack, 16, 0);

	[stack pushObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 16, 8);

	NSUInteger i = 0;
	for (NSString *string in stack)
	{
		NSString *expected = [NSString stringWithFormat:@"%lu", i];
		XCTAssertEqualObjects(string, expected, @"Entry is incorrect at index %lu.", i);
		++i;
	}
}

@end


#pragma mark - Conversion
@implementation CBHStackTests (Conversion)

- (void)test_array
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:array];
	CBHAssertStackState(stack, 8, 8);

	XCTAssertEqualObjects([stack array], array, @"Fails to detect equality.");
}

- (void)test_mutableArray
{
	NSArray<NSString *> *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:array];
	CBHAssertStackState(stack, 8, 8);

	XCTAssertEqualObjects([stack mutableArray], array, @"Fails to detect equality.");
}

- (void)test_orderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHStack<NSString *> *stack = [CBHStack stackWithOrderedSet:set];
	CBHAssertStackState(stack, 8, 8);

	XCTAssertEqualObjects([stack orderedSet], set, @"Fails to detect equality.");
}

- (void)test_mutableOrderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHStack<NSString *> *stack = [CBHStack stackWithOrderedSet:set];
	CBHAssertStackState(stack, 8, 8);

	XCTAssertEqualObjects([stack mutableOrderedSet], set, @"Fails to detect equality.");
}

@end


@implementation CBHStackTests (PushPop)

- (void)test_pushPop
{
	CBHStack<NSString *> *stack = [[CBHStack alloc] initWithCapacity:8];
	CBHAssertStackState(stack, 8, 0);

	for (NSInteger i = 0; i < 8; ++i)
	{
		[stack pushObject:[NSString stringWithFormat:@"%lu", i]];
	}

	/// Ensure Correctness
	CBHAssertStackState(stack, 8, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_pushPop_objects
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:4];
	CBHAssertStackState(stack, 4, 0);

	[stack pushObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];

	/// Ensure Correctness
	CBHAssertStackState(stack, 12, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_pushPop_array
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:4];
	CBHAssertStackState(stack, 4, 0);

	[stack pushObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];

	/// Ensure Correctness
	CBHAssertStackState(stack, 12, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_pushPop_orderedSet
{
	NSOrderedSet<NSString *> *set = [NSOrderedSet orderedSetWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];

	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:4];
	CBHAssertStackState(stack, 4, 0);

	[stack pushObjectsFromOrderedSet:set];

	/// Ensure Correctness
	CBHAssertStackState(stack, 12, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_pushPop_enumerator
{
	NSEnumerator *enumerator = [@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"] objectEnumerator];

	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:4];
	CBHAssertStackState(stack, 4, 0);

	[stack pushObjectsFromEnumerator:enumerator];

	/// Ensure Correctness
	CBHAssertStackState(stack, 12, 8);
	CBHAssertStackDefault(stack, 8);
}


- (void)test_pushPop_grow
{
	CBHStack<NSString *> *stack = [[CBHStack alloc] initWithCapacity:8];
	CBHAssertStackState(stack, 8, 0);

	for (NSInteger i = 0; i < 16; ++i)
	{
		[stack pushObject:[NSString stringWithFormat:@"%lu", i]];
	}

	/// Ensure Correctness
	CBHAssertStackState(stack, 22, 16);
	CBHAssertStackDefault(stack, 16);
}

- (void)test_pushPop_shrink
{
	CBHStack<NSString *> *stack = [[CBHStack alloc] initWithCapacity:8];
	CBHAssertStackState(stack, 8, 0);

	for (NSInteger i = 0; i < 4; ++i)
	{
		[stack pushObject:[NSString stringWithFormat:@"%lu", i]];
	}
	CBHAssertStackState(stack, 8, 4);

	[stack shrink];
	CBHAssertStackState(stack, 4, 4);

	/// Ensure Correctness
	CBHAssertStackState(stack, 4, 4);
	CBHAssertStackDefault(stack, 4);
}

@end


@implementation CBHStackTests (Peek)

- (void)test_topObject
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	/// Count down, 7 to 0.
	for (NSInteger i = 7; i >= 0; --i)
	{
		NSString *expected = [NSString stringWithFormat:@"%ld", i];
		XCTAssertEqualObjects([stack peekAtObject], expected, @"Entry is incorrect at top.");
		XCTAssertEqualObjects([stack popObject], expected, @"Entry is incorrect at index %ld.", i);
	}
	XCTAssertNil([stack peekAtObject],  @"Returned non-nil value when empty.");
	XCTAssertNil([stack popObject], @"Returned non-nil value when empty.");
}

- (void)test_peekObject
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	/// Count down, 7 to 0.
	for (NSInteger i = 7; i >= 0; --i)
	{
		NSString *expected = [NSString stringWithFormat:@"%ld", i];
		XCTAssertEqualObjects([stack peekAtObject], expected, @"Entry is incorrect at top.");
		XCTAssertEqualObjects([stack popObject], expected, @"Entry is incorrect at index %ld.", i);
	}
	XCTAssertNil([stack peekAtObject],  @"Returned non-nil value when empty.");
	XCTAssertNil([stack popObject], @"Returned non-nil value when empty.");
}

- (void)test_objectFromTop
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	/// Count down, 7 to 0.
	for (NSInteger i = 7; i >= 0; --i)
	{
		NSString *expected = [NSString stringWithFormat:@"%ld", i];
		XCTAssertEqualObjects([stack objectFromTop:(NSUInteger)(7 - i)], expected, @"Entry is incorrect at top.");
	}
	XCTAssertNil([stack objectFromTop:8],  @"Returned non-nil value when empty.");
}

- (void)test_objectFromBottom
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	/// Count down, 0 to 7.
	for (NSInteger i = 0; i < 8; ++i)
	{
		NSString *expected = [NSString stringWithFormat:@"%ld", i];
		XCTAssertEqualObjects([stack objectFromBottom:(NSUInteger)i], expected, @"Entry is incorrect at top.");
	}
	XCTAssertNil([stack objectFromBottom:8],  @"Returned non-nil value when empty.");
}

@end


@implementation CBHStackTests (Resize)

#pragma mark - Shrink

- (void)test_resize_shrinkEmpty
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:8];

	XCTAssertEqual([stack count], 0, @"Incorrect count.");
	XCTAssertEqual([stack capacity], 8, @"Incorrect capacity.");

	[stack shrink];

	XCTAssertEqual([stack count], 0, @"Incorrect count.");
	XCTAssertEqual([stack capacity], 1, @"Incorrect capacity.");

	[stack shrink];

	XCTAssertEqual([stack count], 0, @"Incorrect count.");
	XCTAssertEqual([stack capacity], 1, @"Incorrect capacity.");
}

- (void)test_resize_shrinkSingle
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:1];
	[stack pushObject:@"0"];

	XCTAssertEqual([stack count], 1, @"Incorrect count.");
	XCTAssertEqual([stack capacity], 1, @"Incorrect capacity.");

	[stack shrink];

	XCTAssertEqual([stack count], 1, @"Incorrect count.");
	XCTAssertEqual([stack capacity], 1, @"Incorrect capacity.");

	[stack popObject];

	[stack shrink];

	XCTAssertEqual([stack count], 0, @"Incorrect count.");
	XCTAssertEqual([stack capacity], 1, @"Incorrect capacity.");
}

- (void)test_resize
{
	CBHStack<NSString *> *stack = [CBHStack stackWithCapacity:16];
	CBHAssertStackState(stack, 16, 0);

	[stack pushObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 16, 8);

	XCTAssertTrue([stack resize:10]);
	CBHAssertStackState(stack, 10, 8);

	XCTAssertTrue([stack resize:8]);
	CBHAssertStackState(stack, 8, 8);

	XCTAssertFalse([stack resize:8]);
	CBHAssertStackState(stack, 8, 8);

	XCTAssertFalse([stack resize:4]);
	CBHAssertStackState(stack, 8, 8);

	XCTAssertFalse([stack resize:0]);
	CBHAssertStackState(stack, 8, 8);
}

- (void)test_resize_manualGrow
{
	CBHStack<NSString *> *stack = [CBHStack stackWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
	CBHAssertStackState(stack, 8, 8);

	[stack grow];

	CBHAssertStackState(stack, 13, 8);
	CBHAssertStackDefault(stack, 8);
}

- (void)test_resize_manualNoGrow
{
	CBHStack<NSString *> *stack = [CBHStack stackWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
	CBHAssertStackState(stack, 8, 6);

	[stack grow];

	CBHAssertStackState(stack, 8, 6);
	CBHAssertStackDefault(stack, 6);
}

@end


@implementation CBHStackTests (Description)

- (void)test_description
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	NSString *description = [stack description];
	NSString *expected = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5,\n\t6,\n\t7\n)";

	XCTAssertEqualObjects(description, expected, @"Description is wrong, was: \"%@\", expected: \"%@\"", description, expected);
}

- (void)test_debugDescription
{
	CBHStack<NSString *> *stack = [CBHStack stackWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
	CBHAssertStackState(stack, 8, 8);

	NSString *description = [stack debugDescription];
	NSString *properties = @"{\n\tcapacity: 8,\n\tcount: 8\n},";
	NSString *values = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5,\n\t6,\n\t7\n)";
	NSString *expected = [NSString stringWithFormat:@"<%@: %p>\n%@\n%@", [stack class], (void *)stack, properties, values];

	XCTAssertEqualObjects(description, expected, @"Description is wrong, was: \"%@\", expected: \"%@\"", description, expected);
}

@end
