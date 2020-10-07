---
title: OrderedThreadPool – Task Execution In Queued Order !!!
author: vivekragunathan
layout: post
date: 2009-03-18T03:35:00+00:00
url: /2009/03/18/ordered-thread-pool/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 8394495887151499024
categories:
  - .NET
  - 'C#'
  - CLR
  - CodeProject
  - Uncategorized
tags:
  - threadpool

---

I would not want to write chunks of code to spawns threads and perform many of my background tasks such as firing events, UI update etc. Instead I would use the System.Threading.ThreadPool class which serves this purpose. And a programmer who knows to use this class for such cases would also be aware that the tasks queued to the thread pool are NOT dispatched in the order they are queued. They get dispatched for execution in a haphazard fashion.

In some situations, it is required that the tasks queued to the thread pool are dispatched (and executed) in the order they were queued. For instance, in my (and most?) applications, a series of events are fired to notify the clients with what is happening inside the (server) application. Although the events may be fired from any thread (asynchronous), I would want them or rather the client would be expecting that the events are received in a certain order, which aligns with the sequence of steps carried out inside the server application for the requested service. So sequential execution of the queued tasks is not something one must not wish for.

Enough talking&#8230;&#8230;.eat code.

```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace System.Threading
{
   struct ThreadPoolTaskInfo
   {
      public readonly WaitCallback CallbackDelegate;
      public readonly object State;

      public ThreadPoolTaskInfo(WaitCallback wc, object state)
      {
         Debug.Assert(wc != null);
         CallbackDelegate = wc;
         State = state;
      }
   }

   class OrderedThreadPool
   {
      private Queue workItemQ = new Queue();

      public void QueueUserWorkItem(WaitCallback wcbDelegate, object state)
      {
         lock (workItemQ)
         {
            workItemQ.Enqueue(new ThreadPoolTaskInfo(wcbDelegate, state));

            if (workItemQ.Count == 1)
            {
               ThreadPool.QueueUserWorkItem(LoopWork);
            }
         }
      }

      private void LoopWork(object notUsed)
      {
         WaitCallback wcb = null;
         object state = null;

         lock (workItemQ)
         {
            if (workItemQ.Count == 0)
            {
               return;
            }

            ThreadPoolTaskInfo tptInfo = workItemQ.Dequeue();
            state = tptInfo.State;
            wcb = tptInfo.CallbackDelegate;
            Debug.Assert(wcb != null);
         }

         try
         {
            wcb(state);
         }
         finally
         {
            ThreadPool.QueueUserWorkItem(LoopWork, notUsed);
         }
      }
   }
}
```


The above class wraps the System.Threading.ThreadPool and offers the facility of execution of tasks in the order they are queued. Hope that is useful!
