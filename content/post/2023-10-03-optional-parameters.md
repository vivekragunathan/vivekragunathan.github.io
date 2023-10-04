---
title: Optional Parameters
author: higherkindedtype
layout: post
url: /posts/optional-parameters
date: 2023-10-03
tags: [ 'java', 'optional', 'scala' ]
summary: |
  The billion dollar mistake has been committed already. No going back. But it is not necessary to keep repeating it. Oh, I am talking about the infamous `null`. Would Java's `Optional` come to the rescue? Or are there any ironic "Don'ts" when using `Optional`?

---

The billion dollar mistake has been committed already. No going back. But it is not necessary to keep repeating it. Oh, I am talking about the infamous `null`.

A real solution to avert the issues surrounding `null` is to completely avoid using it in your code, and replace direct use of `null` with some sort of nullable container, such as the `Option[A]` in Scala. You could go even as far and enforce not to use `null` anywhere in your code via [Scalastyle](https://www.scalastyle.org/) or other linters.

In Scala, it is pretty common to pass and return[^1] `Option`. For instance ...

```scala
case class Email(
	subject: String,
	body: String,
	attachment: Option[Attachment]
)

object Email {
	def apply(subject: String, body: String): Email =
		new Email(subject, string, attachment = None)
}
```

In the above code, `attachment` may *optionally* be passed to create an instance of `Email`. Another way, a bad one, to achieve the same with sufficient safety around `null` is:

```scala
# This is bad! Don't do it!
class Email(
	val subject: String,
	val body: String,
	attached: Attachment
) {
	val attachment: Option[Attachment] = Option(attached)
}

// calling code
new Email("hello", "world", null)
```

The above code does not use `Option` but directly use `null`, which is wrapped with an `Option` inside the Email class. While this provides safety net around `null`, it is just a bad way.

Introducing `null` in one place potentially causes loss in the strictness of types. The `null`  may be direct value as shown in the example above. Or a runtime value passed down via chain of calls to a variable passed to `Email` constructor, which makes it harder to reason about. Besides, did you notice I had to change the original `case class` to a regular `class`[^2]?

Let us switch gears. Java too has a nullable container - the infamous[^0] `Optional<T>`.

In the Java realm, returning `Optional` from methods is acceptable. Passing `Optional` as parameters is not.

IntelliJ warns such cases via its [inspections](https://www.jetbrains.com/help/idea/code-inspection.html).
![[opt.jpg]]

While you can suppress inspections at your will, that is the not point. It is recommended not to pass `Optional` as parameters. [Even by Java experts](https://stackoverflow.com/a/26328555).

![[opt2.jpg]]

I was not able to find a compelling reason behind such a recommendation, which is in contrast to Scala. Almost every link or material I came across was about to disabling[^3] the inspection to silence IntelliJ from throwing the warning.

However, I came across a couple of things where were better out of the lot. **But not compelling**.

- In the case when there are multiple `Optional` parameters, the calling code would look [clumsy](http://dolszewski.com/java/java-8-optional-use-cases/). Meh! Real production Java code is ugly 🤷‍♂️ because Java syntax is verbose and noisy. I don't buy that multiple `Optional` parameters is going to make uglier.
- Using `Optional` parameters [introduces](https://stackoverflow.com/a/31923105) conditional logic in the method. Of course, it should. Wouldn't there be conditional logic or guards if we were dealing with `null` instead of `Optional`? Only `Optional` makes it disciplined. You wouldn't use the parameter in question blindly without null check, would you?
- `Optional` is relatively [expensive](https://stackoverflow.com/a/31923105). This is a hard sell unless one can prove that `Optional` in the particular case is the bottleneck. In the grand scheme of things, the cost of `Optional` should be negligible. Unless it can be proven it is not negligible.
	- ... although I buy the point here. If you are using `Optional`, typically you would use its methods that takes lambdas or such, which drags in some extra allocations. Again, should not be a problem unless it is proven to be a problem.
- Finally, what if `null` itself is [passed](https://stackoverflow.com/a/31923105) the value for the `Optional` parameter? Duh! I am not denying this is a legit case although I see this as a problem of culture.
	- In Scala and other functional languages, there is a clear distinction in practice and convention between `null` and `Option`. I am yet to encounter a case where a piece of code dealing with `Option` received a `null`. For that matter, I am yet to come across code that was working with a `String` and encountered `null`. If a `String` were to be optional, it would have been an `Option[String]`. Validations at the highest levels may even wrap empty or blank `String`s into a `None`; depending on the case. I thought I would say that the above is practiced religiously. But no. It is just how Scala programmers, and generally speaking functional programmers think about it. It is sadly not the case with Java; at least mainstream[^4].

On a larger scale, I prefer to align with the community - practices, guidelines and conventions. And temper only specific things to cater to my taste/style. For a good reason. In the case of this warning about using `Optional` parameters, I have mixed feelings. Neither do I want to disable the inspection in IntelliJ because IntelliJ team is way smarter than us, and they should have added this for a reason. Nor do I want litter my code with `SuppressWarnings`[^3].

Given that the IntelliJ inspection is a tooling aspect, I might consider disabling it after all. Because I don't think none of us can commit to the alternative - *never write code that takes `Optional` parameter(s)*. It may not be possible.

[^0]: Yes, infamous. Because it is poorly implemented. I might have to write about it in separate post. Let me not digress.
[^1]: The `case class` fields are getters and hence are returning `Option`. The constructor as written above is the argument. So, passing and returning.
[^2]: Similar handling is not possible using `case class`; at least not in a clean way. You might end up having redundant fields breaking invariant on `attachment`. Or some unnecessarily convoluted code.
[^3]: In the worst case you have to suppress the warning, use `@SuppressWarnings("OptionalUsedAsFieldOrParameterType")` instead of disabling the inspection for all cases.
[^4]: There are definitely some elite / esoteric Java code out there that fall in the category of functional thinking, if not really written using functional techniques.
