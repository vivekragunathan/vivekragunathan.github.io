---
title: Iterators vs. Generators
author: vivekragunathan
layout: post
date: 2016-08-02T19:16:00+00:00
url: /posts/iterators-vs-generators
aliases:
- /2016/08/03/iterators-vs-generators/
summary: |
  Yes, there is a difference. Although both produce the same end effect, an iterator is not the same as a generator. The difference is in the way it is implemented and also consumed. Iterator is a (design/implementation) pattern while Generator is a language construct supported by the compiler.
categories:
  - Java
  - Programming
  - Software Design
  - Uncategorized
tags:
  - 'C#'
  - design
  - Java
  - jinq
  - LINQ
  - programming

---
Yes, there is a difference. Although both produce the same end effect, an iterator is not the same as a generator. The difference is in the way it is implemented and also consumed.

<!--more-->

**Iterators**

Iterator is a (design/implementation) pattern for iterating over different kinds of collection sources via an uniform interface. _Typically_ the implementation is driven by a class that implements a method to move the iteration index, a method to retrieve the item at the current index, and a method to reset the iteration index, if required. Conventional iterations using raw pointers or indices not only ooze (iteration) arithematic but can work only with certain types of collections, for instance arrays. An iterator provides a way to abstract the mechanics and can be implemented by any class apart from collections themselves, so as to provide a transparent way to query elements off the source. Classes that implement the iterator pattern are called iterables (or enumerables).

Iterator is nothing new. C++ has been supporting iterators since its early days; STL algorithms.

Here is a **trivial** example:

```cpp
std::list<int> foo = { &#8230;. };
std::set<int> bar;
std::copy(foo.begin(), foo.end(), std::inserter(bar, bar.begin()));
```
Just about any language today exposes standard iterators for all its collections, and also provides standard iterator interface/class/methods for custom implementation.

Here is a **trivial** example of a custom iterator &#8211; unbounded integer counter:

```java
public class IntCounter implements Iterable<Integer> {
    private final int start;

    public IntCounter() { this.start = 0; }
    public IntCounter(int start) { this.start = start; }

    public Iterator<int> iterator() {
        return new IntCountIterator(this.start);
    }

    public static class IntCountIterator implements Iterator<int> {
        private int counter = 0;
        public IntCountIterator(int start) { this.counter = start; }
        public boolean moveNext() { return counter != Integer.MAX_VALUE; }
        public int next() { return counter++; }

        // Let's ignore reset() for now
    }
}
```

You get the idea!

**Generators**

A generator is a language construct supported by the compiler. The compiler saves you from hand-weaving the boiler plate code of implementing the iterator pattern. You are then left to write the last couple of lines of the code that will save the planet!

```csharp
public class SomeClass
{
    // &#8230;

    // Can also be instance method

    public static IEnumerable<int> GetNextInt()
    {
        for (int counter = 0; counter < int.MaxValue; ++counter)
        {
            yield return counter;
        }
    }
}
```

The [`yield`](https://msdn.microsoft.com/en-us/library/9k7k7cf0.aspx) `return`, in contrast to a regular `return`, does not return `counter` once for all but instead allows re-entering the same method where it left off previously to  return the current value and allows re-entering until the counter limit is reached.

Similar to the `IntCounter` _class_, the `GetNextInt` _method_ hands off one element at a time when requested and until exhaustion. While `IntCounter` uses `moveNext()` and `next()` methods in tandem as wheels that drive the iteration, `GetNextInt` abstracts the mechanics via `yield` `return`. Also note that the `GetNextInt` returns `IEnumerable` (analogous to Java's `Iterable`) denoting that it is an iterable; all without the conventional boiler plate.

`Iterable` (or `IEnumerable`) is relatively a low-level mechanism to retrieve elements from a source on-demand; consider stream. It does not provide higher level semantics. It reminds us of just iteration. On the other hand, generators (`yield`) provide a higher level semantics, which is highly useful when you are building other higher level semantics. For instance, LINQ! LINQ's clauses - `where`, `select` etc. heavily use the C# generators (`yield`) instead of conventional iterables.

**JINQ**

When implementing JINQ, I was in a short dilemma whether to implement the clauses using conventional iterables or using a generator. _Alas, JINQ is, of course, written in and for Java_! The language does not support generators. I thought briefly if I would be able to emulate a generator using an `yield` method, and hopefully use this emulated generator as the backbone for the clauses. But you see, I would just be implementing yet another iterable. It might appear that the emulated generator, despite being a normal iterable, would be able to save me from writing other iterables for the clauses. However, that is not the case because each clause has to _generate_ values conditionally. For instance, the `where` clause needs a `Predicate`, `select` takes an optional `Func` for transforming values and so on. This emulated generator would have to become a Frankenstein to fit to the needs of each clause. In the end, I came to my senses that it is not possible to emulate a compiler feature; at least not worthwhile to do so. No matter how hard you try, C++ destructors cannot be emulated. So cannot be constructors.

> If conventional asynchronous programming using callbacks were to be compared with conventional iterables, `async`&#8211;`await` is analogous to `yield`. They appear to be do the same thing but there is a lot less to say and a lot more to do!

JINQ is written with conventional `Iterable` and `Iterator`. However, a lot of it is written in such a way that it is not specific or tightly coupled to JINQ. You could say a bunch of general purpose components were wisely assembled to produce JINQ!
