//  _CBHHeap.m
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

#import "_CBHHeap.h"
#import "_CBHQueue.h"

@import CBHMemoryKit;


#define _lastIndex() (_queue._count - 1)
#define _parentOf(anIndex) ((NSUInteger)floor((anIndex - 1) / 2))

#define _firstChildOf(anIndex) ((2 * (anIndex)) + 1)
#define _secondChildOf(anIndex) ((2 * (anIndex)) + 2)

#define _guardNotEmpty() if ( heap->_count <= 0 ) return
#define _guardNotEmptyReturn(retVal) if ( heap->_count <= 0 ) return (retVal)

#define _guardIndexInBounds(anIndex) if ( (anIndex) >= heap->_count ) @throw NSRangeException


#pragma mark - Mutators

void CBHHeap_insertValue(CBHQueue_t *heap, const void *object, NSComparator comparator)
{
	CBHQueue_enqueue(heap, object);

	if ( heap->_count <= 1 ) return;
	CBHHeap_upHeap(heap, heap->_count - 1, comparator);
}

const void *CBHHeap_extractValue(CBHQueue_t *heap, NSComparator comparator)
{
	_guardNotEmptyReturn(nil);

	const void *retVal = CBHQueue_dequeue(heap);
	CBHHeap_downHeap(heap, 0, comparator);

	return retVal;
}


#pragma mark - Heapification

void CBHHeap_downHeap(CBHQueue_t *heap, const NSUInteger index, NSComparator comparator)
{
	_guardNotEmpty();
	_guardIndexInBounds(index);

	void *p = (void *)CBHQueue_pointerAtIndex(heap, index);

	NSUInteger aIndex = _firstChildOf(index);
	if ( heap->_count <= aIndex) return;
	void *a = (void *)CBHQueue_pointerAtIndex(heap, aIndex);
	if ( comparator((__bridge id)p, (__bridge id)a) != (NSComparisonResult)NSOrderedAscending ) CBHHeap_swapIndeces(heap, index, aIndex);
	CBHHeap_downHeap(heap, aIndex, comparator);

	NSUInteger bIndex = aIndex + 1;
	if ( heap->_count <= bIndex) return;
	void *b = (void *)CBHQueue_pointerAtIndex(heap, bIndex);
	if ( comparator((__bridge id)p, (__bridge id)b) != (NSComparisonResult)NSOrderedAscending ) CBHHeap_swapIndeces(heap, index, bIndex);
	CBHHeap_downHeap(heap, bIndex, comparator);

	//CBHQueue_swapPointers(&_queue, *(void **)a, *(void **)b);
}

void CBHHeap_upHeap(CBHQueue_t *heap, const NSUInteger index, NSComparator comparator)
{
	_guardNotEmpty();

	NSUInteger currentIndex = index;
	NSUInteger nextIndex = _parentOf(currentIndex);

	_guardIndexInBounds(currentIndex);
	_guardIndexInBounds(nextIndex);

	void *parent = nil;
	void *object = CBHQueue_pointerAtIndex(heap, currentIndex);

	while (TRUE)
	{
		parent = CBHQueue_pointerAtIndex(heap, nextIndex);

		id parentObj = (__bridge id)parent;
		id objectObj = (__bridge id)object;

		if ( comparator(parentObj, objectObj) == (NSComparisonResult)NSOrderedAscending ) break;
		CBHHeap_swapIndeces(heap, currentIndex, nextIndex);

		if ( nextIndex <= 0 ) break;

		currentIndex = nextIndex;
		nextIndex = _parentOf(currentIndex);
	}
}


#pragma mark - Swapping

void CBHHeap_swapIndeces(const CBHQueue_t *heap, const NSUInteger firstIndex, const NSUInteger secondIndex)
{
	_guardIndexInBounds(firstIndex);
	_guardIndexInBounds(secondIndex);

	CBHHeap_swapPointers(heap, CBHQueue_pointerToIndex(heap, firstIndex), CBHQueue_pointerToIndex(heap, secondIndex));
}

void CBHHeap_swapPointers(const CBHQueue_t *heap, void **firstPointer, void **secondPointer)
{
	void *tmp = *firstPointer;
	*firstPointer = *secondPointer;
	*secondPointer = tmp;
}


#pragma mark - Array Conversion

void CBHHeap_fillArrayWithObjects(const CBHQueue_t *heap, id __unsafe_unretained *array, NSComparator comparator)
{
	/// TODO: Avoid Copy?
	CBHQueue_t copy = CBHQueue_copy(heap);

	NSUInteger index = 0;
	id __unsafe_unretained object;
	while ( (object = (__bridge id __unsafe_unretained)CBHHeap_extractValue(&copy, comparator)) )
	{
		array[index] = object;
		++index;
	}
}
