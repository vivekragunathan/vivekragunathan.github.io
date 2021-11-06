---
title: A Rambling on Error Handling
author: vivekragunathan
layout: post
date: 2018-09-18
url: /2018/02/18/ramble-error-handling
featured_image: https://images.unsplash.com/photo-1521650775848-620150d73160?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2912&q=80
categories:
  - Functional Programming
---

In the early years, software applications were tiny, compared to what we build today. In any given application, one could say, there were only a handful of error scenarios to deal with. Besides, error reporting, if not error handling, lacked finesse. Just slap the user with something red enough, and just say **An error occurred**.

<!--more-->

Error handling and propagation was tedious in those days. Every call in the stack that reported an error (code or the sorts) had to be manually bubbled up to the surface. Software development, the art aspect of it aside, was also a job. Part of the job involved human errors, or worse sloppiness. It wouldn’t hurt skipping the error handling around a couple of calls. Would it?

Exceptions (and exception handlers `try`-`catch`) freed us from the burden of having to deal with potential errors at each step in the call stack labyrinth. Without the need for a lateral intervention for bubbling up errors, all one needs is a `catch` guard at the API surface[^1]. That would capture any exception thrown anywhere down the call stack, which can be translated/transformed to relevant error information for reporting to the outside world.

Exceptions have proven to be an incredible tool for error handling/reporting, and a real asset to those who have used it to their advantage. Others are unhappy about it. Especially, them! Those functional programming folks! Because they consider throwing exceptions as impure. Purity, that’s what matters more to them than performance. You know there is a cost to unwinding the stack in the event of an exception.

Languages today are designed to please various cohorts of the programming community. Haskell pleases only the purists. C/C++ pleases those who believe in reality, whose battleground is the womb of the machine. Talk to them about `foldLeft`[^2], and they will punch you in the face. Java(Script) ... for the delusional. Scala for those who win arguments; call themselves rationalists. F# ... maybe the middle ground for debates. Go for those who hate C++.

Anyways, my point was that languages today embrace different styles of programming. For instance, traditional object-oriented languages like Java have started adopting functional style constructs, making sure that necessary tools are at the programmer’s disposal to address the problem in hand rather than engaging in language wars. Of course, some languages are sophisticated than others, considering a particular feature for comparison.

Error handling the legacy way using error codes or without the use of exceptions is not taken away by any programming language yet. On the other hand, some languages like Go do not support exceptions.

Easy to say exceptions are for exceptional cases. The tough part, I think, is primarily education. The amount of effort that the industry invested in getting people off of error codes and on-boarding onto exceptions was phenomenal. The worst part of it is that it pressured the programmers into using exceptions even they hadn’t fully understood it. As an effect, exceptions got employed in non-exceptional situations questioning its very need.

Fast forward to today, we are investing in discrediting exceptions rather than educating programmers how to deal in intense situations without exceptions. If it is just one method returning an error code / status, it is not a big deal. How do we handle errors, not same lame way, when there are many calls in a given context, especially nested in logic and deep in the call stack.

Programming languages too are part of the problem. Take Java for example. Since version 8, Java supports `Optional`. We can write an `Either` ourselves. But we don't have pattern matching to make elegant use of such facilities. Not just pattern matching but other constructs to handle errors and maintain flow of control when there are no errors (think `flatMap`). It is not just Java but other languages too in general that call themselves *functional* or embracing functional programming.

In the midst of all this, we have these fanatics, esp. functional programmers, discrediting every other paradigm of programming and claiming functional programming alone will solve all the problems of the world. Except a select few, rest of them do not contribute to the awareness, education and betterment of the programming community.

It is a good thing that us programmers don’t accept and follow something because that’s what we were taught or came to know but we make our choices based on reason. But we shouldn’t forget that right education is essential for reasoning. Otherwise, our choices, our decisions are just impulsive.

We are at this juncture where we need to spread awareness and educate better. Especially, the functional programming pundits, should develop the patience to sit with the mob and enlighten them of the style, value and guarantees that error reporting the functional way brings to the table; rather than shouting slogans.

Let me end this rambling with some motivation:

> *It is possible to write code to the same effect without exceptions as you would with exceptions.*

However, there are two things to keep in mind:

1. Exceptions are for exceptional situations. Practice to report errors without throwing exceptions.
2. Report errors with facilities natural to the language. It is easy to come up with an `Either` or `Option` or other related and supporting facilities in a language that does not provide such facilities first hand. But the house of cards topples without things like pattern matching and others. However, you can be creative! And don't overdo.

Have Fun!

**C# Code (Using Exceptions)**

```csharp
int ConvertToInt(string s)
{
    if (s == null || s.IsEmpty() || s.Any(c => !c.IsDigit()))
    {
        throw new IllegalArgumentException
    }

    return Int32.Parse(s);
}

void CallingMethod()
{
    try
    {
        var n = ConvertToInt("q12");
        Console.WriteLine("N: {0}", n)
    }
    catch (FormatException e)
    {
        Console.WriteLine(e.Message);
    }
}
```

**Scala code (without using exceptions)**

```scala
// null is represented by an Option. Hence it is not checked below.
def convertToInt(str: String): Either[String, Int] =
  str match {
    case s if s.isEmpty            => Left("Empty Input")
    case s if !s.forall(_.isDigit) => Left("Found non-digits")
    case _                         =>
        Try(Integer.parseInt(str)).toEither
  }

def callingMethod =
  convertToInt("q12") match {
    case Left(e)  => println(s"Error: $e")
    case Right(n) => println(s"N: $n")
  }
```

***

[^1]: Unless an exception has to be caught midway either for specialized handling — retry, transformation etc.
[^2]: Functional `foldLeft` (say on Scala / JVM) that creates new aggregate type for every member / iteration of the original sequence.

_Feature Photo by [Tuân Nguyễn Minh](https://unsplash.com/photos/WeA1uHnzf60) on [Unsplash](https://unsplash.com/)_
