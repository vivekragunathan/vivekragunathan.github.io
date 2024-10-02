---
title: "Python Overloaded"
author: higherkindedtype
layout: post
url: /posts/python-overloaded
date: 2023-10-26
tags: [ 'python', 'overloading' ]
summary: |
  Function overloading is every day business in statically typed languages. Not all languages. Go has make it everything [hard](https://go.dev/doc/faq#overloading). 🙄 But function overloading in dynamic languages are not really sought after.

---

Function overloading is every day business in statically typed languages. Not all languages. Go has make it everything [hard](https://go.dev/doc/faq#overloading). 🙄 But function overloading in dynamic languages are not really sought after. Because the types are checked dynamically like so ...

```python
def parse_start_end(raw):
    if isinstance(raw, str):
        s, e = address.split(':')
    elif isinstance(raw, tuple):
        s, e = raw
    else:
        print('Parse error!')
```

TIL Pythong has a way to implement function overloading 🥳 via the `singledispatch`

```python
from functools import singledispatch

@singledispatch
def parse_start_end(raw):
    print('Parse error!')

@parse_start_end.register
def _(raw: str):
    start, end = raw.split(':')
    # some logic ... run loop?
    print(f"str: {start}-{end}")

@parse_start_end.register
def _(raw: tuple):
    start, end = raw
    # some logic ... run loop?
    print(f"tuple: {start}-{end}")

parse_start_end("1:10") # str: 1-10
parse_start_end((1, 10)) # tuple: 1-10
parse_start_end(22) # Parse error!
parse_start_end(list())  # Parse error!
```

What this buys us is a certain level of, for the lack of a better word, type affinity. Meaning, function is called based on the type of the parameters when you have functions by the same name a.k.a function overloading. This enables us to package code / logic based on types. All in Python. In fact, you can call one overload from another; if you have the right types in hand. See (in the code above) the overload that takes a `str` call the overload that takes `tuple`.

What you don't get is complete type safety. Calls to `parse_start_end` with types that are not listed end up in the catch-all (`def parse_start_end(raw)`). You would wish for a compilation error for types that don't match. Of course, there is no compilation error per se. Think of IDEs making use of mypy or other linters to report such errors early instead of at runtime.

One thing to note is that `singledispatch` is not a language construct. But a library implementation. Nonetheless, `singledispatch` is a great addition to our toolbelt.
