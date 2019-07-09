//  _CBHSlice.h
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

@import CoreFoundation;

#import "_CBHSlice_t.h"


#pragma mark - Initializers

CBHSlice_t CBHSlice_init(NSUInteger capacity, size_t entrySize, BOOL shouldClear);
CBHSlice_t CBHSlice_initCopyingBytes(const void *pointer, size_t entrySize, NSUInteger count);
CBHSlice_t CBHSlice_initCopyingBytesWithCount(const void *pointer, size_t entrySize, NSUInteger capacity, NSUInteger count);
CBHSlice_t CBHSlice_initOwningBytes(void *pointer, size_t entrySize, NSUInteger capacity);


#pragma mark - Destructors

void CBHSlice_dealloc(CBHSlice_t *slice);


#pragma mark - Entries

const void *CBHSlice_pointerAtOffset(const CBHSlice_t *slice, NSUInteger offset);
const void *CBHSlice_pointerToOffset(const CBHSlice_t *slice, NSUInteger offset);

void CBHSlice_setValueAtOffset(const CBHSlice_t *slice, NSUInteger offset, const void *value);
void CBHSlice_setValuesInRange(const CBHSlice_t *slice, const void *value, NSUInteger offset, NSUInteger length);


#pragma mark - Capacity

void CBHSlice_setCapacity(CBHSlice_t *slice, NSUInteger capacity, BOOL shouldClear);


#pragma mark - Copying

void CBHSlice_copyValueAtOffset(const CBHSlice_t *slice, NSUInteger src, NSUInteger dst);
void CBHSlice_copyValuesInRange(const CBHSlice_t *slice, NSUInteger src, NSUInteger dst, NSUInteger length);


#pragma mark - Swapping

void CBHSlice_swapValuesAtOffsets(const CBHSlice_t *slice, NSUInteger a, NSUInteger b);
BOOL CBHSlice_swapValuesInRange(const CBHSlice_t *slice, NSUInteger a, NSUInteger b, NSUInteger length);


#pragma mark - Zeroing

void CBHSlice_zeroValuesInRange(const CBHSlice_t *slice, NSUInteger index, NSUInteger length);


#pragma mark - Accessors

const void *CBHSlice_valueAtOffset(const CBHSlice_t *slice, NSUInteger offset);
