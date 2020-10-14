---
title: finally and Return Values !!!
author: vivekragunathan
layout: post
date: 2009-07-01T21:07:00+00:00
url: /2009/07/02/finally-and-return-values/
categories:
  - 'C#'
  - CodeProject
  - Uncategorized
tags:
  - 'C#'
  - codeproject
  - finally

---
<DIV style="font-family:Tahoma;font-size:11pt;">
  Let us read some code:-</p>

  <pre class="brush: c-sharp;" style="font-family:Consolas;font-size:11pt;">int SomeMethod()
{
    int num = 1;

    try
    {
        num = 5;
        return num;
    }
    finally
    {
        num += 5;
    }
}</pre>

  <p>
    What is the return value of SomeMethod? Some anonymous guy asked that question in the code project forum, and it has been answered. I am writing about it here because it is interesting and subtle. One should not be surprised when people misinterpret finally. So let us take a guess, 10 (i = 5, then incremented by 5 in the finally block).It is not the right answer; rather SomeMethod returns 5. Agreed that finally is called in all cases of returning from SomeMethod but the return value is calculated when it is time to return from SomeMethod, normally or abnormally. The subtlety lies not in the way finally is executed but in the return value is calculated. So the return value (5) is decided when a return is encountered in the try block. The finally is just called for cleanup; and the num modified there is local to SomeMethod. So make the return value 10, it is no use being hasty making<br /> SomeMethod return from the finally block. Because returning from finally is not allowed. (We will talk about it later why returning from catch block is a bad practice<br /> and why can't we return from finally block). Had such modifications been done on a reference type, they would have been visible outside of SomeMethod, although the return value may be different. For instance,
  </p>

  <pre class="brush: c-sharp;" style="font-family:Consolas;font-size:11pt;">class Num
{
    public int _num = 0;
};

int SomeMethod()
{
    Num num = new Num();

    try
    {
        num._num = 5;
        return num._num;
    }
    finally
    {
        num._num += 5;
    }
}</pre>

  <p>
    So in the above case, the return value is still 5, but the Num._num would have been incremented to 10 when SomeMethod returns. So reflecting shows that our code is transformed as follows by the compiler, where the CS$1$0000 is our return value.
  </p>

  <pre class="brush: c-sharp;" style="font-family:Consolas;font-size:11pt;">private static int SomeMethod(Num num)
{
    int CS$1$0000;

    try
    {
        num._num = 5;
        CS$1$0000 = num._num;
    }
    finally
    {
        num._num += 5;
    }

    return CS$1$0000;
}</pre>

  <p>
    Given that we have clarified ourselves about finally, we should be writing the code as transformed by the compiler because returning from try and catch blocks is not a good practice.<br /> </DIV>
  </p>
