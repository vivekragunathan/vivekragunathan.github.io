---
title: 'Offering __FILE__ and __LINE__ for C# !!!'
author: vivekragunathan
layout: post
date: 2012-09-08T18:30:40+00:00
url: /2012/09/09/caller_info_in_cs/
categories:
  - .NET
  - 'C#'
  - Uncategorized

---
<p style="font-family:Tahoma;font-size:11pt;">
  Not the same way but we could say better.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  Visual Studio 2012, another power packed release of Visual Studio, among a lot of other powerful fancy language features, offers the ability to deduce the method caller details at compile time.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  C++ offered the compiler defined macros <span style="font-family:Consolas;font-size:11pt;">__FILE__</span> and <span style="font-family:Consolas;font-size:11pt;">__LINE__</span> (and __DATE__ and __TIME__), which are primarily intended for diagnostic purposes in a program, whereby the caller information is captured and logged. For instance, using <span style="font-family:Consolas;font-size:11pt;">__LINE__</span> would be replaced with the exact line number in the file where this macro has been used. That sometimes beats the purpose and doesn&#8217;t gives us what we actually expect. Let&#8217;s see.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  For instance, suppose you wish to write a verbose Log method with an idea to print rich diagnostic details, it would look something like this.
</p>

<pre style="font-family:Consolas;font-size:11pt;">void LogException(const std::string& logText,
                  const std::string& fileName,
                  int lineNumber)
{
   cout &lt;&lt; "[" &lt;&lt; fileName.c_str() &lt;&lt; " (" &lt;&lt; lineNumber &lt;&lt; ")]: " &lt;&lt; logText.c_str() &lt;&lt; std::endl;
}</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  Although it solves the purpose, it is not really developer friendly. You&#8217;ll have to explicitly pass the __FILE__ and __LINE__ parameters while calling the Log method. This results in these macros being scattered all over the files. What if there was a way to avoid passing these parameters explicitly. Yeah, you could make them default parameters &#8211; <span style="font-family:Consolas;font-size:11pt;">const std::string& fileName = __FILE__, int lineNumber = __LINE__</span>. However, the funny thing that happens is they are replaced with the line numbers of the parameters where they appear in the Log method declaration. Not only that, there is no macro for getting the method name. Any C++ developer would have experienced this difficulty.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  C# does not offer the caller information facility directly but developers until now have been resorting to reflection. Although reflection help achieve what is required, it is not quite beautiful in the eyes of a developer. It requires a boring boiler plate code, and requires explicit use of some method call that deduces the caller information. Above all it is not something provided by the compiler itself for use during compile time, which means deducing the line number would not work, since reflection is totally a runtime thing. It also hurts performance (especially in the cases like logging).
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  Come Visual Studio 2012 (with C# 5.0), developers get the compile time facility to deduce caller information. This is different in two ways from what we have seen in C++. First, we are not going to use macros; we are going to use attributes. Second, we are going to do something at the place (in the method) where the caller information is required rather than at the place of method invocation as in C++. Let us see in action.
</p>

<pre style="font-family:Consolas;font-size:11pt;">using System.Runtime.CompilerServices;

void Log(string logText,
        [CallerFileName] string fileName = "",
        [CallerMemberName] string methodName = "",
        [CallerLineName] int lineNumber = 0)
{
   string fmtLogText = string.Format("[{0} ({1})] {2}: {3}",
          fileName,
          lineNumber,
          methodName,
          logText);

   Trace.WriteLine(fmtLogText);
}</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  If you see, there are <span style="font-family:Consolas;font-size:11pt;">CallerXXXName</span> attributes that the parameters have been decorated with, and they are made optional arguments. The compiler sees these attributes, and identifies that the method expects the caller information and takes the responsibility of silently passing them itself. Since the parameters are made optional, you don&#8217;t have to explicitly mention the caller information in any way. The call sites thus are not littered with the caller information. It is transparent and clean. So you would just say <span style="font-family:Consolas;font-size:11pt;">Log(&#8220;some log message&#8221;)</span> and the Log method gets the information of the calling method. As you see, the C# folks cleverly inverted the model used in C++. Besides, if you see that the caller method name attribute is named <span style="font-family:Consolas;font-size:11pt;">CallerMemberName</span>. It is for a reason. Let us see it in the light of its application.
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  It is common that the caller information is employed for logging in most applications. But there is one other application of the caller information that I love, and solves the problem in an elegant way. It is in WPF for property changed event. Until before caller information attributes, this too was patched using reflection.
</p>

<pre style="font-family:Consolas;font-size:11pt;">public class SomeModel : INotifyPropertyChanged
{
   // SomeModel ctor and other members

   public event PropertyChangedEventHandler PropertyChanged;

   public string SomeProperty
   {
      get
      {
         return this.someProperty;
      }
      set
      {
         this.someProperty = value;
         NotifyPropertyChanged();
      }
   }

   private void NotifyPropertyChanged([CallerMemberName] String propertyWhichChanged  = "")
   {
      if (PropertyChanged != null)
      {
         PropertyChanged(this, new PropertyChangedEventArgs(propertyWhichChanged));
      }
   }
}</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  Caller could be a method, property or event. Hence the attribute has been named <span style="font-family:Consolas;font-size:11pt;">CallerMemberName</span>. The compiler silently passes the property (caller) name at the place of invocation. The story does not end there. Although this feature has been introduced in C# 5.0/.NET 4.5, it supports multi-targeting too. That means when you use the C# 5.0 compiler for compiling against the older versions of the .NET framework, you can still make it work by defining the caller info attributes in the right namespace (System.Runtime.CompilerServices). The compiler expects the presence of the attributes and picks it up for processing by passing the caller information to the concerned method. Developers, happy?
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  There are other powerful features in C# 5.0 like async-await. However, the caller information attributes, despite being a miniature, holds its share.
</p>