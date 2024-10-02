---
title: Consts in .NET !!!
author: higherkindedtype
layout: post
date: 2006-03-26T00:37:00+00:00
url: /2006/03/26/consts-in-net/
categories:
  - Uncategorized

---
I was doing some programming with C# and I had to use some `const`s as everybody does generally in programming. I had a class that simply had const string variables for my DB table names and stuff like that. My program was not working well and I started debugging and in the debugger, I was shocked to see that the const variables did not show the string values I had assigned. I did rebuilt and other non-sensical stuff like that until I learnt this about the consts in .NET:- `const` variables in .NET do not exist as variables out of the assembly they exist in. Instead, during compilation, they get embedded - _hard-coded_, where ever you use them, and so when you debug, you do not see the proper value that you had assigned. For debugging purposes you have to output diagnostic trace messages and verify.
