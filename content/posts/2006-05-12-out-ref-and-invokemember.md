---
title: out, ref and InvokeMember !!!
author: vivekragunathan
layout: post
date: 2006-05-12T02:26:00+00:00
url: /2006/05/12/out-ref-and-invokemember/
categories:
  - CodeProject
  - Uncategorized

---
When I was working on the .NET reflection extravaganza thing that I explained in my previous column, i learnt one another interesting thing, that is about the Type.InvokeMember. How will pass out or ref parameters for the method invoked using Type.InvokeMember ? If you are going to invoke a method with the prototype

```csharp
int DoSomething(string someString, int someInt);
```

then you would use InvokeMember like this:-

```csharp
object obj = someType.InvokeMember(“DoSomething”,
        BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,
        null,
        this,
        new object[] {“Largest Integer”, 1});
```

or use some variables in the new object[] {…}. But what do you with the args if DoSomething takes out or ref parameters ?

```csharp
int DoSomething(out string someString, ref int someInt);
```

Something like this will not work

```csharp
string someText = string.Empty;
int someInt = 0;
object obj =
  someType.InvokeMember(
    “DoSomething”,
    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,
    null,
    this,
    new object[] {someText, someInt}
  );
```

It is tricky.

```csharp
object[] args = new object[] { someText, someInt };

object obj =
	someType.InvokeMember(
		“DoSomething”,
		BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,
    null,
    this,
    args
  );
```

or even suprisingly this works:-

```csharp
object[] args = new object[2];
// or object[] args = new object[] { null, null };

object obj =
  someType.InvokeMember(
    “DoSomething”,
    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,
    null,
    this,
    args
  );
```

Access the values by indexing args. So declaring the argument object[] as a local variable solves the problem, but I do not understand why this behavior. May be somebody can explain !!!
