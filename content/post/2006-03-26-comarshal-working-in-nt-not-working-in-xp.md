---
title: CoMarshal…. working in NT, Not working in XP !!!
author: vivekragunathan
layout: post
date: 2006-03-26T00:48:00+00:00
url: /2006/03/26/comarshal-working-in-nt-not-working-in-xp/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114333411439799056
categories:
  - Uncategorized

---
**Problem:**

   I have created a multi-threaded application which works without any problems on a NT-4.0 Workstation/Server. When I try to run the same application in Windows XP, I get an error in a call to `CoMarshalInterThreadInterfaceInStream` which returns ``-2147418113`.

   I have provided a snippet of the code below where the call fails in Windows XP.

   Environment: Windows-XP,SP-2,Visual Studio 6.0,SP-4,ATL-3.0

   Should I be doing anything different in Windows XP?

***

```cpp
HRESULT hr = S_OK;
IUnknown** pp = p->m_vec.begin();

while (pp m_vec.end() && hr == S_OK)
{
   if (*pp != NULL)
   {
         IEvent* pEvent = (IEvent*)*pp;
         IStream* pIStream;

         HRESULT hr = CoMarshalInterThreadInterfaceInStream(
            IID_IEvent,
            pEvent,
            &pIStream
         );

         if(SUCCEEDED(hr))
         {
            CComPtr pMarshalEvent;
            hr = CoGetInterfaceAndReleaseStream(
               pIStream,
               IID_IEvent,
               (void**)&pMarshalEvent
            );

            if(SUCCEEDED(hr))
            {
               hr = pMarshalEvent->NewCurrentCassette(
                  m_pCurrentCassette,
                  m_setBy
               );
            }
         }

      p++;
   }
}
```

**Thread 2:**

I remember facing this problem long time back.The reason it happened was beacuse of the Free-Threaded marshaller code in `FinalConstruct` and `FinalRelease` even though I don't remember the logic behind it. In my case commenting the Free-Threaded marshaller code did the trick.

- The commented code in `FinalConstruct` was:

```cpp
   hr = CoCreateFreeThreadedMarshaler(
         GetControllingUnknown(),
         &m_pUnkMarshaler.p
   );

   PROCESS_HR(IID_ISomeThing);
```

- In `FinalRelease` it was the corresponding `m_pUnkMarshaler.Release();`` that was commented.
- In the header, `DECLARE_GET_CONTROLLING_UNKNOWN()` and `COM_INTERFACE_ENTRY_AGGREGATE(IID_IMarshal, m_pUnkMarshaler.p)` and `CComPtr m_pUnkMarshaler;` was commented.
- Remove marshaling code i.e., `CoInterface` and related marshaling code. The interface pointer can be accessed in the secondary thread directly, no need of marshaling.

I remember faintly that Free-Threaded marshaller is basically to optimize marshalling. So in my case removing it did not have any side-effects as we were not worried about Free-Threaded marshaller.Again the above fix might work but the best thing to do will be to anaylze the apartment link (STA,MTA etc.) between say the client and the component and then come to a conclusion.

**Thread 3**

You need not marshal/unmarshal to call a method on the interface pointer since the sink class itself deriving from the IConnectionPointImpl takes care of unmarshalling. You can see the code in your connection point implementation class.

**Thread 4**

I don`t think `IConnectionPointImpl` class as such has anything to do with marshaling, it is the `m_pUnkMarshaler` member object.It is the call to `CoCreateFreeThreadedMarshaler` in `FinalConstruct` that initializes the `m_pUnkMarshaler` object. I suggest reading the documentation about `CoCreateFreeThreadedMarshaler` in order to come to a conclusion whether to use it or not. By default ATL provides the code calling `CoCreateFreeThreadedMarshaler` API to do efficient marshaling across *thread of the same process(Refer doc)*, but depending on our need we may or may not use it.In my case we did not need it so we commented it out.It depends on the need,but generally i think it is safe to comment it out if we are going to access interface pointers in secondary threads. Hope this helps.
