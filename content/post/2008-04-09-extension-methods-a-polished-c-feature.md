---
title: Extension Methods – A Polished C++ Feature !!!
author: vivekragunathan
layout: post
date: 2008-04-09T06:31:39+00:00
url: /2008/04/09/extension-methods-a-polished-c-feature/
categories:
  - .NET
  - 'C#'
  - C++
  - Programming
  - Uncategorized
tags:
  - 'C#'
  - extension methods
  - interface principle
  - koenig lookup

---
<div>
  <p>
    Extension Methods is an excellent feature in C# 3.0. It is a mechanism by which new methods can be exposed from an existing type (interface or class) without directly adding the method to the type. Why do we need extension methods anyway ? Ok, that is the big story of lamba and LINQ. But from a conceptual standpoint, the extension methods establish a mechanism to extend the public interface of a type. The compiler is smart enough to make the method a part of the public interface of the type. Yeah, that is what it does, and the intellisense is very cool in making us believe that. It is cleaner and easier (for the library developers and for us programmers even) to add extra functionality (methods) not provided in the type. That is the intent. And we know that was exercised extravagantly in LINQ. The IEnumerable was extended with a whole lot set of methods to aid the LINQ design. Remember the <code>Where</code>, <code>Select</code> etc methods on <code>IEnumerable</code>. An example code snippet is worth a thousand words:-
  </p>
  
  <p>
    [code language=&#8221;cpp&#8221;]static class StringExtensions<br /> {<br /> ///<br /> /// &#8216;this&#8217; decorator signifies that this is an extension method.<br /> /// It must be appear only on a public static method.<br /> /// Such a method is added to the public interface of the type following<br /> /// the &#8216;this&#8217; decorator.<br /> ///<br /> public static int ToInteger(this string s)<br /> {<br /> return Convert.ToInt32(s);<br /> }
  </p>
  
  <p>
    public static string Left(this string s, int position)<br /> {<br /> return s.Substring(0,position);<br /> }
  </p>
  
  <p>
    public static string Right(this string s, int position)<br /> {<br /> return s.Substring(s.Length &#8211; position);<br /> }<br /> }[/code]
  </p>
  
  <p>
    You might be aware of all this hot news. But our topic of the day is neither Extension Methods nor LINQ. It is something that dates back to C++. And you will see at the end of this post that extension methods are a polished version of a C++ principle. Ok, let us try to read some code:-
  </p>
  
  <p>
    [code language=&#8221;cpp&#8221;]int Add(SomeClass& sc, int x)<br /> {<br /> // Let us get to here a little later.<br /> }
  </p>
  
  <p>
    class SomeClass<br /> {<br /> private: int m_nNum;<br /> public: void SomeMethod(int n);<br /> public: int Num const<br /> {<br /> return this->m_nNum;<br /> }<br /> };[/code]
  </p>
  
  <p>
    The code is simple &#8211; We have a class called SomeClass and a global function. The global function takes a SomeClass instance by reference and an integer by value. The intent of the function is to add x with m_nNum. But whether to save it to m_nNum or just return is a topic we will deal in a little while. But do we understand that the Add function and SomeClass are closely related ?
  </p>
  
  <p>
    There are two principles to know in C++ to understand the relation.
  </p>
  
  <p>
    <strong>Interface Principle</strong>
  </p>
  
  <p>
    For a class X, all functions, including free functions, that both (a) &#8220;mention&#8221; X, and (b) are &#8220;supplied with&#8221; X are logically part of X, because they form part of the interface of X.
  </p>
  
  <p>
    <i>* Supplied with X means that the function is provided (distributed with) in the same header file as X.</i>
  </p>
  
  <p>
    So now, Add mentions SomeClass and (to keep the discussion short assume that it) is supplied with SomeClass. If that, then Add is a part of the public interface of X. That should convince you.
  </p>
  
  <p>
    <strong>Koenig Lookup</strong>
  </p>
  
  <p>
    When an unqualified name is used as the postfix-expression in a function call, other namespaces not considered during the usual unqualified lookup may be searched, and namespace-scope friend function declarations not otherwise visible may be found. These modifications to the search depend on the types of the arguments. Those are lines from the C++ standard and must be tough to understand like the verses in the Bible. So let us talk our language to understand that:
  </p>
  
  <p>
    [code language=&#8221;cpp&#8221;]namespace CPP<br /> {<br /> class SomeClass { };<br /> void Foo(SomeClass);<br /> }
  </p>
  
  <p>
    CPP::SomeClass sc;
  </p>
  
  <p>
    void main()<br /> {<br /> Foo(sc);<br /> }[/code]
  </p>
  
  <p>
    Will you be still surprised that Foo(sc) call will link to the CPP::Foo ? Don&#8217;t be. That is what the cryptic lines above talks about. Ok, one more example:
  </p>
  
  <p>
    [code language=&#8221;cpp&#8221;]namespace CPP<br /> {<br /> class SomeClass { };<br /> }
  </p>
  
  <p>
    void Foo(CPP::SomeClass);
  </p>
  
  <p>
    void main()<br /> {<br /> CPP::SomeClass sc;<br /> Foo(sc); // Got it ?<br /> }[/code]
  </p>
  
  <p>
    So now down to my point, Extension Methods is a polished version of the Interface Principle (or Koenig Lookup) in C++. The facility has been in C++ for a long time but not sure if exercised well (and wisely). Had the intellisense been intelligent enough, C++ would claimed it a mighty feature. Since the C++ IDE has been the same sucking way for a long time now, C++ got the wrong outlook &#8211; a hard programming language.
  </p>
  
  <p>
    Hey C#, No hard feelings. It is just a perspective. Either way, <b>My compiler compiles your compiler</b>.
  </p>
</div>