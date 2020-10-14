---
title: Consoles for Mr.GUI !!!
author: vivekragunathan
layout: post
date: 2006-03-27T00:13:00+00:00
url: /2006/03/27/consoles-for-mr-gui/
categories:
  - Uncategorized

---
Learnt something new, a small one but very useful.  
Many times I have seen GUI applications accompanied by console windows that show logs or trace information of the application. How do we do that for our application ?

Any GUI application can create its own console window just by calling AllocConsole Win32 API. Actually any process can use that API to allocate a new console. And the application must also learn to be disciplined enough to FreeConsole. Ok, fine. I used that in my small MFC application and was happy to see the console. But I did not see anything displayed on the console. As we know, each process has its own stdin, stdout and stderr. So redirect the console output of your parent application to the console. How do you do that ?

Use the FILE \*freopen(const char \*path, const char \*mode, FILE \*stream); API. The freopen function closes the file currently associated with stream and reassigns stream to the file specified by path. By that way, call freopen as follows:-

<span style="font-family:courier new;">FILE *fpStdOut = freopen (&#8220;CONOUT$&#8221;, &#8220;w&#8221;, stdout);</span>

This means that I want to reassign the standard console output stdout with the console output of the parent application CONONUT$. So any printf calls will print the characters on the console. Cool !!!
