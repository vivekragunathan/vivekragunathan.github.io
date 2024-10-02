---
title: Properties C# 2.0 – Not Elegant Enough
author: HKT
layout: post
date: 2006-06-03T06:59:00+00:00
url: /posts/cs-props-elegance
aliases: /2006/06/03/properties-c-2-0-not-elegant-enough/
categories:
  - CodeProject
  - Uncategorized

---

Prior to .NET 2.0, there wasn't the facility in C# to opt the visibility level for the get and set property or indexers. And i take my comment in [my previous post](/posts/ccli-props-cs-look-alike) that C# does not provide the facility of having different visibility levels for the get and set accessors. While that is partly correct, it is no more in C# 2.0.

And obviously it isn’t in the easy and elegant way. Take a look at this code snippet:-

```csharp
public bool LogToStdError
{
  get
  {
    return _log2StdError;
  }
  protected set
  {
    _log2StdError = value;
  }
}
```

I do not have to explain the code except there are some restrictions while having different visibility levels for the get/set accessors of a property.

1. You can provide an explicit visibility either for get or set. Hence the following code will throw an error:-

```csharp
public bool LogToStdError
{
  protected get
  {
    return _log2StdError;
  }
  protected set
  {
    _log2StdError = value;
  }
}
```

2. The visibility thus explicitly specified must be a subset _restrictive than_ of the property declaration. For example, if the property declaration is protected, then the get/set accessor cannot be like say `public`. So the following code throws an error:-

```csharp
protected bool LogToStdError
{
  get
  {
    return _log2StdError;
  }
  public set
  {
    _log2StdError = value;
  }
}
```

I feel that these restrictions are stupid, and this resulted because of the syntax. I just thought of some ideas for a bit elegant syntax for the property definition.

1. The get and set accessors individually have to specify the visibility level.

```csharp
bool LogToStdError
{
  public get
  {
    return _log2StdError;
  }
  property set
  {
    _log2StdError = value;
  }
}
```

2. The property declaration syntax must not bear any visibility level unless the associated get/set accessors do not bear any. For example, in the property definition below, the get/set accessors are `public`:-

```csharp
public bool LogToStdError
{
  get
  {
    return _log2StdError;
  }
  set
  {
    _log2StdError = value;
  }
}
```

and as per this property definition, the get/set accessors are protected:-

```csharp
protected bool LogToStdError
{
  get
  {
    return _log2StdError;
  }
  set
  {
    _log2StdError = value;
  }
}
```

3. If there are visibility levels specified neither in the property definition nor in the accessors, then the default visibility level as specified for C# I guess `internal` will be applied for the property accessors. Hence the get/set accessors are internal for the following property:-

```csharp
bool LogToStdError
{
  get
  {
    return _log2StdError;
  }
  set
  {
    _log2StdError = value;
  }
}
```
