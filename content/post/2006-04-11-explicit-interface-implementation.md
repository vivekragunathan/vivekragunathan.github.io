---
title: Explicit Interface Implementation !!!
author: vivekragunathan
layout: post
date: 2006-04-11T04:06:00+00:00
url: /2006/04/11/explicit-interface-implementation/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114472842231296148
categories:
  - Uncategorized

---
I have encountered this [wait i&#8217;ll explain] sort of situation many times and I mostly do this way in C++.

Assume you have a class CMyClass that exposes its functionality through its public methods, and also let it listen to events from some sources, events being OnSomeEvent or OnXXXX(), by implementing some event interface IXModuleEvents. Now these event listener methods are reserved only for internal use and are not meant to be called by the users. So when I implement the IXModuleEvents interface in CMyClass, I make them private. Think about it and the problem is solved. It is the polymorphism game, that never cares for the accessibility of the method.

But I was in the same situation and my head had stopped working and my hands went coding the same way, and found that it does not work. In C#, i have the facility to declare a interface and by default its methods are public, strictly no need of any access specifiers. And the class that implements has to implement it publicly. So my OnXXX() methods get exposed.

But yes, there is a solution for the situtation, it is called Explicit Interface Implementation. It is this way:-

<pre style="font-family:Courier New;color:Green;"><span style="color:Blue;">internal interface</span> IXModuleEvents<br />{<br />  <span style="color:Blue;">void</span> OnSomeEvent<span style="color:DarkBlue;">(</span><span style="color:Blue;">int</span> i, <span style="color:Blue;">int</span> j<span style="color:DarkBlue;">)</span>;<br />  <span style="color:Blue;">void</span> OnSomeOtherEvent<span style="color:DarkBlue;">(</span><span style="color:Blue;">string</span> name<span style="color:DarkBlue;">)</span>;<br />}<br /><br /><span style="color:Blue;">public class</span> CMyClass : IXModuleEvents<br />{<br />  <span style="color:DarkGreen;">// ..... Other implementation</span><br /><br />  <span style="color:DarkGreen;">// No need of any access specifiers</span><br />  <span style="color:Blue;">void</span> IXModuleEvents<span style="color:DarkBlue;">.</span>OnSomeEvent<span style="color:DarkBlue;">(</span><span style="color:Blue;">int</span> i, <span style="color:Blue;">int</span> j<span style="color:DarkBlue;">)</span><br />  {<br />  }<br /><br />  <span style="color:DarkGreen;">// No need of any access specifiers</span><br />  <span style="color:Blue;">void</span> IXModuleEvents<span style="color:DarkBlue;">.</span>OnSomeOtherEvent<span style="color:DarkBlue;">(</span><span style="color:Blue;">string</span> name<span style="color:DarkBlue;">)</span><br />  {<br />  }<br />}<br /></pre>

So you can access these OnXXXX() method implementation only if you have a IXModuleEvents reference of the CMyClass, and try out with a CMyClass reference to access the event listener method implementation.