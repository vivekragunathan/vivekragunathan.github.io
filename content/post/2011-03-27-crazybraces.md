---
title: 'Crazy Braces – [](){}();'
author: vivekragunathan
layout: post
date: 2011-03-26T18:38:23+00:00
url: /2011/03/27/crazybraces/
categories:
  - C++
  - Uncategorized
  - Unmanaged

---
What does this cryptic bracket sequence mean? What programming language is it? Is it valid syntax? If there is even a weak chance of this syntax being valid? If so, what does it mean?

Alright, alright, alright! It is C++. That would calm most people; with all their love (pun) for C++. Specifically, it is C++0x. Amongst many other features that we have been waiting for, C++0x gives us the power of lambdas.

The formal definition of a lambda in C++0x is as follows:-

```cpp
[capture_mode] (parameters) mutable throw() -> return_type {
   body
}
```

A lambda may capture one or more variables in scope by value or by reference, or it may capture none. Specifying `return_type` is not necessary if the type can be inferred or is void.

For instance, a `std::for_each`‘s functor based code could be inlined with a lambda as follows:-

```cpp
std::for_each(v.begin(), v.end(), [](int x) {
   cout << x << std::endl;
});
```

A lambda definition could be assigned to a variable and then used or invoked later.

```cpp
auto lessthan = [](int left, int right) {
    return left < right;
};
```

In the above code, `lessthan` represents a function that takes two int parameters, and returns a `bool`. And it can be invoked as `lessthan(2, 3)`, which returns `true`. The cute thing about a lambda is that it can invoked directly right after its definition. The following code defines a lambda (which takes two ints and returns a bool) and invokes it right away.

```cpp
[](int left, int right) {
   return left < right;
} (2, 3);
```

Coming back to our initial question now! You should have guessed it by now.

>The bracket sequence – `[](){}();` – is nothing but a definition followed by a call (right away) to a lambda taking no arguments and returning nothing.

To end with a quote, C++ code is like [Calligraphy](https://en.wikipedia.org/wiki/Calligraphy). In other words, it is beautiful to those who understand it, while cryptic to others.

***

<small>P.S: Bear with me if calligraphy is not an appropriate analogy.</small>