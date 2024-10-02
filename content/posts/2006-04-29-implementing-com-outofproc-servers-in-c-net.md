---
title: 'Implementing COM OutOfProc Servers in C# .NET !!!'
author: vivekragunathan
layout: post
date: 2006-04-29T02:34:00+00:00
url: /posts/com-oop-in-cs
aliases:
  - /2006/04/29/implementing-com-outofproc-servers-in-c-net/
categories:
  - Uncategorized

---

Had to implement our COM OOP Server project in .NET, and I found this solution from the internet after a great deal of search, but unfortunately the whole idea was ruled out, and we wrapped it as a .NET assembly. This is worth knowing.

**Step 1**

Implement IClassFactory in a class in .NET. Use the following definition for IClassFactory.

```cpp
namespace COM
{
   static class Guids
   {
      public const string IClassFactory = "00000001-0000-0000-C000-000000000046";
      public const string IUnknown = "00000000-0000-0000-C000-000000000046";
   }

   ///
   /// IClassFactory declaration
   ///
   [ComImport(), InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid(COM.Guids.IClassFactory)]
   internal interface IClassFactory
   {
      [PreserveSig]
      int CreateInstance(IntPtr pUnkOuter, ref Guid riid, out IntPtr ppvObject);
      [PreserveSig]
      int LockServer(bool fLock);
   }
}
```

**Step 2**

```csharp
[DllImport("ole32.dll")]
private static extern int CoRegisterClassObject(ref Guid rclsid,
[MarshalAs(UnmanagedType.Interface)]IClassFactory pUnkn,
int dwClsContext,
int flags,
out int lpdwRegister);

[DllImport("ole32.dll")]
private static extern int CoRevokeClassObject(int dwRegister);
```

**Step 3**

Use these functions to register your own IClassFactory

**Step 4**

`IClassFactory` has a `CreateInstance` method. Implement this method to return a reference (`IntPtr`) to your own object. Use `Marshal`.`GetIUnknownForObject` to get `IUnknown` pointer to your object.

**Step 5**

The COM client receives a pointer to this object, and can use it as a regular COM object. .NET does the reference counting for you, and the GC will collect these objects when the COM-reference-count decremetns to zero.

Walking through and closely examining the working of ClassFactories for COM will give a clear sight of the objects that you need to implement in .NET, and a solution for COM Server in managed world.
