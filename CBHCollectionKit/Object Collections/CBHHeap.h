//  CBHHeap.h
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

@import Foundation;

#import <CBHCollectionKit/CBHCollection.h>


NS_ASSUME_NONNULL_BEGIN

/** A dynamic ordered collection of objects where objects can only be added from one end and removed from the other.
 *
 * A Heap defines a mutable collection of objects which dynamically expands itself when needed. Objects are removed based on the the order defined by a comparator.
 *
 * @author    Christian Huxtable <chris@huxtable.ca>
 */
@interface CBHHeap<ObjectType> : NSObject <NSCopying, CBHCollectionResizable>

#pragma mark - Factories

+ (instancetype)heapWithComparator:(NSComparator)comparator;
+ (instancetype)heapWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity;
+ (instancetype)heapWithComparator:(NSComparator)comparator andObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)heapWithComparator:(NSComparator)comparator andArray:(NSArray<ObjectType> *)array;
+ (instancetype)heapWithComparator:(NSComparator)comparator andSet:(NSSet<ObjectType> *)set;
+ (instancetype)heapWithComparator:(NSComparator)comparator andEnumerator:(NSEnumerator<ObjectType> *)enumerator;


#pragma mark - Initialization

- (instancetype)initWithComparator:(NSComparator)comparator;
- (instancetype)initWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithComparator:(NSComparator)comparator andObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithComparator:(NSComparator)comparator andArray:(NSArray<ObjectType> *)array;
- (instancetype)initWithComparator:(NSComparator)comparator andSet:(NSSet<ObjectType> *)set;
- (instancetype)initWithComparator:(NSComparator)comparator andEnumerator:(NSEnumerator<ObjectType> *)enumerator;


#pragma mark - Properties

@property (nonatomic, readonly) NSComparator comparator;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) BOOL isEmpty;


#pragma mark - Copying

- (id)copyWithZone:(nullable NSZone *)zone;


#pragma mark - Equality

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToHeap:(CBHHeap<ObjectType> *)other;

- (NSUInteger)hash;


#pragma mark - Description

- (NSString *)description;
- (NSString *)debugDescription;


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


#pragma mark - Resizing

- (BOOL)shrink;

- (BOOL)grow;
- (BOOL)growToFit:(NSUInteger)neededCapacity;

- (BOOL)resize:(NSUInteger)newCapacity;


#pragma mark - Unavailable

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
