---
title: Declaring Implicits
author: higherkindedtype
layout: post
url: /posts/declaring-implicits
date: 2024-09-15
tags: [ 'scala', 'implicits' ]
featured_image: https://images.unsplash.com/photo-1504940760410-5d0c21cbf6f4?q=50
summary: |
  While implicits are easy to use, declaring them properly requires careful consideration. Because there are a few different ways you can declare implicits viz. extension methods, parameter values, type converters and dynamic instances. Each one has a specific purpose. For instance, dynamic instances enable recursive implicit resolution. Understanding the different ways of declaring implicits is critical in choosing the right one for the given scenario. It is also invaluable in troubleshooting subtle bugs and unexpected behavior related to implicit resolution.

---

While implicits are easy to use, declaring them properly requires careful consideration. Because there are a few different ways you can declare implicits viz. extension methods, parameter values, type converters and dynamic instances. Each one has a specific purpose. For instance, dynamic instances enable recursive implicit resolution. Understanding the different ways of declaring implicits is critical in choosing the right one for the given scenario. It is also invaluable in troubleshooting subtle bugs and unexpected behavior related to implicit resolution. Let us dive in.

Implicits can be declared in one of the following ways:

- As [extension methods](#extension-methods) (aka Implicit Classes)
- As [parameter values](#parameter-values)
- As [type converters](#type-converters)
- As [dynamic instances](#dynamic-instances)

In my opinion, the order listed above relates to its ease of comprehension.

### Extension Methods

Extension method is a way to add new functionality to types  without modifying its original definition. The decision to not modify the original definition is either *intentional* or *consequential*.

- Intentional:
   - The new functionality is not a direct behavior of the original type. But serves as a utility   method. Adding it to the original type would pollute the public interface of the type.
   - The new functionality may span and serve type hierarchies instead of a single type. For instance, you want to add a `walk` method on all `Animal`s , and you would use it on a `Dog` type.
- Consequential:
   - You don't have (write) access to the original definition. You may be using the type from one of the dependent libraries.
   - Easier to express certain type constraints as an extension method (e.g `Option#flatten`).

With that literature of the way, here is how you would define extension methods in Scala (version 2).

```scala
package object utils {
  implicit final class StringOps(private val str: String) extends AnyVal {
    def toTitleCase: String =
      // Not the best implementation but we are talking about implicits here. So, shove it under the rug.
      s.split("\\s+").map(_.capitalize).mkString(" ")
  }

  // AI is thinking to help you add more methods here 😀
}
```

The above extension method is an example of the consequential kind. Anyways, you would bring the extension methods in scope and use it.

```scala
import utils._

println("hello world".toTitleCase) // Guess what it prints!
```

The nice thing about extension methods is you can apply on companion objects too. For instance ...

```scala
implicit final class StringTypeOps(private val str: String.type) extends AnyVal {
  def isNullOrBlank(s: String): Boolean = s == null || s.isBlank
}

// somewhere else in code ...
val name: String = ... // could be null if interacting with a Java API
String.isNullOrEmpty(name)
```

## Parameter Values

Implicit parameters, which I would say is the more widely known and used, are just like any parameters to a function except the compiler fills it in for you without having to explicitly mention it.

```scala
def registerUser(input: RegisterUserInput)(implicit ec: ExecutionContext): Future[User] = ...
```

The `registerUser` function is meant to perform a number of tasks to have a user registered. All of it *asynchronously* in a `Future`. Running a `Future` requires an `ExecutionContext`[[^1]](craftdocs://open?blockId=823C1076-0197-4288-90BD-F75A378484E5&spaceId=null)``, which if declared in scope (or in one of the places where the compiler will look for[[^2]](craftdocs://open?blockId=9860AA74-1B5F-4090-94FB-446EEC46E943&spaceId=null)) will be picked up by the compiler and passed *implicitly* to `registerUser`.

Here is an example:

```scala
import scala.concurrent.ExecutionContext

class UserController @Inject() (...) extends BaseController {
  implicit val ec: ExecutionContext = ExecutionContext.Implicits.global

  // Entry point for /register path
  def registerUserPath() = Action { implicit request =>
    val input = pardonMeButDeserializeRequest() // 🙄
    // ...
    service.registerUser(input) // ec declared above picked up for the implicit parameter
  }
}
```

Implicit parameters are ubiquitous in almost every bit of Scala code out there although its instantiation has a gotcha.

In the above example, the *same instance* of  `ExecutionContext` - `ec`, will be used as the implicit parameter even for another function (say `getUserInfo`) similar to  `registerUser`. Because `ec` is declared as a `val`.

If it was declared a `def`, every call that needs the implicit parameter would get a new instance. Try this out ...

```scala
// Not the Show from cats but our version for the post.
trait Show[A] { def show(a: A): String }

object Blah extends App {
  implicit def showInt: Show[Int] = {
    new Show[Int] {
      println("You get a new instance of Show[Int] ...")
      override def show(n: Int): String = s"Int($n)"
    }
  }

  // contrast that with `val showInt: Show[Int] = ...`

  def foo(n: Int)(implicit S: Show[Int]): Unit = {
    println(S.show(n))
  }

  foo(42) // You get a new instance of Show[Int] ...
  foo(10) // You get a new instance of Show[Int] ...
}
```

I chose a different example for the above so that you can copy the code and run it. If `showInt` was a `val`, you would see the message print only once ever because the compiler would create the instance and cache it. Not so in the case of `def`. In other words, once for `implicit val`s or each time an implicit value is needed for `implicit def`s.

You would declare a `def` ...

- if the implicit instance is type parameterized e.g. `implicit def foo[A]: XYZ = ...`
- if there is some state associated with the implicit instance during its creation.

> It is important to know how an implicit parameter value is going to be created. Not only `implicit val` s and `implicit def` s but if the implicit is backed by a macro. Macro backed implicits generate code creating the  implicit value. The code generation is tied to the number of times the implicit is referenced / evaluated, which directly affects compilation time.

### Type converters

Implicit type converters are infamous, and generally speaking, should be avoided. But they do have their place; especially if you are not in the *implicits are hard and bad* camp.

Compiler is all about types - define, create, manage, derive, convert etc. Say, you have a function `def triple(n: Long)` . You cannot call the function passing it an `Int`. You should expect an error because types are different. However, the compiler does not give up in the first go. It is going to look around for a way to convert `Int` to `Long`. Perhaps there is an overloaded function (which is not the case here), and so on. In the list of things it will look for is the *implicit type conversion* function. Something of the sort ...

```scala
implicit def int2Long(n: Int): Long = n.toLong
```

The declaration should be self-explanatory - give me `Int`, take a `Long`. Just that it is declared `implicit`, which means the compiler will invoke this function, if in scope, to convert `n` to `Long` before calling `triple`.

In fact, such implicit conversions are declared in the standard library to make life easier ... for the meek. For the strong-hearted, there are compiler flags to report such conversions as warnings. Top that with `-X:fatal-warnings` flag to report warnings as errors. That means such implicit conversions would be prohibited and you have to use `.toLong` yourself making it explicit and putting the responsibility of the conversion on you, which is right.

Why is implicit type conversion highly discouraged? Because it can kick in unintentionally just because a conversion is in scope. This usually leads to unexpected behavior and bugs  that would require few mugs of coffee to troubleshoot/find/fix. Scala 3 has a `Conversion` typeclass which is the explicit version of the type conversion. It is adding discipline to the conversion and making the it available implicitly. But the actual call to conversion is explicit. In fact, it is not hard at all define such a typeclass if you are using Scala 2.

The type conversion discussed above is not restricted to scalar types. It could be for any two types. When you define a type conversion, you must really know what you are doing. That you really need it and it will not get you in trouble unintentionally.

Here is how an implicit type conversion is used beautifully in [cats](https://github.com/typelevel/cats):

```scala
final case class ShowInterpolator(_sc: StringContext) extends AnyVal {
  def show(args: Shown*): String = _sc.s(args: _*)
}

final case class Shown(override val toString: String) extends AnyVal
object Shown {
  // This is where the magic happens! Every type you provide in show"..." is
  // converted to `Shown` as long as there is an implicit Show[A] available.
  // Shown is just a type to denote that the value is stringified.
  implicit def mat[A](x: A)(implicit z: ContravariantShow[A]): Shown = Shown(z.show(x))
}
```

Read more on `Show` [here](https://github.com/typelevel/cats/blob/f4aec7f6e0fe9e3001234d786a86555ce31bc101/core/src/main/scala/cats/Show.scala#L73).

Generally speaking, if you are about to write a type conversion, think twice. Read about it. Consult with your peers.

### Dynamic Instances

This one is my favorite. Because it gives more than what you put in.

```scala
// Not the cats.Show but just our own version of Show
implicit val showString:              Show[String] = _.toString
implicit def showNumeric[A: Numeric]: Show[A]      = n => s"${n.getClass.getSimpleName}($n)"

implicit def showOption[A](implicit A: Show[A]): Show[Option[A]] = {
  case None    => "None"
  case Some(a) => s"Some(${A.show(a)})"
}

implicit def showEither[L, R](implicit L: Show[L], R: Show[R]): Show[Either[L, R]] = {
  case Left(l)  => s"Left(${L.show(l)})"
  case Right(r) => s"Right(${R.show(r)})"
}
```

The above modest piece of implicit code does something wonderful - *Recursive implicit resolution*.

```scala
def showMe[A](a: A)(implicit ev: Show[A]): Unit =
  println(ev.show(a))

showMe(Option(Option(100)))

val e: Either[String, Int] = Right(200)
showMe(e)

val foo: Either[Option[Either[String, Double]], Int] = Left(Some(Left("Success")))
showMe(foo)

val bar: Either[Option[Either[String, Double]], Int] = Left(Some(Right(3.142)))
showMe(bar)
```

If it is able to find an implicit `Show` instance for `A` then `showOption` would be able to give the string version of the type. Now, `A` could be anything. Even another `Option`, which in turn will look for its `Show[A]` instance. Or it could be an `Either`. Particularly, see how`foo` and `bar` recursively resolve implicits!

> Special thanks to [Morgen Peschke](https://github.com/morgen-peschke) for proof-reading and elevating the quality of this post. And in the process improving my understanding[^3] about implicits.

[^1]: In this case, `registerUser` is not directly using the `ExecutionContext` but passing it along to the `Future`. In any case, the point is `registerUser` takes an `implicit` parameter.
[^2]: That's whole big topic for another day!
[^3]: There are a couple more posts in the making. 😉

<small>Featured image courtesy: [Unsplash](https://unsplash.com/photos/vehicle-window-with-water-particles-Q4Fx0JYCYWc)</small>
