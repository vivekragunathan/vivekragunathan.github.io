---
title: Overloading……A Matter Of Taste !!!
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
<div id="msgcns!753E720D857C98F6!207">
  <span style="font-size:85%;"><span style="font-family:georgia;font-size:100%;"><a href="http://blogs.wdevs.com/mattdoig/archive/2006/08/20/14222.aspx#14244">This</a> was a pretty interesting discussion about method overloading in the managed world. As the discussion says that the overloading is a matter of taste. It seems that the method overloading in the managed world, indeed, is a matter of taste. Sad BUT True !!! But on the contrary, it must have been a [strict] rule. Overloading might be exhibited differently by each language in the unmanaged world. But as far as .NET goes, it must have been made a standard specification. Pardon me, if there is one.</p>

  <p>
    As it was pointed out in the discussion, how do we define the behaviour in the case where we derive classes across assemblies developed in another .NET language ?
  </p>

  <p>
    As far traditional C++ goes, the overloaded method resolution starts from the derived but does not have strict type checking eg. for numeric types]. And the point to note is that only the method in the derived class with the exact prototype as the base is considered the overload. Ofcourse, C++ is not as much type safe as C#. This is taken care in C# by the override keyword which allows only the exact prototypes to be involved in overloading. And at times explicit casting is required unlike in C++.
  </p>

  <p>
    But in the case of C#, the first principle observed in overloading is to avoid it. Pretty confusing, huh? Take a look at the example below:-</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"></p>

    <pre><br />namespace Samples.MyConsole<br />{<br />   class Parent<br />   {<br />       public void Foo()<br />       {<br />           Console.WriteLine("Parent.Foo");<br />       }<br />   }<br /><br />   class Child : Parent<br />   {<br />       public void Bar()<br />       {<br />           Console.WriteLine("Child.Bar");<br />       }<br />   }<br /><br />   class Base<br />   {<br />       public virtual void XYZ(Child c)<br />       {<br />           c.Foo();<br />           c.Bar();<br />       }<br />   }<br /><br />   class Derived : Base<br />   {<br />       public virtual void XYZ(Parent p)<br />       {<br />           p.Foo();<br />       }<br /><br />       public override void XYZ(Child c)<br />       {<br />           base.XYZ(c);<br />       }<br />   }<br /><br />   class User<br />   {<br />       public static void SomeMethod()<br />       {<br />           Child c = new Child();<br />           Parent p = c as Parent;<br /><br />           Derived d = new Derived();<br />           Base b = d as Base;<br /><br />           Console.WriteLine("Playing with Derived");<br />           d.XYZ(c);<br />           d.XYZ(p);<br /><br />           Console.WriteLine("\nPlaying with Base");<br />           b.XYZ(c);<br />           b.XYZ(p as Child);<br />       }<br />   }<br />}<br /></pre>

    <p>
      </span><br />Here is the output at the console:-
    </p>

    <p>
      <span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Playing with Derived</span><br /><span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Parent.Foo</span><br /><span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Parent.Foo</span>
    </p>

    <p>
      <span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Playing with Base</span><br /><span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Parent.Foo</span><br /><span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Child.Bar</span><br /><span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Parent.Foo</span><br /><span style="font-weight:bold;font-family:Courier New,Courier,Monospace;">Child.Bar</span>
    </p>

    <p>
      <span style="font-size:100%;">You would have guessed the surprise that you are about to experience. Yes, d.XYZ(c) calls the Derived.XYZ(Parent p), and not the Derived.XYZ(Child c) which is a better match. It does if it had been defined as public new void XYZ(Child c). But same is not the case with C++. It gives us no suprise.</p>

      <p>
        And as far as C++/CLI is concerned, it behaves as traditional C++.
      </p>

      <p>
        So the intriguing bitter part is that the overloading in the managed world is not a thing at the CLR level nor does it seem to be something concerned with the specification. It seems to be a matter of taste.</span></span></div>

        <p>
          <span style="font-size:100%;"> </span>
        </p>
