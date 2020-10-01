---
title: The Surprising Finalize Call !!!
author: vivekragunathan
layout: post
date: 2007-02-21T20:27:00+00:00
url: /2007/02/22/the-surprising-finalize-call/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 29304367161731330
categories:
  - .NET
  - 'C#'
  - CLR
  - CodeProject
  - Uncategorized

---
<span style="font-size:medium;">Guess the output of the following program:-</span>  
`</p>
<pre>class SomeClass : IDisposable<br />{<br />   public SomeClass()<br />   {<br />      Trace.WriteLine("SomeClass - Attempting instance creation");<br />      throw new Exception("Ohh !!! Not Now");<br />   }<br /> <br />   public void Dispose()<br />   {<br />      Trace.WriteLine("SomeClass::Dispose");<br />   }<br /> <br />   ~SomeClass()<br />   {<br />      Trace.WriteLine("SomeClass::Finalizer");<br />   }<br />}<br /><br />int Main(string args[]){<br />try{<br />SomeClass sc = new SomeClass();<br />}catch(Exception ex){<br />Trace.WriteLine("Main - {0}", ex.Message);<br />}<br />}</pre>
<p>`This will be the output of the program:- `</p>
<pre>SomeClass - Attempting instance creation<br />Ohh !!! Not Now SomeClass::Finalizer</pre>
<p>`<span style="font-family:Georgia;font-size:medium;">If you are surprised with the last line of the output, that will be the intent of our discussion. In the .NET [managed] world, the garbage collector is entirely responsible for memory management &#8211; allocation and deallocation. In C#, an instance of a class is created using the new keyword. When an instance creation is requested, first memory for the instance is allocated followed by a call to the [appropriate] constructor of the class.</p> 

<p>
  To explain the surprising output, the constructor is called after the memory is allocated by the GC. When the constructor throws exception, the object or resource creation is interrupted but the memory cannot deallocated instantly since the GC is entirely responsible for memory deallocation. The GC follows a complex and non-deterministic style for deallocating or reclaiming an allocated chunk of memory. The finalizer method is the last call made on a managed object just before reclaiming memory. Hence in the above case, the finalizer is being called before reclaiming the memory allocated for an instance of SomeClass.
</p>

<p>
  The above behaviour is very much different from the unmanaged C++ where when the instance creation is interrupted [by throwing an exception], the allocated memory is deallocated and reclaimed instantaneously. Also the destructor is not called in this case.
</p>

<p>
  P.S: Thinking of a more detailed post on non-deterministic destruction.</span>
</p>