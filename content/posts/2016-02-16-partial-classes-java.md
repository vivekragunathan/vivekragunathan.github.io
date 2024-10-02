---
title: Partial Classes – Java ???
author: HKT
layout: post
date: 2016-02-16T04:27:37+00:00
url: /posts/partial-classes-java/
aliases:
- /2016/02/16/partial-classes-java/
summary: |
  I am really sorry if I tricked you into believing that Java is offering partial class feature. Unfortunately, Java doesn’t. Maybe never will. But I am going to talk about a workaround also presenting the thought process. Hence the length of the post.
categories:
  - 'C#'
  - Java
  - Programming
  - Uncategorized
tags:
  - 'C#'
  - Java
  - partial
  - partial-class

---
I am really sorry if I tricked you into believing that Java is offering partial class feature. Unfortunately, Java doesn’t. Maybe never will. But I am going to talk about a workaround also presenting the thought process. Hence the length of the post.

<!--more-->

The `partial`<sup id="fnref-1385-1"><a href="#fn-1385-1">1</a></sup> keyword is wonderful tidbit feature in C#; split a class source code across multiple files.

  1. A direct use case of a partial class is to enable code generators physically separate the code but hold (compile) the related discrete parts logically together (same class name). For instance, WinForms and WPF use the feature to separate the generated code into a different file. So does [Entity Framework][1] or any other framework that supports code generation. Needless to say, it is a boon for code generators.
  2. Another use case of the feature is when the class has grown to an extent that the programmers (or the team) start feeling proud of its size. When a class has too many lines of code that obstructs the reader from knowing what the class does; even when the reader is the author himself. In such cases, you can split the class using the partial keyword into logical groups of fields and methods based on what the class does. You can analogize it to sub-namespace or sub-modules, not sub-class 🙂. That way it is easier to focus on the theme of the respective sub-module, say when debugging.

If a language like Java does not support partial classes, the way C# does, what is the alternative? Actually, _there is no alternative_. But we can invent workarounds that produce the similar effect. Inheritance! I know it is not the best thing. But that’s we got.

The generated class could be the base class and your class could be an extension of the generated class. For instance, if the generated class is the entity mapping for the database tables, say, `Person`, your class, name it `BetterPerson`, will extend the generated `Person` class. That way the BetterPerson class offers all that its parent offers in addition to what it offers. For instance, Person provides only the date of birth. `BetterPerson` provides the exact age.

What I do not like with the workaround, as is, is: Because my class provides some extended functionalities, although integral to the entity, I do not want to call it a `BetterPerson`. It is still is a `Person` that mentally I like to map to the database table. Oh, enough of the abstractions, it is a table for Christ sake. There are things that you can’t hide by just abstracting away. But you can and should de-couple or loosely couple the ties.

What works well for me is tiny improvement over the existing workaround – _having the same class names but in different namespaces_.

Let us say if the generated Person class is in `name.space.generated.entities` namespace, then my mainstream `Person` that extends `name.space.generated.entities.Person` would be in `name.space.database.entities`.

```java
package name.space.database.entities;

class Person extends name.space.generated.entities.Person {

}
```

Again, the whole thing is a workaround. My workaround is convention based but pretty clean, I think. Besides, it addresses use case #1 directly. #2 may be seen as a variant of #1, and the workaround applied judiciously. The right thing to do regarding #2 is be aware of the class’s size ahead of time and never be there.

You are thinking “_That’s it? You are worried just about a name_“. Hey you know what they say, “_There are only two hard things in Computer Science: cache invalidation and naming things_“. Names do matter!

Hard to accept but we can settle with not having the partial feature in Java; being an old language and all. How about Scala? It is the hot chick around the block. It does so using [mixins][2] (like the PHP traits<sup id="fnref-1385-2"><a href="#fn-1385-2">2</a></sup>). Scala might not be requiring it all because it provides extremely succint syntax and constructs that you end up with relatively much less footprint; unless you want to write Java in Scala.

<li id="fn-1385-1">
  <code>partial</code>: <a href="https://msdn.microsoft.com/en-us/library/wa80x488.aspx">https://msdn.microsoft.com/en-us/library/wa80x488.aspx</a>&#160;<a href="#fnref-1385-1">&#8617;</a>
</li>
<li id="fn-1385-2">
  <a href="http://php.net/manual/en/language.oop5.traits.php">http://php.net/manual/en/language.oop5.traits.php</a>&#160;<a href="#fnref-1385-2">&#8617;</a> </fn></footnotes>

 [1]: https://msdn.microsoft.com/en-us/data/ee712907
 [2]: http://docs.scala-lang.org/tutorials/tour/mixin-class-composition.html
