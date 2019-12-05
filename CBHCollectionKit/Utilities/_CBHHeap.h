//  _CBHHeap.h
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

@import Foundation;

#import "_CBHQueue.h"
#import "_CBHQueue_t.h"


#pragma mark - Mutators

void CBHHeap_insertValue(CBHQueue_t *heap, const void *object, NSComparator comparator);
const void *CBHHeap_extractValue(CBHQueue_t *heap, NSComparator comparator);


#pragma mark - Heapification

void CBHHeap_downHeap(CBHQueue_t *heap, NSUInteger index, NSComparator _comparator);
void CBHHeap_upHeap(CBHQueue_t *heap, NSUInteger index, NSComparator _comparator);


#pragma mark - Swapping

void CBHHeap_swapIndeces(const CBHQueue_t *queue, NSUInteger firstIndex, NSUInteger secondIndex);
void CBHHeap_swapPointers(const CBHQueue_t *queue, void **firstPointer, void **secondPointer);


#pragma mark - Array Conversion

void CBHHeap_fillArrayWithObjects(const CBHQueue_t *heap, id __unsafe_unretained *array, NSComparator comparator);
