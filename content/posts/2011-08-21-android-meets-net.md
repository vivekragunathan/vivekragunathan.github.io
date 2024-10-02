---
title: Android meets .NET
author: vivekragunathan
layout: post
date: 2011-08-21T13:07:44+00:00
url: /posts/android-meets-net
categories:
  - .NET
  - Android
  - 'C#'
  - Mobile
  - Uncategorized

---
It is always fun to program in C# (besides C++). If so, how would I feel if I was able to program in C# on Android? You may be wondering what in the world I am talking about. Android development environment is all Java and open source stuff. How could this Microsoft thing fit onto it? Well, it seems that some clever guys[^1] had huddled up and ported Mono for Android, developed .NET libraries for the Android SDK, and also supplemented it with a _Mono for Android_ project template in Visual Studio. Thus we relish writing C# code for Android.

After a bunch of installations[^2], fire up your Visual Studio (2010) and you should be seeing a new project template _Mono for Android_[^3] under C#.

Create a new _Mono for Android_ project[^4], which by default comes with an activity – C# code.

<small>Modified the orginal code to try starting a new activity from the default one.</small>

The project layout for most of the part is similar to the native Android project. The layout resources files are named `*.axml`, and the `strings.xml` is really clean with named string constants with the ugly behind the scenes of ids and stuff in the `Resource.designer.cs`. The way to code is straight forward and needs no special explanation. A good to see thing for me was .NET coding style.

A similar set of addins and plugins have been developed for MonoDevelop too; although I did not try that.

Such an attempt &#8211; programming in C# on Android, is really a wondrous thing. However, there are sad curves in the story:-

* Mono for Android is available only for Windows (and Mac). It is not available for Linux.
* The installation of the application from Visual Studio and application response for the few clicks is pig slow. It is not Visual Studio’s fault. It seems Mono takes quite a bit of time for JITting. After each part of the code is JITed, the application response for that part is fairly ok, but as good as Android’s native\custom VM Dalvik.
* The trial version does not allow deploying on the device. You can play around and deploy only on the emulator. If you want to use it on the device, it costs. Yes, it costs somewhere between $400-2500, depending on the licesing and support. Pretty expensive!

Try it out (the trial one or the full version if you are rich), at least for fun!

[^1]: http://www.xamarin.com/
[^2]: http://android.xamarin.com/Installation/Visual_Studio
[^3]: Mono for Android Project ![mono4android](/images/2011/08/mono4android.gif)
[^4]: Activity ![activity](/images/2011/08/activity.gif)