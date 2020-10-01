---
title: C++0x Like Algorithms
author: vivekragunathan
layout: page
date: 2014-10-01T03:32:28+00:00

---
A few C++0x algorithms and other helper methods implemented for C++98

* * *

[code lang=text]
  
#pragma once

#include "Include.h"

namespace stdext
  
{
     
static const TCHAR* EmptyString = _TXT("");

template <typename T>
     
struct Predicate
     
{
     
public: virtual bool operator()(const T& t) = 0;
     
public: virtual ~Predicate() = 0 { }
     
};

template<typename TIterator, typename TPredicate>
     
bool TrueForAll(TIterator begin, TIterator end, TPredicate predicateFunc)
     
{
        
for (; begin != end; ++begin)
        
{
           
if (!predicateFunc(*begin))
           
{
              
return false;
           
}
        
}

return true;
     
}

template<typename TIterator, typename TPredicate>
     
TIterator TrueForAny(TIterator begin, TIterator end, TPredicate predicateFunc)
     
{
        
while (begin != end)
        
{
           
if (predicateFunc(*begin))
           
{
              
return begin;
           
}

++begin;
        
}

return end;
     
}

template<typename TIterator, typename TPredicate>
     
int IndexOf(TIterator begin, TIterator end, TPredicate predicateFunc)
     
{
        
int index = -1;

while (begin != end)
        
{
           
++index;

if (predicateFunc(*begin))
           
{
              
return index;
           
}

++begin;
        
}

return index;
     
}

template<typename TContainer>
     
int IndexOf(TContainer stlContainer, typename TContainer::value_type value)
     
{
        
typedef typename TContainer::const_iterator TContainerConstIter;
        
TContainerConstIter iter = stlContainer.begin();

int index = -1;
        
while (iter != stlContainer.end())
        
{
           
++index;

if (*iter == value)
           
{
              
return index;
           
}

++iter;
        
}

return -1;
     
}

template<typename TSrcIter, typename TDestIter, typename TPredicate>
     
TDestIter CopyIf(TSrcIter srcIterBegin, TSrcIter srcIterEnd, TDestIter destIter, TPredicate predFunc)
     
{
        
while (srcIterBegin != srcIterEnd)
        
{
           
if (predFunc(*srcIterBegin))
           
{
              
\*destIter = \*srcIterBegin;
           
}

++srcIterBegin;
           
++destIter;
        
}

return destIter;
     
}

template<typename TSrcIter, typename TDestIter>
     
TDestIter CopyN(TSrcIter srcIterBegin, size_t copySize, TDestIter destIter)
     
{
        
while (copySize > 0)
        
{
           
\*destIter = \*srcIterBegin;

&#8211;copySize;
           
++srcIterBegin;
           
++destIter;
        
}

return destIter;
     
}

template<typename TIterator, typename TPredicate>
     
bool IsPartitioned(TIterator begin, TIterator end, TPredicate predFunc)
     
{
        
bool isPartioned = false;

while ((begin != end) && predFunc(*begin++));

if (begin == end)
        
{
           
return true;
        
}

while ((begin != end) && !predFunc(*begin++));

if (begin == end)
        
{
           
return true;
        
}

return false;
     
}

template <typename TIterator, typename T>
     
void Itoa(TIterator begin, TIterator end, T value)
     
{
        
while (begin != end)
        
{
           
*begin = value++;
           
++begin;
        
}
     
}

template <template<typename, typename> class TContainer,
        
typename TInType,
        
typename TOutType,
        
typename TConverter>
        
TContainer<TOutType, std::allocator<TOutType>>
        
ConvertAll(const TContainer<TInType, std::allocator<TInType>>& src, TConverter convFunc)
     
{
        
typedef typename TContainer<TInType, std::allocator<TInType>> SourceContainer;
        
typedef typename TContainer<TOutType, std::allocator<TOutType>> TargetContainer;

typename SourceContainer::const_iterator iter = src.begin();
        
TargetContainer target;

while (src.end() != iter)
        
{
           
TOutType outValue = convFunc(*iter);
           
target.push_back(outValue);
           
++iter;
        
}

return target;
     
}

// This method will convert a string to type T.
     
// NOTE: T is intended for numeric conversions.
     
template <typename T> bool FromString(const String& text,
        
T& tObj,
        
std::ios\_base& (*pfn)(std::ios\_base&) = std::dec)
     
{

StringStream tstr(text);
        
return !(tstr >> pfn >> tObj).fail();
     
}

template <typename T> String ToString(const T& t)
     
{
        
static OStringStream ostr;
        
ostr.str(String());

ostr << t;
        
return ostr.str();
     
}

template <typename TContainer>
     
String ToString(const TContainer& tcont,
        
const String& delimiter = _T("\r\n"),
        
const String& prefix = _T(""),
        
const String& suffix = _T(""))
     
{
        
typedef typename TContainer::const_iterator TContainerConstIter;

static OStringStream ostr;
        
ostr.str(String());

ostr << prefix.c_str();

for (TContainerConstIter iter = tcont.begin(); iter != tcont.end(); ++iter)
        
{
           
ostr << *iter << delimiter.c_str();
        
}

ostr << suffix.c_str();

return ostr.str();
     
}

String TrimStart(const String& inString, const String& trimChars = _TXT(" \t"))
     
{
        
if (inString.empty())
        
{
           
return inString;
        
}

size\_t posLeft = inString.find\_first\_not\_of(trimChars, 0);
        
return inString.substr(posLeft, inString.length() &#8211; posLeft);
     
}

String TrimEnd(const String& inString, const String& trimChars = _TXT(" \t"))
     
{
        
if (inString.empty())
        
{
           
return inString;
        
}

size\_t posRight = inString.find\_last\_not\_of(trimChars);
        
return inString.substr(0, posRight + 1);
     
}

String Trim(const String& inString, const String& trimChars = _TXT(" \t"))
     
{
        
if (inString.empty())
        
{
           
return inString;
        
}

size\_t posLeft = inString.find\_first\_not\_of(trimChars, 0);
        
size\_t posRight = inString.find\_last\_not\_of(trimChars);

return inString.substr(posLeft, posRight &#8211; posLeft + 1);
     
}

namespace Functors
     
{
        
template<typename T>
        
class IsNegative
        
{
        
public: bool operator()(const T& value) const
                
{
                   
return (value < 0);
                
}
        
};

template<typename TIn, typename TOut>
        
class staticCast
        
{
        
public: virtual TOut operator()(const TIn& tin)
                
{
                   
return static_cast<TOut>(tin);
                
}
        
};

template <typename T>
        
class StringCast
        
{
        
public: String operator()(T value)
                
{
                   
return stdext::ToString(value);
                
}
        
};

template<typename TIn, typename TOut>
        
class ReinterpretCast
        
{
        
public: virtual TOut operator()(TIn& tin)
                
{
                   
return reinterpret_cast<TOut>(tin);
                
}
        
};

template<typename TIn, typename TOut>
        
class DynamicCast
        
{
        
public: virtual TOut\* operator()(TIn\* tin)
                
{
                   
return dynamic_cast<TOut*>(tin);
                
}
        
};
     
}

int TStrLen(const TCHAR* pszString)
     
{
        
if (NULL == pszString)
        
{
           
return 0;
        
}

int length = 0;
        
while ('' != *pszString)
        
{
           
++length;
           
++pszString;
        
}

return length;
     
}
  
}
  
[/code]