---
title: final, const and beyond
author: vivekragunathan
layout: post
date: 2015-10-13T08:13:30+00:00
url: /posts/final-const-beyond
categories:
  - C++
  - Java
  - Programming
  - Uncategorized
tags:
  - 'C#'
  - const
  - final
  - immutability
  - Java

---

What are your thoughts on the following piece of code?

```java
public String someGibberishMethod() {
	int length = someMethodReturningLength();
	int sum = 0;

	for (int index = 0; index < length; ++index) {
	   // some code that updates the sum variable
	}

	SomeClass someClass = new SomeClass(sum);
	int sumValueInsideSomeClass = someClass.getSumValue();
	// use someText, maybe log or something

	String someText = someClass.doSomeOperation(/*some parameters*/);
	// use someText, maybe log or something
	return someText;
}
```

<!--more-->

>It is imperative if you are programming with imperative languages you should be explicit in your intent to achieve precision. That is why imperative languages provide keyword constructs.

That said the above code is not explicit or rather precise in specifying if the variables should be allowed to mutate or not. That is the theme of this post - immutability.

The claim "_But the code works!_" is just argumentative and yields no value. If the code is less than perfect in any way, it is a great opportunity to make it better.

Alright, what language did you guess the above code is? ... C++, Java or C#?

>This post is neither a language war nor is biased towards a certain language. It is an exploration across languages of a highly-wanted facility or discipline.

That is Java code. So how do express the fact that variables like `length`, `sumValueInsideSomeClass` etc. do not change after they are initialized? Mark it `final`.

```java
public String someGibberishMethod() {
	final int length = someMethodReturningLength();
	int sum = 0;

	for (int index = 0; index < length; ++index) {
	   // some code that updates the sum variable
	}

	final SomeClass someClass = new SomeClass(sum);
	final int sumValueInsideSomeClass = someClass.getSumValue();
	// use someText, maybe log or something

	final String someText = someClass.doSomeOperation(/*some parameters*/);
	// use someText, maybe log or something
	return someText;
}
```

But what good does `final` do with these variables[^5]? After all, it is just another blue colored text on the screen.

* Variables[^1] marked `final` offer a certain level of confidence in the rest of the code that consumes it. `final` variables are fenced from any accidental or unintentional changes, which is a big source of bugs. You might think _What is he talking about? Accidental change? How could somebody change a variable like that?_ Yes, nobody would that intentionally. But if the method is 800 lines with a rich history how it got so big and tradition of preserving it so then unintentional change is unavoidable. Such methods exhibit a couple of patterns:

     * Wild variable names otherwise unrelated to its purpose or context
     * the above pattern slowly pushes the code in the eventual reuse of the variable(s), which leads to unintentional change in the current context

   For bug fixing or refactoring, `final` sets the context which variables could change or which shouldn't. For new code, it establishes the discipline of writing precise code.

* The other reason based on second-hand information is that it allows the runtime to optimize the code with inlining, register based variables and such. Although I fail to provide accurate details, you get the idea, right?

So we can be confident that `length` or `sumValueInsideSomeClass` will not change. That goes for other `final`s like `someText` and `someClass`. Sounds right? No?

Marking `someText` `final` ensures that `someText` shall only point to the `String` instance it was initialized with, and shall not change to point to another `String`. However, it does not guarantee that the `String` it points to when initialized will not change. But since `String` is guaranteed to be immutable, it effectively means `someText` will not see any changes, whatsoever, after it is initialized.

Things are not black and white with `someClass`. Marking it `final` ensures that `someClass` shall point only to the `SomeClass` instance it was initialized with. But there is no guarantee that the instance shall not incur state changes even if we scope the discussion to the above method, and not necessarily to the entire application.

The only other way to ensure that a reference type such as `SomeClass` is to hand-code it to be immutable. In Java, you do the following to create an immutable `class`:

* _Mark the member fields of the class private and final_ so that they cannot be accessed outside the class (even subclass), and must be initialized inline or in the constructor. Marking the member fields `final` ensures that the fields are not modified in any of the methods, even though they need not be named setXXXX (as fanatic Java programmers believe)

* _Mark the `class` `final`_ to prevent subclassing. Otherwise,  subclasses could use the single winning factor of Java - all methods are virtual, to their advantage. Subclasses could override the getter methods to provide a mutable view of the class. Or they could add other member fields.

Immutability is of two flavors:

1. Immutable View - an object appears to be immutable for a defined scope or parts of the code while it may be inherently a mutable one.
2. Immutable Object - That means the object is truly immutable like the `String`.

I think Java fails to address both flavors, elegantly or out of the box. Java offers immutability for primitive data types only. A reference type variable such as `someClass` is nothing but processor word-sized integer (ignore the inaccessible header and metadata), which we should consider a primitive data type for the discussion. The actual object has no control and is the real culprit at large.

Besides, using `final` to prevent subclassing is a keyword abuse. If `final` meant to prevent changes, marking a `class` `final` should mean that it is immutable (the second flavor above, which syntactically establishes the two immutability invariants).

**Enter `const`** ...

`const`? Yes, `const` as in C++ constant qualifier.

```cpp
int someGibberishMethod() {
	const int length = someMethodReturningLength();
	int sum = 0;

	for (int index = 0; index < length; ++index) {
	   // some code that updates the sum variable
	}

	const SomeClass* someClass = new SomeClass(sum);
	const int sumValueInsideSomeClass = someClass->getSumValue();
	// use someText, maybe log or something

	// some more code ...

	return 22;
}
```

`const` offers the same guarantee like `final` for primitive data types (`length`, `sumValueInsideSomeClass` etc.). For the rest, it gets interesting.

>The `const` qualifier can be seen to have two facets - consumer and provider. Pardon the terminology. When being a consumer such as `strlen` (see code below), it offers the `const`ness guarantee for the input consumed. For a provider, `const` mandates to provide the guarantee - `const` methods in an interface[^2].

In C++, a raw string is represented as a pointer to a sequence of characters.

>Of course, it is highly discouraged to use raw strings (or raw pointers for that matter) anymore. Instead use `std::string`.

Let us move on ...

```cpp
size_t strlen(const char* str)
{
	int len = 0;

	if (str == nullptr)
	{
		return len;
	}

	while (*str++ != '\0')
	{
		++len;
	}

	return len;
}
```

That is a sample implementation of a string length function. The `const` qualifier on the `char*` argument `str` provides a strong guarantee that the _function may do anything but alter the contents_.

Alternatively, to allow altering the content but point nowhere else, push the `const` beyond the star; `char* const str`. To disallow both - pointer or content change, make it `const char* const str`, which is primarily for read-only purposes like writing to the console.

You could also `const`-qualify the methods of your class, and establish the guarantee that the method shall not alter object state. This is especially useful when you are implementing a framework in which the client code has to implement certain interfaces/methods. You mandate the client to implement `const`-qualified methods. But what if the client code tries to trick by implementing/providing a non-`const` version of the method.

>C++ was designed to be smart. It's just the syntax is clunky.

C\+\+ considers the `const` and non-`const` methods as different overloads. So in the above case, C++ will complain the class does not implement the required function; unimplemented pure virtual method error.

With `const` methods, you get Immutability View out of the box. You can pass on the type with `const`-methods only (more like a read-only interface) freely and reliably to any part of your code, and can be confident that the code consuming your object through this read-only interface will not be altering the object state.

>A counter-argument of `const_cast`[^3] has to be ignored since we are talking about establishing discipline, and also what the language has in store to realize the discipline (not just following conventions).

An _Immutable Object_ is not an easy joke. C\+\+ offers `const`-ness guarantees that are useful from a practical standpoint in the context of imperative languages. Java offers relatively stronger yet broken[^4] guarantees for writing an immutable class.

C# plays Canadian. I wonder why the C# team has not offered anything in this area. `const` in C# denotes a compile-time constant, and has no relevance to the topic of our discussion. Perhaps, _Anders Hejlsberg_ is convinced that C# is an imperative language; providing a half-baked solution for immutability yields no value but something for especially anti-C# folks to chew on.

Immutability is a fundamental requirement for writing fault-free (or tolerant) and concurrent applications. Like everything else, it takes a bit of getting used to. Imperative languages do their best to offer immutability constructs, which without a doubt is not sufficient to write good code. Given what we have it is important to develop the discipline of using `final` or `const`; they are not nice-to-haves but must-haves. It is high time disciplined programming went mainstream.

Where does that leave us? Nowhere but in an unfair world like [before](/2015/08/24/tuples-anons/).

**Go functional** ...

[^1]: Conventionally, variables are tokens that hold a value, and the value can change. Variables marked `final` don't change. Well, are they _variables_ anymore? It is just word-play that drives the argument towards terminology and tends to give up on establishing the discipline of using `final` (or whatever is the keyword for the respective language).

[^2]: There is no direct facility in C\+\+ to declare an interface; like the `interface` keyword. Not sure what the C++ committee is waiting for! But an interface-like facility can be realized by declaring a class with only pure virtual methods (and additionally following a convention of prefix the class name with an I to denote an interface; `IBufferReader` for example. The word interface in the context of C\+\+ in this post refers to any such class mentioned above.

[^3]: The fact that `const_cast` breaks the const-ness invariant is a Foot Gun. Brendan Eich, the creator of JavaScript, calls features in a language that ideally should be in the language yet they are believed to have been added for a reason, as Foot Guns - devices that you use to shoot yourself in the foot. Douglas Crockford mentions about it in his YUIConf 2014 [talk](https://www.youtube.com/watch?v=bo36MrBfTk4#t=2020).

[^4]: A class intended to be immutable despite being marked `final` (self and member fields) can still have non-private and/or non-`final` member fields. It is more of an idiom, stronger but still broken.

[^5]: I have been highly discouraged by managers or at least questioned why am I littering the code with `final`?
