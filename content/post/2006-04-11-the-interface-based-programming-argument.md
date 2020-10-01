---
title: The Interface Based Programming Argument !!!
author: vivekragunathan
layout: post
date: 2006-04-11T04:03:00+00:00
url: /2006/04/11/the-interface-based-programming-argument/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114472829333280009
categories:
  - Uncategorized

---
I am always a great fan of interface programming. I mean not exactly the interface keyowrd but some way to expose the functionality of the class or your module relieving the user about the worries of the implementation. But definitely make him curious of the stuff inside.

The Win32 APIs are not that good in what I am talking about. Well, there are several reasons for that. And I strongly object that they are raw APIs and not for the ordinary application programmer. That kind of an abstraction is there at every level. Even a programmer using the Win32 APIs does not know what goes inside though some of the APIs expose unknowningly the sort of internals. This is an argument, but what I mean to say is that anything that you wish your users to use must have a elegant interface just exposing the functionality, and in the most intuitive way that makes sense. It may be an interface in C# or an abstract class in C++. And once you do that, you will slowly be under the tree where you can clearly realise the roots of an object oriented system.

I have to argue/fight like that recently to make things bit more object oriented in my project where I had to refactor-redesign the existing mess.