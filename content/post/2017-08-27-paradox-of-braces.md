---
title: A Paradox of Braces
author: vivekragunathan
layout: post
date: 2017-08-27
url: /2017/12/106/paradox-of-braces
categories:
  - JavaScript
---

A great deal of thought goes into language design. Eric Lippert’s [posts](https://ericlippert.com) is a living testament, at least for C#. Syntax and idioms are also part of the language design. When designing a language, the designers have to also consider its future. For instance, when designing C#, [Anders](https://twitter.com/ahejlsberg) and others should have thought of and planned for what’s coming in then upcoming version(s) of C#. Such level of forethought might be seem daunting for an outsider. But the language designers are good at what they do, and most importantly, they know what they are doing. Well, in most cases!

In most cases? There are times when they either do not anticipate the introduction of a feature or its introduction interferes with what’s already existing. I am not talking about C#. I am talking about JavaScript.

A few years back, nobody would have thought that the language is going to get a pair of new shoes. Back then you would have been outlawed for uttering the word `classe`es. Nobody anticipated lambdas because you know JavaScript was already a functional programming language; or so they say. Everything could be solved with `function`s. You implement `class`es with `function`s while the reverse, although it makes sense (think function objects), was considered _not thinking in JavaScript_. Anyways, here comes the funny story.

Here is a simple one line ES6 lambda:

```javascript
x => x + 1  
```

Here is a multiline lambda:

```javascript
(item, index) => {  
  console.log(`Processing item #${index} …`);

  // Imagine a few more lines of code to play with item.

  return {  
    userId: item.account.tokenData.userId,  
    fullName: item.account.firstName + " " + item.account.lastName,  
    location: item.address.city || item.address.province  
    // Want more such ceremony?? 😝  
  };
}
```

In the second snippet, the return value is an object (literal). You don’t need the block `{ .. }` with a `return` if you can express the return value as an expression (as in the one line lambda earlier). Ignoring the _few more lines of code_ and the _ceremony_ 😝, you could have this:

```javascript
(item, index) => {  
  userId: item.account.tokenData.userId,  
  fullName: item.account.firstName + " " + item.account.lastName,  
  location: item.address.city || item.address.province  
}
```

Like the one line lambda returning an integer, the above, technically, is one line lambda. Its’ returning an object (literal). I have just wrapped/formatted the object literal (the way I usually do).

Except the above code won’t work. Duh!

**`Uncaught SyntaxError: Unexpected token :`**

The JavaScript parser is tricked into seeing the **`{`** as the beginning of a multiline lambda block and not as an object literal. Well, you can’t blame it. JavaScript did not see it coming; the language upgrade. Time and again, we put it off saying `function`s is just enough.

I suppose we cannot do anything much here.

```javascript
(item, index) => {  
  return {  
    userId: item.account.tokenData.userId,  
    fullName: item.account.firstName + " " + item.account.lastName,  
    location: item.address.city || item.address.province  
  };  
}
```

Or by declaring _another_ function that returns the object and call the function in the lambda:

```javascript
function mapIt(item) {  
  return {  
    userId: item.account.tokenData.userId,  
    fullName: item.account.firstName + " " + item.account.lastName,  
    location: item.address.city || item.address.province  
  };  
}

let users = items.map(item, item => mapIt(item));  
```

I prefer the above rather than nesting **`{`** for the sake of satisfying the parser and having a dummy `return`.

Also, JavaScript’s closest kin, Typescript, wouldn’t be able to help us here. Because Typescript _augments_ JavaScript, and doesn’t invalidate any existing JavaScript constructs.

I am sure I am not the first to discover this. But I couldn’t stop laughing to myself when I encountered this.

**UPDATE**

Instead of the above workarounds, I came across a cleaner way:

```javascript
(item, index) => ({  
  userId: item.account.tokenData.userId,  
  fullName: item.account.firstName + " " + item.account.lastName,  
  location: item.address.city || item.address.province  
});
```

Still squinting your eyes? Notice the object literal shoved inside `()`.
