---
title: Overloading - A Matter Of Taste !!!
author: vivekragunathan
layout: post
date: 2006-12-20T12:21:00+00:00
url: /2006/12/20/overloading-a-matter-of-taste/
categories:
  - .NET
  - 'C#'
  - CodeProject
  - Uncategorized

---
<a href="http://blogs.wdevs.com/mattdoig/archive/2006/08/20/14222.aspx#14244">This</a> was a pretty interesting discussion about method overloading in the managed world. As the discussion says that the overloading is a matter of taste. It seems that the method overloading in the managed world, indeed, is a matter of taste. Sad BUT True !!! But on the contrary, it must have been a [strict] rule. Overloading might be exhibited differently by each language in the unmanaged world. But as far as .NET goes, it must have been made a standard specification. Pardon me, if there is one.

As far traditional C++ goes, the overloaded method resolution starts from the derived but does not have strict type checking eg. for numeric types]. And the point to note is that only the method in the derived class with the exact prototype as the base is considered the overload. Of course, C++ is not as much type safe as C#. This is taken care in C# by the override keyword which allows only the exact prototypes to be involved in overloading. And at times explicit casting is required unlike in C++.

But in the case of C#, the first principle observed in overloading is to avoid it. Pretty confusing, huh? Take a look at the example below:-

```csharp
namespace Samples.MyConsole
{
   class Parent
   {
       public void Foo()
       {
           Console.WriteLine("Parent.Foo");
       }
   }

   class Child : Parent
   {
       public void Bar()
       {
           Console.WriteLine("Child.Bar");
       }
   }

   class Base
   {
       public virtual void XYZ(Child c)
       {
           c.Foo();
           c.Bar();
       }
   }

   class Derived : Base
   {
       public virtual void XYZ(Parent p)
       {
           p.Foo();
       }

       public override void XYZ(Child c)
       {
           base.XYZ(c);
       }
   }

   class User
   {
       public static void SomeMethod()
       {
           Child c = new Child();
           Parent p = c as Parent;

           Derived d = new Derived();
           Base b = d as Base;

           Console.WriteLine("Playing with Derived");
           d.XYZ(c);
           d.XYZ(p);

           Console.WriteLine("\nPlaying with Base");
           b.XYZ(c);
           b.XYZ(p as Child);
       }
   }
}
```

Here is the output at the console:-

```bash
Playing with Derived
Parent.Foo
Parent.Foo
Playing with Base
Parent.Foo
Child.Bar
Parent.Foo
Child.Bar
```

You would have guessed the surprise that you are about to experience. Yes, d.XYZ(c) calls the Derived.XYZ(Parent p), and not the Derived.XYZ(Child c) which is a better match. It does if it had been defined as public new void XYZ(Child c). But same is not the case with C++. It gives us no surprise.

As far as C++/CLI is concerned, it behaves as traditional C++.

So the intriguing bitter part is that the overloading in the managed world is not a thing at the CLR level nor does it seem to be something concerned with the specification. It seems to be a matter of taste.
