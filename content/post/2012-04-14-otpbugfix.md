---
title: OrderedThreadPool – Bug Fix !!!
author: vivekragunathan
layout: post
date: 2012-04-13T19:50:01+00:00
url: /2012/04/14/otpbugfix/
tagazine-media:
  - 'a:7:{s:7:"primary";s:0:"";s:6:"images";a:0:{}s:6:"videos";a:0:{}s:11:"image_count";s:1:"0";s:6:"author";s:8:"16968609";s:7:"blog_id";s:8:"16420864";s:9:"mod_stamp";s:19:"2012-04-14 13:34:30";}'
categories:
  - .NET
  - 'C#'
  - Uncategorized

---
<div style="font-family:Tahoma;font-size:11pt;text-align:left;" dir="ltr">
  Hugh pointed out a <a href="http://www.blogger.com/comment.g?blogID=11793007&postID=8394495887151499024" target="_blank">bug</a> in the <a href="http://developerexperience.blogspot.in/2009/03/orderedthreadpool-task-execution-in.html" target="_blank">OrderedThreadPool</a>.
</div>

<div>
</div>

<div style="color:blue;font-family:Georgia;font-size:11pt;font-style:italic;">
  I think there is a small window for error in the OrderedThreadPool class. Bascially, if an item of work is queued, then a worker thread runs, takes the item off the queue and is about to call wcb(state) &#8211; but at that instant is (say) context switched. Then another item gets queued and another worker thread runs and dequeues the item and then again is about to call wcb(state). There is scope here for the two operations to run concurrently or even out of order&#8230;
</div>

<div>
</div>

<div style="font-family:Tahoma;font-size:11pt;">
  Here is the fixed version of the same.
</div>

<div>
</div>

<pre style="font-family:Consolas;font-size:11pt;">using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace System.Threading
{
 public class OrderedThreadPool
 {
  private Queue workItemQ = new Queue();
  <span class="Apple-style-span" style="background-color:#f1c232;">private bool loopWorkRunning = false;</span>

  public void QueueUserWorkItem(WaitCallback wcbDelegate, object state)
  {
   lock (workItemQ)
   {
    workItemQ.Enqueue(new ThreadPoolTaskInfo(wcbDelegate, state));

    if (workItemQ.Count == 1 && <span class="Apple-style-span" style="background-color:#f1c232;">!loopWorkRunning</span>)
    {
     <span class="Apple-style-span" style="background-color:#f1c232;">loopWorkRunning = true;</span>
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
     <span class="Apple-style-span" style="background-color:#f1c232;">loopWorkRunning = false;</span>
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
}</pre>