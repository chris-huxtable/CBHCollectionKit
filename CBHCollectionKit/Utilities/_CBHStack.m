//  _CBHStack.m
//  CBHCollectionKit
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

#import "_CBHStack.h"

@import Foundation.NSException;
@import CBHMemoryKit;


#define _pointerToOffset(offset) ((void *)((size_t)stack->_data + (((offset)) * stack->_entrySize)))

#define _guardNotEmpty(retVal) if ( stack->_count <= 0 ) return (retVal)
#define _guardOffsetInBounds(offset) if ( (offset) >= slice->_capacity ) @throw NSRangeException


#pragma mark - Initializers

CBHStack_t CBHStack_init(const NSUInteger capacity, const size_t entrySize)
{
	CBHStack_t retVal;

	retVal._data = CBHMemory_alloc(capacity, entrySize);
	if ( !retVal._data ) @throw CBHCallocException;

	retVal._entrySize = entrySize;
	retVal._capacity = capacity;
	retVal._count = 0;

	return retVal;
}

CBHStack_t CBHStack_initCopyingBytesWithCount(const void *pointer, const size_t entrySize, const NSUInteger capacity, const NSUInteger count)
{
	CBHStack_t retVal;

	retVal._data = CBHMemory_alloc(capacity, entrySize);
	if ( !retVal._data ) @throw CBHCallocException;

	retVal._capacity = capacity;
	retVal._entrySize = entrySize;

	CBHMemory_copyTo(pointer, retVal._data, count, entrySize);

	return retVal;
}

#pragma mark - Destructors

void CBHStack_dealloc(CBHStack_t *stack)
{
	CBHMemory_free(stack->_data);
}


#pragma mark - Entries

inline void CBHStack_pushValue(CBHStack_t *stack, const void *value)
{
	CBHMemory_copyTo(value, _pointerToOffset(stack->_count), 1, stack->_entrySize);
	++stack->_count;
}

inline const void *CBHStack_popValue(CBHStack_t *stack)
{
	_guardNotEmpty(nil);
	--stack->_count;
	return *(void **)_pointerToOffset(stack->_count);
}

inline const void *CBHStack_peekValue(CBHStack_t *stack)
{
	_guardNotEmpty(nil);
	return *(void **)_pointerToOffset(stack->_count - 1);
}
