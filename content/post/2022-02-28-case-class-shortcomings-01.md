---
title: Case Class Shortcomings - Part 1
author: higherkindedtype
layout: post
url: /posts/case-class-shortcomings-01
aliases:
  - /posts/case-class-shortcomings-01
  - /posts/sum-type-companions
date: 2022-02-28
categories:
  - Scala
summary: |
  Despite all the power and utility that `case class`es provide, there are a couple of things that Scala could have done better. This post discusses the situation of defining the (ADT) sum type companions across multiple files.

---

Despite all the power and utility that `case class`es provide, there are a couple of things that Scala could have done better. This post is a first out of the three (I think) that discusses about, for a lack of a better word, the shortcomings of `case class` [^1]. I say shortcomings because the missing features are not a corner case. So, I would have expected them to be supported first hand in Scala.

Here it goes.

**Defining Sum Type Companions Across Files**

Recently, I had to write an ADT. Interestingly, the sum types had quite a bit of logic in them - `implicit` definitions, type specific helpers and so on. Having them all in one file was nothing but distraction to the eader; too much code so to speak.

Here is a contrived example:

```scala
sealed trait ErrorType

object trait ErrorType {
  final case object None extends ErrorType
	final case class BadRequest(field: String) extends ErrorType
	final case class NotFound(id: Long, msg: String) extends ErrorType
	. . .
	final case class Unknown(msg: String) extends ErrorType

	object BadRequest {
		// implicit definitions
		// BadRequest specific helpers
	}

	object NotFound {
		// implicit definitions
		// NotFound specific helpers
	}

	object Unknown {
		// implicit definitions
		// Unknown specific helpers
	}

	. . .
}
```

Each of the sum types  needed a companion object with `implicits` and helpers that mentioned earlier. I wouldn't mind having it all in `ErrorType.scala` if the it were only a couple of sum types.

In my case, it was finite but definitely more than a handful. So, having all the companions with their big fat body in the same file was definitely not something I wanted to do. Also, I did not want to lose the power and guarantee of an ADT (`sealed trait`).

Note that you could have the companion object declarations in different files outside the file that defines the `sealed trait`. If you do, those definitions are not going to be considered as companion objetcts, which means that the compiler will not automatically use those definitions during an implicit lookup.

Fortunaely, there is a workaround, one that I learnt from [BalsungSan](https://users.scala-lang.org/u/balmungsan/summary) in the Scala Discord [Channel](https://discord.com/invite/scala).

```scala
// ErrorType.scala

package domain.errors

object trait ErrorType {
	final case class BadRequest(field: String) extends ErrorType
	final case class NotFound(id: Long, msg: String) extends ErrorType
  . . .
	final case class Unknown(msg: String) extends ErrorType

	object BadRequest extends BadRequestCompanion
	object NotFound extends NotFoundCompanion
	. . .
	object Unknown extends UnknownCompanion
}
```

```scala
// BadRequest.scala
package domain.errors

private[errors] trait BadRequestCompanion { self: BadRequest.type =>
	 // implicit and helpers, a bunch
}
```

```scala
// NotFound.scala
package domain.errors

private[errors] trait NotFoundCompanion { self: NotFound.type =>
	// implicit and helpers, a bunch
}

// . . . and so on in other files, you get the idea
```

So, you see what is going on. It is a workaround but clever. It works well and covers all bases.

* The sum type guarantee is not broken. The base `sealed trait` can be extended only in `ErrorType.scala`
* Scala compiler is able to recognize the companions as they are. They are not namesakes.
* The helper `XXXXCompanion` traits can be only be extended by respective sum type companion objects and not by any other type. This is a wonderful compile-time gurantee.
* The helpers are contained within the subpackage `domain.errors` and cannot be used elsewhere. So, it is an implementation detail.
* ADT defintion in `ErrorType.scala` is succinct and comprehensible to the reader.

Yes, I called it a workaround because it is not exclusive to the problem at hand, which I think the compiler should support firsthand. I am not a compiler writer / expert but here is an imaginary version if / when Scala decides to support it firsthand.

```scala
// ErrorType.scala
package domain.errors

object trait ErrorType {
	final case class BadRequest(field: String) extends ErrorType
	final case class NotFound(id: Long, msg: String) extends ErrorType
  . . .
	final case class Unknown(msg: String) extends ErrorType

	partial object BadRequest
	partial object NotFound
	. . .
	partial object Unknown
}

// BadRequest.scala
package domain.errors

partial object BadRequest {
	// implicit and helpers, a bunch
}

// NotFound.scala
partial object NotFound {
	// implicit and helpers, a bunch
}

// . . . and so on for other companions
```

Taking the C#'s [**partial**](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/partial-classes-and-methods) keyword as inspiration, we are instructing the compiler that the definition / body of the type may be defined in constituents across files. This also gets rid of the noise / ceremony - `private[errors]`, self type etc.

Note, for our problem at hand, the `partial` keyword is applied only to the companion, not to the definition of the sum type (`case class`). I am not sure if marking the `partial case class` would work because it would break the guarantee or contradict with the `sealed trait` tenet. Some food for thought if Scala compiler team were to ever consider this.

In general, if the Scala compiler were to provide the `partial` keyword, it could be applied to any type that will be defined across compilation units. This includes regular `classes` and other types alike. C# uses `partial` classes and methods for duming IDE generated code for user interfaces in XAML/WPF, which works really well.

While `partial` in Scala is a speck in the wishlist for the foreseeable future, the above workaround (companion helper trait) is no less. You could say our needs are `partial`ly served.

[^1]: While the crux of defining sum types is the `sealed trait / abstract class` and not necessarily `case class`, it is typical to use `case class`es over regular `class` for defining sum types.
