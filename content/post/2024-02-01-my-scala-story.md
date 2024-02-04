---
title: My Scala Story
author: higherkindedtype
layout: post
url: /posts/my-scala-story
date: 2024-02-01
tags: [ 'scala', 'journey' ]
summary: |
  I have been reading the _My Scala Story_ [series](https://softwaremill.com/blog/?tag=myscalastory) by Software Mill - a short interview of renowned experts about their Scala journey. I have not done anything substantial in the OSS space to be on Software Mill's radar. But their series inspired me to share mine. So, here it goes ...

---

I have been reading the _My Scala Story_ [series](https://softwaremill.com/blog/?tag=myscalastory) by Software Mill - a short interview of renowned experts about their Scala journey. I have not done anything substantial in the OSS space to be on Software Mill's radar. But their series inspired me to share mine. So, here it goes ...

**How did you first get introduced to Scala, and what did you think about it?**

Around six years ago, I was tired of programming in the mainstream imperative languages - C++, Java, C#, Python, and the like. I was not interested anymore in writing loops and such. I wanted to program on a higher plane (functional style)

I had begun exploring Scala. The syntax instantly impressed me - concise yet expressive. The language dropped every bit of conventional and redundant syntax, which cuts to the chase. Types were the central idea. That got me hooked on Scala.

Also, I wasn't particularly interested in developing pet projects but wanted to use it as my primary language. Luckily, my new job at the time was Scala-based, which set me on a course to never let go of Scala.

**Tell us about a moment when you realized, "Aha! Scala is awesome!" What Scala's features and capabilities made you feel that way?**

Without second thought, it is the `implicit`s, which extend to type classes. Implicit gives you a whole new model of defining dependencies. Typeclasses threw away conventional inheritance out of the window.

In particular, recursive implicit resolution was my _Aha! Scala is awesome_ moment.

**How has Scala influenced your approach to solving programming problems?**

Scala was my gateway into functional programming. It taught me to develop an intuition to abstract and establish/use abstraction patterns. In contrast to object-oriented languages, functional abstractions/patterns cannot be discarded as subjective because they are backed by proof. Functor laws, for instance.

The other big influence for me is the idea of declarative lazy style. You describe/declare your program but do not execute it until you have declared it fully. It is a powerful idea that brings up nice patterns. To explain this idea to newcomers, I use punched cards (or mainframes) as an example. You write your program fully and submit it for execution. Despite being a funny and loose example, it gets the message across. 🤷‍♂️

**What is your favorite programming meme?**

[Microservices - Show user their birth date](https://www.youtube.com/watch?v=y8OnoxKotPQ)

Not a meme, a real talk but really funny:
[Top 5 techniques for building the worst microservice system ever - William Brander - NDC London 2023 - YouTube](https://youtu.be/88_LUw1Wwe4)

**What are your go-to tools and libraries when working as a software developer?**

- **Tools:** IntelliJ IDEA, Metals, `sbt`, `scala-cli` to name a few. There are others that deserve a separate post 😊

- **Libraries:** `cats`, `cats-effect`, `scalatest`, `scalacheck`, `http4s`, `sttp`, `quicklens` to name a few

**Tell us about a time when Scala proved to be a game-changer in a real-world project.**

I worked on a project not so long ago. We had to inspect the parameters for sensitive data before persisting. Two important requirements:
- Report *compilation error* if the user (developers here) has no specified how to strip the sensitive data for a given type
- minimal changes to the existing code base

Let me say that again - compilation error if the user has not provided the logic to strip sensitive data for a given type. Instant feedback!

Implicits, custom string interpolator, type classes and a couple of other Scala features made it possible. It is hard to imagine if it is possible to implement such an elegant solution in other languages, especially with ingenuity of Scala syntax/features.

**How has the Scala community impacted your programming journey? Any standout interactions or support stories to share?**

Some wonderful people I love interacting with:

- I love interacting with [Nicolas Rinaudo](https://nrinaudo.github.io) online - Scala related and online social stuff. I *love* his talks. Anytime he posts something Scala on social media, I reply, "I see a talk coming!" He is polite and friendly.
- I am amazed at [Noel Welsh](https://noelwelsh.com/)'s dedication in onboarding people of all backgrounds to Scala (or programming in general). And his relentless contribution in writing materials that is approachable to newcomers. If you did not know, he runs the [Scala Bridge London](https://www.scalabridgelondon.org/) group. Come join!
- If I am allowed to say I know a bit of Scala, I will say without hesitation that the credit goes to [Morgen Peschke](https://github.com/morgen-peschke). I can't count the number of times I have bugged him when I am stuck.
- I am not sure if [Kit Langton](https://www.kitlangton.com/) remembers me (not by name though). He is a humble and kind person. I remember one time I asked him a question, and he sent me a video replying in detail.

There are other great people in the community I have interacted with ; briefly or for long. It is hard to list all names.

Caveats:

- There are forums and groups that might may not be relevant to you depending on where one is in the journey. So, it is difficult to gauge the nature of the conversations in those communities. For example, Scala contributors forum, if you are not in to following SIP and such.
- One thing that might be a barrier for newcomers is experienced people interacting amongst themselves. So, a newcomer may feel left out. It is not exclusive to Scala.

I mentioned caveats in the middle to highlight the following. There are a lot of great people in the community that I admire for two reasons; especially those I mentioned above:

- their patience in answering questions at a level that is easy to understand for the listener
- modesty despite their expertise

Generally speaking, I have had a pleasant experience in the community so far.

**Did you have any hilarious or embarrassing moments while learning Scala?**

A couple come to mind.
- Funny how I understood, rather was struggling to understand, `for`-comprehension used for `Future` vs `List` or `Seq`.  The part that the latter is kind of loop while with other containers, it is natural to see you go from one line to next in the `for`-comprehension.
- The other one was parameter groups. Because there was such a facility in the language, I was happily grouping them before I realized that it exists for taking function bodies and such.

**What advice would you give to someone just starting with Scala?**

Scala is an incredibly powerful and expressive language. You can bend it to the extent you want. Once you get a hang of the language, it is hard to let go of it. The initial days might be challenging. You might struggle to get a hang of implicits, typeclasses and functional principles in general. However, there are a number of wonderful resources for beginners. From books and courses to people in the community who are happy to help you.

Here is a short but *incomplete* list of ones that top my list:

- Rock the JVM [videos](https://youtube.com/rockthejvm)/[posts](https://blog.rockthejvm.com/)/[courses ](https://rockthejvm.com)
- Noel Welsh's - [Scala with Cats](https://www.scalawithcats.com), [Creative Scala](https://creativescala.org)
- Nicolas Rinaudo's [videos](https://www.youtube.com/results?search_query=nicolas+rinaudo+scala)/[posts](https://nrinaudo.github.io/articles.html)
- Dean Wampler's fantastic [posts](https://medium.com/scala-3), [Programming Scala](https://www.oreilly.com/library/view/programming-scala-3rd/9781492077886/) book
- Alvin Alexander's [books](https://alvinalexander.com/alvin-alexander-books/)/[courses](https://alvinalexander.com/video-course/intro-scala-3/introduction)
- Last but not least, the fantastic [Red Book](https://www.manning.com/books/functional-programming-in-scala-second-edition) (especially the second edition contributed by [Michael Pilquist](https://mpilquist.github.io/about/))

*Beyond the resources listed above, you will come across numerous fantastic resources.* Don't forget to share them.

**How have you seen Scala evolve over the years?**

If you are coming from another language, especially the mainstream imperative ones, Scala 2 should be a big enough upgrade. It should already influence in the way you think and write your programs.

Scala 3 is not just another version but feels like a new language. No, I don't mean like a ton of breaking changes. Watch Michael Pilquist's fantastic [talk](https://www.youtube.com/watch?v=Ljw87JbzdMA) to know what I mean. Scala 3 has been under incubation (or however they call it) for a long time before it went GA. Like well-aged wine (or cheese)! Type level programming using macros, Dependent Types, Polymorphic Function Types, Type Lambdas etc. are some of the features that take you to whole another way of writing code, which is foreign and impossible in many mainstream languages. And may even be considered unnecessary!


[^1]: His wonderful Scala macros site is currently down.
