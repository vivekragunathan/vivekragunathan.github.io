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

Let us take a look at the following piece of code:-

```csharp
public void Operate(IList iList2)
{
 iList2 = new List();
 iList2.Add(1);
 iList2.Add(2);
 iList2.Add(3);
}

public static void Main()
{
 IList iList= new List();
 iList.Add(10);
 Operate(iList);
 Console.WriteLine(iList[0].ToString());
}
```


Be thinking about what would the above program print to the console ? And that is what we are going to talk about in this post – simple but subtle.

I saw this code at CodeProject discussions. The author was confused with why was the program printing `10` instead of `1`. I am writing about this since the ‘gotcha’ was not highlighted in the discussion.

So we passed the reference `iList` to the function which is supposed to make it point to the `List` that it creates and so must be printing 1. Well, a C programmer knowing how to program in C# would have said _Gotcha_ already. A reference (in C#), equivalent to a pointer in C, is an entity that stores the address of an object in heap and accesses it using this address. So when we pass a reference (by value) to a function, then we are passing this address value. That is captured in another 4 byte variable local to that function; so creating assigning inside the function will make `iList2` point to newly created object – `iList` and `iList2` are two different reference pointing to the same object. So if you want to transmit the effect of the changes you make to the List inside the function, pass it by reference – use ref keyword.

Now the fun part !!! Let us try writing the same stuff in C++:-

```csharp
// This function will not alter the source pointer
void Operator(IList* pList)
{
  pList = new List();
  pList->Add(1);
  pList->Add(2);
  pList->Add(3);
}

// This function will affect the source; similar to using ref in C#
// 1) const IList*& pList - Can make pList point elsewhere but cannot modify the existing object
// 2) IList* const &pList - pList cannot point to anywhere else but can modify the existing object
void Operator(IList*& pList)
{
  pList = new List();
  pList->Add(1);
  pList->Add(2);
  pList->Add(3);
}
```

Hope that was fun !!!