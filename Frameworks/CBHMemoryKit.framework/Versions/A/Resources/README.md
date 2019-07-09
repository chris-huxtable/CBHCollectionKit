# CBHMemoryKit

[![release](https://img.shields.io/github/release/chris-huxtable/CBHMemoryKit.svg)](https://github.com/chris-huxtable/CBHMemoryKit/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHMemoryKit.svg)](https://cocoapods.org/pods/CBHMemoryKit)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHMemoryKit/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHMemoryKit)

A safer and easy-to-use interface for managing and manipulating memory.


## Use

`CBHMemoryKit` provides safer c functions for managing and manipulating memory.

#### Examples:

Allocating a slice of 10 `NSUIntegers`:
```c
NSUInteger *slice = CBHMemory_alloc(10, sizeof(NSUInteger));
```

Allocating a slice of 10 `NSUIntegers` where each value is set to 0:
```c
NSUInteger *slice = CBHMemory_calloc(10, sizeof(NSUInteger));
```

Reallocating a slice of 10 `NSUIntegers`  to 20:
```c
NSUInteger *slice = CBHMemory_alloc(10, sizeof(NSUInteger));
slice = CBHMemory_realloc(slice, 20, sizeof(NSUInteger));
```

Reallocating a slice of 10 `NSUIntegers` to 20 where each new value is set to 0:
```c
NSUInteger *slice = CBHMemory_calloc(10, sizeof(NSUInteger));
slice = CBHMemory_recalloc(slice, 20, sizeof(NSUInteger));
```

Swapping bytes:
```c
NSUInteger *slice = {4, 5, 6, 7, 0, 1, 2, 3};
CBHMemory_swapBytes(slice[0], slice[4], 4, sizeof(NSUInteger));
// slice = {0, 1, 2, 3, 4, 5, 6, 7}
```

Freeing heap allocated memory:
```c
NSUInteger *slice = CBHMemory_calloc(10, sizeof(NSUInteger));

// Do some work...

CBHMemory_free(slice);
// slice = NULL
```

## Why?

### Overflows:

These functions fail if an overflow occurs.

### Use-After-Free:

Use-after-free errors are common. `CBHMemory_free()` helps avoid them by setting the pointer to NULL for you.


## Licence
CBHMemoryKit is available under the [ISC license](https://github.com/chris-huxtable/CBHMemoryKit/blob/master/LICENSE).
