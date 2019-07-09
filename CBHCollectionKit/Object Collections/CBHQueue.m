//  CBHQueue.m
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

#import "CBHQueue.h"
#import "_CBHQueue.h"


#define DEFAULT_CAPACITY 8
#define GROWTH_FACTOR 1.618033988749895

#define _nextCapacity(aCapacity) (size_t)ceil((double)(aCapacity) * GROWTH_FACTOR)

#define _pointerAtIndex(aQueue, anIndex) CBHQueue_pointerAtIndex((aQueue), (anIndex))
#define _objectAtIndex(aQueue, anIndex) ((__bridge id __unsafe_unretained)_pointerAtIndex((aQueue), (anIndex)))

#define _objectArray() (id __unsafe_unretained *)CBHQueue_pointerToIndex(&_queue, 0)

#define _enqueueObject(aQueue, anObject)\
{\
	CFBridgingRetain(anObject);\
	CBHQueue_enqueue((aQueue), &(anObject));\
}
#define _dequeueObject() CFBridgingRelease(CBHQueue_dequeue(&_queue))
#define _peekObject() (__bridge id __unsafe_unretained)CBHQueue_peek(&_queue)

#define _guardNotEmpty(retVal) if ( _queue._count <= 0 ) return (retVal)


NS_ASSUME_NONNULL_BEGIN

@interface CBHQueue ()
{
	CBHQueue_t _queue;
}

@end

NS_ASSUME_NONNULL_END


@implementation CBHQueue

#pragma mark Factories

+ (instancetype)queue
{
	return [(CBHQueue *)[self alloc] initWithCapacity:DEFAULT_CAPACITY];
}

+ (instancetype)queueWithCapacity:(NSUInteger)capacity
{
	return [(CBHQueue *)[self alloc] initWithCapacity:capacity];
}

+ (instancetype)queueWithObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	CBHQueue *queue = [(CBHQueue *)[self alloc] initWithFirstObject:object andArgumentList:arguments];

	va_end(arguments);
	return queue;
}


+ (instancetype)queueWithArray:(NSArray *)array
{
	return [(CBHQueue *)[self alloc] initWithArray:array];
}

+ (instancetype)queueWithOrderedSet:(NSOrderedSet *)set
{
	return [(CBHQueue *)[self alloc] initWithOrderedSet:set];
}

+ (instancetype)queueWithEnumerator:(NSEnumerator *)enumerator
{
	return [(CBHQueue *)[self alloc] initWithEnumerator:enumerator];
}


#pragma mark Initialization

- (instancetype)init
{
	return [self initWithCapacity:DEFAULT_CAPACITY];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
	if ( (self = [super init]) )
	{
		_queue = CBHQueue_init(capacity, sizeof(id));
	}

	return self;
}

- (instancetype)initWithObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	CBHQueue *queue = [self initWithFirstObject:object andArgumentList:arguments];

	va_end(arguments);
	return queue;
}

- (instancetype)initWithFirstObject:(id)object andArgumentList:(va_list)argList
{
	if ( (self = [self init]) )
	{
		while ( object )
		{
			[self enqueueObject:object];
			object = va_arg(argList, id);
		}

		va_end(argList);
	}

	return self;
}


- (instancetype)initWithArray:(NSArray *)array
{
	if ( (self = [self initWithCapacity:[array count]]) )
	{
		[self enqueueObjectsFromArray:array];
	}

	return self;
}

- (instancetype)initWithOrderedSet:(NSOrderedSet *)set
{
	if ( (self = [self initWithCapacity:[set count]]) )
	{
		[self enqueueObjectsFromOrderedSet:set];
	}

	return self;
}

- (instancetype)initWithEnumerator:(NSEnumerator *)enumerator
{
	if ( (self = [self init]) )
	{
		[self enqueueObjectsFromEnumerator:enumerator];
	}

	return self;
}


#pragma mark - Destructor

- (void)dealloc
{
	[self removeAllObjects];
	CBHQueue_dealloc(&_queue);
}


#pragma mark - Properties

- (NSUInteger)count
{
	return _queue._count;
}

- (NSUInteger)capacity
{
	return _queue._capacity;
}

- (BOOL)isEmpty
{
	return ( _queue._count <= 0 );
}

@end


#pragma mark - Copying
@implementation CBHQueue (Copying)

- (id)copyWithZone:(nullable NSZone *)zone
{
	CBHQueue *queue = [(CBHQueue *)[[self class] allocWithZone:zone] initWithCapacity:_queue._count];

	for (id object in self)
	{
		_enqueueObject(&queue->_queue, object);
	}

	return queue;
}

@end


#pragma mark - Equality
@implementation CBHQueue (Equality)

- (BOOL)isEqual:(id)other
{
	if ( [other isKindOfClass:[CBHQueue class]] ) return [self isEqualToQueue:other];
	return [super isEqual:other];
}

- (BOOL)isEqualToQueue:(CBHQueue *)other
{
	/// Catch trivial cases.
	if ( self == other ) return YES;
	if ( _queue._count != other->_queue._count ) return NO;
	if ( _queue._count <= 0 ) return YES;

	/// Compare entries.
	for (NSUInteger i = 0; i < _queue._count; ++i)
	{
		id object0 = _objectAtIndex(&_queue, i);
		id object1 = _objectAtIndex(&other->_queue, i);

		/// Early return on failure.
		if ( ![object0 isEqual:object1] ) return NO;
	}

	return YES;
}

- (NSUInteger)hash
{
	/// Mix in properties.
	NSUInteger hash = ((_queue._capacity * 3) * 31);
	NSUInteger count = _queue._count;

	/// XOR in middle object hash.
	if ( count >= 3 )
	{
		hash ^= [_objectAtIndex(&_queue, (NSUInteger)((float)count / 2.0f)) hash] * 71;
	}

	/// XOR in last object hash.
	if ( count >= 2 )
	{
		hash ^= [_objectAtIndex(&_queue, count - 1) hash] * 61;
	}

	/// XOR in first object hash.
	if ( count >= 1 )
	{
		hash ^= [_objectAtIndex(&_queue, 0) hash] * 41;
	}

	return hash;
}

@end


#pragma mark - Description
@implementation CBHQueue (Description)

- (NSString *)description
{
	NSMutableString *description = [NSMutableString stringWithString:@"("];

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

	return [NSString stringWithFormat:@"%@\n)", description];
}

- (NSString *)debugDescription
{
	NSString *properties = [NSString stringWithFormat:@"{\n\tcapacity: %lu,\n\tcount: %lu,\n\toffset: %lu\n},\n", _queue._capacity, _queue._count, _queue._offset];
	return [NSString stringWithFormat:@"<%@: %p>\n%@%@", [self class], (void *)self, properties, [self description]];
}

@end


#pragma mark - Fast Enumeration
@implementation CBHQueue (FastEnumeration)

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
	/// If data is contiguous use it directly.
	if ( !CBHQueue_isSegmented(&_queue) )
	{
		/// Return early if second iteration.
		if ( state->state > 0 ) return 0;

		state->mutationsPtr = (unsigned long *)(__bridge void *)self;
		state->itemsPtr = _objectArray();
		state->state = 1;
		return _queue._count;
	}

	/// If data is not contiguous.
	if ( state->state == 0 )
	{
		/// Return the first half.
		state->state = 1;
		state->mutationsPtr = (unsigned long *)(__bridge void *)self;
		state->itemsPtr = _objectArray();
		return _queue._capacity - _queue._offset;
	}
	else if ( state->state == 1 )
	{
		/// And then the second half.
		state->state = 2;
		state->itemsPtr = (id __unsafe_unretained *)_queue._data;
		return _queue._count - (_queue._capacity - _queue._offset);
	}

	return 0;
}

@end


#pragma mark - Conversion
@implementation CBHQueue (Conversion)

- (NSArray *)array
{
	/// If data is contiguous create the new collection from the raw data.
	if ( !CBHQueue_isSegmented(&_queue) ) { return [NSArray arrayWithObjects:_objectArray() count:_queue._count]; }

	/// Otherwise fill a new array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHQueue_fillArrayWithObjects(&_queue, array);

	/// Load entries from stack into new collection and return.
	return [NSArray arrayWithObjects:array count:_queue._count];
}

- (NSMutableArray *)mutableArray
{
	/// If data is contiguous create the new collection from the raw data.
	if ( !CBHQueue_isSegmented(&_queue) ) { return [NSMutableArray arrayWithObjects:_objectArray() count:_queue._count]; }

	/// Otherwise fill a new array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHQueue_fillArrayWithObjects(&_queue, array);

	/// Load entries from stack into new collection and return.
	return [NSMutableArray arrayWithObjects:array count:_queue._count];
}

- (NSOrderedSet *)orderedSet
{
	/// If data is contiguous create the new collection from the raw data.
	if ( !CBHQueue_isSegmented(&_queue) ) { return [NSOrderedSet orderedSetWithObjects:_objectArray() count:_queue._count]; }

	/// Otherwise fill a new array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHQueue_fillArrayWithObjects(&_queue, array);

	/// Load entries from stack into new collection and return.
	return [NSOrderedSet orderedSetWithObjects:array count:_queue._count];
}

- (NSMutableOrderedSet *)mutableOrderedSet
{
	/// If data is contiguous create the new collection from the raw data.
	if ( !CBHQueue_isSegmented(&_queue) ) { return [NSMutableOrderedSet orderedSetWithObjects:_objectArray() count:_queue._count]; }

	/// Otherwise fill a new array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHQueue_fillArrayWithObjects(&_queue, array);

	/// Load entries from stack into new collection and return.
	return [NSMutableOrderedSet orderedSetWithObjects:array count:_queue._count];
}

@end


#pragma mark - Accessors
@implementation CBHQueue (Accessors)

- (id)peekAtObject
{
	_guardNotEmpty(nil);
	return _peekObject();
}


- (id)objectAtIndex:(NSUInteger)index
{
	return _objectAtIndex(&_queue, index);
}

@end


#pragma mark - Mutators
@implementation CBHQueue (Mutators)

- (void)enqueueObject:(id)object
{
	_enqueueObject(&_queue, object);
}

- (id)dequeueObject
{
	return _dequeueObject();
}


- (void)enqueueObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	while ( object )
	{
		_enqueueObject(&_queue, object);
		object = va_arg(arguments, id);
	}

	va_end(arguments);
}

- (void)enqueueObjectsFromArray:(NSArray *)array
{
	/// Grow once to fit addition objects.
	[self growToFit:([array count] + _queue._count)];

	/// Enqueue objects.
	for (id object in array) { _enqueueObject(&_queue, object); }
}

- (void)enqueueObjectsFromOrderedSet:(NSOrderedSet *)set
{
	/// Grow once to fit addition objects.
	[self growToFit:([set count] + _queue._count)];

	/// Enqueue objects.
	for (id object in set) { _enqueueObject(&_queue, object); }
}

- (void)enqueueObjectsFromEnumerator:(id <NSFastEnumeration>)enumerator
{
	/// Enqueue objects.
	for (id object in enumerator) { _enqueueObject(&_queue, object); }
}


- (NSArray *)dequeueObjects:(NSUInteger)count
{
	/// Catch trivial empty case.
	if ( count == 0 ) { return @[]; }

	id object;
	id array[count];
	NSUInteger index = 0;

	/// Store entries on stack temporarily.
	while ( index < count && (object = [self dequeueObject]) )
	{
		array[index] = object;
		++index;
	}

	/// Load entries into `NSArray` and return.
	return [NSArray arrayWithObjects:array count:index];
}


- (void)removeAllObjects
{
	/// Release stored objects.
	for (NSUInteger i = 0; i < _queue._count; ++i)
	{
		CFRelease(_pointerAtIndex(&_queue, i));
	}

	/// Reset the counter and offset.
	_queue._count = 0;
	_queue._offset = 0;
}

@end


#pragma mark - Resizing
@implementation CBHQueue (Resizing)

- (BOOL)shrink
{
	/// Prevent empty capacity.
	NSUInteger newCapacity = _queue._count;
	if ( newCapacity < 1 ) newCapacity = 1;

	/// Shrink.
	return CBHQueue_shrinkTo(&_queue, newCapacity);
}

- (BOOL)grow
{
	/// Early return if growth unnecessary.
	if ( _queue._capacity > _queue._count ) return NO;

	/// Grow.
	return CBHQueue_growTo(&_queue, _nextCapacity(_queue._capacity));
}

- (BOOL)growToFit:(NSUInteger)neededCapacity
{
	/// Early return if growth unnecessary.
	if ( neededCapacity <= _queue._capacity ) return NO;

	/// Find new capacity which fits the needed capacity.
	NSUInteger nextCapacity = _queue._capacity;
	while ( neededCapacity > nextCapacity ) { nextCapacity = _nextCapacity(nextCapacity); }

	/// Grow to new capacity.
	CBHQueue_growTo(&_queue, nextCapacity);
	return YES;
}

- (BOOL)resize:(NSUInteger)newCapacity
{
	return CBHQueue_resize(&_queue, newCapacity);
}

@end
