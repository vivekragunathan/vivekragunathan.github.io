---
title: Properties in C++/CLI - The C# look alike
author: HKT
layout: post
date: 2006-04-11T03:56:00+00:00
url: /posts/ccli-props-cs-look-alike
aliases:
- /2006/04/11/properties-in-ccli-the-c-look-alike/
categories:
  - Uncategorized

---

Inherently after writing some code in C#, I wanted everything to be as easy to do like in C#. And could not resist myself writing property like syntax in C++ [ofcourse C++/CLI, threw away the ugly Managed C++ before it was too late for my code to grow into a tree]. Then I learnt that properties are supported in C++.NET too but as always in the ugly way. But in C++/CLI, I was happy enough that the syntax is more elegantly redefined. For instance, there was this boolean member `logToStdError` in my class, and in my legacy code, the property definition for `logToStdError` looked like:-

```cpp
__property bool get_LogToStdError()
{
  return logToStdError;
}

__property void set_LogToStdError(bool value)
{
 logToStdError = value;
}
```

Doesn't that seem like the cat scorching its skin wanting to look like a tiger ? But we need to understand that the Managed C++ is just an extension provided by Microsoft for C++, and is not standard unlike C++/CLI. And then in C++/CLI, the syntax for property was reformed with the property keyword:-</p>

```cpp
property bool LogToStdError
{
  bool get() { return logToStdError; }
  void set(bool value) { logToStdError = value; }
}
```

This makes life bit luxurious, and the compiler takes care of still generating the `get_LogToStdError` and `set_LogToStdError` versions of the methods. Try defining a method with that name and see what happens.

The purpose of this post is not just put another note on C++/CLI Property instead there are 2 cute features that I liked:-

1. If the property that we define is a very simple one, just getting and setting the value of the related member variable, then we can simply declare a statement like this in our class [for the LogToStdError], and the compiler takes care of the under-the-cover activities.

```cpp
property bool logToStdError;
```

2. This one I love very much because I wanted this behaviour in a lot of places in my code, and before. It is possible to specify different accessibility levels for the get and the set property accessors. For example ...

  ```cpp
  property bool LogToStdError
  {
    public: bool get() { return logToStdError; }
    protected internal: void set(bool value) { logToStdError = value; }
  }
  ```

  The get accessor can be accessed anywhere outside the class in the assembly, but the set accessor can be accessed only inside the current assembly or within the types derived from the type in which LogToStdError is declared. I guess that this facility is not available in C#.
