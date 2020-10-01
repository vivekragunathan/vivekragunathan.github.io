---
title: Dealing with Bad Code
author: vivekragunathan
layout: post
date: 2013-02-10T18:30:26+00:00
url: /2013/02/11/dealing-with-bad-code/
categories:
  - Computers and Internet
  - Uncategorized

---
Read this fine article by [Joel Spolsky][1]: [Things You Should Never Do][2]

It is a great article, one that invokes mixed feelings. The article talks against rewriting (large scale) software…..from scratch. Joel was kind enough to consider all those who write software as true programmers; people who give enough thought and not just code up something that works. However, it is far different in the real world. That said, I am neither completely in disagreement with Joel nor am I advocating to rewrite large scale software once the code is identified as a mess.

<!--more-->

Most people who are programmers are just people who write code for a living. Nothing wrong but forget the passion part of it. So the quality of the code that is generated is questionable. True programmers are different. They first build those intangible constructs in mind of how the code should be, and then they write code that reflects to the reader the intent of the task being achieved. Hence such code is readable, modular and maintainable. They are deliberate in building such code so that it is possible to implement new features (and do bug fixes, if any) in such code with ease for a fellow programmer too. That’s when Joel’s statement that _programmers, in their hearts, are architects applies_.

I agree that rewriting the whole software from scratch is an ambitious attempt, and might end up foolish too. Nobody, in their sane mind, would attempt that without a backup plan. However those functions with over 200 lines of code, which ideally would be some ten lines of code, could be rewritten. I don’t agree that those functions, which clearly would have been written without forethought, with its tons of bug fixes carry loads of knowledge. They mislead the reader from understanding what is actually been achieved in the function. I would argue that most of those bugs should not have been there in the first place. They come into existence because of the programmer’s lack of due diligence when implementing the function. In simple words, programming is an art and not a contest of (fast) typewriting.

I have seen my share of messy unmaintainable code; code that is just as dead with its smell or that just runs at the mercy of time! For instance, consider this piece of MFC code…..

[code lang=cpp]
  
int controlId = reinterpret_cast(this);
  
GetDlgItem(controlId);
  
[/code]

The above code assumes that there is an user control with an id equal to the this pointer, where the current object was some MFC form/window. That ugly code was there in production, and was running purely on luck; may be that code path was not used or God knows!

I have seen programmers use `std::string*` for creating an array of strings, and the associated memory never properly released – a deliberate memory leak for free. They couldn’t accept that it could be replaced with `std::vector`. I have also seen mightier – `std::list***`; perhaps the programmer was programming for Einstein trying to think more than three dimensions. And never bother to think if the memory management was in place for that. When I take this for a discussion with the programmer who wrote that crap of code, I get a soft slap on the face, _why bother, it works, right?_. Worse to accept is the possessiveness that they have for the code; they won’t allow the code to change (to be improved).

Although threads in .NET are managed, programmers don’t think even once before creating threads just for firing events or such, which they should have achieved using the ThreadPool. And they create it without holding a reference – bad practice. They don’t get a grasp of the line, _Thread is an expensive resource_. (See also [To Hold or Not to Hold – A story on Thread references][3])

To find out and to live with the architectural/design problems in code is another beast. In most environments, the way to sort it out goes political. Unfortunately, programmers invent new ways to make the code even more worse in order to make up for the code leaks across software layers. Besides, how many times programmers, because of deadlines or their reluctance, fail to build an object oriented design, and end up writing humongous functions with whole bunch of discrete parameters. How many times doesn’t a programmer spend long hours just trying to get a hang of what the code does and why it was authored a such way? Don’t the comments in the code read what the code does, rather than why? And what about code with misleading comments? Bad messy code comes in several such forms and more, and we see them around all the time. It has a lot of impact on the day to day life of a programmer, of which the foremost I would say is maintenance. Maintaining bad code without the hope of ever improving it makes every day of a programmer painful and worthless. Unfortunately, finding and fixing tough bugs in such code is accounted as knowledge. It is nothing but the legacy of the author who wrote that bad code. This knowledge is not helpful when it comes to building/modeling software, even if it has to be rewritten.

So let me call it refactoring instead of rewriting so that I don’t sound against Joel’s wonderful post. I have refactored whole modules because they were truly messy and unreadable, completely misleading the reader from understanding what it was actually doing. Because they were not integrating well with other modules in the system and causing havoc all around. When you fix one bug in that code, it spawned one more or more. And I have refactored more than once in different projects in full production code. I know I sound blind and ambitious. Still…….I would argue that it is possible to refactor without side effects and replace those worthless piece of code with something better. I say something better, not to be safe but because opinion differs. But that something better, I hope will save the life of a true programmer who is wasting life shoveling such code with no hope of cleaning it some day.

You could even start with naming functions and variables appropriately, and making code modular within a file or class. You could build test suites of expected behavior and start changing code inside out. Form a project wide group to detect and prevent code and functionality duplication, and build SDKs for project wide use. Although…..probably, in Joel’s terms, one at a time. **After all, it is all code that a programmer shovels everyday**. Is it unfair of a real programmer to expect that the code be clean, readable and maintainable? And best of all be in a way that a fellow or new programmer to the team could understand it even after the original author of the code is long gone.

All it needs to rewrite (refactor) something is a vision of how better can you get the code to, a bit of courage to tackle dirty politics, and speed of execution. If you have at least the above three things, it is possible to clean up those 200 or two page(s) functions with a cleaner readable modular maintainable version of it. That in an industrial environment, which almost always is political, is a noble cause. I think it is not only the duty but the charm of a _real programmer_!

* * *

<small>With regard to this post, one of my favorite quotes by <a href="http://www.johndcook.com/">John D. Cook</a> comes to my mind:</small>

> <small>The romantic image of an über-programmer is someone who fires up Emacs, types like a machine gun, and delivers a flawless final product from scratch. A more accurate image would be someone who stares quietly into space for a few minutes and then says <em>Hmm. I think I’ve seen something like this before.</em></small>

 [1]: http://www.joelonsoftware.com/
 [2]: http://www.joelonsoftware.com/articles/fog0000000069.html
 [3]: https://vivekragunathan.wordpress.com/2011/03/30/threadreference/