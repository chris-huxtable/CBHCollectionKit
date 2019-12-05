//  _CBHStack.h
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

@import CoreFoundation;

#import "_CBHSlice.h"
#import "_CBHStack_t.h"


#pragma mark - Initializers

CBHStack_t CBHStack_init(NSUInteger capacity, size_t entrySize);
CBHStack_t CBHStack_initCopyingBytesWithCount(const void *pointer, size_t entrySize, NSUInteger capacity, NSUInteger count);


#pragma mark - Destructors

void CBHStack_dealloc(CBHStack_t *stack);


#pragma mark - Entries

void CBHStack_pushValue(CBHStack_t *stack, const void *value);
void CBHStack_setValueAtIndex(CBHStack_t *stack, const void *value, size_t index);

const void *CBHStack_popValue(CBHStack_t *stack);
const void *CBHStack_peekValue(CBHStack_t *stack);


#pragma mark - Capacity

void CBHStack_setCapacity(CBHStack_t *stack, NSUInteger capacity);
