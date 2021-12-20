---
title: Learning Type Access Modifiers Basics !!!
author: vivekragunathan
layout: post
date: 2006-12-20T18:01:00+00:00
url: /2006/12/20/learning-type-access-modifiers-basics/
categories:
  - CodeProject
  - Uncategorized

---
<div id="msgcns!753E720D857C98F6!244">
  <p>
    <span style="font-size:100%;">When I started developing my module, I had an interface <span style="color:rgb(51,153,102);font-family:Courier New,Courier,Monospace;">IParamCountBasedAlgo</span> declared as a nested type in a class <span style="color:rgb(51,153,102);font-family:Courier New,Courier,Monospace;">AlgorithmOneExecutor</span>, declared as follows:-</span><span style="font-size:85%;"><br /></span>
  </p>

  <pre><span style="font-size:85%;"><span style="color:rgb(0,0,255);"></span></span><span style="font-size:100%;"><span style="color:rgb(0,0,255);"><span style="font-family:Courier New,Courier,Monospace;">namespace DataStructuresAndAlgo</span><br /><span style="font-family:Courier New,Courier,Monospace;">{</span><br /><span style="font-family:Courier New,Courier,Monospace;">   partial class AlgorithmOneExecutor</span><br /><span style="font-family:Courier New,Courier,Monospace;">   {</span><br /><span style="font-family:Courier New,Courier,Monospace;">      private interface IParamCountBasedAlgo</span><br /><span style="font-family:Courier New,Courier,Monospace;">      {</span><br /><span style="font-family:Courier New,Courier,Monospace;">         void Validate();</span><br /><span style="font-family:Courier New,Courier,Monospace;">         void Execute();</span><br /><span style="font-family:Courier New,Courier,Monospace;">      }</span><br /><span style="font-family:Courier New,Courier,Monospace;">   }</span><br /><span style="font-family:Courier New,Courier,Monospace;">}</span></span></span><span style="font-size:85%;"><span style="color:rgb(0,0,255);"></span></span></pre>

  <p>
    <span style="font-size:100%;">There were other concrete nested types inside <span style="color:rgb(51,153,102);font-family:Courier New;">AlgorithmOneExecutor </span>that implemented <span style="color:rgb(51,153,102);font-family:Courier New;">IParamCountBasedAlgo</span>. But later, other types nested in other than <span style="color:rgb(51,153,102);font-family:Courier New;">AlgorithmOneExecutor </span>emerged that required to implement <span style="color:rgb(51,153,102);font-family:Courier New;">IParamCountBasedAlgo</span>. So I moved <span style="color:rgb(51,153,102);font-family:Courier New;">IParamCountBasedAlgo </span>from a nested type to a direct type under the namespace <span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">DataStructuresAndAlgo</span>, as declared below:-</span>
  </p>

  <p>
    <span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"></p>

    <pre>namespace DataStructuresAndAlgo<br />{<br /> private interface IParamCountBasedAlgo<br /> {<br />   void Validate();<br />   void Execute();<br /> }<br />}<br /></pre>

    <p>
      </span>And the compiler spat an error &#8220;<span style="font-family:Courier New,Courier,Monospace;">Namespace elements cannot be explicitly declared as private, protected, or protected internal</span>&#8220;. Then a simple research gave me an insight that types directly under namespace can be declared either public or internal only, and the default is internal. Seems reasonable cuz if declared private, it gives an ambiguous look that it cannot accessed or created and protected seems rather very unrelated. Hence either public or internal only.
    </p>

    <p>
      A subtle point to note is that not all access modifiers are applicable for all types and at all declaration levels. To learn the basics of type access modifiers, visit <a href="http://msdn2.microsoft.com/en-us/library/ms173121.aspx">http://msdn2.microsoft.com/en-us/library/ms173121.aspx</a>
    </p></div>
