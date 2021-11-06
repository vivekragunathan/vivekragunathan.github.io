---
title: Know Thy Option
author: vivekragunathan
layout: post
date: 2020-04-17
url: /2020/04/17/know-thy-option
categories:
  - Scala
  - Functional-Programming
summary: |
  Avoid `.get` at all costs. Forget there is even a `.get` function on `Option`. There is always a way out - better one, than using `.get`. Same applies to `.head`

  If you are going to have access the value in an `Option` in a test class, prefer extending your test class from `OptionValues`. Then you can use `.value` on an `Option`. Doing so establishes the presence of value as verification with meaningful error if value is not defined.
---

- Avoid `.get` at all costs. Forget there is even a `.get` function on `Option`. There is always a way out - better one, than using `.get`. Same applies to `.head`
- If you are going to have access the value in an `Option` in a test class[^1], prefer extending your test class from `OptionValues`. Then you can use `.value` on an `Option`. Doing so establishes the presence of value as verification with meaningful error if value is not defined.

<!-- more -->

## Did you know ?

- `Option` maybe viewed as a sequence (of zero or one element). This is for convenience when working with `Option`, which is why see a `.head` on an `Option`.

## The Different Options

Following are the different ways to _avoid the use of `.get` or `.head`_ to yield a value from an `Option`.

### **`map` and `flatMap`**

When you think of reaching into an `Option` for its value, `map` or `flatMap` is the defacto choice and is safe because they allow us to safely reach into `Option` only if there is a value inside. They may be chained back to back to attempt a series of transformations on the `Option`. Since the resultant type of the  transformations is still an `Option`, it is common for `map` or `flatMap` to end with one of the `getOrElse` , `fold` or is pattern `match`ed to resolve to a value.

```scala
val maybeGreeting: Option[String] = ...

def personalizeGreeting(g: String): String = ...

val mayBeGreetingBanner = maybeGreeting.map(personalizeGreeting)

// ---------------------------------------------------------------

val maybeGreetingKey: Option[String] = getGreetingKeyConfigName()

def readGreetingValue(g: String): Option[String] = ...

val maybeGreeting = maybeGreetingKey.flatMap(k => readGreetingValue(k))
```

### **`getOrElse`**

```scala
val maybeGreeting: Option[String] = ...

val g: String = maybeGreeting.getOrElse("Hello!")

val g: String = maybeGreeting.map(_.upperCase).getOrElse("HELLO!")
```

`getOrElse` provides a default or replacement value if the `Option` does not have a value. It is commonly used in cases where the intent is to resolve to a value by *optionally* running a sequence of transformations; a common default value if none of the transformations in the pipeline yields a value.

```scala
val maybeGreeting: Option[String] = maybeValueFromConfig()

val simpleStyleGreeting: String =
   maybeGreeting.getOrElse("Hello!")

val yelling: String = 
  maybeGreeting
    .map(_.upperCase)
    .getOrElse("HELLO!")

val greetingAfterTransformations =
  mayBeGreeting
    .flatMap(maybeValueFromSource1)
    .flatMap(maybeValueFromSource2)
    .flatMap(maybeValueFromSource3)
    .getOrElse("Hello!")
```

`greetingAfterTransformations` may have one of the following values:

1. `maybeValueFromConfig`
2. Otherwise, `Hello!` even if one of the transformations (`flatMap`) does not yield non-empty `Option`
3. Otherwise, the string after running each of the transformations - `maybeValueFromSource1`, `maybeValueFromSource2`, `maybeValueFromSource3`.

   The subtlety in `greetingAfterTransformations` is that it is not explicit which transformation did not yield a value and was defaulted with `Hello!`.

### **`orElse`**

Consider `orElse` as the dual of `flatMap`. While `flatMap` runs when the `Option` has a value, `orElse` does the opposite. It runs when the `Option` does not have a value. Like `flatMap`, `orElse` expects an `Option` back from the evaluated expression.

```scala
import cats.syntax.option._
import cats.instances.functor._

val maybeG: Optional[String] =
  maybeGreeting.orElse("Hello!".some)
```

### **Pattern `match`**

One of the facilities that would have

```scala
val g: X =
  maybeGreeting match {
    case Some(g) => ...
    case None => ...
  }
```

where `X` is the type of value returned by the `match` expression.

```scala
import cats.syntax.option._
import cats.instances.functor._

val maybeGreeting: Option[String] = ...

val g: String = maybeGreeting.getOrElse("Hello!")

val g: String = maybeGreeting.map(_.upperCase).getOrElse("Hello!")

val maybeG: Optional[String] = maybeGreeting.orElse("Hello!".some)

val g: String =
  maybeGreeting match {
    case Some(g) => ...
    case None => ...
  }

val g: String =
  maybeGreeting.fold("Hello!") { g =>
  if (g.startsWith("How")) s"$g?"
  else s"$g!"
  }

val maybeG: Option[String] =
  maybeGreeting.innerMap {
    case Some(g) if g.startsWith("GG") => ...
    case Some("How are you?") => ...
  }
```

### **`fold`**

When you want to resolve to a value with explicit paths for the empty and

```scala
val g: String =
  maybeGreeting.fold("Hello!") { g =>
    if (g.startsWith("How")) s"$g?"
    else s"$g!"
  }
```

## Finally

As you can see, there is a myriad of options to avoid `.get` or `.head`, each with a different style and purpose and fitting different situations. You did not ask the question: _why should we avoid `.get` or `.head`?_

[^1]: Test code is real time code. It is used / executed several dozen times a day. Its quality is equally vital to a robust application. So, it is natural to develop a lot of classes and facilities to write better quality tests. It is recommended to reserve the use of `OptionalValues`.`value` in the tests themselves rather than in the facilities supporting the tests.
