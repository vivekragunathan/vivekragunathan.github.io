---
title: OrderedThreadPool – Bug Fix !!!
author: vivekragunathan
layout: post
date: 2012-04-13T19:50:01+00:00
url: /2012/04/14/otp-bug-fix/
categories:
  - .NET
  - 'C#'
  - Uncategorized

---
Hugh pointed out a [bug](http://www.blogger.com/comment.g?blogID=11793007&postID=8394495887151499024) in the [OrderedThreadPool](/2009/03/18/ordered-thread-pool).

I think there is a small window for error in the OrderedThreadPool class. Basically, if an item of work is queued, then a worker thread runs, takes the item off the queue and is about to call `wcb(state)` – but at that instant is (say) context switched. Then another item gets queued and another worker thread runs and dequeues the item and then again is about to call `wcb(state)`. There is scope here for the two operations to run concurrently or even out of order…

Here is the fixed version of the same.

```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace System.Threading
{
 public class OrderedThreadPool
 {
  private Queue workItemQ = new Queue();
  private bool loopWorkRunning = false;

  public void QueueUserWorkItem(WaitCallback wcbDelegate, object state)
  {
   lock (workItemQ)
   {
    workItemQ.Enqueue(new ThreadPoolTaskInfo(wcbDelegate, state));

    if (workItemQ.Count == 1 && !loopWorkRunning)
    {
     loopWorkRunning = true;
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
     loopWorkRunning = false;
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

  public struct ThreadPoolTaskInfo
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
 }
}
```
