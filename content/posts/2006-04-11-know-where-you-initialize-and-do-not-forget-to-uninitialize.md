---
title: Know where you initialize and Do not forget to uninitialize !!!
author: vivekragunathan
layout: post
date: 2006-04-11T04:33:00+00:00
url: /2006/04/11/know-where-you-initialize-and-do-not-forget-to-uninitialize/
categories:
  - Uncategorized

---
If you have long been programming in C++/COM and then you move to C#.NET, the first difference you can feel is that you got a ctor for the object you create unlike the CoCreateInstance. In the C++/COM world, you generally would have a `Initialize` method to do the construction sort of, paired with `Terminate`/`Uninitialize` method. Similar is the case with singleton classes. For singleton classes in C++, you will have `public static Instance` or `GetInstance` method to get the only and one instance of the class and then use the initialize method to do the construction. This is certainly advantageous than the ctor facility in .NET, since you will not know when the instance will be initialized without the initialize method. Any call like `SingletonClass`.`GetInstance()`.SomeMethod may initialize the singleton anywhere and you will not exactly do the initialization during the application startup, which in many cases will lead to application errors after startup.

I do not recommend putting the initialization logic in the ctor, particularly for singletons. The Initialize/Uninitialize method seem to be primitive and kind of from the legacy age but we want code elegance rather than fashion. The pair gives a reasonable intuition and a feel of responsibility to initialize and uninitiailze. Without this simple pair, the object [singleton or any .NET object] gets initialized without control. Programmers making their entry into the .NET world develop the tendency to forget memory management, and leave it all to the GC. But GC can't be held responsible to perform the uninitialization required by the business logic.

The `Initialize`/`Uninitialize` pair just silently enforces to follow the pattern to initialize at the right place, and most important uninitialize, not giving the risk of remembering about Dispose.

I was forced to write this comment because I was forced to write that code.
