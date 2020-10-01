---
title: Casting Restrictions ???
author: vivekragunathan
layout: post
date: 2008-11-22T11:43:00+00:00
url: /2008/11/22/casting-restrictions/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 4083012105248464865
categories:
  - 'C#'
  - CodeProject
  - Uncategorized

---
We all know that the runtime can detect the actual type of a System.Object instance. The primitive data types provided by the runtime are compatible with one another for casting (assuming that we do not truncate the values). So if I have an int, it can be cast to long or ulong. All that is fine. Watch this:-

<pre style="font-family:Consolas;font-size:11pt;">interface IAppDataTypeBase<br />{<br />   // Other methods<br />   GetValue();<br />}<br /></pre>

Since IAppDataTypeBase represents the mother of all types of data in my application, I have made GetValue to return the value as object (I could have used generics, that is for another day!).

<pre style="font-family:Consolas;font-size:11pt;">IAppDataTypeBase longType = GetLongInstanceFromSomeWhere();<br />int i = (int)longType.GetValue();</pre>

So are we discussing any problems here? Yes, we are. The problem is that the value returned by GetValue &#8211; System.Object &#8211; despite being inherently long cannot be cast to an int. It would result in an &#8216;Specified cast is invalid&#8217; exception. If an object is one of the primitive types, it can only be cast to its actual type. In the above case, the object returned by GetValue can only be cast to long, and nothing else. The user defined data types do not have this restriction if the base type and target type are related.

<pre style="font-family:Consolas;font-size:11pt;">class X { };<br />class DX : X { };<br />class Y { };</pre>

If GetValue returns an instance of DX, it can be cast to X or any of its base interfaces (if any). The same goes good for structs too.

So why do we have this casting restriction for the primitive types? Was this unintentional or is there an advanced CLR internals web page somewhere talking about this? Probably fixed in C#4.0? Until I learn why, the question is open.