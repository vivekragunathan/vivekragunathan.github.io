---
title: Managed Debugging Assistant !!!
author: vivekragunathan
layout: post
date: 2006-04-11T03:52:00+00:00
url: /2006/04/11/managed-debugging-assistant/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114472771858328463
categories:
  - Uncategorized

---
The Loader Lock is a synchronization object that hepls to provide mutual exclusion during DLL loading and unloading. It helps to prevent DLLs being re-entered before they are completely initialized [in the DLLMain].

When the some dll load code is executed, the loader lock is set and after the complete intialization it is unset. But there is a possibility of deadlock when threads do not properly synchronize on the loader lock. This mostly happens when threads try to call other other Win32 APIs [LoadLibrary, GetProcAddress, FreeLibrary etc] that also require the loader lock. Often this is evident in the mixed managed/unmanaged code, whereby it is not intentional but the CLR may have to call those APIs like during a call using platform invoke on one of the above listed Win32 API.

For instance, if an unmanaged DLL&#8217;s DllMain entry point tries to CoCreate a managed object that has been exposed to COM, then it is an attempt to execute managed code inside the loader lock.

MDA &#8211; Managed Debugging Assistant, facility available in .NET 2.0/VS 2005 helps to find out this situation while debugging and pops up a dialog box. Then we can break into the code, have a look at the stack trace and resolve it. The feature can be disabled if not needed.

So what could be the effect of this deadlock ? It saved me whole of time and effort that I would have wasted when such a box poped up in my project, and I do not know if I would have found the reason. If the thread that deadlocks happens to be the GC thread or any thread that loads and unloads my assemblies, I do not have explain further the disasterous effect. And for a programmer like me, new to the .NET environment, who has not yet gotten out of the fascinating external features, will not ponder into the internals.