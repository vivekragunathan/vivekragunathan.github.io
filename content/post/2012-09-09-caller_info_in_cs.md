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
Not the same way but we could say better.

Visual Studio 2012, another power packed release of Visual Studio, among a lot of other powerful fancy language features, offers the ability to deduce the method caller details at compile time.

C++ offered the compiler defined macros FILE and LINE (and DATE and TIME), which are primarily intended for diagnostic purposes in a program, whereby the caller information is captured and logged. For instance, using LINE would be replaced with the exact line number in the file where this macro has been used. That sometimes beats the purpose and doesn’t gives us what we actually expect. Let’s see.

For instance, suppose you wish to write a verbose Log method with an idea to print rich diagnostic details, it would look something like this.

```
void LogException(
  const std::string& logText,
  const std::string& fileName,
  int lineNumber
)
{
   cout << "[" << fileName.c_str() << " (" << lineNumber << ")]: " << logText.c_str() << std::endl;
}
```

Although it solves the purpose, it is not really developer friendly. You’ll have to explicitly pass the `__FILE__` and `__LINE__` parameters while calling the Log method. This results in these macros being scattered all over the files. What if there was a way to avoid passing these parameters explicitly. Yeah, you could make them default parameters – `const std::string& fileName = __FILE__`, `int lineNumber = __LINE__`. However, the funny thing that happens is they are replaced with the line numbers of the parameters where they appear in the Log method declaration. Not only that, there is no macro for getting the method name. Any C++ developer would have experienced this difficulty.

C# does not offer the caller information facility directly but developers until now have been resorting to reflection. Although reflection help achieve what is required, it is not quite beautiful in the eyes of a developer. It requires a boring boiler plate code, and requires explicit use of some method call that deduces the caller information. Above all it is not something provided by the compiler itself for use during compile time, which means deducing the line number would not work, since reflection is totally a runtime thing. It also hurts performance (especially in the cases like logging).

Come Visual Studio 2012 (with C# 5.0), developers get the compile time facility to deduce caller information. This is different in two ways from what we have seen in C++. First, we are not going to use macros; we are going to use attributes. Second, we are going to do something at the place (in the method) where the caller information is required rather than at the place of method invocation as in C++. Let us see in action.

```csharp
using System.Runtime.CompilerServices;

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
}
```

If you see, there are CallerXXXName attributes that the parameters have been decorated with, and they are made optional arguments. The compiler sees these attributes, and identifies that the method expects the caller information and takes the responsibility of silently passing them itself. Since the parameters are made optional, you don’t have to explicitly mention the caller information in any way. The call sites thus are not littered with the caller information. It is transparent and clean. So, you would just say `Log(“some log message”)`, and the `Log` method gets the information of the calling method. As you see, the C# folks cleverly inverted the model used in C++. Besides, if you see that the caller method name attribute is named CallerMemberName. It is for a reason. Let us see it in the light of its application.

It is common that the caller information is employed for logging in most applications. But there is one other application of the caller information that I love, and solves the problem in an elegant way. It is in WPF for property changed event. Until before caller information attributes, this too was patched using reflection.

```csharp
public class SomeModel : INotifyPropertyChanged
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
}
```

Caller could be a method, property or event. Hence the attribute has been named CallerMemberName. The compiler silently passes the property (caller) name at the place of invocation. The story does not end there. Although this feature has been introduced in C# 5.0/.NET 4.5, it supports multi-targeting too. That means when you use the C# 5.0 compiler for compiling against the older versions of the .NET framework, you can still make it work by defining the caller info attributes in the right namespace (`System.Runtime.CompilerServices`). The compiler expects the presence of the attributes and picks it up for processing by passing the caller information to the concerned method. Developers, happy?

There are other powerful features in C# 5.0 like async-await. However, the caller information attributes, despite being a miniature, holds its share.
