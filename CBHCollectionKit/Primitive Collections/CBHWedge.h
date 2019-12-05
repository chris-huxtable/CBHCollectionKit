//  CBHWedge.h
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

/** A dynamic ordered collection of primitive values.
 *
 * A Wedge defines a mutable slice which dynamically expands itself when needed.
 *
 * @author    Christian Huxtable <chris@huxtable.ca>
 */
@interface CBHWedge : NSObject <CBHPrimitiveCollection>

#pragma mark Factories

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize;
+ (instancetype)wedgeWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;
+ (instancetype)wedgeWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;

+ (instancetype)wedgeWithSlice:(CBHSlice *)slice;
+ (instancetype)wedgeWithSlice:(CBHSlice *)slice andCapacity:(NSUInteger)capacity;


#pragma mark Initialization

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithEntrySize:(size_t)entrySize;
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity copying:(NSUInteger)count entriesFromBytes:(const void *)bytes NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithSlice:(CBHSlice *)slice;
- (instancetype)initWithSlice:(CBHSlice *)slice andCapacity:(NSUInteger)capacity;


#pragma mark Properties

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) size_t entrySize;

@property (nonatomic, readonly) BOOL isEmpty;

@property (nonatomic, readonly) const void *bytes;

@end


#pragma mark - Copying
@interface CBHWedge (Copying) <NSCopying>

- (id)copyWithZone:(nullable NSZone *)zone;

@end


#pragma mark - Equality
@interface CBHWedge (Equality)

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToWedge:(CBHWedge *)other;

- (NSUInteger)hash;

@end


#pragma mark - Conversion
@interface CBHWedge (Conversion)

- (NSData *)data;
- (NSMutableData *)mutableData;
- (CBHSlice *)slice;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;

@end


#pragma mark - Resizing
@interface CBHWedge (Resizing) <CBHCollectionResizable>

- (BOOL)shrink;

- (BOOL)grow;
- (BOOL)growToFit:(NSUInteger)neededCapacity;

- (BOOL)resize:(NSUInteger)newCapacity;

@end


#pragma mark - Swapping and Duplicating Entries
@interface CBHWedge (SwapDuplicate)

- (void)swapValuesAtIndex:(NSUInteger)a andIndex:(NSUInteger)b;
- (BOOL)swapValuesInRange:(NSRange)a andIndex:(NSUInteger)b;

- (void)duplicateValueAtIndex:(NSUInteger)src toIndex:(NSUInteger)dst;
- (void)duplicateValuesInRange:(NSRange)range toIndex:(NSUInteger)dst;

@end


#pragma mark - Clearing Buffer
@interface CBHWedge (Clearing)

- (void)removeAll;
- (void)removeLast:(NSUInteger)count;

@end


#pragma mark - Description
@interface CBHWedge (Description)

- (NSString *)description;
- (NSString *)debugDescription;

@end


#pragma mark - Generic Operations
@interface CBHWedge (GenericOperations)

- (const void *)valueAtIndex:(NSUInteger)index;

- (void)appendValue:(const void *)value;
- (void)setValue:(const void *)value atIndex:(NSUInteger)index;

@end


#pragma mark - Named Byte Operations
@interface CBHWedge (NamedByteOperations)

- (uint8_t)byteAtIndex:(NSUInteger)index;
- (void)appendByte:(uint8_t)value;
- (void)setByte:(uint8_t)value atIndex:(NSUInteger)index;

- (int8_t)signedByteAtIndex:(NSUInteger)index;
- (void)appendSignedByte:(int8_t)value;
- (void)setSignedByte:(int8_t)value atIndex:(NSUInteger)index;

- (uint8_t)unsignedByteAtIndex:(NSUInteger)index;
- (void)appendUnsignedByte:(uint8_t)value;
- (void)setUnsignedByte:(uint8_t)value atIndex:(NSUInteger)index;

@end


#pragma mark - Named Integer Operations
@interface CBHWedge (NamedIntegerOperations)

- (NSInteger)integerAtIndex:(NSUInteger)index;
- (void)appendInteger:(NSInteger)value;
- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index;

- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index;
- (void)appendUnsignedInteger:(NSUInteger)value;
- (void)setUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;

@end


#pragma mark - Sized Integer Operations
@interface CBHWedge (SizedIntegerOperations)

- (int8_t)int8AtIndex:(NSUInteger)index;
- (void)appendInt8:(int8_t)value;
- (void)setInt8:(int8_t)value atIndex:(NSUInteger)index;

- (uint8_t)uint8AtIndex:(NSUInteger)index;
- (void)appendUInt8:(uint8_t)value;
- (void)setUInt8:(uint8_t)value atIndex:(NSUInteger)index;

- (int16_t)int16AtIndex:(NSUInteger)index;
- (void)appendInt16:(int16_t)value;
- (void)setInt16:(int16_t)value atIndex:(NSUInteger)index;

- (uint16_t)uint16AtIndex:(NSUInteger)index;
- (void)appendUInt16:(uint16_t)value;
- (void)setUInt16:(uint16_t)value atIndex:(NSUInteger)index;

- (int32_t)int32AtIndex:(NSUInteger)index;
- (void)appendInt32:(int32_t)value;
- (void)setInt32:(int32_t)value atIndex:(NSUInteger)index;

- (uint32_t)uint32AtIndex:(NSUInteger)index;
- (void)appendUInt32:(uint32_t)value;
- (void)setUInt32:(uint32_t)value atIndex:(NSUInteger)index;

- (int64_t)int64AtIndex:(NSUInteger)index;
- (void)appendInt64:(int64_t)value;
- (void)setInt64:(int64_t)value atIndex:(NSUInteger)index;

- (uint64_t)uint64AtIndex:(NSUInteger)index;
- (void)appendUInt64:(uint64_t)value;
- (void)setUInt64:(uint64_t)value atIndex:(NSUInteger)index;

@end


#pragma mark - Named Float Accessors
@interface CBHWedge (NamedFloatAccessors)

- (CGFloat)cgfloatAtIndex:(NSUInteger)index;
- (void)appendCGFloat:(CGFloat)value;
- (void)setCGFloat:(CGFloat)value atIndex:(NSUInteger)index;

- (float)floatAtIndex:(NSUInteger)index;
- (void)appendFloat:(float)value;
- (void)setFloat:(float)value atIndex:(NSUInteger)index;

- (double)doubleAtIndex:(NSUInteger)index;
- (void)appendDouble:(double)value;
- (void)setDouble:(double)value atIndex:(NSUInteger)index;

- (long double)longDoubleAtIndex:(NSUInteger)index;
- (void)appendLongDouble:(long double)value;
- (void)setLongDouble:(long double)value atIndex:(NSUInteger)index;

@end


#pragma mark - Character Accessors
@interface CBHWedge (CharacterAccessors)

- (char)charAtIndex:(NSUInteger)index;
- (void)appendChar:(char)value;
- (void)setChar:(char)value atIndex:(NSUInteger)index;

- (unsigned char)unsignedCharAtIndex:(NSUInteger)index;
- (void)appendUnsignedChar:(unsigned char)value;
- (void)setUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index;

@end


#pragma mark - Buffer Creation
@interface CBHSlice (Buffer)

- (CBHWedge *)wedge;

@end

NS_ASSUME_NONNULL_END
