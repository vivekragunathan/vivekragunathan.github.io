---
title: A Note On Finalize !!!
author: vivekragunathan
layout: post
date: 2006-04-11T04:12:00+00:00
url: /2006/04/11/a-note-on-finalize/
categories:
  - Uncategorized

---
This is not about what Finalize is, but well Finalize is the last call on a managed object, where you can perform some clean up operations, before getting garbage collected by the .NET runtime. A few important things that are to be noted about finalizers are:-

&#8211; In C#, finalizers are represented by the ~ClassName [destructor syntax], and the Object.finalize can neither be overridden or called directly. It cannot be called directly because it is protected. The destructors in C# also take care of calling the dtor of the base class.  
&#8211; Finalizer is called on an object only once, just before the .NET runtime attempts to garbage collect the object.  
&#8211; Finalizers can be called anytime on a managed object that is not being referenced, and on any thread by the .NET runtime.  
&#8211; The order in which the finalizers are called is also not fixed. Even when two objects are related to each other in some way, there is no hierarchial order in which the finalizers for the objects will be called.  
&#8211; During an application shutdown, finalizers will be called even on objects that are still accessible.

The most interesting part of the finalizer is not when it is called but when all is it NOT called. This is where we need to watch and rely on the Dipose method [[IDispoable &#8211; Dispose pattern][1]].

&#8211; When a finalizer of a object blocks indefinitely [deadlock, infinite loop etc].  
&#8211; When the process terminates improperly without giving the .NET runtime a chance run the finalizers.  
&#8211; When a managed object is exempt from finalization by calls like GC.SupressFinalize or KeepAlive.

 [1]: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpgenref/html/cpconFinalizeDispose.asp
