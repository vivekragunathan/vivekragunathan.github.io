---
title: 'Singularity – Safety & Speed !!!'
author: vivekragunathan
layout: post
date: 2006-06-02T19:54:00+00:00
url: /2006/06/02/singularity-safety-speed/
categories:
  - CodeProject
  - Uncategorized

---
I read about this interesting thing somewhere in MSDN.

There are two types of programming or programming languages. The good old C/C++ kind called the unsafe programming languages, and the other is the safe programming type which we realised very much after advent of Java/C#. And there has always been debate about safety and speed. And neither of the two has won.

So Microsoft is doing a research on a new operating system called Singularity which is written in a safe programming language [C#]. Although there are parts in the OS, especially the kernel, that uses unsafe code, it stills uses the safe C#. So in the Singularity environment, every program that runs is safe. And the environment as such is reinventing from the hardware layers up and above.

Any process in singularity will not be as huge as its counterpart in the unsafe world. It will start with very minimal image and bring up things as when required. But also there was some thing that i read but could not understand exactly. It said that Singularity processes are closed &#8211; dynamic loading of code is not allowed after the process starts executing.

Whatever, the environment is .NET as whole which means that .NET is not just libraries on the disk instead it is into the kernel. Microsoft is doing the research to prove that there is no compromise between speed and safety with this safe programming environment, and also help programmers stopping worrying about the choice of speed or safety.
