---
title: Overloading vs Variable Arguments !!!
author: vivekragunathan
layout: post
date: 2014-05-28T21:26:39+00:00
url: /2014/05/29/overloading-and-varargs/
categories:
  - JavaScript
  - PHP
  - Programming
  - Uncategorized
tags:
  - dynamic-languages
  - functions
  - javascript
  - overloading
  - php
  - static typing
  - variable arguments

---
In a statically typed (object oriented?) language, function overloading offers the facility of organizing your code into two or more functions with different types and/or number of arguments. This is highly useful when the functionality offered by the function can be invoked in different scenarios. For instance, let us consider the function(s) below:

<!--more-->

```csharp
// C# code
Dictionary<string, object> CreateResponse(string msg) {
	return CreateResponse(ex.Message, 0, false);
}

Dictionary<string, object> CreateResponse(string msg, int code) {
	return CreateResponse(ex.Message, code, false);
}

Dictionary<string, object> CreateResponse(string msg, bool success) {
	return CreateResponse(ex.Message, 0, success);
}

Dictionary<string, object> CreateResponse(Exception ex) {
	return CreateResponse(ex.Message, ex.HResult, false);
}

Dictionary<string, object> CreateResponse(string msg, int code, bool success) {
	var errorInfo = new Dictionary<string, object>();
	errorInfo['message'] = msg;
	errorInfo['code'] = code;
	errorInfo['success'] = success;
	return errorInfo;
}
```

Not a great example but I guess it is enough to explain my point.

The CreateResponse function has different overloads yielding itself to be used without much noise depending on the situation. If you have to create a response from within a catch block, you could go for the overload that takes an Exception object as input. And all the different overloads use or share a single core implementation, the one that takes all the possible inputs for CreateResponse. One would also have seen the same thing when implementing a class with multiple constructors. This is a common pattern. I find it very useful because you can be pretty sure about the inputs and their types. Of course, type guarantee is an integral part of any statically typed language.

Dynamic languages (such as JavaScript or PHP), on the contrary, do not offer any type guarantee, and hence could not possibly offer overloading, at least based on the types of arguments. They could, theoretically, offer overloading based on number of arguments. However, they don’t, and for a good reason. Unlike statically typed languages, dynamic languages don’t take the number of arguments for a function *seriously*. What that means is, in JavaScript or PHP, one could call a three arguments function without any arguments or less than or even more than three arguments. It is up to the implementation to deal with whatever arguments have been passed, including situations when one or more arguments have not been passed.

With the variable arguments, one could more or less simulate overloading but the implementation would be relatively messy or not natural unlike in statically typed languages. There would be a ceremony around argument checking – number and types of arguments, before they can be reliably used. It takes a quite an effort to make the function fail safe, **execution wise**. If the function expects an integer, it could not possibly work with a parameter that is an array. If this is all too much to worry about, one could just ignore implementing the guarantee, call it an assumption or ground rule, and and let the function fail; which is how code is typically written.

The other drawback around variable arguments, in the context of simulating overloading, is that it could end up not extensible; for instance to support future types and/or arguments. For instance, the type deduction at a particular argument index may not be possible any more if more arguments have been to be supported or even for the same number of arguments but with different types.

Actually my original musings was something else, besides compare/contrast overloading and variable arguments. It was about how the dynamic language runtime could, with my layman knowledge or as a consumer, handle type guarantee and so forth. I like to reserve a separate post, hopefully the next, to discuss about it.

Until then, I am going to let you try implementing `CreateResponse` in a dynamic language, say JavaScript, and *enjoy* the difficulty!
