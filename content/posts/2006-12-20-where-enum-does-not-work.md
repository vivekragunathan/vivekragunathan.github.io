---
title: where enum does not work
author: HKT
layout: post
date: 2006-12-20T12:25:00+00:00
url: /2006/12/20/where-enum-does-not-work/
categories:
  - .NET
  - 'C#'
  - CodeProject
  - Uncategorized

---

I was writing a [generic](http://msdn2.microsoft.com/en-us/library/0x6a29h6.aspx) method with `enum` as the [Constraint](http://msdn2.microsoft.com/en-us/library/d5x73970.aspx), and the compiler spat a few errors that did not directly convey me that `enum`s cannot used as generic constraints. I learnt the following from my investigation:

Following is an excerpt from the [C# language specification](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-334.pdf) **for generic constraints**

---

A _class-type_ constraint must satisfy the following rules:

- The type must be a class type.
- The type must not be sealed.
- The type must not be one of the following types: `System.Array`, `System.Delegate`, `System.Enum`, or `System.ValueType`.

- The type must not be `object`. Because all types derive from `object`, such a constraint would have no effect if it were permitted.

- At most one constraint for a given type parameter can be a class type.

A type specified as an _interface-type_ constraint must satisfy the following rules:

- The type must be an interface type.
- A type must not be specified more than once in a given `where` clause.

---

There you have it. The specification deliberately restricts value types and `enum`s as generic type parameters. But if you wish to specify a non-reference type as the *primary* constraint, a `struct` can be used.

```csharp
private void Method where T : struct
```

We know that the numeric types like `int`, `float` etc in C# are declared `struct` (value type). An `int` (Int32) is declared as follows:

```csharp
public struct Int32 : IComparable, IFormattable, IConvertible, IComparable, IEquatable
```

Whereas an [`enum`](http://msdn2.microsoft.com/en-us/library/system.enum.aspx), though a value type, is declared as an abstract class that derives from `System.ValueType`; unlike `int` or `float`. However, the end result is `enum`s are value types. Go figure!

Anyway, the question still remains unresolved – why `enum`s cannot be used as constraints. *Because the language specification says so* is not satisfactory.

I am not sure if there is any other way to resolve my situation. Question open to cyberspace !!!

------

<small>P.S. Refer section 25.7 through for the specification on Generic Type Constraints.</small>
