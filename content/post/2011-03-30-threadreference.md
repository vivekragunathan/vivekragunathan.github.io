---
title: To Hold or Not to Hold – A story on Thread references !!!
author: vivekragunathan
layout: post
date: 2011-03-30T17:05:36+00:00
url: /2011/03/30/threadreference/
categories:
  - .NET
  - CLR
  - Uncategorized

---
[code lang=csharp]
  
void SomeMethod(int x, double y) {
      
// some code
      
&#8230;.
      
new Thread(ThreadFunc).Start();
  
}
  
[/code]

What do you think about the code above?

Some may say nothing seems to be wrong. Some may say there is not enough information to comment. A few may say that it is awful to spin off a thread like that (the last line of the method), and that there is a probability for the thread to be garbage collected at an unexpected point of execution. That is something interesting to discuss about.

Before presenting my thoughts and supporting facts, the short answer is NO. A thread spun off like that will not be garbage collected as we expect, although one should be morally insane to write such code. Alright, let us discuss.

The `Thread` class is like any other reference type in the BCL. When an instance of a reference type holds no more outstanding references, it is a candidate to be garbage collected. Even worse, it could become a [candidate][1] even while it is executing an instance method, while there are no more outstanding references to that instance. If such facts are considered, then the thread created at free will in the above code is bound to be collected anytime while executing the associated `ThreadFunc`. Let us try that with _simple_ sample application.

[code lang=csharp]
  
static void Main(string[] args)
  
{
     
Console.WriteLine("The Beginning&#8230;."); 

// ThreadFunc inlined as anonymous delegate
     
new Thread(delegate()
     
{
        
for (int i = 0; i < 1000; i++)
        
{
           
var obj = new Junk(i, i, i.ToString());
           
Console.WriteLine("{0}, ", i);
           
Thread.Sleep(100); 

if (i % 10 == 0)
           
{
              
GC.Collect();
              
GC.WaitForPendingFinalizers();
           
}

}
     
}).Start(); 

GC.Collect();
     
GC.WaitForPendingFinalizers(); 

Console.WriteLine("At the end!");
  
}
  
[/code]

In the sample application above, I have forced garbage collections and also waited for pending finalizers at two important points of execution &#8211; 1) at the end of main thread 2) in the course of execution of the thread delegate. I have made sure that there is enough chance of GC kicking in by creating some Junk objects too. Those are some of the important triggers for GC to kick in.

If you run the application, you will see that the application does not quit until the loop runs to completion; although the main thread runs to completion &#8211; prints `At the end!`. Now, let us not enter an argument that the thread is a foreground thread and application shall not quit until all foreground threads have finished executing. Yes, if the thread in the above code was a background thread, the application would have quit before the loop completed. But then we would have created a reference to set it as a background thread, and we would have to stop the discussion there since we are talking about threads created\started without holding a reference. Besides, the context of the problem is not application exit but application running.

Alright, let me rephrase it in a way that is relevant to our context &#8211; If you run the application, you will see that the thread function runs to completion successfully (loops 1000 times, creates 1000 objects, waits for 100ms each iteration of the loop, triggers garbage collection/waits for pending finalizers during execution). If thread had been garbage collected, it would not have run a 1000 iterations successfully. So does that mean the CLR has a soft corner for Thread types? Seems so.

If you drill down the `Thread` type using Reflector, you will see that it neither implements `IDisposable` nor a`finalizer`. How could an object not implement cleanup mechanism, escape the almighty garbage collector, and still not cause any havoc? That is weird! It gives the impression that we might be leaking the underlying native thread resource. Obviously, the CLR folks are not that careless or we would not be running applications today written in managed code. My common sense told me that there is some trick played behind the scenes such that a reference to every thread is somehow maintained and the clean up is thus taken care of.

So Ananth and I rolled up our sleeves to ponder for the evidence inside the runtime using [SSCLI][2]. It is tough to project a few snippets of code or so from SSCLI to show you _Here, this is the evidence_. However, I can share what we saw. When a thread is created, a reference to the thread object is added to a static list maintained by the framework. Thus a reference is established whether the user code holds it or not. When a thread is started, there is a bit of framework code executed, which then turns over control to our thread delegate. When our thread delegate finishes execution (normally or abnormally), it returns to the caller inside the framework code, which takes care of removing the reference from the static list. The framework code then does some cleanup which involves closing the thread handle and such. Only then, does a thread object become a candidate for garbage collection, which finally has nothing specific to cleanup. I think the CLR folks are smart enough (obviously) to do it this way. Because 1) threads are really special resources whose behavior is a bit different than other native resources 2) `Thread` type is a just wrapper for over the original native\OS thread.

We have seen the evidence. Now, let us discuss something about morale. When you take a look at the code with thread spun off at free will, don&#8217;t you wink twice? Doesn&#8217;t it raise a lot of questions about correctness, safety etc. Obviously, it is not a good practice. Just because there is something in the framework to take care of, it does not unleash us to do such things. Agreed that SSCLI does not lie but is it completely safe for our application code to rely on some very intrinsic detail of the framework code? I don&#8217;t think so.

The intent of the code like `SomeMethod` seems to fire (off a thread to do some processing) and forget, since it is not interested in holding a reference to the thread object. And it is very well possible that `SomeMethod` could be called few or many times, and we would be creating new threads just to fire and forget. Haven&#8217;t we heard that threads are expensive resources? Why did people come up with idea of thread pool? Thread pool is the apt choice for such fire and forget or processing that do not require thread affinity.

Next time, you see such code, if you have the authority to change it, correct it. If not, speak to the developer who wrote the code. Start with a soft and warm conversation and explain him the morale or show him this post (a little marketing!). Make sure that the conversation does not become aggressive (getting the developer defensive). Even after such warm conversations, the developer does not have the brains to take your side, shoot him! Just kidding.

Well, that is something I wanted to share. It is now your turn to comment and/or correct. Please share your thoughts if you have found or know of any other evidences about thread references and related. I am sure it would be an interesting and worthy discussion.

 [1]: http://blogs.msdn.com/b/cbrumme/archive/2003/04/19/51365.aspx
 [2]: http://www.microsoft.com/downloads/en/details.aspx?FamilyId=8C09FD61-3F26-4555-AE17-3121B4F51D4D