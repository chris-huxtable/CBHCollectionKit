//  CBHStack.m
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

#import "CBHStack.h"
#import "_CBHStack.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHStack ()
{
	@protected
	CBHStack_t _stack;
}


#pragma mark - Initialization

- (instancetype)initWithFirstObject:(id)object andArgumentList:(va_list)argList;

@end

NS_ASSUME_NONNULL_END


@implementation CBHStack


#define DEFAULT_CAPACITY 8
#define GROWTH_FACTOR 1.618033988749895

#define _nextCapacity(aCapacity) (size_t)ceil((double)(aCapacity) * GROWTH_FACTOR)
#define _growIfNeeded() if ( _stack._capacity <= _stack._count ) { CBHSlice_setCapacity((CBHSlice_t *)&_stack, _nextCapacity(_stack._capacity), NO); }

#define _pointerAtIndex(aSlice, anIndex) CBHSlice_pointerAtOffset((CBHSlice_t *)(aSlice), (anIndex))
#define _objectAtIndex(aSlice, anIndex) ((id)_pointerAtIndex((aSlice), (anIndex)))

#define _objectArray() (id *)_stack._data

#define _pushObject(aQueue, anObject)\
{\
	[anObject retain];\
	CBHStack_pushValue((aQueue), &(anObject));\
}
#define _popObject() [(id)CBHStack_popValue(&_stack) autorelease]
#define _peekObject() (id)CBHStack_peekValue(&_stack)

#define _guardNotEmpty(retVal) if ( _stack._count <= 0 ) return (retVal)
#define _guardValidIndex(anIndex, retVal) if ( (anIndex) >= _stack._count ) return (retVal)


#pragma mark - Factories

+ (instancetype)stack
{
	return [[(CBHStack *)[self alloc] initWithCapacity:DEFAULT_CAPACITY] autorelease];
}

+ (instancetype)stackWithCapacity:(NSUInteger)capacity
{
	return [[(CBHStack *)[self alloc] initWithCapacity:capacity] autorelease];
}

+ (instancetype)stackWithObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	CBHStack *stack = [(CBHStack *)[self alloc] initWithFirstObject:object andArgumentList:arguments];

	va_end(arguments);
	return [stack autorelease];
}


+ (instancetype)stackWithArray:(NSArray *)array
{
	return [[(CBHStack *)[self alloc] initWithArray:array] autorelease];
}

+ (instancetype)stackWithOrderedSet:(NSOrderedSet *)set
{
	return [[(CBHStack *)[self alloc] initWithOrderedSet:set] autorelease];
}

+ (instancetype)stackWithEnumerator:(NSEnumerator *)enumerator
{
	return [[(CBHStack *)[self alloc] initWithEnumerator:enumerator] autorelease];
}


#pragma mark - Initialization

- (instancetype)init
{
	return [self initWithCapacity:DEFAULT_CAPACITY];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
	if ( (self = [super init]) )
	{
		_stack = CBHStack_init(capacity, sizeof(id));
	}

	return self;
}

- (instancetype)initWithObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	CBHStack *stack = [self initWithFirstObject:object andArgumentList:arguments];

	va_end(arguments);
	return stack;
}

- (instancetype)initWithFirstObject:(id)object andArgumentList:(va_list)argList
{
	if ( (self = [self init]) )
	{
		id __nullable current = object;
		while ( current )
		{
			[self pushObject:current];
			current = va_arg(argList, id);
		}

		va_end(argList);
	}

	return self;
}


- (instancetype)initWithArray:(NSArray *)array
{
	if ( (self = [self initWithCapacity:[array count]]) )
	{
		[self pushObjectsFromArray:array];
	}

	return self;
}

- (instancetype)initWithOrderedSet:(NSOrderedSet *)set
{
	if ( (self = [self initWithCapacity:[set count]]) )
	{
		[self pushObjectsFromOrderedSet:set];
	}

	return self;
}

- (instancetype)initWithEnumerator:(id <NSFastEnumeration>)enumerator
{
	if ( (self = [self init]) )
	{
		[self pushObjectsFromEnumerator:enumerator];
	}

	return self;
}


#pragma mark Destructor

- (void)dealloc
{
	[self removeAllObjects];
	CBHStack_dealloc(&_stack);

	[super dealloc];
}


#pragma mark Properties

- (NSUInteger)count
{
	return _stack._count;
}

- (NSUInteger)capacity
{
	return _stack._capacity;
}

- (BOOL)isEmpty
{
	return ( _stack._count <= 0 );
}


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
	CBHStack *stack = [(CBHStack *)[[self class] allocWithZone:zone] initWithCapacity:_stack._capacity];

	for (id object in self)
	{
		_pushObject(&stack->_stack, object);
	}

	return stack;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
	if ( [other isKindOfClass:[CBHStack class]] ) return [self isEqualToStack:other];
	return [super isEqual:other];
}

- (BOOL)isEqualToStack:(CBHStack *)other
{
	/// Catch trivial cases.
	if ( self == other ) return YES;
	if ( _stack._count != other->_stack._count ) return NO;
	if ( _stack._count <= 0 ) return YES;

	/// Compare entries.
	for (NSUInteger i = 0; i < _stack._count; ++i)
	{
		id object0 = _objectAtIndex(&_stack, i);
		id object1 = _objectAtIndex(&other->_stack, i);

		/// Early return on failure.
		if ( ![object0 isEqual:object1] ) return NO;
	}

	return YES;
}

- (NSUInteger)hash
{
	/// Mix in properties.
	NSUInteger hash = ((_stack._capacity * 3) * 31);

	/// XOR in middle object hash.
	if ( _stack._count >= 3 )
	{
		hash ^= [_objectAtIndex(&_stack, (NSUInteger)((float)_stack._count / 2.0f)) hash] * 71;
	}

	/// XOR in last object hash.
	if ( _stack._count >= 2 )
	{
		hash ^= [_objectAtIndex(&_stack, _stack._count - 1) hash] * 61;
	}

	/// XOR in first object hash.
	if ( _stack._count >= 1 )
	{
		hash ^= [_objectAtIndex(&_stack, 0) hash] * 41;
	}

	return hash;
}


#pragma mark - Description

- (NSString *)description
{
	NSMutableString *description = [NSMutableString string];

	[description appendString:@"("];

	BOOL firstLoop = YES;
	for (id object in self)
	{
		if ( !firstLoop ) { [description appendFormat:@",\n\t%@", object]; }
		else
		{
			[description appendFormat:@"\n\t%@", object];
			firstLoop = NO;
		}
	}
	[description appendString:@"\n)"];

	return [NSString stringWithString:description];
}

- (NSString *)debugDescription
{
	NSString *properties = [NSString stringWithFormat:@"\n{\n\tcapacity: %lu,\n\tcount: %lu\n},\n", _stack._capacity, _stack._count];
	return [NSString stringWithFormat:@"<%@: %p>%@%@", [self class], (void *)self, properties, [self description]];
}


#pragma mark - Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
	// Return early if second iteration.
	if ( state->state != 0 ) return 0;

	/// Return the data directly.
	state->mutationsPtr = (unsigned long *)(__bridge void *)self;
	state->itemsPtr = _objectArray();
	state->state = 1;
	return _stack._count;
}


#pragma mark - Conversion

- (NSArray *)array
{
	return [NSArray arrayWithObjects:_objectArray() count:_stack._count];
}

- (NSMutableArray *)mutableArray
{
	return [NSMutableArray arrayWithObjects:_objectArray() count:_stack._count];
}

- (NSOrderedSet *)orderedSet
{
	return [NSOrderedSet orderedSetWithObjects:_objectArray() count:_stack._count];
}

- (NSMutableOrderedSet *)mutableOrderedSet
{
	return [NSMutableOrderedSet orderedSetWithObjects:_objectArray() count:_stack._count];
}


#pragma mark - Accessors

- (id)peekAtObject
{
	return _peekObject();
}

- (id)peekAtObjectFromTop:(NSUInteger)index
{
	if ( index >= _stack._count ) return nil;
	index = _stack._count - 1 - index;
	_guardValidIndex(index, nil);
	return _objectAtIndex(&_stack, index);
}

- (id)peekAtObjectFromBottom:(NSUInteger)index
{
	_guardValidIndex(index, nil);
	return _objectAtIndex(&_stack, index);
}


#pragma mark - Mutators

- (void)pushObject:(id)object
{
	_growIfNeeded();

	_pushObject(&_stack, object);
}

- (id)popObject
{
	_guardNotEmpty(nil);
	return _popObject();
}


- (void)pushObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	id __nullable current = object;
	while ( current )
	{
		[self pushObject:current];
		current = va_arg(arguments, id);
	}

	va_end(arguments);
}

- (void)pushObjectsFromArray:(NSArray *)array
{
	[self growToFit:([array count] + _stack._count)];
	for (id object in array) { _pushObject(&_stack, object); }
}

- (void)pushObjectsFromOrderedSet:(NSOrderedSet *)set
{
	[self growToFit:([set count] + _stack._count)];
	for (id object in set) { _pushObject(&_stack, object); }
}

- (void)pushObjectsFromEnumerator:(id <NSFastEnumeration>)enumerator
{
	for (id object in enumerator) { [self pushObject:object]; }
}


- (void)removeAllObjects
{
	/// Release stored objects.
	for (NSUInteger i = 0; i < _stack._count; ++i)
	{
		CFRelease(_pointerAtIndex(&_stack, i));
	}

	/// Reset the counter.
	_stack._count = 0;
}


#pragma mark - Resizing

- (BOOL)shrink
{
	/// Prevent empty capacity.
	NSUInteger newCapacity = _stack._count;
	if ( newCapacity < 1 ) newCapacity = 1;

	/// Shrink.
	CBHSlice_setCapacity((CBHSlice_t *)&_stack, newCapacity, NO);
	return YES;
}

- (BOOL)grow
{
	/// Early return if growth unnecessary.
	if ( _stack._capacity > _stack._count ) return NO;

	/// Grow.
	CBHSlice_setCapacity((CBHSlice_t *)&_stack, _nextCapacity(_stack._capacity), NO);
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
	CBHSlice_setCapacity((CBHSlice_t *)&_stack, nextCapacity, NO);
	return YES;
}

- (BOOL)resize:(NSUInteger)newCapacity
{
	/// Early return if resize unnecessary.
	if ( newCapacity <= 0 ) return NO;
	if ( newCapacity == _stack._capacity ) return NO;
	if ( newCapacity < _stack._count ) return NO;

	/// Resize.
	CBHSlice_setCapacity((CBHSlice_t *)&_stack, newCapacity, NO);
	return YES;
}

@end
