---
title: Clean Code
author: vivekragunathan
layout: post
date: 2014-05-23T01:31:21+00:00
url: /2014/05/23/clean-code/
categories:
  - Programming
  - Uncategorized
tags:
  - clean code
  - programming

---
I received quite a lot of criticism for [Dealing with Bad Code](/2013/02/11/dealing-with-bad-code/). The criticism was mostly along these lines – _There is no good or bad programmer. The good programmer thing is more of an illusion. When you place a programmer in a domain in which he has little or no experience (like a PHP web programmer writing C++ code), he will soon be seen as a bad programmer. What is branded good or bad is subjective_.

<!--more-->

Although it sounds to make sense, I don’t completely agree with that. Maybe the topic of the discussion was ambiguous. It wasn’t the programmer but the code. I am not willing to spend my energy to demotivate somebody by branding him a bad programmer. But I will in reviewing anybody’s code, not just brand it bad code but ultimately clean it up.

I believe programming isn’t restricted to language. Although the language used to program has its impact on the way a problem is solved, it doesn’t limit the programmer from losing the basics. In other words, a programmer should be able to program in any given language; of course he needs time to study the language. So if a PHP programmer is writing C++ code, he can’t stick to his old habits and disregard memory management, and also be aware what is considered expensive in C++ unlike PHP. I agree that every language has its areas which cannot be mastered without exposure and time, for instance template meta-programming in C++. I doubt if one who has programmed in one of the dynamic languages all his time would even comprehend seeing results at compile time.

So if one transcends the language wars, programming is about three things – logic, semantic and structure. I am going to assume that those terms are self-explanatory in our context. And if I were to order them, they are reversed ordered……to sound better. Although the order relates to the importance of each facet, one cannot and should not be sacrificed over the other. Each facet carries equal importance as the other and must be given attention to achieve good code. So the order is more of which one to attend to first.

Whenever I came across code that could be made better, I had thought making a collection of such things. Well, I think I am up to it now. I am starting to write a series of posts (at irregular intervals), which will talk about how certain piece of code could be written so that it is easier for the reader to understand; in other words tell him why something is done a certain way. We see that line “*…for the reader to understand…*” everywhere in books and articles. The assumption there is that the reader is looking for the reason. If one were to just read code literally but never question why it is or is not written certain way, we got nothing to discuss. So every effort taken to write good code, and more importantly, maintain it that way, is not just for self-satisfaction.

Let me get started with the first one today, and it is about logic. Logic means how do solve a certain problem (specific and granular) efficiently. Efficiency does not mean only speed. If you can solve the problem in a comparatively fewer lines code without losing clarity and readability, then that is efficient. That sometimes involves educating ourselves and our peers with new techniques. For instance, in a language of your choice, how would you implement a function that returns the sum of all numbers starting 1 through N (including). One could start with this:

```java
function sum(int n) {
	int total = 0;

	for (int i = 1; i <= n; ++i) {
		total += i;
	}

	return total;
}
```

That’s about 5 effective lines of code. It can be made succinct:

```java
function sum(int n) {
	return (n * (n + 1)) / 2;
}
```

The above code is just one line. One could even question if we need a function. If programmers in the team were educated with the technique, calculating the sum doesn’t need any encapsulation.

Some people will fight back saying what I am explaining here is just algorithms in action. True but it is not just limited to applying algorithms. What I am talking about applies even implementing an algorithm. I am talking about how can one write logic to improve the efficiency of code without losing the readability. I will leave it to the reader whether to agree with me or not.
