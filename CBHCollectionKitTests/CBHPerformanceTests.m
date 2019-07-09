//  CBHPerformanceTests.m
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
@import CBHCollectionKit.CBHQueue;
@import CBHCollectionKit.CBHBuffer;


@interface CBHPerformanceTests : XCTestCase
@end


@implementation CBHPerformanceTests

- (void)test_Array_addObject
{
	NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:8];
	
	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[array addObject:@(i)];
		}
	}];
}

- (void)test_Stack_pushObject
{
	CBHStack<NSNumber *> *stack = [CBHStack stack];

	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[stack pushObject:@(i)];
		}
	}];
}


- (void)test_Queue_enqueueObject
{
	CBHQueue<NSNumber *> *queue = [CBHQueue queue];

	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[queue enqueueObject:@(i)];
		}
	}];
}

- (void)test_Buffer_appendValue
{
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:8];

	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[buffer appendValue:&i];
		}
	}];
}

- (void)test_Buffer_setValue
{
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:8];

	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[buffer setValue:&i atIndex:i];
		}
	}];
}

- (void)test_Buffer_appendUnsignedInteger
{
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:8];

	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[buffer appendUnsignedInteger:i];
		}
	}];
}

- (void)test_Buffer_setUnsignedInteger
{
	CBHBuffer *buffer = [CBHBuffer bufferWithEntrySize:sizeof(NSUInteger) andCapacity:8];

	[self measureBlock:^{
		for (NSUInteger i = 0; i < 100000; ++i)
		{
			[buffer setUnsignedInteger:i atIndex:i];
		}
	}];
}

@end
