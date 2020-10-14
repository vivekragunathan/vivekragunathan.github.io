---
title: CComPtr Misconception !!!
author: vivekragunathan
layout: post
date: 2009-04-08T00:15:00+00:00
url: /2009/04/08/ccomptr-misconception/
categories:
  - C++
  - CodeProject
  - COM
  - Uncategorized
  - Unmanaged

---
This is about a killer bug identified by our chief software engineer in our application. What was devised for ease of use and write smart code ended up in this killer defect due to improper perception. Ok, let us go!

`CComPtr` is a template class in ATL designed to wrap the discrete functionality of COM object management – `AddRef` and `Release`. Technically it is a smart pointer for a COM object.

```cpp
void SomeMethod()
{
   CComPtr siPtr;
   HRESULT hr = siPtr.CoCreateInstance(CLSID_SomeComponent);
   siPtr->MethodOne(20, L"Hello");
}
```

Without `CComPtr`, the code wouldn’t be as elegant as above. The code would be spilled with AddRef and Release. Besides, writing code to Release after use under any circumstance is either hard or ugly. CComPtr automatically takes care of releasing in its destructor just like std::auto_ptr. As a C++ programmer, we must be able to appreciate the inevitability of the destructor and its immense use in writing smart code. However there is a difference between pointers to normal C++ objects and pointers to COM objects; CComPtr and std::auto_ptr. When you assign one `auto_ptr` to another, the source is no more the owner of the object it was pointing to. The ownership is transferred to the destination. Whereas when a `CComPtr` is assigned to another, the reference count of the target COM object increases by one. And the two `CComPtr`s point to the same COM object. Changes made via one `CComPtr` object can be realized when the object is accessed via the other CComPtr. Release must be called on each `CComPtr` instance (to completely release the COM object). All fine, lets us see some code.

```cpp
void SomeOtherMethod()
{
   CComPtr aPtr;
   InitAndPopulateObject(aPtr);

   int itemCount = 0;
   HRESULT hr = aPtr->GetCount(&itemCount);
   _ASSERTE(SUCCEEDED(hr));

   for (int i = 0; i < itemCount; ++i)
   {
      TCHAR szBuffer[128] = { 0 };
      sprintf_s(szBuffer, sizeof(szBuffer), "Key%ld", i);
      CComBSTR bstrKey(szBuffer);

      int iValue = 0;
      hr = aPtr->GetItem(bstrKey, &iValue);
      _ASSERTE(SUCCEEDED(hr));

      std::cout << bstrKey << " - " << iValue;
   }
}

void InitAndPopulateObject(CComPtr bPtr)
{
   HRESULT hr = ptr.CoCreateInstance(CLSID_Hashtable);

   _ASSERTE(SUCCEEDED(hr));

   for (int i = 0; i < 100; ++i)
   {
      TCHAR szBuffer[128] = { 0 };
      sprintf_s(szBuffer, sizeof(szBuffer), "Key%ld", i);
      bPtr->Add(szBuffer, i);
   }  
}
```

`CComPtr` saved a whole of code as explained above. But my application was always crashing in the SomeOtherMethod on the line where GetCount method is called on the COM object initialized one line above. So I am passing a `CComPtr` to `InitAndPopulateObject`, which is supposed to create me my COM object and fill it with some information I expect. Since I am passing a CComPtr, a return value is not needed. Looks fine, but the application crashed.

People are often misled with many things in programming mostly because they stick to the prime way of its use. `CComPtr`, in most cases, is used for creating a COM object, passed around across various sections in the code where `AddRef` and `Release` is done under the covers until the COM object dies a pleasant death. People tend to forget that the member in `CComPtr` (named poorly as p) is the one that is actually pointing to the COM object. So `aPtr.p`, whose value is `0x0000` (`NULL`), is passed by value and copied to bPtr.p. When the COM object is created using bPtr, it is `bPtr.p` ,which is assigned the COM object’s address, say `0x23456789`; whereas `aPtr.p` remains NULL even after `InitAndPopulateObject` returns. Hence the application was crashing because of null pointer access.

The problem might be obvious in the above few lines of clear code. It sure was very tough to locate and reason it in our huge code base.
