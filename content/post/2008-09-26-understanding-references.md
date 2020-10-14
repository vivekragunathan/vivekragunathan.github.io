---
title: Understanding (ref)erences !!!
author: vivekragunathan
layout: post
date: 2008-09-26T17:03:00+00:00
url: /2008/09/26/understanding-references/
categories:
  - .NET
  - 'C#'
  - CodeProject
  - Uncategorized

---
<div style="font-family:Tahoma;">
  Let us take a look at the following piece of code:-
</div>

<pre style="font-family:Consolas;font-size:11pt;">public void Operate(IList iList2)<br />{<br /> iList2 = new List();<br /> iList2.Add(1);<br /> iList2.Add(2);<br /> iList2.Add(3);<br />}<br /><br />public static void Main()<br />{<br /> IList iList= new List();<br /> iList.Add(10);<br /> Operate(iList);<br /> Console.WriteLine(iList[0].ToString());<br />}</pre>

<div style="font-family:Tahoma;">
  Be thinking about what would the above program print to the console ? And that is what we are going to talk about in this post &#8211; simple but subtle.
</div>



<div style="font-family:Tahoma;">
  I saw this code at CodeProject discussions. The author was confused with why was the program printing 10 instead of 1. I am writing about this since the &#8216;gotcha&#8217; was not highlighted in the discussion.
</div>



<div style="font-family:Tahoma;">
  So we passed the reference &#8216;iList&#8217; to the function which is supposed to make it point to the &#8216;List&#8217; that it creates and so must be printing 1. Well, a C++ programmer knowing how to program in C# would have said &#8216;Gotcha&#8217; already. A reference (in C#), equivalent to a pointer in C++, is an entity that stores the address of an object in heap and accesses it using this address. So when we pass a reference (by value) to a function, then we are passing this address value. That is captured in another 4 byte variable local to that function; so creating assigning inside the function will make iList2 point to newly created object &#8211; iList and iList are two different reference pointing to the same object. So if you want to transmit the effect of the changes you make to the List inside the function, pass it by reference &#8211; use ref keyword.
</div>



<div style="font-family:Tahoma;">
  Now the fun part !!! Let us try writing the same stuff in C++:-
</div>

<pre style="font-family:Consolas;font-size:11pt;">// This function will not alter the source pointer<br />void Operator(IList* pList)<br />{<br />  pList = new List();<br />  pList-&gt;Add(1);<br />  pList-&gt;Add(2);<br />  pList-&gt;Add(3);<br />}<br /><br />// This function will affect the source; similar to using ref in C#<br />// 1) const IList*& pList - Can make pList point elsewhere but cannot modify the existing object<br />// 2) IList* const &pList - pList cannot point to anywhere else but can modify the existing object<br />void Operator(IList*& pList)<br />{<br />  pList = new List();<br />  pList-&gt;Add(1);<br />  pList-&gt;Add(2);<br />  pList-&gt;Add(3);<br />}<br /></pre>

<div style="font-family:Tahoma;">
  Hope that was fun !!!
</div>
