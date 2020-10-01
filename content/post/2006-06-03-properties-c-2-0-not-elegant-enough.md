---
title: 'Properties C# 2.0 – Not Elegant Enough !!!'
author: vivekragunathan
layout: post
date: 2006-06-03T06:59:00+00:00
url: /2006/06/03/properties-c-2-0-not-elegant-enough/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 114931804494891028
categories:
  - CodeProject
  - Uncategorized

---
<span style="font-family:Georgia;font-size:100%;">Prior to .NET 2.0, there wasn&#8217;t the facility in C# to opt the visibility level for the get and set property or indexers. And i take my comment in </span><span style="font-family:Georgia;font-size:100%;"><a href="http://developerexperience.blogspot.com/2006/04/properties-in-cclithe-c-look-alike.html">my previous post</a></span><span style="font-size:100%;"><span style="font-family:Georgia;"> that C# does not provide the facility of having different visibility levels for the get and set accessors. While that is partly correct, it is no more in C# 2.0.</p> 

<p>
  And obviously it isn&#8217;t in the easy and elegant way. Take a look at this code snippet:-</span><br /></span>
</p>

<pre><span style="font-family:Courier New;font-size:100%;">public bool LogToStdError<br />{<br />get<br />{<br />   return _log2StdError;<br />}<br />protected set<br />{<br />   _log2StdError = value;<br />}<br />}<br /></span></pre>

<p>
  <span style="font-size:100%;"><span style="font-family:Georgia;">I do not have to explain the code except there are some restrictions while having different visibility levels for the get/set accessors of a property.</p> 
  
  <p>
    1. You can provide an explicit visibility either for get or set. Hence the following code will throw an error:-
  </p>
  
  <p>
    </span><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">public bool LogToStdError</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">{</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> protected get</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> return _log2StdError;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> protected set</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> _log2StdError = value;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">}</span><br /></span><span style="font-size:100%;"><br /><span style="font-family:Georgia;">2. The visibility thus explicitly specified must be a subset [restrictive than] of the property declaration.<br />For example, if the property declaration is protected, then the get/set accessor cannot be like say public. So the following code throws an error:-</span></p> 
    
    <p>
      <span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">protected bool LogToStdError</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">{</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> get</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> return _log2StdError;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> public set</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> _log2StdError = value;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">}</span>
    </p>
    
    <p>
      </span><span style="font-size:100%;"><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"></span><span style="font-family:Georgia;">I feel that these restrictions are stupid, and this resulted because of the syntax. I just thought of some ideas for a bit elegant syntax for the property definition.</p> 
      
      <p>
        1. The get and set accessors individually have to specify the visibility level.
      </p>
      
      <p>
        </span><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">bool LogToStdError</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">{</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> public get</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> return _log2StdError;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> property set</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> _log2StdError = value;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">}</span>
      </p>
      
      <p>
        </span><span style="font-size:100%;"><span style="font-family:Georgia;">2. The property declaration syntax must not bear any visibility level unless the associated get/set accessors do not bear any. For example, in the property definition below, the get/set accessors are public:-</span></p> 
        
        <p>
          <span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"></span><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">public bool LogToStdError</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">{</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> get</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> return _log2StdError;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> set</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> _log2StdError = value;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">}</span>
        </p>
        
        <p>
          </span><span style="font-size:100%;"><span style="font-family:Georgia;">and as per this property definition, the get/set accessors are protected:-</span></p> 
          
          <p>
            <span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">protected bool LogToStdError</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">{</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> get</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> return _log2StdError;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> set</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> _log2StdError = value;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">}</span><br /></span><span style="font-size:100%;"><br /><span style="font-family:Georgia;">3. If there are visibility levels specified neither in the property definition nor in the accessors, then the default visibility level as specified for C# [I guess internal] will be applied for the property accessors. Hence the get/set accessors are internal for the following property:-<br /></span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">bool LogToStdError</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">{</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> get</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> return _log2StdError;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> set</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> {</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> _log2StdError = value;</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;"> }</span><br /><span style="color:rgb(0,0,255);font-family:Courier New,Courier,Monospace;">}</span><br /></span>
          </p>