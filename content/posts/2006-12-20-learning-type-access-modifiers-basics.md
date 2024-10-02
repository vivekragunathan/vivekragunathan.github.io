---
title: Learning Type Access Modifiers Basics
author: HKT
layout: post
date: 2006-12-20T18:01:00+00:00
url: /2006/12/20/learning-type-access-modifiers-basics/
categories:
  - CodeProject
  - Uncategorized

---

When I started developing my module, I had an interface IParamCountBasedAlgo declared as a nested type in a class AlgorithmOneExecutor, declared as follows:-

```csharp
namespace DataStructuresAndAlgo
{
   partial class AlgorithmOneExecutor
   {
      private interface IParamCountBasedAlgo
      {
         void Validate();
         void Execute();
      }
   }
}
```

<!--more-->

There were other concrete nested types inside AlgorithmOneExecutor that implemented IParamCountBasedAlgo. But later, other types nested in other than AlgorithmOneExecutor emerged that required to implement IParamCountBasedAlgo. So I moved IParamCountBasedAlgo from a nested type to a direct type under the namespace DataStructuresAndAlgo, as declared below:-

```csharp
namespace DataStructuresAndAlgo
{
 private interface IParamCountBasedAlgo
 {
   void Validate();
   void Execute();
 }
}
```

And the compiler spat an error “Namespace elements cannot be explicitly declared as private, protected, or protected internal“. Then a simple research gave me an insight that types directly under namespace can be declared either public or internal only, and the default is internal. Seems reasonable cuz if declared private, it gives an ambiguous look that it cannot accessed or created and protected seems rather very unrelated. Hence either public or internal only.

A subtle point to note is that not all access modifiers are applicable for all types and at all declaration levels. To learn the basics of type access modifiers, visit [http://msdn2.microsoft.com/en-us/library/ms173121.aspx](http://msdn2.microsoft.com/en-us/library/ms173121.aspx)
