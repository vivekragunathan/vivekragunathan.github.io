---
title: Consts in .NET !!!
author: vivekragunathan
layout: post
date: 2006-03-26T00:37:00+00:00
url: /2006/03/26/consts-in-net/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114333375151725120
categories:
  - Uncategorized

---
I was doing some programming with C# and I had to use some &#8216;const&#8217;s as everybody does generally in programming. I had a class that simply had const string variables for my DB table names and stuff like that. My program was not working well and I started debugging and in the debugger, I was shocked to see that the const variables did not show the string values I had assigned. I did rebuilt and other non-sensical stuff like that until I learnt this about the consts in .NET:- &#8216;const&#8217; variables in .NET do not exist as variables out of the assembly they exist in. Instead, during compilation, they get embedded [hard-coded] where ever you use them, and so when you debug, you do not see the proper value that you had assigned. For debugging purposes you have to output diagnostic trace messages and verify.