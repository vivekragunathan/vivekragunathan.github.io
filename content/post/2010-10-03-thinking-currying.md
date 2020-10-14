---
title: Thinking Currying !!!
author: vivekragunathan
layout: post
date: 2010-10-03T12:08:00+00:00
url: /2010/10/03/thinking-currying/
categories:
  - .NET
  - 'C#'
  - C++
  - CodeProject
  - Uncategorized
tags:
  - binding
  - currying
  - functional programming

---
_Currying_ is a mathematical concept based on lambda calculus. It is a technique of operating on a function (taking multiple arguments) by splitting and capable of chaining into a series of single argument functions. It is very similar to what a human would attempt to do on paper. For example, if you have to add numbers `1` through `10`, what would you do? Class II mathematics&#8230; `` in hand, `1` in the mind, add `` and `1`, so `1` in the mind, then `2` in the hand, &#8230; up to `10`. So we compute the addition with one argument at a time.

In the programming world, it is realized by transforming a n-arguments function into a (n-1) arguments function, which takes the remaining one argument. This transformation when applied recursively on each of the single argument functions is the chaining of single argument functions that I discussed earlier. Needless to say, currying is a gift of the functional programming world. In simple words, functional programming is about building functions from other functions, and so functions are treated as first class citizens (like data).

If currying is just transforming a n arguments function into a single argument function, then extension method too is an example of currying.

```csharp
public static bool Replace(this IList srcList, int position, T item)  
{
  // Imagine an implementation here&#8230;.
}
```

So you would be using the Replace above without explicitly passing the source list to the method; one argument less.

```csharp
list.Replace(2, newItem);

// instead of Replace(ilistObj, 2, newItem) if extension method was not invented.
```

Isn’t that right? Yes, but that is not the currying from the conventional standpoint of functional programming.

For samples, we will not use the devil (any functional programming language) itself; instead we will use C#, which provides functional programming facilities. Alright, let us curry.

```csharp
int Add(int x, int y)
{
  return x + y;
}
```

Or to be _functional_, we may (re)write:

```csharp
Func adderFunc = (x, y) => x + y;
```

To curry out an increment function, we would write as follows:-

```csharp
Func<int, Func> Incrementer()
{
  return num => Add(num, 1);
}
```

and we use it is as follows:-

```csharp
var inc = Incrementer();
Console.WriteLine(inc(5));
Console.WriteLine(inc(12));
```

Is that not better and wise than writing `Sum(5, 1)`?

If currying is just transforming a n-arguments function into a single argument function, then we should be able to write a generic currying function.

```csharp
Func<T1, Func> Curry(Func fn)
{
  return x => y => fn(x, y);
}

Func<int, Func> Adder = Curry(Add);
var Incrementor = Adder(1);
var i = Incrementor(5);
```

when we may not have actually encountered a compelling situations to use this in the past

But isn’t this all cryptic? So why would we want to do all such cryptic things when we have not encountered any such situation….in the past? Actually we have.

When simple principles are tough for us to understand, it is our grandma who helps us. Our grandma here is C++; although grandma called it binding.

In C++, many STL algorithms require a functor (roughly equivalent to a function definition) with one argument, where as the desired function was a two or more arguments function. Then we use std::bind1st or std::bind2nd to curry it into unary function.

For instance, the `count\_if` algorithm calculates the number of elements in a sequence that satisfy the predicate, which happens to be a unary function. Suppose we want to count the even numbers in a collection of whole numbers (and imagine this to be a tough calculation). If there was a function that could take a number and return true if it was an even number, it could be fed to count_if. But what if we had a function like the one below – a two argument function.

```csharp
bool IsDivisible(int number, int divisor)  
{
  return number % divisor == 0;
}
```

The functor we need is nothing but an `IsDivisible` function with the second argument as 2. We could write an IsEven function which in turn calls `IsDivisible`. But that could be tedious one we were write such wrappers for a function with 10 arguments. In situations like this, we curry. In C++, we (use) bind.

> `std::bind1st`[^1] – A helper template function that creates an adaptor to convert a binary function object into a unary function object by binding the first argument of the binary function to a specified value.

> `std::bind2nd`[^2] – A helper template function that creates an adaptor to convert a binary function object into a unary function object by binding the second argument of the binary function to a specified value.

So in our case, we will be using`bind2nd`, as follows:-

```cpp
std::vector wholeNumbers = { 1, 2, 4, 5, 6, 7, 9, 10, 12, 15, 17, 20 };

std::count_if(wholeNumbers.begin(),

wholeNumbers.end(),

std::bind2nd(IsDivisible, 2));
```

Unfortunately, C++ stayed with `bind1st` and `bind2nd`, and currying was not that evident or securely possible since C++ did not have required facilities, say something like the C# `delegate`. So the concept has been in vogue from long time ago. Like every paradigm in programming, functional programming requires (re)aligning our thought (process). Instead of treating functions as just reusable pieces of code (as considered in procedural programming), they have to be conceived as the input processors, which may return either data or whole new function.

So that is a quick thought on Currying. I will try to share a few other thoughts related to currying, slightly expanding to functional programming but later.

[^1]: http://msdn.microsoft.com/en-us/library/sh813d0y%2528v=VS.90%2529.aspx
[^2]: http://msdn.microsoft.com/en-us/library/3f0defz2%2528v=VS.90%2529.aspx
