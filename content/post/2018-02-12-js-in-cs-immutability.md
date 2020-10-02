---
title: JS Programming in C# - Immutability
author: vivekragunathan
layout: post
date: 2018-09-18
url: /2018/02/18/js-in-cs-immutability
categories:
  - Functional Programming
---

Enough! JavaScript had us in its grip for long with its foot guns. The first time I heard the term _Hoisting_, I had no idea about it and misheard as _hosting_. You declare variables using _var_ happily, and you have to come to peace with yourself that it is okay to _hoist_ the `var`s (lift'em all to the top-most scope). I can't believe JS convinced the rest of us that it was okay. Then came ES6 and saved us. [`let`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let) fixed the scoping. [`const`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const) provided immutability. At least now, you can say JavaScript supports functional programming.

> JavaScript got feathers on its hat - `let` and `const`.

Even a kid would tell you that the top 2 facets of functional programming are immutability and functions as first-class citizens viz. Higher Order Functions (_HOF_). The other facets are equally important but without the top two, there is no functional programming.

From day one, C# has supported the ability to treat functions as first-class citizens through `delegate`s. Yes, the concept of _HOF_ wasn't at its best in C# until the introduction of anonymous delegates or better [lambda]()s later. But, hey, you were able to pass functions around as data.

That was one side of the coin - _HOF_. What about the other side - immutability? As you should know by now, [**Immutability**](https://vivekragunathan.wordpress.com/2017/12/06/facets-of-immutability/) is not a light subject.

>It is a shame that even after 15+ years, C# doesn't yet support immutability ... **fully**.

C# supports (compile-time) constants (`const`), and a partial or rather peculiar support for immutable variables (`readonly`). With `readonly`, you can only declare immutable _member_ variables. It cannot be used with local variables or method parameters. But here's the peculiar part.

> A `readonly` is still mutable within the constructor.

I wonder why.

**Selling Immutability**

I am a big fan of [immutability](https://vivekragunathan.wordpress.com/2017/12/06/facets-of-immutability/). The confidence that an immutable variable provides is irreplacable. Once you start declaring immutable variables - assignable only once, the complexity of your code / logic untangles and assembles itself in steps. Individual steps of your logic wire smoothly in a chain / pipeline allowing each step to be tested independently.

**Immutability for C#**

I have not read (any) proposals myself but heard rumors, once or twice, of adding support for immutable variables in C#. Like I said, I haven't looked into the proposals, so I am dreaming here.

There are several ways to get C# support immutable variables.

**New Keywords/Quantifiers**

- **`val`**

	... as in Scala or pairing up with C#'s own `var`.

	Despite being succinct and using an establish convention, I don't like this option because of two reasons:

	- `var` was invented primarily for automatic type deduction or what C# calls [implicit typing](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/implicitly-typed-local-variables) specifically for LINQ queries that return anonymous types. Although the C# team was smart in making it more or less general purpose, it might have been better named `auto`. Since C# is not a purely functional language and is inherently imperative, it just so happens that `var` naturally got related to (mutable) variable.
	- `var` is restricted to local variables. It cannot be used as class members, method parameters etc.

	Should `var` be lifted outside function scope to class members and others so that `val` becomes an apt counterpart? In other words, `var` and `val` should be freely usable - local variables, members arguments etc. That won't work because `var` on parameters does not make sense (an indication that `var` is `auto`) and `val` on class members overlaps with `readonly`.

	If `var` is not lifted, yeah maybe, `val` might work. Or maybe, not quite so. For instance, if we assign a LINQ query returning an anonymous type to a `val`, we would expect `val` to perform automatic type deduction. Although it is nice, `val` now is doing more than what we started with viz. immutable variables.

	Over the recent years, C# has been trying to appeal to the Java and JavaScript community more than its patrons. A `val` would appear to be an effort to appeal to the Scala community.

	Like I said, `var` and `val` pair up verbally but not in their purpose. There is definitely some noise around there.

- **`immutable`**

	... in parlance with F#'s `mutable`.

	Of all the ways to declare variables, mutable and immutable, I like the F#'s most; better than `var` and `val`. F# starts with immutable variables as its default and wants you to explicit state that you like to make a variable mutable, just like Scala. But the beauty of F# is having to decorate the default `let` with `mutable` making it stand out visually.

	```fsharp
	// F# code
	let imCount          = GetNoOfItems();
	let mutable mutCount = GetNoOfItems();
	```

	Borrowing the idea, we could come up with an `immutable` keyword.

	```csharp
	// C# code
	int mutCount          = GetNoOfItems();
	immutable int imCount = GetNoOfItems();
	```

	Does the job. Besides being mouthful, what do we with `readonly`? Two different keywords for essentially the same thing. This will be a catalyst for introducing yet another for immutable method parameters. Come on, this isn't PHP 😂.

    If thrown for a vote, I am sure this option would lose.

**Reuse Existing Keywords/Quantifiers**

- **`const`**

	A vehement _No_. A constant is [different](https://vivekragunathan.wordpress.com/2017/12/06/facets-of-immutability/) from an immutable variable. Any attempt to reuse will skew the meaning of existing conventions in C#. Case closed.

- **`let`**

	Mixed feelings. `let` was schooled for LINQ queries. Although the (intermediary) variables declared through `let` are immutable[^1], it is not particularly obvious in an imperative language like C#. A `let` in C# does not suggest the same thing as in F#.

	Suppose we go with `let`, do we make it an independent keyword or a modifier on existing variable declarations?

	```csharp
    // C# code
	let immutableCount = GetNoOfItems();
	```

	or

	```csharp
    // C# code
	let int imCount	= GetNoOfItems();
	```

	I prefer the latter because the former is on the same boat as `val` and implicit typing thing we discussed earlier. The latter seems to fit the bill. Just that `let` has got this unintended feel of a lame copy from F# and poorly applied. Do we really want that blame?

- **`readonly`**

  If done right, this would be the perfect choice. Before dealing with the _perfect_ side of it ...

  - Scope wise, `readonly` is the opposite of `var`. A `var` is stuck inside methods while `readonly` is stuck outside. Oh, lovers apart! Earlier we discussed about lifting `var` outside the function scope. Here, we like to get `readonly` into function scope.

  - `var` is the equivalent of the actual type specifier (or the type auto-detected). `readonly` is a modifier on a type specifier. So, `readonly` goes well with `var` too. _Lovers meet_. So, `readonly var imCount = …` is as legit as `readonly int imCount = ...`.

  - `readonly` is equivalent of F#'s `mutable` producing the reverse effect. A `readonly` in C# makes a variable immutable while `mutable` does the opposite in F#. Both are modifiers on variable declarations.

  So, shall we declare `readonly` the winner? Yes, but not quite. It is not a perfect choice yet. Because let us remind ourselves that `readonly` is a peculiar one.

  >**If we make one breaking change of no longer supporting `readonly` member variables mutable inside a constructor then `readonly` should be the perfect choice.**

  I will argue that mutated `readonly` member variables today can be rewritten to once-assigned and truly immutable variables. So, a breaking change here is truly for the win.

**Other side of the fence**

Languages that started out as functional first like Scala, F# and others are well-off; as far as immutability is concerned. On some level, I would say C++ too has got it covered; nevertheless beware of quirks.

It shouldn't be exaggerating to say that JavaScript has by far the largest community behind it; the support of which blessed it with `let` and `const`.

Let us take a moment to interrogate the arch rivals we created - C# and Java.

Java started out with support for immutability but not _HOF_; until the introduction of lambdas in version 8. So now, you can do functional programming in Java; or so they say.

On the other hand, C# started out with (a little crude) support for _HOF_ and is still limping its way towards supporting immutability. No wonder, they are arch rivals. What an odd world we live in.

***

Needless to say, there should be other good options. Love to hear.

C# is a very carefully designed language. There is abundant written material to prove that. At the same time, it is man-made. So any limitations or shortcomings one should see should be seen with some love.

It is unfortunate that each language starts out with a certain flavor - imperative, OO, functional or whatever, and later finds itself struggling or unable to support other flavors.

> A _reasonable_ language should support and allow picking from a variety of widely practiced paradigms, techniques and styles of programming and yield to the _reasonable_ programmer to implement a solution that fits the problem.

Or so did _Bjarne Stroustoup_ say (something similar), of course quoting C++. He was right in every way.
