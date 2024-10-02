---
title: Fooled by the Activator !!!
author: vivekragunathan
layout: post
date: 2006-07-07T01:56:00+00:00
url: /2006/07/07/fooled-by-the-activator/
categories:
  - CodeProject
  - Uncategorized

---
It was interesting to know that a custom exception, say an exception class derived from [System.ApplicationException](http://msdn2.microsoft.com/en-us/library/system.applicationexception.aspx), thrown while creating an instance of a type using Activator.CreateInstance does not get caught in its appropriate exception handler, instead gets caught in the global exception handler `catch(Exception ex)`, if provided. Any exception raised while creating an instance of the loaded type is wrapped inside a new exception object as `InnerException` by `Activator`.`CreateInstance`.

I was fooled that there was some problem with the image generation for quite some time, and then very lately inspected the members of the exception caught and found my exception object wrapped as `InnerException`.

Now my global exception catch handler catch(Exception ex) has the logic to check if there is any inner exception in ex and inspect if it is of my custom exception type. I am not sure but why cannot the custom exception be thrown as such by the `Activator`.`CreateInstance` without wrapping it inside a new `Exception` object. Would not that be good besides saving a few lines of code ?
