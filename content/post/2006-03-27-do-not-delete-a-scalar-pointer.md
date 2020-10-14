---
title: 'Do not delete [] a scalar pointer !!!'
author: vivekragunathan
layout: post
date: 2006-03-27T20:28:00+00:00
url: /2006/03/27/do-not-delete-a-scalar-pointer/
categories:
  - Uncategorized

---
Recently I got tangled into this problem in my code &#8211; Calling a vector dtor for a scalar pointer. We all know that it is perfectly illegal to do that. For example, if we allocate something like this:-

<span style="font-family:courier new;">OurClass *p = new OurClass();</span>

and try to delete like this:-            
<span style="font-family:courier new;">delete []p;</span>

then we are going to end up in trouble. Ofcourse we know that we will end up in trouble. But I have really not given a thought HOW ?

When we allocate an array of items eg. <span style="font-family:courier new;">OurClass pa[] = new[5] pa()</span>, the compiler actually allocates the necessary amount of memory, calls the ctors for each allocated class and also prefixes the block of memory of the &#8216;n&#8217; items allocated with the number of items allocated.

<span style="font-size:85%;"><span style="font-family:courier new;"> NumItems | OurClassObject1 | OurClassObject2 | &#8230;&#8230; | OurClassObjectn</span></span>

But pa always points to the first item in the allocation, thereby the item count prefix remains hidden. When we call <span style="font-family:courier new;">delete[] pa</span>, the compiler uses the item count prefix to delete the allocated objects and call the dtors.

Now i think i don&#8217;t need explain any further as what happens when i use delete []p, and what junk value will the compiler take from the memory location just before the memory location p believing it to be the item count.

I learnt this interesting information from  [OldNewThing Blog][1]. Adam Nathan has explained it well with the compiler generated assembly and a bit of excellent code for the dtor.

And what if we do a scalar delete on a vector pointer, there is less harm, you do not unallocate the memory completely, you leave behind remnants of your allocated memory which you cannot reclaim.

Either way, it is better to be disciplined while programming.

 [1]: http://blogs.msdn.com/oldnewthing/archive/2004/02/03/66660.aspx
