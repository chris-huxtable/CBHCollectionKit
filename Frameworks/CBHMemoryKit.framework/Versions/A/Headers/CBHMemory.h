//  CBHMemory.h
//  CBHMemoryKit
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

#pragma once

#include <stddef.h>
#include <stdbool.h>

@import Foundation.NSObjCRuntime;


#pragma mark - Exceptions

extern const NSExceptionName CBHCallocException;
extern const NSExceptionName CBHReallocException;


#pragma mark - Allocation
/**
 * @name Allocating New Heap Memory
 */

/** Allocates a slice of new memory. The slice is `num` consecutive blocks of `size`.
 *
 * @param num     The number of blocks of `size` to allocate.
 * @param size    The size of each block to allocate.
 *
 * @return        A pointer to the start of the slice.
 *
 * @note Memory allocated by this method is on the heap and must be freed by either `free()`, `CBHMemory_free()`, or `CBHMemory_free_f()`.
 */
void *CBHMemory_alloc(size_t num, size_t size) __result_use_check __alloc_size(1,2);

/** Allocates a **clean** slice of new memory. The slice is `num` consecutive blocks of `size`.
 *
 * @param num     The number of blocks of `size` to allocate.
 * @param size    The size of each block to allocate.
 *
 * @return        A pointer to the start of the slice.
 *
 * @note Memory allocated by this method is on the heap and must be freed by either `free()`, `CBHMemory_free()`, or `CBHMemory_free_f()`.
 */
void *CBHMemory_calloc(size_t num, size_t size) __result_use_check __alloc_size(1,2);


#pragma mark - Reallocation
/**
 * @name Reallocating Heap Memory
 */

/** Reallocates a slice of memory to a new size. The new slice is `num` consecutive blocks of `size`.
 *
 * @param ptr     A pointer to the memory to reallocate.
 * @param num     The new number of blocks of `size`.
 * @param size    The size of each block.
 *
 * @return        A pointer to the start of the reallocated slice.
 *
 * @note Memory allocated by this method is on the heap and must be freed by either `free()`, `CBHMemory_free()`, or `CBHMemory_free_f()`.
 */
void *CBHMemory_realloc(void *ptr, size_t num, size_t size) __result_use_check __alloc_size(2,3);

/** Reallocates a slice of memory to a new size. The new slice is `num` consecutive blocks of `size`. If the new size is larger then the old size the additional memory is cleared.
 *
 * @param ptr       A pointer to the memory to reallocate.
 * @param oldNum    The old number of blocks of `size`.
 * @param newNum    The new number of blocks of `size`.
 * @param size      The size of each block.
 *
 * @return          A pointer to the start of the reallocated slice.
 *
 * @note Memory allocated by this method is on the heap and must be freed by either `free()`, `CBHMemory_free()`, or `CBHMemory_free_f()`.
 */
void *CBHMemory_recalloc(void *ptr, size_t oldNum, size_t newNum, size_t size) __result_use_check __alloc_size(2,3);


#pragma mark - Copying
/**
 * @name Copying Memory
 */

/** Allocates a new slice of memory filled with the contents of `orig`.
 *
 * @param orig    A pointer to the memory to copy.
 * @param num     The number of blocks of `size`.
 * @param size    The size of each block.
 *
 * @return        A pointer to the start of the new slice.
 *
 * @note Memory allocated by this method is on the heap and must be freed by either `free()`, `CBHMemory_free()`, or `CBHMemory_free_f()`.
 */
void *CBHMemory_copy(const void *orig, size_t num, size_t size) __alloc_size(2,3);

/** Copies memory from `orig` to `dest`.
 *
 * @param orig    A pointer to the memory to copy.
 * @param dest    A pointer to the memory to copy to.
 * @param num     The number of blocks of `size`.
 * @param size    The size of each block.
 *
 * @return        A pointer to the start of the destination slice.
 */
void *CBHMemory_copyTo(const void *orig, void *dest, size_t num, size_t size) __alloc_size(3,4);


#pragma mark - Swapping
/**
 * @name Swapping Memory
 */

/** Copies memory at `a` and `b`.
 *
 * @param a       A pointer to the memory to swap.
 * @param b       A pointer to the memory to swap.
 * @param num     The number of blocks of `size`.
 * @param size    The size of each block.
 */
void CBHMemory_swapBytes(void *a, void *b, size_t num, size_t size);


#pragma mark - Zeroing
/**
 * @name Zeroing Memory
 */

/** Zero's memory ar `ptr`.
 *
 * @param ptr     A pointer to the memory to zero.
 * @param num     The number of blocks of `size` to zero.
 * @param size    The size of each block.
 */
void CBHMemory_zero(void *ptr, size_t num, size_t size);


#pragma mark - Compare
/**
 * @name Zeroing Memory
 */

/** Compares the memory pointed to by two pointers with `num` blocks of `size`.
 *
 * @param ptr0    A pointer to memory to compare.
 * @param ptr1    Another pointer to memory to compare.
 * @param num     The number of blocks of `size` to compare.
 * @param size    The size of each block.
 */
bool CBHMemory_compare(const void *ptr0, const void *ptr1, size_t num, size_t size);


#pragma mark - Free
/**
 * @name Freeing Memory
 */

/** Frees memory at the provided pointer and sets the pointer to NULL in an effort to avoid use after free.
 *
 * @param mem     A pointer to heap memory to free.
 */
#define CBHMemory_free(mem) CBHMemory_free_f((void **)&(mem))

/** Frees memory pointed to by the pointer and sets the pointer to NULL in an effort to avoid use after free.
 *
 * @param mem     A pointer to a pointer of heap memory to free.
 */
void CBHMemory_free_f(void **mem);


#pragma mark - Overflow
/**
 * @name Catching Overflows
 */

/** Checks if the multiplication of memory related values results in an overflow.
 *
 * @param num     The number of blocks of `size`.
 * @param size    The size of each block.
 *
 * @return        A `bool` indicating if an overflow will occur.
 */
#define CBHMemory_willOverflow(num, size) CBHMemory_willOverflowSize((num), (size), SIZE_MAX)

/** Checks if the multiplication of values results in an overflow of the provided `max` value.
 *
 * @param num     The number of blocks of `size`.
 * @param size    The size of each block.
 * @param max     The maximum value that can be held in the desired type.
 *
 * @return        A `bool` indicating if an overflow will occur.
 */
bool CBHMemory_willOverflowSize(size_t num, size_t size, size_t max);
