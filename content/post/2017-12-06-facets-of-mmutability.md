---
title: Facets of Immutability
author: vivekragunathan
layout: post
date: 2017-12-06
url: /2017/12/106/facets-of-mmutability
categories:
  - Functional Programming
---

Immutability, the cornerstone of functional programming, has many facets.

Not every (mainstream) language supports all the facets; at least not per what each facet stands for. That's what I will talk about today. The various facets of immutability from a theoretical perspective, and briefly show how some of the mainstream languages have adopted and support these facets in their own way.

<!--more-->

**`const`**

I bet you already know what a constant is. Should you need an example[^1], refer the appendix below. In any case, hear me out.

> An identifier **`x`** is called a constant if it satisfies the following criteria
>
> - The value of **`x`** cannot be modified by any means neither at construction nor at runtime.
> - The value of **`x`** is either readily available or can be determined at compile time.

Also called _compile-time_ constants, it is the equivalent of using the value directly at the call site.

On your behalf, the compiler hard-codes the value of the constant at the call-site (place of use). It is up to the compiler either to keep the identifiers in the final binary or throw them away during compilation (since the required values are hard-coded at the call site).

(In an ideal world) A compiler should allow using a constant in any place where its value may be directly used; hard-coded. Although it is straightforward, there are cases like the use of constants in [annotations]() or [attributes](); or its use restricted thereof in some languages/scenarios[^2].

```csharp
// The atrribute values below could be declared as constant
[StringLength(
  120,
  MinimumLength=5,
  ErrorMessage="Value does not meet length requirements"
)]
public string Name { get; set; }
```

A taste of support for constants in a few popular languages:

- C++ - **`const`**
- C# - **`const`**
- Java - **`static final`**
- Scala - **`final val`**[^2.1]
- JavaScript - **`const`** (Well, there isn't a conventional compile time but `const` is still available to the rescue)

Generally speaking, the use of constants is a good practice more than its need and purpose. Because you could hard-code the value as well, and your program will still work the same way. Like I said _generally speaking_. But not so in C++.

As always, C++ has something interesting in store. While those languages that support constants support only constant identifiers (or _constant variables_, just to remind you), C++ supports [**`constexpr`**](https://docs.microsoft.com/en-us/cpp/cpp/constexpr-cpp) or constant expressions. Unlike trivial assignments (`const int X = 10;`), `constexpr` are *expressions* that are evaluated at  compile time. A `constexpr` may be a simple identifier or even a full blown user-defined type (`class`). A `constexpr` is equivalent to using an identifier or the resultant value at the call site.

Let us try this[^3]:

```cpp
constexpr float exp(float x, int n)  
{  
    return n == 0
      ? 1
      : n % 2 == 0
        ? exp(x * x, n / 2)
        : exp(x * x, (n - 1) / 2) * x;  
};
```

The above function `exp` is evaluated at compile time. Using `exp(8, 2)` directly at the call site or assigning to an identifier and consuming it are exactly the same. In either case, the value is computed at compile time and cannot be mutated[^4]. Also, you can throw in templates in the mix.

By the way, if you failed to notice, `exp` uses recursion ... at compile time. In the past, you might have implemented compile-time recursive logic using templates (think canonical `factorial` function). Now, you have `constexpr` on your side.

Recap: In order to qualify as a **constant**, it should satisfy the criteria that we saw at the beginning of this section.

***

**`read-only` (RO), otherwise the constant variable**

The constant that we saw earlier is a compile-time constant. RO is a runtime constant, if you will, although it is not a constant per se. _It is immutable_.

By declaring a variable read-only, we intend to assign a value once (in its respective scope and frame). Needless to say, the value of the variable doesn't change thereafter.

```java
// In Java
public static int someFunc() {
   ...
   final int count = getCount();
   ...
   return someValue;
}
```

The variable `count` is assigned the value returned from `getCount`, and cannot be changed anytime after it is assigned. The scope of `count` is the `someFunc` method and the corresponding thread. `someFunc` executing on another thread will have a different instance of `count` with possibly a different value from `getCount`. In any case, the identifier `count` is _immutable_, albeit its value is determined at runtime. Let me repeat again, the identifier `count` is not a _constant_ but is immutable.

If you think about it, the constant variable is not only a misnomer but an oxymoron. But if we were given a chance to associate the term *constant variable* with something, it would be a *read only variable*.

A taste of support for _read-only variables_ in a few popular languages:

- Java - `final`
- C++ - `const`
- C# - `readonly`
- Scala - `val`
- JavaScript - `const`

Yes, as you might have spotted, in some languages, the same keyword is used for both constants and ROs. Perhaps that is part of the reason why in some languages,  despite declared a constant, it is not allowed to used in all places (like the annotations we saw earlier).

Here is a thing about C#. C# supports readonly variables, in a very limited and restrictive way. `readonly` variables are allowed only as class members and are mutable within the class constructor. In other words, they can be re-assigned but only within the constructor. It is a shame  C#, unlike Java, Scala or JavaScript for that matter, does not allow declaring read-only local variables.

***

**Immutable Objects**

While the `const` and `read-only` are concerned with the identifiers or handles, _immutable objects_ are concerned with entities that the identifiers refer to by name. You can't just wave your hand to accept immutability in general and not acknowledge the difference.

There are a few flavors of immutable objects.

**Immutable Class**

An instance whose members or state cannot be mutated after instantiation. Imagine writing the following in Java:

```java
final class StoneClass {
  private final String name;
  private final int age;

  public StoneClass(String name, int age) {
    this.name = name;
    this.age = age;
  }

  public String getName() { return this.name; }
  public int getAge() { return this.age; }
}
```

.. or if you prefer to be succinct like Scala, write a `case class`:

```scala
case class StoneClass(name: String, age: Int)
```

Once an instance of the `StoneClass` is created, the `name` and `age` cannot change in a thousand years. Changes or mutations are realized by making a copy with new values. I would say _an immutable class is the holy grail of immutability_.

**Immutable Interface or Copy**

Think Java's `Collections.immutableList(list)` or one of the other variants, which hands out an immutable copy of the collection. This flavor is *primarily* associated with collections or container objects, wherein the immutability is applicable to the container objects and not the containee. The containee objects might as well be mutable.

This flavor of immutability is not driven by language keywords. It is a library/API thing. Besides, it need not necessarily (although _primarily_) be associated with collections but simple objects too. The idea is that there is an extensible interface for the type/class of interest that the library/API takes advantage of to look like it is immutable. The ugly side to this flavor is that the mutable portions of the interface are still accessible although they either may not suppress mutation or throw an exception condemning the mutation attempted. Despite that this flavor is still useful to establish [semantics](https://vivekragunathan.wordpress.com/2016/11/07/semantics/), and promote immutability / functional-style programming in an imperative world.

**Frozen**

This flavor of immutability gives the ability to prevent mutations on an object for a brief period of time as opposed to completely banning mutations[^5].

JavaScript's `Object`.`freeze` is a classic example of this flavor of immutability. I am sure you know what `Object.freeze(obj)` does; else [look](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze) it up. The object `obj` is frozen in time until you call `Object.unfreeze(obj)`.

The source object `obj` is not copied but frozen for *everybody* for the period of time until it is unfrozen. This is unlike handing out a read only interface in which case each party can have  either a read only or mutable interface. Bear in mind that the object is inherently mutable. I don't know of other languages that offer a `freeze` method like JavaScript although there are mechanisms to freeze.

I am not a big fan of _Frozen_, and cannot convince myself of scenarios for which this is a good solution. But hey, this is JavaScript, you will have all things here. If it hurts you, you should know it is a *foot gun*. Also, JavaScript, proclaiming to have the lead functional or functional-style programming into mainstream, seems to have misplaced immutability.

You can implement this in Java or C# too. But it is going to be crude. You can save the time and effort, and implement an `immutable class` instead.

**Closure**

If you are working in a pure or strongly functional programming language, you get immutable class for free, a luxury that the imperative style languages are still lacking or unwilling to support. On the flip side, enjoying functional-style, you shouldn't ignore the importance of `const`s, and maybe `constexpr`s too.

How about some Tequila for a closure? By Tequila, I mean C++.

- **`char* cptr`**
  Can change where `cptr` points. Can modify the `char` at the location where `cptr` points.

- **`const char* cptr`**
  Can change where `cptr` points. _Cannot_ modify the `char` at the location where `cptr` points.

- **`char* const cptr`**
  _Cannot_ change where `cptr` points. Can modify the `char` at the location where `cptr` points.

- **`const char* const cptr`**
  _Cannot_ change where `cptr` points. _Cannot_ modify the `char` at the location where `cptr` points.


[^1]: **Usecase for a constant**: Say you are writing a client that makes a bunch of API calls, say 30 different calls, to a third-party server. The API calls mandate a secret key assigned to your client as a parameter (query or form). You could hard-code the secret key in the 30 different methods that make the API calls. Or you could declare a constant, say `SECRET_KEY`, and use that. They are effectively the same. The value of `SECRET_KEY` is known at compile time, and it does not change, for whatever reason. Why do we want a constant if it is no different from hard-coding? Like I said, best practices. By assigning an identifier, we make it compiler-aware. Refactoring and what not. Also, the code that consumes the `SECRET_KEY` is not particular on its value. If the value had to be changed for whatever reason, changing it in one place is definitely better than changing it a bunch of places. Besides, we have a name, a token for a value. Doesn't it make sense it refer it by a name `SECRET_KEY`? Or do you prefer `AX12-345H-900N-TT6R`?
[^2]: Some languages like Java and Scala do not _fully_ support the use of constants in annotations. For the constant to be used in annotations or other places where you would want to use an identifier instead of hard coding the value, the identifier has to be declared in the same class or package. I am not fully aware of the rules. But I have been bitten by it more than once. I did not have the patience and time to chase it to closure. I had other bigger problems to take care of then.
[^2.1]: A `val` in Scala is analogous to `read-only`. Only a `final val` maps to a constant for most purposes but not all as discussed in the corresponding section.
[^3]: The `exp` function was borrowed from [MSDN](https://docs.microsoft.com/en-us/cpp/cpp/constexpr-cpp)
[^4]: `constexpr`  has rules that govern if the value can be determined at compile time. Read more. For instance, `exp(num)` cannot be computed at compile assuming `num` is not a compile time constant. Also, the value of a `constexpr` may be assigned to a mutable variable and could changed at run time, which is not under the purview of `constexpr`. `constexpr` is more of an indication to the compiler to try to evaluate the expression at compile time; similar to `tailrec` in some languages.
[^5]: Imagine the user interface freezing for a few seconds when it is gone to do its thing when you clicked that button. Generally, the user interface is usable but it freezes for that bit. Scrap that, I was just trying to be funny.

***

<small>Featured image is some hill near Cascavelle, Mauritius. Courtesy: self.</small>
