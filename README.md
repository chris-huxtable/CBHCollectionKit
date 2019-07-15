# CBHCollectionKit

[![release](https://img.shields.io/github/release/chris-huxtable/CBHCollectionKit.svg)](https://github.com/chris-huxtable/CBHCollectionKit/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHCollectionKit.svg)](https://cocoapods.org/pods/CBHCollectionKit)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHCollectionKit/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHCollectionKit)

A collection of easy-to-use  and safer primitive and object based collections.

**Note: This Framework is still a work-in-progress** and is missing most documentation. Performance is also excepted to  improve. 


## Outline

`CBHCollectionKit` provides classes to manage collections of primitive and object values.

### `CBHSlice` and `CBHMutableSlice`

A Slice can be thought of an abstraction over a c array. It makes for safer use by performing bounds checking and by reducing user code that is more likely to contain mistakes. 


### `CBHWedge`

A Wedge, is a dynamically sized slice. It is intended to handle growth for the user, reducing complexity and the likelihood for error.


### `CBHStack`

A Stack is a dynamically sized last-in first-out (LIFO) structure for Objects. 


### `CBHQueue`

A Queue is a dynamically sized  first-in first-out (FIFO) structure for Objects. 


### `CBHHeap`

A Heap is a dynamically sized structure for Objects which sorts the extracted output by a given comparator. 


## Licence
CBHCollectionKit is available under the [ISC license](https://github.com/chris-huxtable/CBHCollectionKit/blob/master/LICENSE).
