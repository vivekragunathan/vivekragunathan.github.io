---
title: An encounter with Hashtables !!!
author: vivekragunathan
layout: post
date: 2006-04-11T04:26:00+00:00
url: /2006/04/11/an-encounter-with-hashtables/
categories:
  - Uncategorized

---
I encountered a situation like this where I had a hashtable in which the key is a string and the value is some object, and I had to change the values of all the keys [from zero to count] to null or some other value. I used the some of the facilities &#8211; enumerator, the Keys property etc provided by the hash table itself but it did not work out, and I spent too much time on this.

The interesting thing is that for the following code,

```csharp
IDictionaryEnumerator de = ht.GetEnumerator();

while (de.MoveNext())
{
   de.Value = null;
}
```

... the compiler spat an error:

```text
System.Collections.IDictionaryEnumerator.Value cannot be assigned to; it is read only;
```

while for this code

```csharp
foreach (string key in ht.Keys)
{
  ht[key] = null;
}
```

it compiled successfully but threw a runtime exception

```text
An unhandled exception of type System.InvalidOperationException occurred in mscorlib.dll Additional information: Collection was modified; enumeration operation may not execute].
```

But the solution was just bit out of sight while it was in hand. Just forget that you encountered this problem, and start again, you will have the solution simple like this:-

```csharp
ArrayList keys = new ArrayList(ht.Keys);
foreach (string key in keys)
{
   ht[key] = null;
}
```

Another thing I came to know was that the hash table entries are not maintained in the same order as they are inserted. I came to know that it is the inherent nature of the algorithm. That is basic but it was new to me.
