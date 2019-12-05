//  CBHQueue.h
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

@import Foundation;

#import <CBHCollectionKit/CBHCollection.h>


NS_ASSUME_NONNULL_BEGIN

/** A dynamic ordered collection of objects where objects can only be added from one end and removed from the other.
 *
 * A Queue defines a mutable collection of objects which dynamically expands itself when needed. Changes are done in a first in, first out (FIFO) fashion.
 *
 * @author    Christian Huxtable <chris@huxtable.ca>
 */
@interface CBHQueue<ObjectType> : NSObject <NSCopying, NSFastEnumeration, CBHCollectionResizable>

#pragma mark - Factories

+ (instancetype)queue;
+ (instancetype)queueWithCapacity:(NSUInteger)capacity;
+ (instancetype)queueWithObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)queueWithArray:(NSArray<ObjectType> *)array;
+ (instancetype)queueWithOrderedSet:(NSOrderedSet<ObjectType> *)set;
+ (instancetype)queueWithEnumerator:(id<NSFastEnumeration>)enumerator;


#pragma mark - Initialization

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(nullable ObjectType)object, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithArray:(NSArray<ObjectType> *)array;
- (instancetype)initWithOrderedSet:(NSOrderedSet<ObjectType> *)set;
- (instancetype)initWithEnumerator:(id<NSFastEnumeration>)enumerator;


#pragma mark - Properties

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) BOOL isEmpty;


#pragma mark - Copying

- (id)copyWithZone:(nullable NSZone *)zone;


#pragma mark - Equality

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToQueue:(CBHQueue<ObjectType> *)other;

- (NSUInteger)hash;


#pragma mark - Description

- (NSString *)description;
- (NSString *)debugDescription;


#pragma mark - Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len;


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


#pragma mark - Resizing

- (BOOL)shrink;

- (BOOL)grow;
- (BOOL)growToFit:(NSUInteger)neededCapacity;

- (BOOL)resize:(NSUInteger)newCapacity;

@end

NS_ASSUME_NONNULL_END
