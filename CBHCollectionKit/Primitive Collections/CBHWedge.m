//  CBHWedge.m
//  CBHCollectionKit
//
//  Created by Christian Huxtable <chris@huxtable.ca>, June 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.
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

#import "CBHWedge.h"
#import "_CBHStack.h"

@import CBHMemoryKit;


#define DEFAULT_CAPACITY 8
#define GROWTH_FACTOR 1.618033988749895

#define _checkEntrySize(aType) if (_stack._entrySize != sizeof(aType)) @throw CBHEntrySizeException
#define _checkSettableIndex(anIndex) if ( (anIndex) > _stack._count ) @throw NSRangeException
#define _checkReadableIndex(anIndex) if ( (anIndex) >= _stack._count ) @throw NSRangeException

#define _typeAtIndex(aType, anIndex) *((aType *)CBHSlice_pointerToOffset((CBHSlice_t *)&_stack, (anIndex)))

#define _nextCapacity(aCapacity) (size_t)ceil((double)(aCapacity) * GROWTH_FACTOR)
#define _growIfNeeded() if ( _stack._capacity <= _stack._count ) { CBHStack_setCapacity(&_stack, _nextCapacity(_stack._capacity)); }

#define _setValueAtIndex(aValue, anIndex)\
{\
	if ( (anIndex) == _stack._count )\
	{\
		_appendValue(&_stack, aValue);\
	}\
	else\
	{\
		CBHStack_setValueAtIndex(&_stack, (aValue), (anIndex));\
	}\
}

#define _appendValue(aStack, aValue)\
{\
	_growIfNeeded();\
	CBHStack_pushValue((aStack), (aValue));\
}


@interface CBHWedge ()
{
	CBHStack_t _stack;
}

@end


@implementation CBHWedge

#pragma mark - Factories

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize
{
	return [[(CBHWedge *)[self alloc] initWithEntrySize:entrySize] autorelease];
}

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity
{
	return [[(CBHWedge *)[self alloc] initWithEntrySize:entrySize andCapacity:capacity] autorelease];
}

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes
{
	return [[(CBHWedge *)[self alloc] initWithEntrySize:entrySize copying:count entriesFromBytes:bytes] autorelease];
}

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity copying:(NSUInteger)count entriesFromBytes:(const void *)bytes
{
	return [[(CBHWedge *)[self alloc] initWithEntrySize:entrySize andCapacity:capacity copying:count entriesFromBytes:bytes] autorelease];
}


+ (instancetype)wedgeWithSlice:(CBHSlice *)slice
{
	return [[(CBHWedge *)[self alloc] initWithSlice:slice] autorelease];
}

+ (instancetype)wedgeWithSlice:(CBHSlice *)slice andCapacity:(NSUInteger)capacity
{
	return [[(CBHWedge *)[self alloc] initWithSlice:slice andCapacity:capacity] autorelease];
}


#pragma mark - Initialization

- (instancetype)initWithEntrySize:(size_t)entrySize
{
	return [self initWithEntrySize:entrySize andCapacity:DEFAULT_CAPACITY];
}

- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity
{
	if ( (self = [super init]) )
	{
		_stack = CBHStack_init(capacity, entrySize);
	}

	return self;
}


- (instancetype)initWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes
{
	return [self initWithEntrySize:entrySize andCapacity:count copying:count entriesFromBytes:bytes];
}

- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity copying:(NSUInteger)count entriesFromBytes:(const void *)bytes
{
	if ( count > capacity ) { capacity = count; }
	if ( (self = [super init]) )
	{
		_stack = CBHStack_initCopyingBytesWithCount(bytes, entrySize, capacity, count);
		_stack._count = count;
	}

	return self;
}

- (instancetype)initWithSlice:(CBHSlice *)slice
{
	return [self initWithEntrySize:[slice entrySize] copying:[slice capacity] entriesFromBytes:[slice bytes]];
}

- (instancetype)initWithSlice:(CBHSlice *)slice andCapacity:(NSUInteger)capacity
{
	return [self initWithEntrySize:[slice entrySize] andCapacity:capacity copying:[slice capacity] entriesFromBytes:[slice bytes]];
}


#pragma mark - Destructor

- (void)dealloc
{
	CBHStack_dealloc(&_stack);

	[super dealloc];
}


#pragma mark - Properties

- (NSUInteger)count
{
	return _stack._count;
}

- (NSUInteger)capacity
{
	return _stack._capacity;
}

- (size_t)entrySize
{
	return _stack._entrySize;
}

- (BOOL)isEmpty
{
	return _stack._capacity <= 0;
}

- (const void *)bytes
{
	return _stack._data;
}


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
	return [[CBHWedge allocWithZone:zone] initWithEntrySize:_stack._entrySize andCapacity:_stack._capacity copying:_stack._count entriesFromBytes:_stack._data];
}


#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
	if ( [other isKindOfClass:[CBHWedge class]] ) return [self isEqualToWedge:other];
	return [super isEqual:other];
}

- (BOOL)isEqualToWedge:(CBHWedge *)other
{
	/// Catch trivial cases.
	if ( self == other ) return YES;
	if ( _stack._entrySize != other->_stack._entrySize ) return NO;
	if ( _stack._count != other->_stack._count ) return NO;
	if ( _stack._count <= 0 ) return YES;

	/// Compare the data.
	return CBHMemory_compare(_stack._data, other->_stack._data, _stack._count, _stack._entrySize);
}

- (NSUInteger)hash
{
	/// Mix in properties.
	NSUInteger hash = ((_stack._capacity * 3) ^ (_stack._entrySize * 7) * 31);
	const NSUInteger byteCount = _stack._capacity * _stack._entrySize;

	/// XOR in middle 32/64 bits.
	if ( byteCount >= (sizeof(NSUInteger) + sizeof(NSUInteger) + sizeof(NSUInteger)) )
	{
		size_t middle = (size_t)((byteCount % sizeof(NSUInteger)) / 2.0) * sizeof(NSUInteger);
		hash ^= (*(NSUInteger *)((size_t)_stack._data + middle)) * 71;
	}

	/// XOR in last 32/64 bits.
	if ( byteCount >= (sizeof(NSUInteger) + sizeof(NSUInteger)) )
	{
		hash ^= (*(NSUInteger *)((size_t)_stack._data + (byteCount - sizeof(NSUInteger)))) * 61;
	}

	/// XOR in first 32/64 bits.
	if ( byteCount >= sizeof(NSUInteger) )
	{
		hash ^= (*(NSUInteger *)_stack._data) * 41;
	}

	return hash;
}


#pragma mark - Description

- (NSString *)description
{
	NSMutableString *description = [NSMutableString stringWithString:@"("];

	for (NSUInteger i = 0; i < _stack._capacity; ++i)
	{
		[description appendString:@"\n\t0x"];
		uint8_t *ptr = (uint8_t *)CBHSlice_pointerToOffset((CBHSlice_t *)&_stack, i);
		for (NSUInteger j = _stack._entrySize; j > 0; --j)
		{
			[description appendFormat:@"%x", *(uint8_t *)((size_t)ptr + (j - 1))];
		}
		if ( i != _stack._capacity - 1 ) { [description appendString:@","]; }
	}

	return [NSString stringWithFormat:@"%@\n)", description];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p> %@", [self class], (void *)self, [self description]];
}


#pragma mark - Conversion

- (NSData *)data
{
	return [NSData dataWithBytes:_stack._data length:_stack._capacity];
}

- (NSMutableData *)mutableData
{
	return [NSMutableData dataWithBytes:_stack._data length:_stack._capacity];
}

- (CBHSlice *)slice
{
	return [CBHSlice sliceWithEntrySize:_stack._entrySize copying:_stack._count entriesFromBytes:_stack._data];
}


- (NSString *)stringWithEncoding:(NSStringEncoding)encoding
{
	return [[[NSString alloc] initWithBytes:_stack._data length:_stack._count encoding:encoding] autorelease];
}


#pragma mark - Resizable

- (BOOL)shrink
{
	/// Prevent empty capacity.
	NSUInteger newCapacity = _stack._count;
	if ( newCapacity < 1 ) newCapacity = 1;

	/// Shrink.
	CBHStack_setCapacity(&_stack, newCapacity);
	return YES;
}

- (BOOL)grow
{
	/// Early return if growth unnecessary.
	if ( _stack._capacity > _stack._count ) return NO;

	/// Grow.
	CBHStack_setCapacity(&_stack, _nextCapacity(_stack._capacity));
	return YES;
}

- (BOOL)growToFit:(NSUInteger)neededCapacity
{
	/// Early return if growth unnecessary.
	if ( neededCapacity <= _stack._capacity ) return NO;

	/// Find new capacity which fits the needed capacity.
	NSUInteger nextCapacity = _stack._capacity;
	while ( neededCapacity > nextCapacity ) { nextCapacity = _nextCapacity(nextCapacity); }

	/// Grow.
	CBHStack_setCapacity(&_stack, nextCapacity);
	return YES;
}

- (BOOL)resize:(NSUInteger)newCapacity
{
	/// Early return if resize unnecessary.
	if ( newCapacity <= 0 ) return NO;
	if ( newCapacity == _stack._capacity ) return NO;
	if ( newCapacity < _stack._count ) return NO;

	/// Resize.
	CBHStack_setCapacity(&_stack, newCapacity);
	return YES;
}


#pragma mark - Swapping and Duplicating Entries

- (void)swapValuesAtIndex:(NSUInteger)a andIndex:(NSUInteger)b
{
	CBHSlice_swapValuesAtOffsets((CBHSlice_t *)&_stack, a, b);
}

- (BOOL)swapValuesInRange:(NSRange)a andIndex:(NSUInteger)b
{
	return CBHSlice_swapValuesInRange((CBHSlice_t *)&_stack, a.location, b, a.length);
}


- (void)duplicateValueAtIndex:(NSUInteger)src toIndex:(NSUInteger)dst
{
	CBHSlice_copyValueAtOffset((CBHSlice_t *)&_stack, src, dst);
}

- (void)duplicateValuesInRange:(NSRange)range toIndex:(NSUInteger)dst
{
	CBHSlice_copyValuesInRange((CBHSlice_t *)&_stack, range.location, dst, range.length);
}


#pragma mark - Clearing Wedge

- (void)removeAll
{
	_stack._count = 0;
}

- (void)removeLast:(NSUInteger)count
{
	if ( count >= _stack._count )
	{
		_stack._count = 0;
	}
	else
	{
		_stack._count -= count;
	}
}


#pragma mark - Generic Accessors

- (const void *)valueAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	return CBHSlice_pointerToOffset((CBHSlice_t *)&_stack, index);
}

- (void)appendValue:(const void *)value
{
	_appendValue(&_stack, value);
}

- (void)setValue:(const void *)value atIndex:(NSUInteger)index
{
	_setValueAtIndex(value, index);
}

@end


#pragma mark - Named Byte Accessors

@implementation CBHWedge (NamedByteAccessors)

- (uint8_t)byteAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(uint8_t);
	return _typeAtIndex(uint8_t, index);
}

- (void)appendByte:(uint8_t)value
{
	_checkEntrySize(uint8_t);
	_appendValue(&_stack, &value);
}

- (void)setByte:(uint8_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(uint8_t);
	_setValueAtIndex(&value, index);
}


- (int8_t)signedByteAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(int8_t);
	return _typeAtIndex(int8_t, index);
}

- (void)appendSignedByte:(int8_t)value
{
	_checkEntrySize(int8_t);
	_appendValue(&_stack, &value);
}

- (void)setSignedByte:(int8_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(int8_t);
	_setValueAtIndex(&value, index);
}


- (uint8_t)unsignedByteAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(uint8_t);
	return _typeAtIndex(uint8_t, index);
}

- (void)appendUnsignedByte:(uint8_t)value
{
	_checkEntrySize(uint8_t);
	_appendValue(&_stack, &value);
}

- (void)setUnsignedByte:(uint8_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(uint8_t);
	_setValueAtIndex(&value, index);
}

@end


#pragma mark - Named Integer Accessors

@implementation CBHWedge (NamedIntegerAccessors)

- (NSInteger)integerAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(NSInteger);
	return _typeAtIndex(NSInteger, index);
}

- (void)appendInteger:(NSInteger)value
{
	_checkEntrySize(NSUInteger);
	_appendValue(&_stack, &value);
}

- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index
{
	_checkEntrySize(NSUInteger);
	_setValueAtIndex(&value, index);
}


- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(NSUInteger);
	return _typeAtIndex(NSUInteger, index);
}

- (void)appendUnsignedInteger:(NSUInteger)value
{
	_checkEntrySize(NSUInteger);
	_appendValue(&_stack, &value);
}

- (void)setUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index
{
	_checkEntrySize(NSUInteger);
	_setValueAtIndex(&value, index);
}

@end


#pragma mark - Sized Integer Accessors

@implementation CBHWedge (SizedIntegerAccessors)

- (int8_t)int8AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(int8_t);
	return _typeAtIndex(int8_t, index);
}

- (void)appendInt8:(int8_t)value
{
	_checkEntrySize(int8_t);
	_appendValue(&_stack, &value);
}

- (void)setInt8:(int8_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(int8_t);
	_setValueAtIndex(&value, index);
}


- (uint8_t)uint8AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(uint8_t);
	return _typeAtIndex(uint8_t, index);
}

- (void)appendUInt8:(uint8_t)value
{
	_checkEntrySize(uint8_t);
	_appendValue(&_stack, &value);
}

- (void)setUInt8:(uint8_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(uint8_t);
	_setValueAtIndex(&value, index);
}


- (int16_t)int16AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(int16_t);
	return _typeAtIndex(int16_t, index);
}

- (void)appendInt16:(int16_t)value
{
	_checkEntrySize(int16_t);
	_appendValue(&_stack, &value);
}

- (void)setInt16:(int16_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(int16_t);
	_setValueAtIndex(&value, index);
}


- (uint16_t)uint16AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(uint16_t);
	return _typeAtIndex(uint16_t, index);
}

- (void)appendUInt16:(uint16_t)value
{
	_checkEntrySize(uint16_t);
	_appendValue(&_stack, &value);
}

- (void)setUInt16:(uint16_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(uint16_t);
	_setValueAtIndex(&value, index);
}


- (int32_t)int32AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(int32_t);
	return _typeAtIndex(int32_t, index);
}

- (void)appendInt32:(int32_t)value
{
	_checkEntrySize(int32_t);
	_appendValue(&_stack, &value);
}

- (void)setInt32:(int32_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(int32_t);
	_setValueAtIndex(&value, index);
}


- (uint32_t)uint32AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(uint32_t);
	return _typeAtIndex(uint32_t, index);
}

- (void)appendUInt32:(uint32_t)value
{
	_checkEntrySize(uint32_t);
	_appendValue(&_stack, &value);
}

- (void)setUInt32:(uint32_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(uint32_t);
	_setValueAtIndex(&value, index);
}


- (int64_t)int64AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(int64_t);
	return _typeAtIndex(int64_t, index);
}

- (void)appendInt64:(int64_t)value
{
	_checkEntrySize(int64_t);
	_appendValue(&_stack, &value);
}

- (void)setInt64:(int64_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(int64_t);
	_setValueAtIndex(&value, index);
}


- (uint64_t)uint64AtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(uint64_t);
	return _typeAtIndex(uint64_t, index);
}

- (void)appendUInt64:(uint64_t)value
{
	_checkEntrySize(uint64_t);
	_appendValue(&_stack, &value);
}

- (void)setUInt64:(uint64_t)value atIndex:(NSUInteger)index
{
	_checkEntrySize(uint64_t);
	_setValueAtIndex(&value, index);
}

@end


#pragma mark - Named Float Accessors

@implementation CBHWedge (NamedFloatAccessors)

- (CGFloat)cgfloatAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(CGFloat);
	return _typeAtIndex(CGFloat, index);
}

- (void)appendCGFloat:(CGFloat)value
{
	_checkEntrySize(CGFloat);
	_appendValue(&_stack, &value);
}

- (void)setCGFloat:(CGFloat)value atIndex:(NSUInteger)index
{
	_checkEntrySize(CGFloat);
	_setValueAtIndex(&value, index);
}


- (float)floatAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(float);
	return _typeAtIndex(float, index);
}

- (void)appendFloat:(float)value
{
	_checkEntrySize(float);
	_appendValue(&_stack, &value);
}

- (void)setFloat:(float)value atIndex:(NSUInteger)index
{
	_checkEntrySize(float);
	_setValueAtIndex(&value, index);
}


- (double)doubleAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(double);
	return _typeAtIndex(double, index);
}

- (void)appendDouble:(double)value
{
	_checkEntrySize(double);
	_appendValue(&_stack, &value);
}

- (void)setDouble:(double)value atIndex:(NSUInteger)index
{
	_checkEntrySize(double);
	_setValueAtIndex(&value, index);
}


- (long double)longDoubleAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(long double);
	return _typeAtIndex(long double, index);
}

- (void)appendLongDouble:(long double)value
{
	_checkEntrySize(long double);
	_appendValue(&_stack, &value);
}

- (void)setLongDouble:(long double)value atIndex:(NSUInteger)index
{
	_checkEntrySize(long double);
	_setValueAtIndex(&value, index);
}

@end


#pragma mark - Character Accessors

@implementation CBHWedge (CharacterAccessors)

- (char)charAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(char);
	return _typeAtIndex(char, index);
}

- (void)appendChar:(char)value
{
	_checkEntrySize(char);
	_appendValue(&_stack, &value);
}

- (void)setChar:(char)value atIndex:(NSUInteger)index
{
	_checkEntrySize(char);
	_setValueAtIndex(&value, index);
}


- (unsigned char)unsignedCharAtIndex:(NSUInteger)index
{
	_checkReadableIndex(index);
	_checkEntrySize(unsigned char);
	return _typeAtIndex(unsigned char, index);
}

- (void)appendUnsignedChar:(unsigned char)value
{
	_checkEntrySize(unsigned char);
	_appendValue(&_stack, &value);
}

- (void)setUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index
{
	_checkEntrySize(unsigned char);
	_setValueAtIndex(&value, index);
}

@end


#pragma mark - Wedge from Slice

@implementation CBHSlice (Wedge)

- (CBHWedge *)wedge
{
	return [CBHWedge wedgeWithEntrySize:[self entrySize] copying:[self capacity] entriesFromBytes:[self bytes]];
}

@end
