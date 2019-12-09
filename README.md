# CBHCollectionKit

[![release](https://img.shields.io/github/release/chris-huxtable/CBHCollectionKit.svg)](https://github.com/chris-huxtable/CBHCollectionKit/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHCollectionKit.svg)](https://cocoapods.org/pods/CBHCollectionKit)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHCollectionKit/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHCollectionKit)

A collection of primitive and object-based collections which aim to be safer and easy-to-use.

**Note: This Framework is still a work-in-progress** and is missing most documentation.


## Highlights:

- Primitive collection types.
- Performance equivalent to Foundation collection types. 


## Outline:

**Note: The interfaces provided in this page are not complete**

### `CBHSlice`

A Slice is a primitive collection that can be thought of an abstraction around a c array. It makes for safer use by performing bounds checking and by reducing code that is more likely to contain mistakes. 

#### Concepts

- `entrySize`: The size of an entry in bytes.
- `capacity`: The number of entries. The default value is 0.

```objective-c

#pragma mark - Factories

+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;
+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity shouldClear:(BOOL)shouldClear;
+ (instancetype)sliceWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity initialValue:(nullable const void *)value;

+ (instancetype)sliceWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;
+ (instancetype)sliceWithEntrySize:(size_t)entrySize owning:(NSUInteger)count entriesFromBytes:(void *)bytes;


#pragma mark - Initialization

- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity shouldClear:(BOOL)shouldClear;
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity initialValue:(const void *)value;

- (instancetype)initWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;
- (instancetype)initWithEntrySize:(size_t)entrySize owning:(NSUInteger)count entriesFromBytes:(void *)bytes;


#pragma mark - Properties

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) size_t entrySize;
@property (nonatomic, readonly) BOOL isEmpty;
@property (nonatomic, readonly) const void *bytes;


#pragma mark - Equality

- (BOOL)isEqualToSlice:(CBHSlice *)other;


#pragma mark - Conversion

- (NSData *)data;
- (NSMutableData *)mutableData;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;


#pragma mark - Generic Accessors

- (const void *)valueAtIndex:(NSUInteger)index;


#pragma mark - Named Byte Accessors

- (uint8_t)byteAtIndex:(NSUInteger)index;
- (int8_t)signedByteAtIndex:(NSUInteger)index;
- (uint8_t)unsignedByteAtIndex:(NSUInteger)index;


#pragma mark - Named Integer Accessors

- (NSInteger)integerAtIndex:(NSUInteger)index;
- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index;


#pragma mark - Sized Integer Accessors

- (int8_t)int8AtIndex:(NSUInteger)index;
- (uint8_t)uint8AtIndex:(NSUInteger)index;

- (int16_t)int16AtIndex:(NSUInteger)index;
- (uint16_t)uint16AtIndex:(NSUInteger)index;

- (int32_t)int32AtIndex:(NSUInteger)index;
- (uint32_t)uint32AtIndex:(NSUInteger)index;

- (int64_t)int64AtIndex:(NSUInteger)index;
- (uint64_t)uint64AtIndex:(NSUInteger)index;


#pragma mark - Named Float Accessors

- (CGFloat)cgfloatAtIndex:(NSUInteger)index;
- (float)floatAtIndex:(NSUInteger)index;
- (double)doubleAtIndex:(NSUInteger)index;
- (long double)longDoubleAtIndex:(NSUInteger)index;


#pragma mark - Character Accessors

- (char)charAtIndex:(NSUInteger)index;
- (unsigned char)unsignedCharAtIndex:(NSUInteger)index;
```


### `CBHMutableSlice`

The mutable variation of a `CBHSlice` where the size and entries of the slice can be changed. Though the entry size remains fixed. 

```objective-c
#pragma mark - Resizing

- (void)resize:(NSUInteger)capacity;
- (void)resize:(NSUInteger)capacity andClear:(BOOL)shouldClear;


#pragma mark - Swapping and Duplicating Entries

- (void)swapValuesAtIndex:(NSUInteger)a andIndex:(NSUInteger)b;
- (BOOL)swapValuesInRange:(NSRange)a andIndex:(NSUInteger)b;

- (void)duplicateValueAtIndex:(NSUInteger)src toIndex:(NSUInteger)dst;
- (void)duplicateValuesInRange:(NSRange)range toIndex:(NSUInteger)dst;


#pragma mark - Clearing Slice

- (void)clearAllValues;
- (void)clearValuesInRange:(NSRange)range;


#pragma mark - Generic Mutators

- (void)setValue:(const void *)value atIndex:(NSUInteger)index;


#pragma mark - Named Byte Mutators

- (void)setByte:(uint8_t)value atIndex:(NSUInteger)index;
- (void)setSignedByte:(int8_t)value atIndex:(NSUInteger)index;
- (void)setUnsignedByte:(uint8_t)value atIndex:(NSUInteger)index;


#pragma mark - Named Integer Mutators

- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index;
- (void)setUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;


#pragma mark - Sized Integer Mutators

- (void)setInt8:(int8_t)value atIndex:(NSUInteger)index;
- (void)setUInt8:(uint8_t)value atIndex:(NSUInteger)index;

- (void)setInt16:(int16_t)value atIndex:(NSUInteger)index;
- (void)setUInt16:(uint16_t)value atIndex:(NSUInteger)index;

- (void)setInt32:(int32_t)value atIndex:(NSUInteger)index;
- (void)setUInt32:(uint32_t)value atIndex:(NSUInteger)index;

- (void)setInt64:(int64_t)value atIndex:(NSUInteger)index;
- (void)setUInt64:(uint64_t)value atIndex:(NSUInteger)index;


#pragma mark - Named Float Mutators

- (void)setCGFloat:(CGFloat)value atIndex:(NSUInteger)index;

- (void)setFloat:(float)value atIndex:(NSUInteger)index;
- (void)setDouble:(double)value atIndex:(NSUInteger)index;
- (void)setLongDouble:(long double)value atIndex:(NSUInteger)index;


#pragma mark - Character Mutators

- (void)setChar:(char)value atIndex:(NSUInteger)index;
- (void)setUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index;
```


### `CBHWedge`

A Wedge is a dynamically sized primitive collection. It is intended to handle growth for the user, reducing complexity and the likelihood for error.

#### Concepts:

- `entrySize`: The size of an entry in bytes.
- `count`: The number of entries held.
- `capacity`: The number of entries that can be held before a resize is required.


```objective-c
#pragma mark - Factories

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize;
+ (instancetype)wedgeWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;

+ (instancetype)wedgeWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;
+ (instancetype)wedgeWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;

+ (instancetype)wedgeWithSlice:(CBHSlice *)slice;
+ (instancetype)wedgeWithSlice:(CBHSlice *)slice andCapacity:(NSUInteger)capacity;


#pragma mark - Initialization

- (instancetype)initWithEntrySize:(size_t)entrySize;
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity;

- (instancetype)initWithEntrySize:(size_t)entrySize copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;
- (instancetype)initWithEntrySize:(size_t)entrySize andCapacity:(NSUInteger)capacity copying:(NSUInteger)count entriesFromBytes:(const void *)bytes;

- (instancetype)initWithSlice:(CBHSlice *)slice;
- (instancetype)initWithSlice:(CBHSlice *)slice andCapacity:(NSUInteger)capacity;


#pragma mark - Properties

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) size_t entrySize;

@property (nonatomic, readonly) BOOL isEmpty;

@property (nonatomic, readonly) const void *bytes;


#pragma mark - Equality

- (BOOL)isEqualToWedge:(CBHWedge *)other;


#pragma mark - Conversion

- (NSData *)data;
- (NSMutableData *)mutableData;
- (CBHSlice *)slice;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;


#pragma mark - Swapping and Duplicating Entries

- (void)swapValuesAtIndex:(NSUInteger)a andIndex:(NSUInteger)b;
- (BOOL)swapValuesInRange:(NSRange)a andIndex:(NSUInteger)b;

- (void)duplicateValueAtIndex:(NSUInteger)src toIndex:(NSUInteger)dst;
- (void)duplicateValuesInRange:(NSRange)range toIndex:(NSUInteger)dst;


#pragma mark - Clearing Buffer

- (void)removeAll;
- (void)removeLast:(NSUInteger)count;


#pragma mark - Generic Operations

- (const void *)valueAtIndex:(NSUInteger)index;

- (void)appendValue:(const void *)value;
- (void)setValue:(const void *)value atIndex:(NSUInteger)index;


#pragma mark - Named Byte Operations

- (uint8_t)byteAtIndex:(NSUInteger)index;
- (void)appendByte:(uint8_t)value;
- (void)setByte:(uint8_t)value atIndex:(NSUInteger)index;

- (int8_t)signedByteAtIndex:(NSUInteger)index;
- (void)appendSignedByte:(int8_t)value;
- (void)setSignedByte:(int8_t)value atIndex:(NSUInteger)index;

- (uint8_t)unsignedByteAtIndex:(NSUInteger)index;
- (void)appendUnsignedByte:(uint8_t)value;
- (void)setUnsignedByte:(uint8_t)value atIndex:(NSUInteger)index;


#pragma mark - Named Integer Operations

- (NSInteger)integerAtIndex:(NSUInteger)index;
- (void)appendInteger:(NSInteger)value;
- (void)setInteger:(NSInteger)value atIndex:(NSUInteger)index;

- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index;
- (void)appendUnsignedInteger:(NSUInteger)value;
- (void)setUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;


#pragma mark - Sized Integer Operations

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


#pragma mark - Named Float Accessors

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


#pragma mark - Character Accessors

- (char)charAtIndex:(NSUInteger)index;
- (void)appendChar:(char)value;
- (void)setChar:(char)value atIndex:(NSUInteger)index;

- (unsigned char)unsignedCharAtIndex:(NSUInteger)index;
- (void)appendUnsignedChar:(unsigned char)value;
- (void)setUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index;
```

### `CBHStack`

A Stack is a dynamically sized last-in first-out (LIFO) structure for Objects. 

#### Concepts:

- `count`: The number of entries held.
- `capacity`: The number of entries that can be held before a resize is required.

```objective-c
#pragma mark - Factories

+ (instancetype)stack;
+ (instancetype)stackWithCapacity:(NSUInteger)capacity;
+ (instancetype)stackWithObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)stackWithArray:(NSArray<ObjectType> *)array;
+ (instancetype)stackWithOrderedSet:(NSOrderedSet<ObjectType> *)set;
+ (instancetype)stackWithEnumerator:(id<NSFastEnumeration>)enumerator;


#pragma mark - Initialization

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (instancetype)initWithObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithArray:(NSArray<ObjectType> *)array;
- (instancetype)initWithOrderedSet:(NSOrderedSet<ObjectType> *)set;
- (instancetype)initWithEnumerator:(id<NSFastEnumeration>)enumerator;


#pragma mark - Properties

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) BOOL isEmpty;


#pragma mark - Equality

- (BOOL)isEqualToStack:(CBHStack<ObjectType> *)other;


#pragma mark - Conversion

- (NSArray<ObjectType> *)array;
- (NSMutableArray<ObjectType> *)mutableArray;

- (NSOrderedSet<ObjectType> *)orderedSet;
- (NSMutableOrderedSet<ObjectType> *)mutableOrderedSet;


#pragma mark - Accessors

- (nullable ObjectType)peekAtObject;

- (nullable ObjectType)peekAtObjectFromTop:(NSUInteger)index;
- (nullable ObjectType)peekAtObjectFromBottom:(NSUInteger)index;


#pragma mark - Mutators

- (void)pushObject:(ObjectType)object;
- (nullable ObjectType)popObject;

- (void)pushObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;
- (void)pushObjectsFromArray:(NSArray<ObjectType> *)array;
- (void)pushObjectsFromOrderedSet:(NSOrderedSet<ObjectType> *)set;
- (void)pushObjectsFromEnumerator:(id <NSFastEnumeration>)enumerator;

- (void)removeAllObjects;
```

### `CBHQueue`

A Queue is a dynamically sized  first-in first-out (FIFO) structure for Objects. 

#### Concepts:

- `count`: The number of entries held.
- `capacity`: The number of entries that can be held before a resize is required.

```objective-c

#pragma mark - Factories

+ (instancetype)queue;
+ (instancetype)queueWithCapacity:(NSUInteger)capacity;
+ (instancetype)queueWithObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)queueWithArray:(NSArray<ObjectType> *)array;
+ (instancetype)queueWithOrderedSet:(NSOrderedSet<ObjectType> *)set;
+ (instancetype)queueWithEnumerator:(id<NSFastEnumeration>)enumerator;


#pragma mark - Initialization

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (instancetype)initWithObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithArray:(NSArray<ObjectType> *)array;
- (instancetype)initWithOrderedSet:(NSOrderedSet<ObjectType> *)set;
- (instancetype)initWithEnumerator:(id<NSFastEnumeration>)enumerator;


#pragma mark - Properties

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) BOOL isEmpty;


#pragma mark - Equality

- (BOOL)isEqualToQueue:(CBHQueue<ObjectType> *)other;

#pragma mark - Conversion

- (NSArray<ObjectType> *)array;
- (NSMutableArray<ObjectType> *)mutableArray;

- (NSOrderedSet<ObjectType> *)orderedSet;
- (NSMutableOrderedSet<ObjectType> *)mutableOrderedSet;


#pragma mark - Accessors

- (nullable ObjectType)peekAtObject;
- (nullable ObjectType)objectAtIndex:(NSUInteger)index;


#pragma mark - Mutators

- (void)enqueueObject:(ObjectType)object;

- (nullable ObjectType)dequeueObject;

- (void)enqueueObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;
- (void)enqueueObjectsFromArray:(NSArray<ObjectType> *)array;
- (void)enqueueObjectsFromOrderedSet:(NSOrderedSet<ObjectType> *)set;
- (void)enqueueObjectsFromEnumerator:(id <NSFastEnumeration>)enumerator;

- (NSArray<ObjectType> *)dequeueObjects:(NSUInteger)count;

- (void)removeAllObjects;
```

### `CBHHeap`

A Heap is a dynamically sized structure for Objects which sorts the extracted output by a given comparator. 

#### Concepts:

- `comparator`: The comparison to be done which determines the heaps order.
- `count`: The number of entries held.
- `capacity`: The number of entries that can be held before a resize is required.

```objective-c
#pragma mark - Factories

+ (instancetype)heapWithComparator:(NSComparator)comparator;
+ (instancetype)heapWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity;
+ (instancetype)heapWithComparator:(NSComparator)comparator andObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)heapWithComparator:(NSComparator)comparator andArray:(NSArray<ObjectType> *)array;
+ (instancetype)heapWithComparator:(NSComparator)comparator andSet:(NSSet<ObjectType> *)set;
+ (instancetype)heapWithComparator:(NSComparator)comparator andEnumerator:(NSEnumerator<ObjectType> *)enumerator;


#pragma mark - Initialization

- (instancetype)initWithComparator:(NSComparator)comparator;
- (instancetype)initWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity;
- (instancetype)initWithComparator:(NSComparator)comparator andObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithComparator:(NSComparator)comparator andArray:(NSArray<ObjectType> *)array;
- (instancetype)initWithComparator:(NSComparator)comparator andSet:(NSSet<ObjectType> *)set;
- (instancetype)initWithComparator:(NSComparator)comparator andEnumerator:(NSEnumerator<ObjectType> *)enumerator;


#pragma mark - Properties

@property (nonatomic, readonly) NSComparator comparator;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) BOOL isEmpty;


#pragma mark - Equality

- (BOOL)isEqualToHeap:(CBHHeap<ObjectType> *)other;


#pragma mark - Conversion

- (NSArray<ObjectType> *)array;
- (NSMutableArray<ObjectType> *)mutableArray;

- (NSOrderedSet<ObjectType> *)orderedSet;
- (NSMutableOrderedSet<ObjectType> *)mutableOrderedSet;


#pragma mark - Peeking

- (nullable ObjectType)peekAtObject;


#pragma mark - Addition

- (void)insertObject:(ObjectType)object;
- (void)insertObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

- (void)insertObjectsFromArray:(NSArray<ObjectType> *)array;
- (void)insertObjectsFromSet:(NSSet<ObjectType> *)set;
- (void)insertObjectsFromEnumerator:(id <NSFastEnumeration>)enumerator;


#pragma mark - Subtraction

- (nullable ObjectType)extractObject;
- (NSArray<ObjectType> *)extractObjects:(NSUInteger)count;

- (void)removeAllObjects;
```


## Todo: 

- Convert `CBHWedge` to a circular buffer.


## Licence
CBHCollectionKit is available under the [ISC license](https://github.com/chris-huxtable/CBHCollectionKit/blob/master/LICENSE).
