---
title: sizeof vs Marshal.SizeOf !!!
author: vivekragunathan
layout: post
date: 2009-12-29T22:25:00+00:00
url: /2009/12/30/sizeof-vs-marshal-sizeof/
categories:
  - .NET
  - 'C#'
  - CLR
  - CodeProject
  - Uncategorized

---

There are two facilities in C# to determine the size of a type – [`sizeof`](http://msdn.microsoft.com/en-us/library/eahchzkf.aspx) operator and[`Marshal.SizeOf`](http://msdn.microsoft.com/en-us/library/5s4920fa.aspx) method. Let us discuss what they offer and how they differ.

Before we settle the difference between `sizeof` and `Marshal.SizeOf`, let us discuss why would we want to compute the size of a variable or type. Other than academic, one typical reason to know the size of a type (in a production code) would be allocate memory for an array of items; typically done while using [`malloc`](http://msdn.microsoft.com/en-us/library/6ewkz86d(VS.80).aspx). Unlike in C++ (or unmanaged world), computing the size of a type definitely has no such use in C# (managed world). Within the managed application, size does not matter; since there are types provided by the CLR for creating \ managing fixed size and variable size (typed) arrays. And as per MSDN, the size cannot be computed accurately. Does that mean we don’t need to compute the size of a type at all when working in the CLR world? Obviously no, else I would not be writing this post.

Value Types: User-defined value (and reference types) are composed of the primitive value types exposed by the compiler, most of which exist as keywords – `int`, `bool`, `char`, `long`, `double` etc. Since the primitive value types are exposed by the compiler, their sizes are (pre-)defined by the compiler (based on the platform on which the CLR runs). The compiler allows querying the sizes of the primitive value types the sizeof operator. The sizeof operator returns the size of the type in bytes as allocated by the CLR (on the current platform). Refer [MSDN](http://msdn.microsoft.com/en-us/library/eahchzkf(VS.85).aspx) for the sizes of primitive types.

However, the sizeof cannot be freely used with user-defined value types (struct) but only if the following conditions are true:-

- The size of the struct is requested from within an unsafe block.
- The struct does not contain a reference type as its member.Since the size of a reference type cannot be computed (see Reference Types below), the size of the struct cannot be computed too.
- The struct is not a generic value type. `sizeof` should be imagined as a compile-time construct. That implies the type for which the size is queried should be known at compile time. When we say `sizeof(GenValueType)``, the (closed) type definition `GenValueType` is not available at compile time but only at runtime. Hence the compiler does not allow computing the size of a generic value type. But the size of an instance of the same closed type may be determined. But ideally it does not sound convincing to me because the compiler uses the MSIL `sizeof` instruction to computer the size, instead of hard coding the size (as is done for primitive types).


Besides, the subtle and bitter thing is that the size depends on other factors such as the pack size used ([`StructLayout.Pack`](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.structlayoutattribute.pack.aspx)) or character set ([`StructLayout.CharSet`](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.structlayoutattribute(VS.85).aspx)) applied on the type definition or the fixed size specified ([``StructLayout.Size``](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.structlayoutattribute(VS.85).aspx)). Unlike in C++, sizeof accepts only a (closed) type known at compile time and not variables.

Reference Types: The sizeof operator cannot be used on reference types. As per MSDN, the size can be either misleading or meaningless for reference types. Consider a class (reference type) SomeClass containing a char and a string. Reference types are basically (C++) pointer like. When computing the size of SomeClass, which aspect of the string member should be consider – the reference (4 bytes) or the value (n bytes)? Also, every .NET object incurs a 16 (I guess) byte header overhead. Should we consider the header size too and the same question applies here too – 16 bytes or the mazy data structure that the header actually refers to. So for such reasons, it does not make sense to determine the size of a reference type using sizeof (at least at compile time). The other way of putting this is sizeof works only for POD types.

Given all this uncertainty in computing the size of a type (using sizeof), will there ever be a need then? In a broader sense, there is one situation. That is when the data is passed out of the managed application – Interop or custom serialization and such. For example, the managed application might want to allocate unmanaged memory for creating \ filling a data structure for calling a native API, which takes the data structure as its input or would be populating it with output.

Let us enter the second half (or the better half) – `Marshal.SizeOf`. Unlike sizeof (C# keyword), this one is offered from the BCL. This method returns the size (in bytes) of the type or its instance if it had to exist in the unmanaged world. This method has two overloads – one taking the type as input and the other an instance. Let us say we want to allocate some memory in the unmanaged heap to call a native API (`SendMessage` or `VirtualAlloc` or `ReadProcessMemory`). In many cases, the amount of memory to be allocated is the equivalent of a Win32 structure – `LVITEM`, `STARTUPINFO` or one such. In such situations, Marshal.SizeOf method has to be used { int x = Marshal.SizeOf(typeof(LVITEM)); }, which returns the size of the structure depending on the `StructLayoutAttribute` applied.

Can `Marshal.SizeOf` method be used on reference and value types? It can be used on any value type but will throw an exception at runtime if the value type contains a reference type. And the error makes sense – Type cannot be marshaled as an unmanaged structure; no meaningful size or offset can be computed. Otherwise, it can be used with primitive or user-defined value types. It is allowed to be used with reference types only if the type layout is specified to be `LayoutKind.Sequential` or `LayoutKind.Explicit`; else the same exception above will be thrown at runtime.

It is possible that the size returned by sizeof and Marshal.SizeOf are different, as with the case of char. sizeof(char) is 2 since CLR is an Unicode beast. `Marshal.SizeOf(char)` will return 1 since a char in the unmanaged world takes up one byte. However, `Marshal.SizeOf(SomeStruct)` may report  that its char member consumes two bytes (by default) or made to take up one byte (if the `StructLayout.CharSet = CharSet.Ansi`).

Do I need to conclude something?
