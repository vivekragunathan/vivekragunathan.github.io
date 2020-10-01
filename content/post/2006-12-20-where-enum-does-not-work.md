---
title: where enum does not work !!!
author: vivekragunathan
layout: post
date: 2006-12-20T12:25:00+00:00
url: /2006/12/20/where-enum-does-not-work/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 116663756731164677
categories:
  - .NET
  - 'C#'
  - CodeProject
  - Uncategorized

---
<div style="font-family:Open Sans, Tahoma;font-size:14px;">
  I was writing a <a href="http://msdn2.microsoft.com/en-us/library/0x6a29h6.aspx">generic</a> method with enum as the <a href="http://msdn2.microsoft.com/en-us/library/d5x73970.aspx">Constraint</a>, and the compiler spat a few errors that did not directly convey me that enums cannot used as generic constraints. And I learnt the following from my investigation:</p> 
  
  <p>
    <strong>C# language specification for generic constraints</strong>
  </p>
  
  <p>
    A class-type constraint shall satisfy the following rules:
  </p>
  
  <ul>
    <li>
      The type shall be a class type.
    </li>
    <li>
      The type shall not be sealed.
    </li>
    <li>
      The type shall not be one of the following: types: <code>System.Array</code>, <code>System.Delegate</code>, <code>System.Enum</code> or <code>System.ValueType</code>.
    </li>
    <li>
      The type shall not the <code>&lt;strong>object&lt;/strong></code>. [Note: Since all types, derive from <code>&lt;strong>object&lt;/strong></code> such a constraint would have no effect if it were permitted, end note]
    </li>
    <li>
      At most one constraint for a given type parameter can be a class type.
    </li>
  </ul>
  
  <p>
    A type specified as an interface-type constraint shall satisfy the following rules:
  </p>
  
  <ul>
    <li>
      The type shall be an interface type.
    </li>
  </ul>
  
  <p>
    This is an excerpt from the <a href="http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-334.pdf">C# Language Specification</a>. Enums are value types and there is no way that you can specify the System.ValueType as a constraint, as per the specification. But if you wish to specify a non-reference type as a [primary] constraint, struct can be used.
  </p>
  
  <pre style="color:#008080;font-size:14px;font-family:Consolas, Courier New, Courier, Monospace;">private void Method where T : struct</pre>
  
  <p>
    During the course of investigation, I was surprised (my bad!) to know that the numeric types like int, float etc in C# are declared struct. It is not far from the fact that they are value types, but it was interesting to know that they are declared as:
  </p>
  
  <p>
    <code>public struct Int32 : IComparable, IFormattable, IConvertible, IComparable, IEquatable</code>
  </p>
  
  <p>
    Similar thing for other numeric types. Whereas an enum [<a href="http://msdn2.microsoft.com/en-us/library/system.enum.aspx">System.Enum]</a>, though a value type, is declared as an abstract class that derives from System.ValueTypes unlike the int or float. The end result is that enums are value types but i wonder the way they are declared.
  </p>
  
  <p>
    Anyway, the question still remains unresolved &#8211; why enums cannot be used as constraints, and just the specification saying that enums cannot be used as constraints does not seem satisfactory.
  </p>
  
  <div>
    I am not sure if there is any other way to resolve my situation. Question open to cyber space !!!</p> 
    
    <blockquote>
      <p>
        P.S. Refer section 25.7 through for the specification on Generic Type Constraints.
      </p>
    </blockquote>
  </div>
</div>