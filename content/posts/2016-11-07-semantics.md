---
title: Importance of Semantics
author: HKT
layout: post
date: 2016-11-07T06:04:46+00:00
url: /posts/semantics
aliases:
- /2016/11/07/semantics/
summary: |
  **semantics** | /sɪˈmæntɪks/ | noun (functioning as sing)

  &dash; the branch of linguistics that deals with the study of meaning, changes in meaning, and the principles that govern the relationship between sentences or words and their meanings
  the study of the relationships between signs and symbols and what they represent
  (logic)

  &dash; the study of interpretations of a formal theory

  &dash; the study of the relationship between the structure of a theory and its subject matter
  (of a formal theory) the principles that determine the truth or falsehood of sentences within the theory, and the references of its terms
categories:
  - Programming
  - Software Design
  - Uncategorized
tags:
  - api
  - clean code
  - design
  - programming
  - semantics

---
**semantics**<sup id="fnref-2002-1"><a href="#fn-2002-1">1</a></sup> | /sɪˈmæntɪks/ | noun (functioning as sing)

  1. the branch of linguistics that deals with the study of meaning, changes in meaning, and the principles that govern the relationship between sentences or words and their meanings
  2. the study of the relationships between signs and symbols and what they represent
  3. (**logic**)
      * the study of interpretations of a formal theory
      * the study of the relationship between the structure of a theory and its subject matter
      * (of a formal theory) the principles that determine the truth or falsehood of sentences within the theory, and the references of its terms

* * *

Semantics is ever more important in programming.

Take JDK [`Stack`][1] for example. If you were providing a `Stack` class, you should make sure to expose only those methods that do not break the stack semantics &#8211; _add and remove elements only from the top of the stack_. The underlying data structure could be an array or linked list (depending on your need). Your `Stack` should not expose methods to add or remove elements from other indices although you should expose the facility of iterating the elements. Exposing methods that mutate the order of elements freely at indices other than top is a breach of semantics. You could still use such a data structure and you could make it work to your wish but don&#8217;t call it `Stack`.

> Java/JDK is notorious for such poor semantics. Not just Stack but many others &#8211; `Thread`, obtaining an immutable `List`, ambiguous method names<sup id="fnref-2002-2"><a href="#fn-2002-2">2</a></sup> etc.

Let us think about obtaining that immutable list. Here is how you get an immutable list out of an existing immutable list:-

```java
// list could have been created elsewhere or in place new ArrayList();
Collections.immutableList(list);
```

You might argue _it does the job_. However it is operating on broken or poor semantics. With a `List` in hand, how do you tell that it is immutable? Imagine that you are returning the immutable list from one of your methods. How would the caller know that the list is immutable and avoid modifying the list. Don&#8217;t tell me _from Java doc_. It is known for sure only at runtime when an `UnsupportedOperationException` is encountered in an attempt to modify the list. A better semantic is to have a separate interface/class that does not even provide mutator methods just like [`IReadOnlyList`][2] in .NET.

Let us extend on the above thought a bit further. Suppose you have to implement an API `List getMeTheList(/*some input arguments*/)`. The API can return an empty list for some cases and a non-empty one for others; some business logic. It is not uncommon to declare a shared empty list `EMPTY_LIST` and use that for all empty list cases in the above method and other such methods too. We don&#8217;t want to be churning empty lists for no reason. Remember you don&#8217;t the garbage collector for free. So you would make that shared empty list immutable &#8211; `Collections.immutableList(new ArrayList());` If the shared list is not immutable, any consumer code that modified the list would make it non-empty and all consumers would not be getting empty list anymore when we return `EMPTY_LIST`.

```java
final class AppLib {
  private static final List EMPTY\_LIST\_REF = Collections.unmodifiableList(new ArrayList<>());

  @SuppressWarnings("unchecked")
  public static <T> List<T> emptyList() {
    return EMPTY\_LIST\_REF;
  }
}

class YourAppCode {
  public static <T> List<T> getMeTheList(/\*some input arguments\*/) {
    if (some truth condition) {
      return AppLib.emptyList();
    }

    if (some other condition) {
      return an existing list; like one from cache etc.
    }

    final List<T> result = new ArrayList<>();

    // some logic that populates the list

    return result;
  }
}
```

I am sure you see the problem with above implementation &#8211; inconsistent return value although it is `List` in all cases. Think from the caller&#8217;s perspective. There is no way that the caller can deduce (from the method signature) to refrain from modifying the `List` returned (or rather prevent the caller in the first place).

You can go to great lengths in making such a contract work with a try-catch, size()<sup id="fnref2:2002-2"><a href="#fn-2002-2">2</a></sup> checks and what not. By doing so, you are just working around the problem rather than standardizing the semantics of the API; if you are the author or have access to effect a change in the API.

In majority of cases, the calling code iterates/consumes and does not make modifications to the resultant list. However, the fact that the calling code can make modifications should not influence the API design with a false idea that it is convenient for the caller. That said, if the API is designed with the information beforehand that the client code will make modifications or such is the regular scenario, then the semantics change; API should be returning a mutable list. But the API should be consistent in its behavior. In other words, _the API should be semantically meaningful_. Think of an Equals implementation. Likewise, you should also consider the effect of allowing or skipping `null`s in your resultant list.

> Your API that returns a `Collection` should not be returning a `List` sometimes and `Set` at other times.**

As a publisher of the API, you should first _decide_ the appropriate semantics. No forethought of semantics or alternatively a poor/broken one is ignorantly or knowingly planting bugs in code. I am sure you would have come across APIs such as `getMeTheList` or worse used the JDK `Stack` in ways that ignore the stack semantics.

There are several other factors that determine the integrity of the semantics of an API &#8211; name, consistency, thread safety to name a few. Did I say **name**? Don&#8217;t make the mistake of thinking _What&#8217;s in a name?_ Suppose you name your API `float getProductWeight()`, which weight does it return &#8211; absolute weight of the product, with addons, with packaging? For instance, think of a cycle. If `getProductWeight` will return different values depending on some context that is not even controlled by the caller, it will not only wrek havoc in your code(-base) or the caller code(-base) but it will be hiding in plain sight, and you will be busy fixing parts of the application except `getProductWeight`.

Among problems that affect the sanctity and the integrity of large scale application code bases, API semantics or the absence thereof is one of the biggest contributors.

<li id="fn-2002-1">
  Definition of <a href="semantics">semantics</a> was borrowed from [Dictionary.com](www.dictionary.com]&#160;<a href="#fnref-2002-1">&#8617;</a>
</li>
<li id="fn-2002-2">
  <em>size()</em> sounds the method is going to return the number of bytes consumed by the <em>Collection</em>. One of the more appropriate names is <em>Count</em>.&#160;<a href="#fnref-2002-2">&#8617;</a> <a href="2002-2">&#8617;</a> </fn></footnotes>

 [1]: http://docs.oracle.com/javase/7/docs/api/java/util/Stack.html
 [2]: https://msdn.microsoft.com/en-us/library/hh192385.aspx
