//  CBHHeap.m
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

#import "CBHHeap.h"
#import "_CBHHeap.h"

@import CBHMemoryKit;


#define DEFAULT_CAPACITY 8
#define GROWTH_FACTOR 1.618033988749895

#define _nextCapacity(aCapacity) (size_t)ceil((double)(aCapacity) * GROWTH_FACTOR)

#define _pointerAtIndex(aQueue, anIndex) CBHQueue_pointerAtIndex((aQueue), (anIndex))
#define _objectAtIndex(aQueue, anIndex) ((id)_pointerAtIndex((aQueue), (anIndex)))

#define _insertObject(aHeap, anObject)\
{\
	CFRetain(anObject);\
	CBHHeap_insertValue((aHeap), &(anObject), _comparator);\
}
#define _extractObject() [(id)CBHHeap_extractValue(&_queue, _comparator) autorelease]
#define _peekObject() (id)CBHQueue_peek(&_queue)

#define _guardNotEmpty(retVal) if ( _queue._count <= 0 ) return (retVal)


NS_ASSUME_NONNULL_BEGIN

@interface CBHHeap<ObjectType> ()
{
	CBHQueue_t _queue;
	NSComparator _comparator;
}


#pragma mark Private Initialization

- (instancetype)initWithComparator:(NSComparator)comparator firstObject:(ObjectType)object andArgumentList:(va_list)argList;

@end

NS_ASSUME_NONNULL_END


@implementation CBHHeap

#pragma mark Factories

+ (instancetype)heapWithComparator:(NSComparator)comparator
{
	return [[(CBHHeap *)[self alloc] initWithComparator:comparator andCapacity:DEFAULT_CAPACITY] autorelease];
}

+ (instancetype)heapWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity
{
	return [[(CBHHeap *)[self alloc] initWithComparator:comparator andCapacity:capacity] autorelease];
}

+ (instancetype)heapWithComparator:(NSComparator)comparator andObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	CBHHeap *heap = [(CBHHeap *)[self alloc] initWithComparator:comparator firstObject:object andArgumentList:arguments];

	va_end(arguments);
	return [heap autorelease];
}


+ (instancetype)heapWithComparator:(NSComparator)comparator andArray:(NSArray *)array
{
	return [[(CBHHeap *)[self alloc] initWithComparator:comparator andArray:array] autorelease];
}

+ (instancetype)heapWithComparator:(NSComparator)comparator andSet:(NSSet *)set
{
	return [[(CBHHeap *)[self alloc] initWithComparator:comparator andSet:set] autorelease];
}

+ (instancetype)heapWithComparator:(NSComparator)comparator andEnumerator:(NSEnumerator *)enumerator
{
	return [[(CBHHeap *)[self alloc] initWithComparator:comparator andEnumerator:enumerator] autorelease];
}


#pragma mark Initialization

- (instancetype)initWithComparator:(NSComparator)comparator
{
	return [self initWithComparator:comparator andCapacity:DEFAULT_CAPACITY];
}

- (instancetype)initWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity
{
	if ( (self = [super init]) )
	{
		_queue = CBHQueue_init(capacity, sizeof(id));
		_comparator = [comparator copy];
	}

	return self;
}

- (instancetype)initWithComparator:(NSComparator)comparator andObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	CBHHeap *heap = [self initWithComparator:comparator firstObject:object andArgumentList:arguments];

	va_end(arguments);
	return heap;
}

- (instancetype)initWithComparator:(NSComparator)comparator firstObject:(id)object andArgumentList:(va_list)argList
{
	if ( (self = [self initWithComparator:comparator]) )
	{
		id __nullable current = object;
		while ( current )
		{
			_insertObject(&_queue, current);
			current = va_arg(argList, id);
		}

		va_end(argList);
	}

	return self;
}

- (instancetype)initWithComparator:(NSComparator)comparator andArray:(NSArray *)array
{
	if ( (self = [self initWithComparator:comparator andCapacity:[array count]]) )
	{
		[self insertObjectsFromArray:array];
	}

	return self;
}

- (instancetype)initWithComparator:(NSComparator)comparator andSet:(NSSet *)set
{
	if ( (self = [self initWithComparator:comparator andCapacity:[set count]]) )
	{
		[self insertObjectsFromSet:set];
	}

	return self;
}

- (instancetype)initWithComparator:(NSComparator)comparator andEnumerator:(NSEnumerator *)enumerator
{
	if ( (self = [self initWithComparator:comparator]) )
	{
		[self insertObjectsFromEnumerator:enumerator];
	}

	return self;
}


#pragma mark Destructor

- (void)dealloc
{
	[self removeAllObjects];
	CBHQueue_dealloc(&_queue);

	[super dealloc];
}


#pragma mark Properties

@synthesize comparator = _comparator;

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
@implementation CBHHeap (Copying)

- (id)copyWithZone:(NSZone *)zone
{
	CBHHeap *heap = [(CBHHeap *)[[self class] allocWithZone:zone] initWithComparator:_comparator andCapacity:_queue._capacity];

	/// Copy existing heap to new heap.
	CBHMemory_copyTo(_queue._data, heap->_queue._data, sizeof(id), _queue._capacity);

	/// Set heap properties.
	heap->_queue._count = _queue._count;
	heap->_queue._offset = _queue._offset;

	/// Retain all objects.
	for (NSUInteger i = 0; i < _queue._count; ++i)
	{
		CFBridgingRetain((__bridge id __unsafe_unretained)CBHQueue_pointerAtIndex(&heap->_queue, i));
	}

	return heap;
}

@end


#pragma mark - Equality
@implementation CBHHeap (Equality)

- (BOOL)isEqual:(id)other
{
	if ( [other isKindOfClass:[CBHHeap class]] ) return [self isEqualToHeap:other];
	return [super isEqual:other];
}

- (BOOL)isEqualToHeap:(CBHHeap *)other
{
	/// Catch trivial cases.
	if ( self == other ) return YES;
	if ( _queue._count != other->_queue._count ) return NO;
	if ( _queue._count <= 0 ) return YES;
	if ( ![[self peekAtObject] isEqual:[other peekAtObject]] ) return NO;

	/// Stack Copies.
	CBHQueue_t a = CBHQueue_copy(&_queue);
	CBHQueue_t b = CBHQueue_copy(&other->_queue);

	/// Compare entries.
	for (NSUInteger i = 0; i < _queue._count; ++i)
	{
		id object0 = (__bridge id __unsafe_unretained)CBHHeap_extractValue(&a, _comparator);
		id object1 = (__bridge id __unsafe_unretained)CBHHeap_extractValue(&b, other->_comparator);

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
@implementation CBHHeap (Description)

- (NSString *)description
{
	NSMutableString *description = [NSMutableString stringWithString:@"("];

	BOOL firstLoop = YES;
	for (id object in [self array])
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


#pragma mark - Conversion
@implementation CBHHeap (Conversion)

- (NSArray *)array
{
	/// Fill a temporary array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHHeap_fillArrayWithObjects(&_queue, array, _comparator);

	/// Load entries from stack into new collection and return.
	return [NSArray arrayWithObjects:array count:_queue._count];
}

- (NSMutableArray *)mutableArray
{
	/// Fill a temporary array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHHeap_fillArrayWithObjects(&_queue, array, _comparator);

	/// Load entries from stack into new collection and return.
	return [NSMutableArray arrayWithObjects:array count:_queue._count];
}

- (NSOrderedSet *)orderedSet
{
	/// Fill a temporary array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHHeap_fillArrayWithObjects(&_queue, array, _comparator);

	/// Load entries from stack into new collection and return.
	return [NSOrderedSet orderedSetWithObjects:array count:_queue._count];
}

- (NSMutableOrderedSet *)mutableOrderedSet
{
	/// Fill a temporary array on the stack.
	id __unsafe_unretained array[_queue._count];
	CBHHeap_fillArrayWithObjects(&_queue, array, _comparator);

	/// Load entries from stack into new collection and return.
	return [NSMutableOrderedSet orderedSetWithObjects:array count:_queue._count];
}

@end


#pragma mark - Peeking
@implementation CBHHeap (Peeking)

- (id)peekAtObject
{
	_guardNotEmpty(nil);
	return _peekObject();
}

@end


#pragma mark - Addition
@implementation CBHHeap (Addition)

- (void)insertObject:(id)object
{
	_insertObject(&_queue, object);
}

- (void)insertObjects:(id)object, ...
{
	va_list arguments;
	va_start(arguments, object);

	id __nullable current = object;
	while ( current )
	{
		// TODO: Only balance at end?
		_insertObject(&_queue, current);
		current = va_arg(arguments, id);
	}

	va_end(arguments);
}

- (void)insertObjectsFromArray:(NSArray *)array
{
	[self growToFit:([array count] + _queue._count)];

	// TODO: Only balance at end?
	for (id object in array) { _insertObject(&_queue, object); }
}

- (void)insertObjectsFromSet:(NSSet *)set
{
	[self growToFit:([set count] + _queue._count)];

	// TODO: Only balance at end?
	for (id object in set) { _insertObject(&_queue, object); }
}

- (void)insertObjectsFromEnumerator:(id <NSFastEnumeration>)enumerator
{
	// TODO: Only balance at end?
	for (id object in enumerator) { _insertObject(&_queue, object); }
}

@end


#pragma mark - Subtraction
@implementation CBHHeap (Subtraction)

- (id)extractObject
{
	return _extractObject();
}

- (NSArray *)extractObjects:(NSUInteger)count
{
	/// Catch trivial empty case.
	if ( count == 0 ) { return @[]; }

	id object;
	id array[count];
	NSUInteger index = 0;

	/// Store entries on stack temporarily.
	while ( index < count && (object = _extractObject()) )
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
@implementation CBHHeap (Resizing)

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
