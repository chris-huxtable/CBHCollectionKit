//  CBHSlice.h
//  CBHCollectionKit
//
//  Created by Christian Huxtable, October 2018.
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

@import Foundation;

#import <CBHCollectionKit/CBHPrimitiveCollection.h>


NS_ASSUME_NONNULL_BEGIN

/** A static ordered collection of primitive values.
 *
 * A Slice can be thought of an abstraction over a c array. Slice adds ease-of-use features while also enhancing safety.
 *
 * @author    Christian Huxtable <chris@huxtable.ca>
 */
@interface CBHSlice : NSObject <NSCopying, CBHPrimitiveCollection>

#pragma mark - Factories
/**
 * @name Slice Factories
 */

/** Creates and returns a new slice that can contain a `capacity` number of entries of size `entrySize`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param capacity     The number of entries in the slice.
 *
 * @return             A new slice.
 */
+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;

/** Creates and returns a new slice that can contain a `capacity` number of entries of size `entrySize`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param capacity     The number of entries in the slice.
 * @param shouldClear  Whether the slice should be explicitly cleared.
 *
 * @return             A new slice.
 */
+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity shouldClear:(BOOL)shouldClear;

/** Creates and returns a new slice that can contain a `capacity` number of entries of size `entrySize`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param capacity     The number of entries in the slice.
 * @param value        A pointer to the value of length `entrySize` to set all entries.
 *
 * @return             A new slice.
 */
+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity initialValue:(nullable const void *)value;


/** Creates and returns a new slice that can contain a `capacity` number of entries of size `entrySize` and copying a the first `count` values of size `entrySize` from `bytes`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param count        The number of entries to copy and the initial capacity of the slice.
 * @param bytes        A pointer to the first of `count` values of length `entrySize` to be copied.
 *
 * @return             A new slice containing the first `count` values of size `entrySize` of `bytes`.
 */
+ (instancetype)sliceWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;

/** Creates and returns a new slice that takes ownership of the memory pointed to by `bytes`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param count        The number of entries pointed to by `bytes` and the initial capacity of the slice.
 * @param bytes        A pointer to the memory to take ownership of. `bytes` must point to a memory block allocated with `malloc`.
 *
 * @return             A new slice with the contents of bytes.
 *
 * @note: This method takes ownership of the memory management of bytes and `free`s it on deallocation. The pointer should no longer be used to manipulate the memory.
 */
+ (instancetype)sliceWithEntrySize:(size_t)entrySize owning:(NSUInteger)count entriesFromBytes:(void *)bytes;


#pragma mark - Initialization
/**
 * @name Slice Initialization
 */

- (instancetype)init NS_UNAVAILABLE;

/** Initializes a newly allocated slice that can contain a `capacity` number of entries of size `entrySize`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param capacity     The number of entries in the slice.
 *
 * @return             A newly initialized slice.
 */
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;

/** Initializes a newly allocated slice that can contain a `capacity` number of entries of size `entrySize`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param capacity     The number of entries in the slice.
 * @param shouldClear  Whether the slice should be explicitly cleared.
 *
 * @return             A newly initialized slice.
 */
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity shouldClear:(BOOL)shouldClear NS_DESIGNATED_INITIALIZER;

/** Initializes a newly allocated slice that can contain a `capacity` number of entries of size `entrySize`. Each entry has been set to the value at `value`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param capacity     The number of entries in the slice.
 * @param value        A pointer to the value of length `entrySize` to set all entries.
 *
 * @return             A newly initialized slice.
 */
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity initialValue:(const void *)value NS_DESIGNATED_INITIALIZER;


/** Initializes a newly allocated slice that can contain a `capacity` number of entries of size `entrySize` and copying a the first `count` values of size `entrySize` from `bytes`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param count        The number of entries to copy and the initial capacity of the slice.
 * @param bytes        A pointer to the first of `count` values of length `entrySize` to be copied.
 *
 * @return             A newly initialized slice containing the first `count` values of size `entrySize` of `bytes`.
 */
- (instancetype)initWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes NS_DESIGNATED_INITIALIZER;

/** Initializes a newly allocated slice that takes ownership of the memory pointed to by `bytes`.
 *
 * @param entrySize    The size of each entry in the slice.
 * @param count        The number of entries pointed to by `bytes` and the initial capacity of the slice.
 * @param bytes        A pointer to the memory to take ownership of. `bytes` must point to a memory block allocated with `malloc`.
 *
 * @return             A newly initialized slice with the contents of bytes.
 *
 * @note: This method takes ownership of the memory management of bytes and `free`s it on deallocation. The pointer should no longer be used to manipulate the memory.
 */
- (instancetype)initWithEntrySize:(size_t)entrySize owning:(NSUInteger)count entriesFromBytes:(void *)bytes NS_DESIGNATED_INITIALIZER;


#pragma mark - Properties

/** The number of entries in the slice.
 */
@property (nonatomic, readonly) NSUInteger count;

/** The number of entries in the slice.
 */
@property (nonatomic, readonly) NSUInteger capacity;

/** The size of each entry in the slice.
 */
@property (nonatomic, readonly) size_t entrySize;

/** Whether the slice is empty or not.

 @note: A slice is considered empty when it is of 0 count.
 */
@property (nonatomic, readonly) BOOL isEmpty;

/** A pointer to the bytes contained in the slice.
 */
@property (nonatomic, readonly) const void *bytes;


#pragma mark - Copying

/** Returns a new instance that’s a copy of the receiver.
 *
 * @param zone    This parameter is ignored. Memory zones are no longer used by Objective-C.
 */
- (id)copyWithZone:(nullable NSZone *)zone;


#pragma mark - Equality

/** Returns a Boolean value that indicates whether the receiver and a given object are equal.
 *
 * @param other    The object to be compared to the receiver. May be `nil`, in which case this method returns `NO`.
 *
 * @return         `YES` if the receiver and `object` are equal, otherwise `NO`.
 */
- (BOOL)isEqual:(id)other;

/** Compares the receiving slice to another slice.
 *
 * @param other    A slice.
 *
 * @return         `YES` if the contents of `other` are equal to the contents of the receiving array, otherwise `NO`.
 */
- (BOOL)isEqualToSlice:(CBHSlice *)other;

/** Returns an integer that can be used as a table address in a hash table structure.
 *
 * @return         An integer that can be used as a table address in a hash table structure.
 */
- (NSUInteger)hash;


#pragma mark - Conversion

/** The receiver represented as `NSData`.
 */
- (NSData *)data;

/** The receiver represented as `NSMutableData`.
 */
- (NSMutableData *)mutableData;

/** The receiver represented as a `NSString`.
 *
 * @param encoding    The encoding to use.
 */
- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;


#pragma mark - Description

- (NSString *)description;
- (NSString *)debugDescription;


#pragma mark - Generic Accessors

- (const void *)valueAtIndex:(NSUInteger)index;

@end


#pragma mark - Named Byte Accessors

@interface CBHSlice (NamedByteAccessors)

- (uint8_t)byteAtIndex:(NSUInteger)index;
- (int8_t)signedByteAtIndex:(NSUInteger)index;
- (uint8_t)unsignedByteAtIndex:(NSUInteger)index;

@end


#pragma mark - Named Integer Accessors

@interface CBHSlice (NamedIntegerAccessors)

- (NSInteger)integerAtIndex:(NSUInteger)index;
- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index;

@end


#pragma mark - Sized Integer Accessors

@interface CBHSlice (SizedIntegerAccessors)

- (int8_t)int8AtIndex:(NSUInteger)index;
- (uint8_t)uint8AtIndex:(NSUInteger)index;

- (int16_t)int16AtIndex:(NSUInteger)index;
- (uint16_t)uint16AtIndex:(NSUInteger)index;

- (int32_t)int32AtIndex:(NSUInteger)index;
- (uint32_t)uint32AtIndex:(NSUInteger)index;

- (int64_t)int64AtIndex:(NSUInteger)index;
- (uint64_t)uint64AtIndex:(NSUInteger)index;

@end


#pragma mark - Named Float Accessors

@interface CBHSlice (NamedFloatAccessors)

- (CGFloat)cgfloatAtIndex:(NSUInteger)index;
- (float)floatAtIndex:(NSUInteger)index;
- (double)doubleAtIndex:(NSUInteger)index;
- (long double)longDoubleAtIndex:(NSUInteger)index;

@end


#pragma mark - Character Accessors

@interface CBHSlice (CharacterAccessors)

- (char)charAtIndex:(NSUInteger)index;
- (unsigned char)unsignedCharAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
