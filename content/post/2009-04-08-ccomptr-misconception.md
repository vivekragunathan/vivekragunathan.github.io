---
title: CComPtr Misconception !!!
author: vivekragunathan
layout: post
date: 2009-04-08T00:15:00+00:00
url: /2009/04/08/ccomptr-misconception/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 8856326086691149602
categories:
  - C++
  - CodeProject
  - COM
  - Uncategorized
  - Unmanaged

---
<p style="font-family:Tahoma;">
  This is about a killer bug identified by our chief software engineer in our software. What was devised for ease of use and write smart code ended up in this killer defect due to improper perception. Ok, let us go!
</p>

CComPtr is a template class in ATL designed to wrap the discrete functionality of COM object management &#8211; <font face="Consolas">AddRef</font> and <font face="Consolas">Release</font>. Technically it is a smart pointer for a COM object.

<pre style="font-family:Consolas;font-size:11pt;">void SomeMethod()<br />{<br />   CComPtr siPtr;<br />   HRESULT hr = siPtr.CoCreateInstance(CLSID_SomeComponent);<br />   siPtr-&gt;MethodOne(20, L"Hello");<br />}</pre>

<p style="font-family:Tahoma;">
  Without CComPtr, the code wouldn&#8217;t be as elegant as above. The code would be spilled with AddRef and Release. Besides, writing code to Release after use under any circumstance is either hard or ugly. CComPtr automatically takes care of releasing in its destructor just like std::auto_ptr. As a C++ programmer, we must be able to appreciate the inevitability of the destructor and its immense use in writing smart code. However there is a difference between pointers to normal C++ objects and pointers to COM objects; CComPtr and std::auto_ptr. When you assign one auto_ptr to another, the source is no more the owner of the object pointing to. The ownership is transferred to the destination. Whereas when a CComPtr is assigned to another, the reference count of the target COM object increases by one. And the two CComPtrs point to the same COM object. Changes made via one CComPtr object can be realized when the object is accessed via the other CComPtr. Release must be called on each CComPtr instance (to completely release the COM object). All fine, lets us see some code.
</p>

<pre style="font-family:Consolas;font-size:11pt;">void SomeOtherMethod()<br />{<br />   CComPtr aPtr;<br />   InitAndPopulateObject(aPtr);<br /><br />   int itemCount = 0;<br />   HRESULT hr = aPtr-&gt;GetCount(&itemCount);<br />   _ASSERTE(SUCCEEDED(hr));<br /><br />   for (int i = 0; i &lt; itemCount; ++i)<br />   {<br />      TCHAR szBuffer[128] = { 0 };<br />      sprintf_s(szBuffer, sizeof(szBuffer), "Key%ld", i);<br />      CComBSTR bstrKey(szBuffer);<br /><br />      int iValue = 0;<br />      hr = aPtr-&gt;GetItem(bstrKey, &iValue);<br />      _ASSERTE(SUCCEEDED(hr));<br /><br />      std::cout &lt;&lt; bstrKey &lt;&lt; " - " &lt;&lt; iValue;<br />   }<br />}<br /><br />void InitAndPopulateObject(CComPtr bPtr)<br />{<br />   HRESULT hr = ptr.CoCreateInstance(CLSID_Hashtable);<br />   <br />   _ASSERTE(SUCCEEDED(hr));<br /><br />   for (int i = 0; i &lt; 100; ++i)<br />   {<br />      TCHAR szBuffer[128] = { 0 };<br />      sprintf_s(szBuffer, sizeof(szBuffer), "Key%ld", i);<br />      bPtr-&gt;Add(szBuffer, i);<br />   }  <br />}</pre>

<p style="font-family:Tahoma;">
  CComPtr saved a whole of code as explained above. But my application was always crashing in the <font face="Consolas">SomeOtherMethod</font> on the line where <font face="Consolas">GetCount</font> method is called on the COM object initialized one line above. So I am passing a CComPtr to <font face="Consolas">InitAndPopulateObject</font>, which is supposed to create me my COM object and fill it with some information I expect. Since I am passing a CComPtr, a return value is not needed. Looks fine, but the application crashed.
</p>

People are often misled with many things in programming mostly because they stick to the prime way of its use. CComPtr, in most cases, is used for creating a COM object, passed around across various sections in the code where <font face="Consolas">AddRef</font> and <font face="Consolas">Release</font> is done under the covers until the COM object dies a pleasant death. People tend to forget that the member in CComPtr (named poorly as p) is the one that is actually pointing to the COM object. So <font face="Consolas">aPtr.p</font>, whose value is 0x0000 (NULL), is passed by value and copied to bPtr.p. When the COM object is created using bPtr, it is <font face="Consolas">bPtr.p</font> ,which is assigned the COM object&#8217;s address, say 0x23456789; whereas <font face="Consolas">aPtr.p</font> remains <font face="Consolas">NULL</font> even after <font face="Consolas">InitAndPopulateObject</font> returns. Hence the application was crashing because of null pointer access.

The problem might be obvious in the above few lines of clear code. It sure was very tough to locate and reason it in our huge code base.