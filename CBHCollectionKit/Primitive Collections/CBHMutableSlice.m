//  CBHMutableSlice.m
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

#import "CBHMutableSlice.h"
#import "_CBHSlice.h"


#define checkEntrySize(aType) if (_slice._entrySize != sizeof(aType)) @throw CBHEntrySizeException


@interface CBHSlice ()
{
	@protected
	CBHSlice_t _slice;
}

@end


@implementation CBHMutableSlice

#pragma mark Copying

- (id)copyWithZone:(NSZone *)zone
{
	return [[CBHSlice allocWithZone:zone] initWithEntrySize:_slice._entrySize copying:_slice._capacity entriesFromBytes:_slice._data];
}

@end


#pragma mark - Resizing
@implementation CBHMutableSlice (Resizing)

- (void)resize:(NSUInteger)capacity
{
	CBHSlice_setCapacity(&_slice, capacity, YES);
}

- (void)resize:(NSUInteger)capacity andClear:(BOOL)shouldClear
{
	CBHSlice_setCapacity(&_slice, capacity, shouldClear);
}

@end


@implementation CBHMutableSlice (SwapCopy)
#pragma mark - Swapping and Duplicating Entries

- (void)swapValuesAtIndex:(NSUInteger)a andIndex:(NSUInteger)b
{
	CBHSlice_swapValuesAtOffsets(&_slice, a, b);
}

- (BOOL)swapValuesInRange:(NSRange)a andIndex:(NSUInteger)b
{
	return CBHSlice_swapValuesInRange(&_slice, a.location, b, a.length);
}


- (void)duplicateValueAtIndex:(NSUInteger)src toIndex:(NSUInteger)dst
{
	CBHSlice_copyValueAtOffset(&_slice, src, dst);
}

- (void)duplicateValuesInRange:(NSRange)range toIndex:(NSUInteger)dst
{
	CBHSlice_copyValuesInRange(&_slice, range.location, dst, range.length);
}

@end


#pragma mark - Clearing Slice
@implementation CBHMutableSlice (Clearing)

- (void)clearAllValues
{
	CBHSlice_zeroValuesInRange(&_slice, 0, _slice._capacity);
}

- (void)clearValuesInRange:(NSRange)range
{
	CBHSlice_zeroValuesInRange(&_slice, range.location, range.length);
}

@end


#pragma mark - Generic Mutators
@implementation CBHMutableSlice (GenericMutators)

- (void)setValue:(const void *)value atIndex:(NSUInteger)index
{
	CBHSlice_setValueAtOffset(&_slice, index, value);
}

@end


#pragma mark - Named Byte Mutators
@implementation CBHMutableSlice (NamedByteMutators)

- (void)setByte:(uint8_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(uint8_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setSignedByte:(int8_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(int8_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUnsignedByte:(uint8_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(uint8_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

@end


#pragma mark - Named Integer Mutators
@implementation CBHMutableSlice (NamedIntegerMutators)

- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index
{
	checkEntrySize(NSUInteger);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index
{
	checkEntrySize(NSUInteger);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

@end


#pragma mark - Sized Integer Mutators
@implementation CBHMutableSlice (SizedIntegerMutators)

- (void)setInt8:(int8_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(int8_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUInt8:(uint8_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(uint8_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}


- (void)setInt16:(int16_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(int16_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUInt16:(uint16_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(uint16_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}


- (void)setInt32:(int32_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(int32_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUInt32:(uint32_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(uint32_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}


- (void)setInt64:(int64_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(int64_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUInt64:(uint64_t)value atIndex:(NSUInteger)index
{
	checkEntrySize(uint64_t);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

@end


#pragma mark - Named Float Mutators
@implementation CBHMutableSlice (NamedFloatMutators)

- (void)setCGFloat:(CGFloat)value atIndex:(NSUInteger)index
{
	checkEntrySize(CGFloat);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setFloat:(float)value atIndex:(NSUInteger)index
{
	checkEntrySize(float);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setDouble:(double)value atIndex:(NSUInteger)index
{
	checkEntrySize(double);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setLongDouble:(long double)value atIndex:(NSUInteger)index
{
	checkEntrySize(long double);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

@end


#pragma mark - Character Mutators
@implementation CBHMutableSlice (CharacterMutators)

- (void)setChar:(char)value atIndex:(NSUInteger)index
{
	checkEntrySize(char);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

- (void)setUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index
{
	checkEntrySize(unsigned char);
	CBHSlice_setValueAtOffset(&_slice, index, &value);
}

@end


#pragma mark - Mutable Copying
@implementation CBHSlice (MutableCopying)

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
	return [[CBHMutableSlice allocWithZone:zone] initWithEntrySize:_slice._entrySize copying:_slice._capacity entriesFromBytes:_slice._data];
}

@end
