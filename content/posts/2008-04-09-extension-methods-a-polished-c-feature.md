---
title: Extension Methods – A Polished C++ Feature
author: vivekragunathan
layout: post
date: 2008-04-09T06:31:39+00:00
url: /2008/04/09/extension-methods-a-polished-c-feature/
categories:
  - .NET
  - 'C#'
  - C++
  - Programming
  - Uncategorized
tags:
  - 'C#'
  - extension methods
  - interface principle
  - koenig lookup

---

Extension Methods is an excellent feature in C# 3.0. It is a mechanism by which new methods can be exposed from an existing type (interface or class) without directly adding the method to the type. Why do we need extension methods anyway ? Ok, that is the big story of lamba and LINQ. But from a conceptual standpoint, the extension methods establish a mechanism to extend the public interface of a type. The compiler is smart enough to make the method a part of the public interface of the type. Yeah, that is what it does, and the intellisense is very cool in making us believe that. It is cleaner and easier (for the library developers and for us programmers even) to add extra functionality (methods) not provided in the type. That is the intent. And we know that was exercised extravagantly in LINQ. The IEnumerable was extended with a whole lot set of methods to aid the LINQ design. Remember the `Where`, `Select` etc methods on `IEnumerable`.

<!--more-->

An example code snippet is worth a thousand words:-

```cpp
static class StringExtensions
{
///
/// ‘this’ decorator signifies that this is an extension method.
/// It must be appear only on a public static method.
/// Such a method is added to the public interface of the type following
/// the ‘this’ decorator.
///
public static int ToInteger(this string s)
{
  return Convert.ToInt32(s);
}

public static string Left(this string s, int position)
{
  return s.Substring(0,position);
}

public static string Right(this string s, int position)
{
  return s.Substring(s.Length – position);
}
}
```

You might be aware of all this hot news. But our topic of the day is neither Extension Methods nor LINQ. It is something that dates back to C++. And you will see at the end of this post that extension methods are a polished version of a C++ principle. Ok, let us try to read some code:-

```cpp
int Add(SomeClass& sc, int x)
{
  // Let us get to here a little later.
}

class SomeClass
{
  private: int m_nNum;
  public: void SomeMethod(int n);

  public: int Num const
  {
    return this->m_nNum;
  }
};
```

The code is simple – We have a class called `SomeClass` and a global function. The global function takes a `SomeClass` instance by reference and an integer by value. The intent of the function is to add `x` with m_nNum. But whether to save it to `m_nNum` or just return is a topic we will deal in a little while. But do we understand that the `Add` function and `SomeClass` are closely related ?

There are two principles to know in C++ to understand the relation.

**Interface Principle**

For a class `X`, all functions, including free functions, that both (a) _mention_ `X`, and (b) are _supplied with_ `X` are logically part of `X`, because they form part of the interface of `X`.

** Supplied with X means that the function is provided (distributed with) in the same header file as X.*

So now, Add mentions SomeClass and (to keep the discussion short assume that it) is supplied with `SomeClass`. If that, then `Add` is a part of the public interface of `X`. That should convince you.

**Koenig Lookup**

When an unqualified name is used as the postfix-expression in a function call, other namespaces not considered during the usual unqualified lookup may be searched, and namespace-scope friend function declarations not otherwise visible may be found. These modifications to the search depend on the types of the arguments. Those are lines from the C++ standard and must be tough to understand like the verses in the Bible. So let us talk our language to understand that:

```cpp
namespace CPP
{
  class SomeClass { };
  void Foo(SomeClass);
}

CPP::SomeClass sc;

void main()
{
  Foo(sc);
}
```

Will you be still surprised that `Foo(sc)` call will link to the `CPP::Foo` ? Dont be. That is what the cryptic lines above talks about. Ok, one more example:


```cpp
namespace CPP
{
  class SomeClass { };
}

void Foo(CPP::SomeClass);

void main()
{
  CPP::SomeClass sc;
  Foo(sc); // Got it ?
}
```

So now down to my point, Extension Methods is a polished version of the _Interface Principle_ (or _Koenig Lookup_) in C++. The facility has been in C++ for a long time but not sure if exercised well (and wisely). Had the intellisense been intelligent enough, C++ would claimed it a mighty feature. Since the C++ IDE has been the same sucking way for a long time now, C++ got the wrong outlook – a hard programming language.

Hey C#, No hard feelings. It is just a perspective. Either way, **My compiler compiles your compiler**.
