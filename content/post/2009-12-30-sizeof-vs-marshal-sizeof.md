---
title: sizeof vs Marshal.SizeOf !!!
author: vivekragunathan
layout: post
date: 2009-12-29T22:25:00+00:00
url: /2009/12/30/sizeof-vs-marshal-sizeof/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 474452470488814286
categories:
  - .NET
  - 'C#'
  - CLR
  - CodeProject
  - Uncategorized

---
<p style="font-family:Tahoma;">
  There are two facilities in C# to determine the size of a type &#8211; <a target="_blank" href="http://msdn.microsoft.com/en-us/library/eahchzkf.aspx"><span style="font-family:Consolas;font-size:11pt;">sizeof</span></a> operator and<span style="font-family:Consolas;font-size:11pt;"><a target="_blank" href="http://msdn.microsoft.com/en-us/library/5s4920fa.aspx">Marshal.SizeOf</a></span> method. Let me discuss what they offer and how they differ. Pardon me if I happen to ramble a bit.
</p>

<p style="font-family:Tahoma;">
  Before we settle the difference between <span style="font-family:Consolas;font-size:11pt;">sizeof</span> and <span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf</span>, let us discuss why would we want to compute the size of a variable or type. Other than academic, one typical reason to know the size of a type (in a production code) would be allocate memory for an array of items; typically done while using <span style="font-family:Consolas;font-size:11pt;"><a target="_blank" href="http://msdn.microsoft.com/en-us/library/6ewkz86d(VS.80).aspx">malloc</a></span>. Unlike in C++ (or unmanaged world), computing the size of a type definitely has no such use in C# (managed world). Within the managed application, size does not matter; since there are types provided by the CLR for creating\managing fixed size and variable size (typed) arrays. And as per MSDN, the size cannot be computed accurately. Does that mean we don&#8217;t need to compute the size of a type at all when working in the CLR world? Obviously no, else I would not be writing this post.
</p>

<p style="font-family:Tahoma;">
  Value Types: User-defined value (and reference types) are composed of the primitive value types exposed by the compiler, most of which exist as keywords – int, bool, char, long, double etc. Since the primitive value types are exposed by the compiler, their sizes are (pre-)defined by the compiler (based on the platform on which the CLR runs). The compiler allows querying the sizes of the primitive value types the <span style="font-family:Consolas;font-size:11pt;">sizeof</span> operator. The <span style="font-family:Consolas;font-size:11pt;">sizeof</span> operator returns the size of the type in bytes as allocated by the CLR (on the current platform). Refer<a target="_blank" href="http://msdn.microsoft.com/en-us/library/eahchzkf(VS.85).aspx">MSDN</a> for the sizes of primitive types.
</p>

<p style="font-family:Tahoma;">
  However, the <span style="font-family:Consolas;font-size:11pt;">sizeof</span> cannot be freely used with user-defined value types (struct) but only if the following conditions are true:-
</p>

<ul style="font-family:Tahoma;">
  <li>
    The size of the struct is requested from within an unsafe block. <p />
  </li>
  <li>
    The struct does not contain a reference type as its member.<br /> Since the size of a reference type cannot be computed (see Reference Types below), the size of the struct cannot be computed too. <p />
  </li>
  <li>
    The struct is not a generic value type.<br /> <span style="font-family:Consolas;font-size:11pt;">sizeof</span> should be imagined as a compile-time construct. That implies the type for which the size is queried should be known at compile time. When we say <span style="font-family:Consolas;font-size:11pt;">sizeof</span>(GenValueType), the (closed) type definition GenValueType is not available at compile time but only at runtime. Hence the compiler does not allow computing the size of a generic value type. But the size of an instance of the same closed type may be determined. But ideally it does not sound convincing to me because the compiler uses the MSIL <span style="font-family:Consolas;font-size:11pt;">sizeof</span> instruction to computer the size, instead of hard coding the size (as is done for primitive types). <p />
  </li>
</ul>

<p style="font-family:Tahoma;">
  Besides, the subtle and bitter thing is that the size depends on other factors such as the pack size used (<span style="font-size:11pt;font-family:Consolas;"><a href="http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.structlayoutattribute.pack.aspx">StructLayout.Pack</a></span>) or character set (<span style="font-size:11pt;font-family:Consolas;"><a target="_blank" href="http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.structlayoutattribute(VS.85).aspx">StructLayout.CharSet</a></span>) applied on the type definition or the fixed size specified (<span style="font-size:11pt;font-family:Consolas;"><a target="_blank" href="http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.structlayoutattribute(VS.85).aspx">StructLayout.Size</a></span>). Unlike in C++, <span style="font-family:Consolas;font-size:11pt;">sizeof</span> accepts only a (closed) type known at compile time and not variables.
</p>

<p style="font-family:Tahoma;">
  Reference Types: The <span style="font-family:Consolas;font-size:11pt;">sizeof</span> operator cannot be used on reference types. As per MSDN, the size can be either misleading or meaningless for reference types. Consider a class (reference type) SomeClass containing a char and a string. Reference types are basically (C++) pointer like. When computing the size of <span style="font-size:11pt;font-family:Consolas;">SomeClass</span>, which aspect of the string member should be consider &#8211; the reference (4 bytes) or the value (n bytes)? Also, every .NET object incurs a 16 (I guess) byte header overhead. Should we consider the header size too and the same question applies here too &#8211; 16 bytes or the mazy data structure that the header actually refers to. So for such reasons, it does not make sense to determine the size of a reference type using <span style="font-family:Consolas;font-size:11pt;">sizeof</span> (at least at compile time). The other way of putting this is <span style="font-family:Consolas;font-size:11pt;">sizeof</span> works only for POD types.
</p>

<p style="font-family:Tahoma;">
  Given all this uncertainty in computing the size of a type (using <span style="font-family:Consolas;font-size:11pt;">sizeof</span>), will there ever be a need then? In a broader sense, there is one situation. That is when the data is passed out of the managed application &#8211; Interop or custom serialization and such. For example, the managed application might want to allocate unmanaged memory for creating\filling a data structure for calling a native API, which takes the data structure as its input or would be populating it with output.
</p>

<p style="font-family:Tahoma;">
  Let us enter the second half (or the better half) &#8211; <span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf</span>. Unlike <span style="font-family:Consolas;font-size:11pt;">sizeof</span> (C# keyword), this one is offered from the BCL. This method returns the size (in bytes) of the type or its instance if it had to exist in the unmanaged world. This method has two overloads &#8211; one taking the type as input and the other an instance. Let us say we want to allocate some memory in the unmanaged heap to call a native API (<span style="font-family:Consolas;font-size:11pt;">SendMessage</span> or<span style="font-family:Consolas;font-size:11pt;">VirtualAlloc</span> or <span style="font-family:Consolas;font-size:11pt;">ReadProcessMemory</span>). In many cases, the amount of memory to be allocated is the equivalent of a Win32 structure &#8211;<span style="font-family:Consolas;font-size:11pt;">LVITEM</span>, <span style="font-family:Consolas;font-size:11pt;">STARTUPINFO</span> or one such. In such situations, <span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf</span> method has to be used <span style="font-size:11pt;font-family:Consolas;">{ int x = Marshal.SizeOf(typeof(LVITEM)); }</span>, which returns the size of the structure depending on the StructLayoutAttribute applied.
</p>

<p style="font-family:Tahoma;">
  Can <span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf</span> method be used on reference and value types? It can be used on any value type but will throw an exception at runtime if the value type contains a reference type. And the error makes sense &#8211; <span style="font-family:Consolas;font-size:12pt;color:red;">Type cannot be marshaled as an unmanaged structure; no meaningful size or offset can be computed.</span> Otherwise, it can be used with primitive or user-defined value types. It is allowed to be used with reference types only if the type layout is specified to be LayoutKind.Sequential or LayoutKind.Explicit; else the same exception above will be thrown at runtime.
</p>

<p style="font-family:Tahoma;">
  It is possible that the size returned by <span style="font-family:Consolas;font-size:11pt;">sizeof</span> and <span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf</span> are different, as with the case of char. <span style="font-family:Consolas;font-size:11pt;"> <span style="font-family:Consolas;font-size:11pt;">sizeof</span>(char)</span> is 2 since CLR is an Unicode beast. <span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf(char)</span> will return 1 since a char in the unmanaged world takes up one byte. However,<span style="font-family:Consolas;font-size:11pt;">Marshal.SizeOf(SomeStruct)</span> may report to that its char member consumes two bytes (by default) or made to take up one byte (if the <span style="font-family:Consolas;font-size:11pt;">StructLayout.CharSet=CharSet.Ansi</span>).
</p>

<p style="font-family:Tahoma;">
  Do I need to conclude something?
</p>