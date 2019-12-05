//  _CBHQueue.h
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

#import "_CBHSlice.h"
#import "_CBHQueue_t.h"


#pragma mark - Initializers

CBHQueue_t CBHQueue_init(NSUInteger capacity, size_t entrySize);


#pragma mark - Copiers

CBHQueue_t CBHQueue_copy(const CBHQueue_t *existing);


#pragma mark - Destructors

void CBHQueue_dealloc(CBHQueue_t *queue);


#pragma mark - Mutators

void CBHQueue_enqueue(CBHQueue_t *queue, const void *object);
const void *CBHQueue_dequeue(CBHQueue_t *queue);


#pragma mark - Accessors

void *CBHQueue_peek(const CBHQueue_t *queue);
void *CBHQueue_pointerToIndex(const CBHQueue_t *queue, NSUInteger index);
void *CBHQueue_pointerAtIndex(const CBHQueue_t *queue, NSUInteger index);


#pragma mark - Capacity

BOOL CBHQueue_growTo(CBHQueue_t *queue, NSUInteger newCapacity);
BOOL CBHQueue_shrinkTo(CBHQueue_t *queue, NSUInteger newCapacity);

BOOL CBHQueue_resize(CBHQueue_t *queue, NSUInteger newCapacity);


#pragma mark - Translation

void CBHQueue_translateWhole(CBHQueue_t *queue);
void CBHQueue_translateTailOut(CBHQueue_t *queue);
void CBHQueue_translateTailIn(CBHQueue_t *queue);
void CBHQueue_translateHeadOut(CBHQueue_t *queue, NSUInteger oldCapacity);
void CBHQueue_translateHeadIn(CBHQueue_t *queue, NSUInteger newCapacity);


#pragma mark - Utilities

BOOL CBHQueue_isSegmented(CBHQueue_t *queue);


#pragma mark - Array Conversion

void CBHQueue_fillArrayWithObjects(const CBHQueue_t *queue, id __unsafe_unretained *array);
