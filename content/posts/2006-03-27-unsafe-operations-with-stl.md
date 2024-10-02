---
title: Unsafe Operations with STL !!!
author: vivekragunathan
layout: post
date: 2006-03-27T00:19:00+00:00
url: /2006/03/27/unsafe-operations-with-stl/
categories:
  - Uncategorized

---
It is UNSAFE to do any operation on an STL container that will modify its size while holding a reference to one of its existing element. What could happen is, when you do an operation, say push_back on a vector, it determines if there is enough space available to add a new element. If there is not sufficient space available, it allocates new space for whole of the data structure and deletes the old buffer. At this point, any reference to one of its elements created prior to push_back would have gotten corrupted.

For example, the following usage of code is not safe when used within a single scope.

```cpp
SomeClass &sc = m_Vector.back();
m_Vector.push_back(someotherobject);
.
.
.
sc.SomeMethodCall(); // Code might crash here.
```
