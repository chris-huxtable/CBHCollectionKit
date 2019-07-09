//  _CBHSlice.m
//  CBHCollectionKit
//
//  Created by Christian Huxtable, November 2018.
//  Copyright (c) 2018, Christian Huxtable <chris@huxtable.ca>
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

#import "_CBHSlice.h"

@import Foundation.NSException;
@import CBHMemoryKit;


#define _pointerToOffset(offset) ((void *)((size_t)slice->_data + (((offset)) * slice->_entrySize)))
#define _guardOffsetInBounds(offset) if ( (offset) >= slice->_capacity ) @throw NSRangeException


#pragma mark - Initializers

CBHSlice_t CBHSlice_init(NSUInteger capacity, const size_t entrySize, const BOOL shouldClear)
{
	CBHSlice_t retVal;

	retVal._data = ( shouldClear ) ? CBHMemory_calloc(capacity, entrySize) : CBHMemory_alloc(capacity, entrySize);
	if ( !retVal._data ) @throw CBHCallocException;

	retVal._capacity = capacity;
	retVal._entrySize = entrySize;

	return retVal;
}


CBHSlice_t CBHSlice_initCopyingBytes(const void *pointer, const size_t entrySize, const NSUInteger count)
{
	return CBHSlice_initCopyingBytesWithCount(pointer, entrySize, count, count);
}

CBHSlice_t CBHSlice_initCopyingBytesWithCount(const void *pointer, const size_t entrySize, const NSUInteger capacity, const NSUInteger count)
{
	CBHSlice_t retVal;

	retVal._data = CBHMemory_alloc(capacity, entrySize);
	if ( !retVal._data ) @throw CBHCallocException;

	retVal._capacity = capacity;
	retVal._entrySize = entrySize;

	CBHMemory_copyTo(pointer, retVal._data, count, entrySize);

	return retVal;
}

CBHSlice_t CBHSlice_initOwningBytes(void *pointer, const size_t entrySize, const NSUInteger capacity)
{
	CBHSlice_t retVal;

	retVal._data = pointer;

	retVal._capacity = capacity;
	retVal._entrySize = entrySize;

	return retVal;
}


#pragma mark - Destructors

void CBHSlice_dealloc(CBHSlice_t *slice)
{
	CBHMemory_free(slice->_data);
}


#pragma mark - Entries

inline const void *CBHSlice_pointerAtOffset(const CBHSlice_t *slice, NSUInteger const offset)
{
	_guardOffsetInBounds(offset);
	return *(void **)_pointerToOffset(offset);
}

inline const void *CBHSlice_pointerToOffset(const CBHSlice_t *slice, NSUInteger const offset)
{
	_guardOffsetInBounds(offset);
	return _pointerToOffset(offset);
}

inline void CBHSlice_setValueAtOffset(const CBHSlice_t *slice, NSUInteger const offset, const void *value)
{
	_guardOffsetInBounds(offset);
	CBHMemory_copyTo(value, _pointerToOffset(offset), 1, slice->_entrySize);
}

inline void CBHSlice_setValuesInRange(const CBHSlice_t *slice, const void *value, const NSUInteger offset, const NSUInteger length)
{
	if ( length <= 0 ) return;

	_guardOffsetInBounds(offset);
	_guardOffsetInBounds(offset + length - 1);

	for ( NSUInteger i = offset; i < length; ++i )
	{
		CBHMemory_copyTo(value, _pointerToOffset(i), 1, slice->_entrySize);
	}
}


#pragma mark - Capacity

inline void CBHSlice_setCapacity(CBHSlice_t *slice, const NSUInteger capacity, const BOOL shouldClear)
{
	if (capacity == slice->_capacity) return;

	if ( shouldClear )
	{
		slice->_data = CBHMemory_recalloc(slice->_data, slice->_capacity, capacity, slice->_entrySize);
	}
	else
	{
		slice->_data = CBHMemory_realloc(slice->_data, capacity, slice->_entrySize);
	}

	if ( !slice->_data ) @throw CBHReallocException;

	slice->_capacity = capacity;
}


#pragma mark - Copying

void CBHSlice_copyValueAtOffset(const CBHSlice_t *slice, const NSUInteger src, const NSUInteger dst)
{
	if ( src == dst ) return;

	_guardOffsetInBounds(src);
	_guardOffsetInBounds(dst);

	CBHMemory_copyTo(_pointerToOffset(src), _pointerToOffset(dst), 1, slice->_entrySize);
}

void CBHSlice_copyValuesInRange(const CBHSlice_t *slice, const NSUInteger src, const NSUInteger dst, const NSUInteger length)
{
	if ( src == dst ) return;

	_guardOffsetInBounds(src);
	_guardOffsetInBounds(src + length - 1);
	_guardOffsetInBounds(dst + length - 1);

	CBHMemory_copyTo(_pointerToOffset(src), _pointerToOffset(dst), length, slice->_entrySize);
}


#pragma mark - Swapping

void CBHSlice_swapValuesAtOffsets(const CBHSlice_t *slice, const NSUInteger a, const NSUInteger b)
{
	if ( a == b ) return;

	_guardOffsetInBounds(a);
	_guardOffsetInBounds(b);

	CBHMemory_swapBytes(_pointerToOffset(a), _pointerToOffset(b), 1, slice->_entrySize);
}

BOOL CBHSlice_swapValuesInRange(const CBHSlice_t *slice, const NSUInteger a, const NSUInteger b, const NSUInteger length)
{
	if ( a == b ) return NO;

	_guardOffsetInBounds(a);

	NSUInteger a_last = a + length - 1;
	_guardOffsetInBounds(a_last);

	NSUInteger b_last = b + length - 1;
	_guardOffsetInBounds(b_last);

	if ( a < b )
	{
		if ( b <= a_last ) { return NO; }
	}
	else
	{
		if ( a <= b_last ) { return NO; }
	}

	CBHMemory_swapBytes(_pointerToOffset(a), _pointerToOffset(b), length, slice->_entrySize);
	return YES;
}

#pragma mark - Zeroing

void CBHSlice_zeroValuesInRange(const CBHSlice_t *slice, const NSUInteger index, const NSUInteger length)
{
	if ( length <= 0 ) return;

	_guardOffsetInBounds(index);
	_guardOffsetInBounds(index + length - 1);

	CBHMemory_zero(_pointerToOffset(index), length, slice->_entrySize);
}
