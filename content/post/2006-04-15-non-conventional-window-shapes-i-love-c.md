---
title: 'Non-conventional Window Shapes [I love C#] !!!'
author: vivekragunathan
layout: post
date: 2006-04-15T05:48:00+00:00
url: /2006/04/15/non-conventional-window-shapes-i-love-c/
categories:
  - Uncategorized

---
I am not a UI guy. More specifically, I love to work with UIs. I think (only) a UI can give a better picture of the system in a multitasking environment unlike Unix. I do not say I hate Unix. And I do not like to work on UIs ie program on UIs cuz I do not know much. But have always wanted to create a non-conventional window, say an elliptical one. .NET made things like that very easy for guys like me. Look at the code below for creating a ellipitcal window.

```csharp
GraphicsPath windowShape = new GraphicsPath();
windowShape.AddEllipse(0, 0, 320, 200);
this.Region = new Region(windowShape);
````

The `GraphicsPath` has methods to create wiondows of other shapes too.

I am not sure but I think it was not this straight forward in the MFC/Win32 programming world. Thanks to C#.NET. I love this 3 lines of code.
