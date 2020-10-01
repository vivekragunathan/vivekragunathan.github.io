---
title: out, ref and InvokeMember !!!
author: vivekragunathan
layout: post
date: 2006-05-12T02:26:00+00:00
url: /2006/05/12/out-ref-and-invokemember/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114740089682055867
categories:
  - CodeProject
  - Uncategorized

---
When I was working on the .NET reflection extravaganza thing that I explained in my previous column, i learnt one another interesting thing, that is about the Type.InvokeMember. How will pass out or ref parameters for the method invoked using Type.InvokeMember ? If you are going to invoke a method with the prototype

<PRE><FONT face="Courier New" color="#006600" size="3">int DoSomething(string someString, int someInt);</FONT></PRE>then you would use InvokeMember like this:-

<PRE><FONT face="Courier New" color="#006600" size="3">object obj = someType.InvokeMember(&#8220;DoSomething&#8221;, <br />        BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,<br />        null,<br />        this,<br />        new object[] {&#8220;Largest Integer&#8221;, 1});</FONT></PRE>or use some variables in the new object[] {&#8230;}. But what do you with the args if DoSomething takes out or ref parameters ?

<PRE><FONT face="Courier New" color="#006600" size="3">int DoSomething(out string someString, ref int someInt);</FONT></PRE>Something like this will not work 

<PRE><FONT face="Courier New" color="#006600" size="3">string someText = string.Empty;<br />int someInt = 0;<br />object obj = someType.InvokeMember(&#8220;DoSomething&#8221;, <br />        BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,<br />        null,<br />        this,<br />        new object[] {someText, someInt});<br /></FONT></PRE>

It is tricky.

<PRE><FONT face="Courier New" color="#006600" size="3">object[] args = new object[] { someText, someInt };<br />object obj = someType.InvokeMember(&#8220;DoSomething&#8221;, <br />        BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,<br />        null,<br />        this,<br />        args);</FONT></PRE>

or even suprisingly this works:-

<PRE><FONT face="Courier New" color="#006600" size="3">object[] args = new object[2];<br />// or object[] args = new object[] { null, null };</p>


<p>
  object obj = someType.InvokeMember(&#8220;DoSomething&#8221;, <br /> BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,<br /> null,<br /> this,<br /> args);</FONT></PRE>
  
  <P>
    Access the values by indexing args. So declaring the argument object[] as a local variable solves the problem, but I do not understand why this behaviour. May be somebody can explain !!! 
  </P>
</p>