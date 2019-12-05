//  _CBHQueue.m
//  CBHCollectionKit
//
//  Created by Christian Huxtable <chris@huxtable.ca>, November 2018.
//  Copyright (c) 2018 Christian Huxtable. All rights reserved.
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

#import "_CBHQueue.h"

@import CBHMemoryKit;


#define GROWTH_FACTOR 1.618033988749895

#define _nextCapacity(aCapacity) (size_t)ceil((double)(aCapacity) * GROWTH_FACTOR)

#define _offsetOfIndex(anIndex) ((queue->_offset + (anIndex)) % queue->_capacity)
#define _pointerToOffset(anOffset) (void *)((size_t)queue->_data + ((anOffset) * queue->_entrySize))
#define _pointerToIndex(anIndex) _pointerToOffset(_offsetOfIndex(anIndex))

#define _guardNotEmpty(retVal) if ( queue->_count <= 0 ) return (retVal)
#define _guardIndexInBounds(index) if ( (index) >= queue->_count ) @throw NSRangeException


#pragma mark - Initializers

CBHQueue_t CBHQueue_init(NSUInteger capacity, const size_t entrySize)
{
	CBHQueue_t retVal;

	if (capacity < 1) capacity = 1;

	retVal._data = CBHMemory_alloc(capacity, entrySize);
	if ( !retVal._data ) @throw CBHCallocException;

	retVal._capacity = capacity;
	retVal._entrySize = entrySize;
	retVal._offset = 0;
	retVal._count = 0;

	return retVal;
}


#pragma mark - Copiers

CBHQueue_t CBHQueue_copy(const CBHQueue_t *existing)
{
	CBHQueue_t copy = CBHQueue_init(existing->_capacity, sizeof(id));
	CBHMemory_copyTo(existing->_data, copy._data, existing->_entrySize, existing->_capacity);
	copy._count = existing->_count;
	copy._offset = existing->_offset;

	return copy;
}


#pragma mark - Destructors

void CBHQueue_dealloc(CBHQueue_t *queue)
{
	CBHMemory_free(queue->_data);
}


#pragma mark - Mutators

inline void CBHQueue_enqueue(CBHQueue_t *queue, const void *object)
{
	if ( queue->_capacity <= queue->_count ) { CBHQueue_growTo(queue, _nextCapacity(queue->_capacity)); }
	CBHSlice_setValueAtOffset((CBHSlice_t *)queue, _offsetOfIndex(queue->_count), object);
	++(queue->_count);
}

inline const void *CBHQueue_dequeue(CBHQueue_t *queue)
{
	_guardNotEmpty(nil);

	NSUInteger oldOffset = queue->_offset;
	( queue->_offset >= queue->_capacity - 1 ) ? queue->_offset = 0 : ++(queue->_offset);
	--(queue->_count);

	return CBHSlice_pointerAtOffset((CBHSlice_t *)queue, oldOffset);
}


#pragma mark - Accessors

inline void *CBHQueue_peek(const CBHQueue_t *queue)
{
	_guardNotEmpty(nil);
	return *(void **)_pointerToOffset(queue->_offset);
}

inline void *CBHQueue_pointerToIndex(const CBHQueue_t *queue, const NSUInteger index)
{
	return _pointerToIndex(index);
}

inline void *CBHQueue_pointerAtIndex(const CBHQueue_t *queue, const NSUInteger index)
{
	_guardIndexInBounds(index);
	return *(void **)_pointerToIndex(index);
}


#pragma mark - Capacity

inline BOOL CBHQueue_growTo(CBHQueue_t *queue, const NSUInteger newCapacity)
{
	if ( newCapacity <= queue->_capacity ) return NO;

	NSUInteger oldCapacity = queue->_capacity;
	CBHSlice_setCapacity((CBHSlice_t *)queue, newCapacity, NO);

	/// No Translation Necessary
	if ( queue->_offset == 0 ) return YES;

	/// If offset is in the later half of the slice.
	if ( queue->_offset >= oldCapacity / 2 )
		CBHQueue_translateHeadOut(queue, oldCapacity);
	else
		CBHQueue_translateTailOut(queue);

	return YES;
}

BOOL CBHQueue_shrinkTo(CBHQueue_t *queue, NSUInteger newCapacity)
{
	if ( queue->_capacity <= newCapacity ) return NO;
	if ( newCapacity < 1 ) newCapacity = 1;

	/// [0|1|2|3|4|-|-|-] -> [0|1|2|3|4]
	if ( queue->_offset == 0 ) {}

	/// [-|-|-|-|0|1|2|3] -> [0|1|2|3]
	else if ( queue->_offset >= queue->_count ) CBHQueue_translateWhole(queue);

	/// [-|-|0|1|2|3|4|-] -> [0|1|2|3|4]
	else if ( queue->_offset + queue->_count <= queue->_capacity ) CBHQueue_translateTailIn(queue);

	/// [2|3|4|-|-|-|0|1] -> [2|3|4|0|1]
	else CBHQueue_translateHeadIn(queue, newCapacity);

	CBHSlice_setCapacity((CBHSlice_t *)queue, newCapacity, NO);
	return YES;
}

BOOL CBHQueue_resize(CBHQueue_t *queue, NSUInteger newCapacity)
{
	if ( newCapacity < queue->_count ) return NO;
	if ( newCapacity == queue->_capacity ) return NO;
	if ( newCapacity < 1 ) newCapacity = 1;

	if ( newCapacity < queue->_capacity ) CBHQueue_shrinkTo(queue, newCapacity);
	else CBHQueue_growTo(queue, newCapacity);

	return YES;
}


#pragma mark - Translation

void CBHQueue_translateWhole(CBHQueue_t *queue)
{
	/// [-|-|0|1|2|3|4|5|-] -> [0|1|2|3|4|5|-|-|-]
	CBHSlice_copyValuesInRange((CBHSlice_t *)queue, queue->_offset, 0, queue->_count);
	queue->_offset = 0;
}

void CBHQueue_translateTailOut(CBHQueue_t *queue)
{
	/// [4|5|0|1|2|3|-|-|-] -> [-|-|0|1|2|3|4|5|-]
	NSUInteger numToMove = queue->_offset;
	//(const CBHSlice_t *slice, const NSUInteger src, const NSUInteger dst, const NSUInteger length)
	CBHSlice_copyValuesInRange((CBHSlice_t *)queue, 0, queue->_offset + queue->_count - numToMove, numToMove);
}

void CBHQueue_translateTailIn(CBHQueue_t *queue)
{
	/// [-|-|0|1|2|3|4|5|-] -> [4|5|0|1|2|3|-|-|-]
	NSUInteger numToMove = queue->_offset;
	CBHSlice_copyValuesInRange((CBHSlice_t *)queue, queue->_offset + queue->_count - numToMove, 0, numToMove);
}

void CBHQueue_translateHeadOut(CBHQueue_t *queue, const NSUInteger oldCapacity)
{
	/// [2|3|4|5|0|1|-|-|-] -> [2|3|4|5|-|-|-|0|1]
	NSUInteger numToMove = oldCapacity - queue->_offset;
	NSUInteger newOffset = queue->_capacity - numToMove;

	CBHSlice_copyValuesInRange((CBHSlice_t *)queue, queue->_offset, newOffset, numToMove);
	queue->_offset = newOffset;
}

void CBHQueue_translateHeadIn(CBHQueue_t *queue, const NSUInteger newCapacity)
{
	/// [2|3|4|5|-|-|-|0|1] -> [2|3|4|5|0|1|-|-|-]
	NSUInteger numToMove = queue->_capacity  - queue->_offset;
	NSUInteger newOffset = newCapacity - numToMove;

	CBHSlice_copyValuesInRange((CBHSlice_t *)queue, queue->_offset, newOffset, numToMove);
	queue->_offset = newOffset;
}


#pragma mark - Utilities

inline BOOL CBHQueue_isSegmented(CBHQueue_t *queue)
{
	return ((queue->_offset + queue->_count) > queue->_capacity);
}


#pragma mark - Array Conversion

void CBHQueue_fillArrayWithObjects(const CBHQueue_t *queue, id __unsafe_unretained *array)
{
	NSUInteger index = 0;
	while ( index < queue->_count )
	{
		array[index] = (__bridge id __unsafe_unretained)CBHQueue_pointerAtIndex(queue, index);
		++index;
	}
}
