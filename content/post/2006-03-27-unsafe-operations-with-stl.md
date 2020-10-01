---
title: Unsafe Operations with STL !!!
author: vivekragunathan
layout: post
date: 2006-03-27T00:19:00+00:00
url: /2006/03/27/unsafe-operations-with-stl/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114341885657818221
categories:
  - Uncategorized

---
It is UNSAFE to do any operation on an STL container that will modify its size while holding a reference to one of its exisiting element. What could happen is, when you do an operation, say push\_back on a vector, it determines if there is enough space available to add a new element. If there is not sufficient space available, it allocates new space for whole of the data structure and deletes the old buffer. At this point, any reference to one of its elements created prior to push\_back would have gotten corrupted.

For example, the following usage of code is dangerous when used within a single scope.

<span style="font-family:courier new;">SomeClass &sc = m_Vector.back();</span>  
<span style="font-family:courier new;">m_Vector.push_back(someotherobject);</span>  
<span style="font-family:courier new;">.</span>  
<span style="font-family:courier new;">.</span>  
<span style="font-family:courier new;">.</span>  
<span style="font-family:courier new;">sc.SomeMethodCall(); // Code might crash here. </span>