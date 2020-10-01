---
title: Use Of Class Factories !!!
author: vivekragunathan
layout: post
date: 2006-03-27T00:22:00+00:00
url: /2006/03/27/use-of-class-factories/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114341897089827964
categories:
  - Uncategorized

---
To understand quickly and to explain in the simplest way, Class Factories are the factory classes that create a COM object. A class factory may be responsible for creating one or more COM objects. In the case of COM OutOfProc servers, the server registers the class factories for objects that it can create in a system-global table using CoRegisterClassObject. Whenever a client does CoGetClassObject for a CLSID, the COM run-time can look it up in the system global table, and return the factory instance. The case with InProc servers is also similar but through the DLLGetClassObject.

The point here is that class factories are required [irrespective of how they exist physically in the servers, either as seperate instances or the COM object itself behaving as a factory for the objects of that type], they abstract the creation of the COM object through IClassfactory::CreateInstance.