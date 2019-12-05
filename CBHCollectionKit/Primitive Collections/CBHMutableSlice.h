//  CBHMutableSlice.h
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

@import Foundation;

#import <CBHCollectionKit/CBHSlice.h>


NS_ASSUME_NONNULL_BEGIN

/** A mutable ordered collection of primitive values.
 *
 * Defines a modifiable slice of primitive values. This class adds the ability to set, swap and copy entires to the basic slice-handling behaviour inherited from `CBHSlice`.
 *
 * @author    Christian Huxtable <chris@huxtable.ca>
 */
@interface CBHMutableSlice : CBHSlice

#pragma mark Copying

/** Returns a new instance that’s a copy of the receiver.
 *
 * @param zone    This parameter is ignored. Memory zones are no longer used by Objective-C.
 */
- (id)copyWithZone:(nullable NSZone *)zone;

@end


#pragma mark - Resizing

@interface CBHMutableSlice (Resizing)

- (void)resize:(NSUInteger)capacity;
- (void)resize:(NSUInteger)capacity andClear:(BOOL)shouldClear;

@end


#pragma mark - Swapping and Duplicating Entries

@interface CBHMutableSlice (SwapDuplicate)

- (void)swapValuesAtIndex:(NSUInteger)a andIndex:(NSUInteger)b;
- (BOOL)swapValuesInRange:(NSRange)a andIndex:(NSUInteger)b;

- (void)duplicateValueAtIndex:(NSUInteger)src toIndex:(NSUInteger)dst;
- (void)duplicateValuesInRange:(NSRange)range toIndex:(NSUInteger)dst;

@end


#pragma mark - Clearing Slice
@interface CBHMutableSlice (Clearing)

- (void)clearAllValues;
- (void)clearValuesInRange:(NSRange)range;

@end


#pragma mark - Generic Mutators
@interface CBHMutableSlice (GenericMutators)

- (void)setValue:(const void *)value atIndex:(NSUInteger)index;

@end


#pragma mark - Named Byte Mutators
@interface CBHMutableSlice (NamedByteMutators)

- (void)setByte:(uint8_t)value atIndex:(NSUInteger)index;
- (void)setSignedByte:(int8_t)value atIndex:(NSUInteger)index;
- (void)setUnsignedByte:(uint8_t)value atIndex:(NSUInteger)index;

@end


#pragma mark - Named Integer Mutators
@interface CBHMutableSlice (NamedIntegerMutators)

- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index;
- (void)setUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;

@end


#pragma mark - Sized Integer Mutators
@interface CBHMutableSlice (SizedIntegerMutators)

- (void)setInt8:(int8_t)value atIndex:(NSUInteger)index;
- (void)setUInt8:(uint8_t)value atIndex:(NSUInteger)index;

- (void)setInt16:(int16_t)value atIndex:(NSUInteger)index;
- (void)setUInt16:(uint16_t)value atIndex:(NSUInteger)index;

- (void)setInt32:(int32_t)value atIndex:(NSUInteger)index;
- (void)setUInt32:(uint32_t)value atIndex:(NSUInteger)index;

- (void)setInt64:(int64_t)value atIndex:(NSUInteger)index;
- (void)setUInt64:(uint64_t)value atIndex:(NSUInteger)index;

@end


#pragma mark - Named Float Mutators

@interface CBHMutableSlice (NamedFloatMutators)

- (void)setCGFloat:(CGFloat)value atIndex:(NSUInteger)index;

- (void)setFloat:(float)value atIndex:(NSUInteger)index;
- (void)setDouble:(double)value atIndex:(NSUInteger)index;
- (void)setLongDouble:(long double)value atIndex:(NSUInteger)index;

@end


#pragma mark - Character Mutators

@interface CBHMutableSlice (CharacterMutators)

- (void)setChar:(char)value atIndex:(NSUInteger)index;
- (void)setUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index;

@end


#pragma mark - Mutable Copying

@interface CBHSlice (MutableCopying) <NSMutableCopying>

- (id)mutableCopyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END
