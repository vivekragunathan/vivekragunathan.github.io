---
title: Either Disjoint or Union Types
author: vivekragunathan
layout: post
date: 2020-12-28
categories:
  - Scala
  - Functional-Programming
summary: |
  Many languages support union types, and it is high time Scala did. Union types are coming in upcoming version of Scala - Dotty.
---

Many languages support union types, and it is high time Scala did. Union types are coming in upcoming version of Scala - Dotty. Union types (`|`) are already being compared with `Either` and `Option` (disjoint unions).

In some ways, `Either` and `Option` may be expressed as union types.

``````scala
// Option[String]
String | null

// Either[Int, String]
Int | String
``````

Similar to disjoint union types, you can pattern match over Union types. However, the differences outshine the similarities. 

Disjoint union types like `Either` and `Option` ...

- constraint the universe of types to be unique - `Left` and `Right`, `Some` and `None`. There is only one `Left` or `Some`.
- can be parameterized - `Either[L, R]` , `Option[T]`
- Defined in the standard library. Not language syntax.

On the other hand, Union Types (`|`) ...

- Not parameterized. Types are specific.

- The types involved don't have to be necessarily unique.
	```scala
	String | Int | String | Int
	```
	
	The above definition is valid although the universe of types is just `String` and `Int`.
	
- Language syntax

There is one difference that stands out to me, in fact of disjoint union types. `Either` and `Option` are monads and so they give the niceties of `map`, `flatMap` and all those of a container. Can't do that with Union types.

However, Union types give you edge over one thing. In fact, the thing I don't like about `Either` or `Option`; or JVM in general. Disjoint union types are allocated on the heap; every instance. Union types are compile time construct and do not require extra allocation.

As you can see, grass is greener on either side. Both disjoint union and Union types have their place and are here to stay. You gotta choose the right one for the job; `Either` disjoint types `|` Union Types!