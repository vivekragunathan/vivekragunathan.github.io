---
title: Simple Array Class For C++
author: vivekragunathan
layout: post
date: 2009-04-10T16:48:00+00:00
url: /2009/04/10/simple-array-class-for-c/
categories:
  - C++
  - CodeProject
  - Uncategorized

---

This is a simple array like class for C++, which can be used as a safe wrapper for accessing a block of memory pointed by a bare pointer.

```cpp
#pragma once

template class Array
{
private: T* _tPtr;
private: size_t _length;
private: bool _isOwner;

public: Array(size_t length, bool isOwner = true)
           : _isOwner(isOwner)
        {
           _length = length;
           _tPtr = new T[length];
        }

public: Array(T* tPtr, size_t numItems, bool isOwner = true)
           : _isOwner(isOwner)
        {
           if (NULL == tPtr)
           {
              throw std::exception("Specified T* pointer is NULL.");
           }

           this-&gt;_length = numItems;
           this-&gt;_tPtr = tPtr;
        }

public: template
        Array(const TSTLContainerType& stlContainer, bool isOwner) : _isOwner(isOwner)
        {
           _length = stlContainer.size();
           _tPtr = new T[_length];

           int index = 0;
           for (TSTLContainerType::const_iterator iter = stlContainer.begin();
              iter != stlContainer.end();
              ++iter, ++index)
           {
              _tPtr[index] = *iter;
           }
        }

public: ~Array()
        {
           if (IsOwner())
           {
              delete _tPtr;
           }
        }

public: T& operator[](size_t index) const
        {
           return GetItem(index);
        }

public: T& operator[](int index) const
        {
           return GetItem(static_cast(index));
        }

        // Gets a copy of the value at the specified index
public: T GetValue(size_t index)
        {
           return GetItem(index);
        }

public: operator T* const() const
        {
           return _tPtr;
        }

public: T* const Get() const
        {
           return _tPtr;
        }

public: operator const T* const()
        {
           return _tPtr;
        }

public: int Length() const
        {
           return static_cast(this-&gt;_length);
        }

public: int Size() const
        {
           return _length * typeof(T);
        }

public: bool IsOwner() const
        {
           return this-&gt;_isOwner;
        }

public: void CopyTo(T* tPtr, size_t copySize)
        {
           memcpy(tPtr, this-&gt;_tPtr, copySize);
        }

        // Gets a reference to the item (T) at the specified index
private: T& GetItem(size_t index) const
         {
            const size_t length = static_cast(Length());
            if  (index &gt; length)
            {
               throw std::exception("Index out of bounds");
            }

            return _tPtr[index];
         }
};
```

This class is also available at [KenBase](http://sites.google.com/site/kenbase/cpp/cpparray).

Disclaimer: It is not aimed to replace the STL containers.
