---
title: Serialization and Exceptions !!!
author: vivekragunathan
layout: post
date: 2006-04-15T00:23:00+00:00
url: /2006/04/15/serialization-and-exceptions/
categories:
  - Uncategorized
---

I am just like Alice in Wonderland, and not yet got out of the wonders of the .NET framework, C# and the VS 2003(5) IDE. I thought that the serialization is all not my thing until I do something big in C#. I had written this custom exception class in my project that has 3 processes connected by .NET Remoting Infrastructure. I throw my custom exception for a scenario but all I got was some other exception:

```
The constructor to deserialize an object of type MyException was not found
```

Note I had the `Serializable` attribute tagged to my custom `Exception` class.

Let me to get to the point. Even though you attach the `Serializable` attribute to your custom exception class, the base class Exception implements the `ISerializable` interface and the constructor required during the deserialization [`Exception()`] is protected. So when you throw MyException, it may get serialized and cross the remoting boundaries but on the client side, it will not able to deserialize because the required ctor is not accessible. So, what we do is simple as shown in the following code:-

```csharp
[Serializable]
public class MyException : ApplicationException
{
    // Member Data

    // Other necessary ctors

   /// &lt;summary>
   /// Let us call this ctor as Deserializing Ctor [DSCTOR]
   /// &lt;/summary>
   public MyException(SerializationInfo info, StreamingContext context)
       : base(info, context)
   {
       // Any other custom data to be transferred
       // info.AddValue(CustomDataName, DataValue);
   }

   /// &lt;summary>
   /// If any custom information needs to be transferred
   /// with the MyException thrown, it must be added to the
   /// SerializationInfo object on the call to
   /// GetObjectData() and to take them from this object in
   /// the constructor for deserialization.
   /// &lt;/summary>
   public override void GetObjectData(SerializationInfo info, StreamingContext context)
   {
       base.GetObjectData(info, context);
       // Any other custom data to be transferred
       // info.AddValue(CustomDataName, DataValue);
   }

   // Other methods
}
```

This DSCTOR is very much necessary, else the exception thrown will not be caught as the one thrown and you will get the following exception:

```
The constructor to deserialize an object of type MyException was not found
```

If any custom data needs to be transferred with the `MyException` thrown, it must be added to the `SerializationInfo` object on the call to `GetObjectData()` and to take them from this object in this secondary [deserialization] constructor.
