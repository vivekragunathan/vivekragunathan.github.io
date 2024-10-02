---
title: Settling Casting Restrictions
author: vivekragunathan
layout: post
date: 2009-02-05T20:31:00+00:00
url: /2009/02/06/settling-casting-restrictions/
categories:
  - 'C#'
  - CodeProject
  - Uncategorized

---

Remember the Casting Restrictions we discussed a while back, let us settle that now. So we have some code like this:

```csharp
object obj = i;
long l = (long)obj;
```

And an invalid cast exception while casting &#8216;obj&#8217; to long. It is obvious that we are not changing the value held by obj, but just reading it. Then why restrict such casting. Let us disassemble and see what we got.

```il
.locals init (
  [0] int32 i,
  [1] object obj,
  [2] int64 l
)
L_0000: nop
L_0001: ldc.i4.s 100
L_0003: stloc.0
L_0004: ldloc.0
L_0005: box int32
L_000a: stloc.1
L_000b: ldloc.1
L_000c: unbox.any int64
L_0011: stloc.2
L_0012: ret
```

Oh, there we see something interesting - `unbox`. So the C# compiler uses the `unbox` instruction to retrieve the value from `obj` while casting; it does not use [`Convert`](http://msdn.microsoft.com/en-us/library/system.convert.aspx).[`ToInt64`](http://msdn.microsoft.com/en-us/library/system.convert.toint64.aspx)  or similar mechanism. That is why the exception was thrown.

From MSDN:

> Unboxing is an explicit conversion from the type object to a value type or from an interface type to a value type that implements the interface. An unboxing operation consists of:
>
> - Checking the object instance to make sure it is a boxed value of the given value type
> - Copying the value from the instance into the value-type variable

So we are blown at step 1 of the unbox operation. Let us play with what we have for now, and stop bugging why was unbox meant to be like that.
