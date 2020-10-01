---
title: Settling Casting Restrictions !!!
author: vivekragunathan
layout: post
date: 2009-02-05T20:31:00+00:00
url: /2009/02/06/settling-casting-restrictions/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 3460047567779743817
categories:
  - 'C#'
  - CodeProject
  - Uncategorized

---
<p style="font-family:Tahoma;">
  Remember the Casting Restrictions we discussed a while back, let us settle that now. So we have some code like this:
</p>

<pre style="font-family:Consolas;font-size:11pt;">int i = 100;<br />object obj = i;<br />long l = (long)obj;<br /></pre>

<p style="font-family:Tahoma;">
  And an invalid cast exception while casting &#8216;obj&#8217; to long. It is obvious that we are not changing the value held by obj, but just reading it. Then why restrict such casting. Let us disassemble and see what we got.
</p>

<pre style="font-family:Consolas;font-size:11pt;">.locals init (<br />        [0] int32 i,<br />        [1] object obj,<br />        [2] int64 l)<br />    L_0000: nop<br />    L_0001: ldc.i4.s 100<br />    L_0003: stloc.0<br />    L_0004: ldloc.0<br />    L_0005: box int32<br />    L_000a: stloc.1<br />    L_000b: ldloc.1<br />    <i><b>L_000c: unbox.any int64</b></i><br />    L_0011: stloc.2<br />    L_0012: ret<br /></pre>

<p style="font-family:Tahoma;">
  Oh, there we see something interesting &#8211; unbox. So the C# compiler uses the unbox instruction to retrieve the value from obj while casting; it does not use <span style="font-family:Consolas;font-size:11pt;"><a href="http://msdn.microsoft.com/en-us/library/system.convert.aspx" target="_blank">Convert</a>.<a href="http://msdn.microsoft.com/en-us/library/system.convert.toint64.aspx" target="_blank">ToInt64</a></span> or similar mechanism. That is why the exception was thrown.
</p>

<p style="font-family:Tahoma;">
  From MSDN:
</p>

<blockquote style="font-family:Georgia;">
  <p>
    Unboxing is an explicit conversion from the type object to a value type or from an interface type to a value type that implements the interface. An unboxing operation consists of:
  </p>
  
  <ul>
    <li>
      Checking the object instance to make sure it is a boxed value of the given value type
    </li>
    <li>
      Copying the value from the instance into the value-type variable
    </li>
  </ul>
</blockquote>

<p style="font-family:Tahoma;">
  So we are blown at step 1 of the unbox operation. Let us play with what we have for now, and stop bugging why was unbox meant to be like that.
</p>