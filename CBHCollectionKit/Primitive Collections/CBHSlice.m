//  CBHSlice.m
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

#import "CBHSlice.h"
#import "_CBHSlice.h"

#import "CBHWedge.h"

@import CBHMemoryKit;


#define checkEntrySize(aType) if (_slice._entrySize != sizeof(aType)) @throw CBHEntrySizeException
#define typeAtIndex(aType, anIndex) *((aType *)CBHSlice_pointerToOffset(&_slice, (anIndex)))


@interface CBHSlice ()
{
	@protected
	CBHSlice_t _slice;
}

@end


@implementation CBHSlice


#pragma mark Factories

+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity
{
	return [[(CBHSlice *)[self alloc] initWithEntrySize:entrySize andCapacity:capacity] autorelease];
}

+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity shouldClear:(BOOL)shouldClear
{
	return [[(CBHSlice *)[self alloc] initWithEntrySize:entrySize andCapacity:capacity shouldClear:shouldClear] autorelease];
}

+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity initialValue:(const void *)value
{
	return [[(CBHSlice *)[self alloc] initWithEntrySize:entrySize andCapacity:capacity initialValue:value] autorelease];
}


+ (instancetype)sliceWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes
{
	return [[(CBHSlice *)[self alloc] initWithEntrySize:entrySize copying:count entriesFromBytes:bytes] autorelease];
}

+ (instancetype)sliceWithEntrySize:(size_t)entrySize owning:(NSUInteger)count entriesFromBytes:(void *)bytes
{
	return [[(CBHSlice *)[self alloc] initWithEntrySize:entrySize owning:count entriesFromBytes:bytes] autorelease];
}


#pragma mark Initializers

- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity
{
	return [self initWithEntrySize:entrySize andCapacity:capacity shouldClear:YES];
}

- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity shouldClear:(BOOL)shouldClear
{
	if ( (self = [super init]) )
	{
		_slice = CBHSlice_init(capacity, entrySize, shouldClear);
	}

	return self;
}

- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity initialValue:(const void *)value
{
	if ( (self = [super init]) )
	{
		_slice = CBHSlice_init(capacity, entrySize, NO);
		CBHSlice_setValuesInRange(&_slice, value, 0, capacity);
	}

	return self;
}


- (instancetype)initWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes
{
	if ( (self = [super init]) )
	{
		_slice = CBHSlice_initCopyingBytes(bytes, entrySize, count);
	}

	return self;
}

- (instancetype)initWithEntrySize:(size_t)entrySize owning:(NSUInteger)count entriesFromBytes:(void *)bytes
{
	if ( (self = [super init]) )
	{
		_slice = CBHSlice_initOwningBytes(bytes, entrySize, count);
	}

	return self;
}


#pragma mark Destructor

- (void)dealloc
{
	CBHSlice_dealloc(&_slice);

	[super dealloc];
}


#pragma mark Properties

- (NSUInteger)count
{
	return _slice._capacity;
}

- (NSUInteger)capacity
{
	return _slice._capacity;
}

- (size_t)entrySize
{
	return _slice._entrySize;
}

- (BOOL)isEmpty
{
	return ( _slice._capacity <= 0 );
}

- (const void *)bytes
{
	return _slice._data;
}

@end


#pragma mark - Copying
@implementation CBHSlice (Copying)

- (id)copyWithZone:(NSZone *)zone
{
	/// Object is immutable. Return self.
	return [self retain];
}

@end


#pragma mark - Equality
@implementation CBHSlice (Equality)

- (BOOL)isEqual:(id)other
{
	if ( [other isKindOfClass:[CBHSlice class]] ) return [self isEqualToSlice:other];
	return [super isEqual:other];
}

- (BOOL)isEqualToSlice:(CBHSlice *)other
{
	/// Catch trivial cases.
	if ( self == other ) return YES;
	if ( _slice._entrySize != other->_slice._entrySize ) return NO;
	if ( _slice._capacity != other->_slice._capacity ) return NO;

	/// Compare the data.
	return CBHMemory_compare(_slice._data, other->_slice._data, _slice._capacity, _slice._entrySize);
}

- (NSUInteger)hash
{
	/// Mix in properties.
	NSUInteger hash = ((_slice._capacity * 3) ^ (_slice._entrySize * 7) * 31);
	const NSUInteger byteCount = _slice._capacity * _slice._entrySize;

	/// XOR in middle 32/64 bits
	if ( byteCount >= (sizeof(NSUInteger) + sizeof(NSUInteger) + sizeof(NSUInteger)) )
	{
		size_t middle = (size_t)((byteCount % sizeof(NSUInteger)) / 2.0) * sizeof(NSUInteger);
		hash ^= (*(NSUInteger *)((size_t)_slice._data + middle)) * 71;
	}

	/// XOR in last 32/64 bits
	if ( byteCount >= (sizeof(NSUInteger) + sizeof(NSUInteger)) )
	{
		hash ^= (*(NSUInteger *)((size_t)_slice._data + (byteCount - sizeof(NSUInteger)))) * 61;
	}

	/// XOR in first 32/64 bits
	if ( byteCount >= sizeof(NSUInteger) )
	{
		hash ^= (*(NSUInteger *)_slice._data) * 41;
	}

	return hash;
}

@end


#pragma mark - Description
@implementation CBHSlice (Description)

- (NSString *)description
{
	NSMutableString *description = [NSMutableString stringWithString:@"("];

	for (NSUInteger i = 0; i < _slice._capacity; ++i)
	{
		[description appendString:@"\n\t0x"];
		uint8_t *ptr = (uint8_t *)CBHSlice_pointerToOffset(&_slice, i);
		for (NSUInteger j = _slice._entrySize; j > 0; --j)
		{
			[description appendFormat:@"%x", *(uint8_t *)((size_t)ptr + (j - 1))];
		}
		if ( i != _slice._capacity - 1 ) { [description appendString:@","]; }
	}

	return [NSString stringWithFormat:@"%@\n)", description];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p> %@", [self class], (void *)self, [self description]];
}

@end


#pragma mark - Conversion
@implementation CBHSlice (Conversion)

- (NSData *)data
{
	return [NSData dataWithBytes:_slice._data length:_slice._capacity];
}

- (NSMutableData *)mutableData
{
	return [NSMutableData dataWithBytes:_slice._data length:_slice._capacity];
}

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding
{
	return [[[NSString alloc] initWithBytes:_slice._data length:_slice._capacity encoding:encoding] autorelease];
}

@end


#pragma mark - Generic Accessors
@implementation CBHSlice (GenericAccessors)

- (const void *)valueAtIndex:(NSUInteger)index
{
	return CBHSlice_pointerToOffset(&_slice, index);
}

@end


#pragma mark - Named Byte Accessors
@implementation CBHSlice (NamedByteAccessors)

- (uint8_t)byteAtIndex:(NSUInteger)index
{
	checkEntrySize(uint8_t);
	return typeAtIndex(uint8_t, index);
}

- (int8_t)signedByteAtIndex:(NSUInteger)index
{
	checkEntrySize(int8_t);
	return typeAtIndex(int8_t, index);
}

- (uint8_t)unsignedByteAtIndex:(NSUInteger)index
{
	checkEntrySize(uint8_t);
	return typeAtIndex(uint8_t, index);
}

@end


#pragma mark - Named Integer Accessors
@implementation CBHSlice (NamedIntegerAccessors)

- (NSInteger)integerAtIndex:(NSUInteger)index
{
	checkEntrySize(NSInteger);
	return typeAtIndex(NSInteger, index);
}

- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index
{
	checkEntrySize(NSUInteger);
	return typeAtIndex(NSUInteger, index);
}

@end


#pragma mark - Sized Integer Accessors
@implementation CBHSlice (SizedIntegerAccessors)

- (int8_t)int8AtIndex:(NSUInteger)index
{
	checkEntrySize(int8_t);
	return typeAtIndex(int8_t, index);
}

- (uint8_t)uint8AtIndex:(NSUInteger)index
{
	checkEntrySize(uint8_t);
	return typeAtIndex(uint8_t, index);
}


- (int16_t)int16AtIndex:(NSUInteger)index
{
	checkEntrySize(int16_t);
	return typeAtIndex(int16_t, index);
}

- (uint16_t)uint16AtIndex:(NSUInteger)index
{
	checkEntrySize(uint16_t);
	return typeAtIndex(uint16_t, index);
}


- (int32_t)int32AtIndex:(NSUInteger)index
{
	checkEntrySize(int32_t);
	return typeAtIndex(int32_t, index);
}

- (uint32_t)uint32AtIndex:(NSUInteger)index
{
	checkEntrySize(uint32_t);
	return typeAtIndex(uint32_t, index);
}


- (int64_t)int64AtIndex:(NSUInteger)index
{
	checkEntrySize(int64_t);
	return typeAtIndex(int64_t, index);
}

- (uint64_t)uint64AtIndex:(NSUInteger)index
{
	checkEntrySize(uint64_t);
	return typeAtIndex(uint64_t, index);
}

@end


#pragma mark - Named Float Accessors
@implementation CBHSlice (NamedFloatAccessors)

- (CGFloat)cgfloatAtIndex:(NSUInteger)index
{
	checkEntrySize(CGFloat);
	return typeAtIndex(CGFloat, index);
}

- (float)floatAtIndex:(NSUInteger)index
{
	checkEntrySize(float);
	return typeAtIndex(float, index);
}

- (double)doubleAtIndex:(NSUInteger)index
{
	checkEntrySize(double);
	return typeAtIndex(double, index);
}

- (long double)longDoubleAtIndex:(NSUInteger)index
{
	checkEntrySize(long double);
	return typeAtIndex(long double, index);
}

@end


#pragma mark - Character Accessors
@implementation CBHSlice (CharacterAccessors)

- (char)charAtIndex:(NSUInteger)index
{
	checkEntrySize(char);
	return typeAtIndex(char, index);
}

- (unsigned char)unsignedCharAtIndex:(NSUInteger)index
{
	checkEntrySize(unsigned char);
	return typeAtIndex(unsigned char, index);
}

@end
