---
title: A funny moment of IoC
author: vivekragunathan
layout: post
date: 2015-07-08T06:16:56+00:00
url: /2015/07/08/a-funny-moment-of-ioc/
sharing_disabled:
  - 1
categories:
  - Computers and Internet
  - Uncategorized
tags:
  - carpool
  - inversion-of-control
  - ioc

---
[IoC][1] &#8211; Inversion of control, is a design that enables fluid flow of control by decoupling tight dependencies between the portion of a code that exhibits behavior and another portion of code that provides required functionality. One form of IoC, as we know, is Dependency Injection (DI). For instance, a `TextEditor` could refer an `ISpellChecker` instead of direct coupling to a specific implementation of spell checker thereby enabling the text editor to switch spell checker or even use more than one.

<!--more-->

> An elaborate description of IoC can be read [here][2]. 

A canonical example of IoC is an application that takes user information &#8211; name, address etc., and say persists it. A _typical_ console application would prompt the user to enter each of the user information that the application requires one by one in the order that the application was written to gather. The flow of control (or control) lies with the application. The application would not be able to gather the next required user information unless the user provides it with the currently what the application expects. It is equivalent to reading sequential access memory, say a tape.

On the other hand, if the user information was gathered by a GUI (powered by an event loop), the user is free to enter the information in any order he wishes (although the user interface might be designed to prompts error or warning messages when tabbing from one user control to other without providing appopriate input). Now, the user is in control of providing the information to the application.

On my way back to home, I had a funny moment of analogizing IoC with a non-software but real time instance. Think about the carpool lane. The intent/purpose of the carpool lane is to promote group commute so that we use less number of cars and less fuel, and possibly save the planet? So people, two or more, huddling up to commute together would be given privileges to use a special lane, which would save time and fuel. However, how many cars do you see on the carpool lane? Or what is the ratio of the cars using the carpool lane vs those parked on the freeway :):) While the carpool lane was intended for doing good, it doesn&#8217;t seem to do so by wasting time and fuel of the other thousand cars that are prohibited to use carpool lane. This, my friend, is called Inversion of Control, at least not in the classical sense of the term used in software. Just kidding!

But &#8230; would it be prove better to open the carpool lane for all cars? And think of a _really_ better way to promote group commute. Like well connected round the clock buses and trains.

 [1]: https://en.wikipedia.org/wiki/Inversion_of_control
 [2]: http://www.martinfowler.com/articles/injection.html