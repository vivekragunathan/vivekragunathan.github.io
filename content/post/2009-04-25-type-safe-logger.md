---
title: Type Safe Logger
author: vivekragunathan
layout: post
date: 2009-04-25T15:02:00+00:00
url: /2009/04/25/type-safe-logger/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 9076675656332833893
categories:
  - C++
  - CodeProject
  - Uncategorized

---
<p style="font-family:Tahoma;font-size:11pt;">
  <a href="http://www.codeproject.com/Members/sanvenk" target="_blank">Sanjeev</a> and I have published an <a href="http://www.codeproject.com/kb/cpp/typesafelogger.aspx" target="_blank">article</a> &#8211; Type Safe Logger For C++ &#8211; at CodeProject. Every bit of work is tiresome or little ugly in C++. So is logging &#8211; writing application diagnostics to console, file etc. The printf style of outputting diagnostics is primitive and not type safe. The std::cout is type safe but does not have a format specification. Besides that, printf and std::cout know to write only to the console. So we need a logging mechanism that provides a format specification, is type safe and log destination transparent. So we came up with this new Logger to make C++ programmers happy.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  Following is a short introduction excerpt of the article:-
</p>

<blockquote style="font-family:Georgia;font-size:11pt;">
  <p>
    Every application logs a whole bunch of diagnostic messages, primarily for (production) debugging, to the console or the standard error device or to files. There are so many other destinations where the logs can be written to. Irrespective of the destination that each application must be able to configure, the diagnostic log message and the way to generate the message is of our interest now. So we are in need of a Logger class that can behave transparent to the logging destination. That should not be a problem, it would be fun to design that&#8230;&#8230;.<a href="http://www.codeproject.com/kb/cpp/typesafelogger.aspx" target="_blank">Read more</a>.
  </p>
</blockquote>

<p style="font-family:Tahoma;font-size:11pt;">
  As always your comments are most valuable.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  And oh, Happy Logging!
</p>