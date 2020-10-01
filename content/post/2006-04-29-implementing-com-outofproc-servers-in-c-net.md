---
title: 'Implementing COM OutOfProc Servers in C# .NET !!!'
author: vivekragunathan
layout: post
date: 2006-04-29T02:34:00+00:00
url: /2006/04/29/implementing-com-outofproc-servers-in-c-net/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114627833651687050
categories:
  - Uncategorized

---
Had to implement our COM OOP Server project in .NET, and I found this solution from the internet after a great deal of search, but unfortunately the whole idea was ruled out, and we wrapped it as a .NET assembly. This is worth knowing.

Step 1:  
Implement IClassFactory in a class in .NET. Use the following definition for IClassFactory.

<pre style="color:#006600;font-family:'Courier New';font-size:100%;">namespace COM<br />{<br />   static class Guids<br />   {<br />      public const string IClassFactory = "00000001-0000-0000-C000-000000000046";<br />      public const string IUnknown = "00000000-0000-0000-C000-000000000046";<br />   }<br />   <br />   /// <br />   /// IClassFactory declaration<br />   /// <br />   [ComImport(), InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid(COM.Guids.IClassFactory)]<br />   internal interface IClassFactory<br />   {<br />      [PreserveSig]<br />      int CreateInstance(IntPtr pUnkOuter, ref Guid riid, out IntPtr ppvObject);<br />      [PreserveSig]<br />      int LockServer(bool fLock);<br />   }<br />}<br /></pre>

Step 2:

<pre><span style="color:#006600;font-family:'Courier New';font-size:100%;">[DllImport("ole32.dll")]<br />private static extern int CoRegisterClassObject(ref Guid rclsid,<br />[MarshalAs(UnmanagedType.Interface)]IClassFactory pUnkn,<br />int dwClsContext,<br />int flags,<br />out int lpdwRegister);<br /><br />[DllImport("ole32.dll")]<br />private static extern int CoRevokeClassObject(int dwRegister);<br /></span></pre>

Step 3:  
Use these functions to register your own IClassFactory

Step 4:  
IClassFactory has a CreateInstance method. Implement this method to return a reference (IntPtr) to your own object. Use Marshal.GetIUnknownForObject to get IUnknown pointer to your object.

Step 5:  
The COM client receives a pointer to this object, and can use it as a regular COM object. .NET does the reference counting for you, and the GC will collect these objects when the COM-reference-count decremetns to zero.

Walking through and closely examining the working of ClassFactories for COM will give a clear sight of the objects that you need to implement in .NET, and a solution for COM Server in managed world.