---
title: Invoking methods with out and ref – Finale !!!
author: vivekragunathan
layout: post
date: 2010-12-21T13:24:39+00:00
url: /2010/12/21/out-ref-finale/
categories:
  - .NET
  - 'C#'
  - Uncategorized

---
<p style="font-family:Tahoma;font-size:11pt;">
  Alright, it is a long wait. And I am going to keep it short.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  Recap of the problem: Why did the ref variable in <a href="http://developerexperience.blogspot.com/2010/10/invoking-methods-with-out-and-ref-part.html" target="_blank">SomeMethod</a> not get the expected result (<span style="font-family:Consolas;font-size:11pt;">DayOfWeek.Friday</span>) when called from a different thread?
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  Boxing. Yes, that is the culprit. Sometimes, it is subtle to note. DayOfWeek is an enum &#8211; a value type. When the method is called from a different thread, we put the argument (arg3) in an object array, and that&#8217;s where the value gets boxed. So we happen to assign the resultant value to the boxed value.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  So how do resolve the issue? Simple&#8230;&#8230;.assign the value back from the object array to the ref variable.
</p>

<pre class="brush: cpp; gutter: false; Code" style="font-family:Consolas;font-size:11pt;">int SomeMethod(string arg1,
    string arg2,
    ref DayOfWeek arg3)
{
    if (Dispatcher.CheckAccess())
    {
        var funcDelegate = (Func&lt;string, string, DayOfWeek, int&gt;)SomeMethod;

        var args = new object[] {
            arg1,
            arg2,
            arg3
        };

        int retVal = Dispatcher.Invoke(funcDelegate, args);
        arg3 = args[2];

        return retVal;
    }

    // No more implementation
    arg3 = DayOfWeek.Friday;

    return 1234;
}</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  It may not be worth the wait but it is subtle enough to plant a bug in the code; tough enough to be noted.
</p>