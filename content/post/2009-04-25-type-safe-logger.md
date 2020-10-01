---
title: Type Safe Logger
author: vivekragunathan
layout: post
date: 2009-04-25T15:02:00+00:00
url: /2009/04/25/type-safe-logger/
blogger_blog:
  - developerexperience.blogspot.com
blogger_author:
  - Vivek Ragunathan
blogger_efd3de0af000aedcb3351cb4b4995ef6_permalink:
  - 9076675656332833893
categories:
  - C++
  - CodeProject
  - Uncategorized

---

Article co-authored with [Sanjeev](http://localhost:1313/pages/typesafe-logger/www.linkedin.com/in/sanjeev-venkataramanan-3496b018), and [published](http://www.codeproject.com/Articles/35648/Type-Safe-Logger-For-C) on [CodeProject](http://localhost:1313/pages/typesafe-logger/www.codeproject.com)

-----

### PROBLEM

Every application logs a whole bunch of diagnostic messages, primarily for (production) debugging, to the console or the standard error device or to files. There are so many other destinations where the logs can be written to. Irrespective of the destination that each application must be able to configure, the diagnostic log message and the way to generate the message is of our interest now. So we are in need of a logger class that can behave transparent to the logging destination. That should not be a problem, it would be fun to design that.

The crux of the problem now is the generation of the log messages. Usually the log messages are generated dynamically in your code. For instance if an user calls an API `int GetFileSize(LPCTSTR lpszFilePath)`, the log may look something like this:-

```bash
GetFileSize – File: C:\Temp\Sample.txt. Size: 1492 bytes.
```

In the above line of log, the file path and size values are known at runtime depending on the file. And the log could also bear the current date and time with the current logged in user requesting the file size and a variety of other stuff that might look information rich to the user. So, no doubt, our logger should have a method with variable number of arguments. Let us do the first draft of our logger class.

```cpp
class Logger
{
  public: Logger() ;
  public: ~Logger() ;

  public: void LogTrace(const std::string& category, const std::string& fmtSpec, ...);
  public: void LogInformation(const std::string& category, const std::string& fmtSpec, ...);
  public: void LogWarning(const std::string& category, const std::string& fmtSpec, ...);
  public: void LogError(const std::string& category, const std::string& fmtSpec, ...);
};
```

The variable number of arguments is just fair enough. The C/C++ style of format specification string is cryptic with `%` and tough to match the corresponding format specification for each type; and especially tough when the format specification string is a long one. For instance, in order to output an `int`, the format specifier must be `%d`; if the programmer made a mistake by specifying `%s`, the whole show comes down. The application crashes pathetically. That is our prime problem to be solved – type safe logging.

So

- Our logger must offer type safe logging, which means there must literally be no possibility of crash due to format specification mismatch or improper arguments count.
- The C++ programming language and the Windows operating system both do not offer a convenient and generic logging facilities.
- The logger must be loosely coupled with the log destination.
- The variable arguments facility is very crude and something a C programmer would be happy about, whereas C++ abstracts and encapsulates everything as objects.

### SOLUTION – (Type Safe) Logger

First obstacle to get through is the facility to specify the variable number of arguments, especially in a type safe way. Fortunately the Standard Template Library is our savior. We can rely on `std::ostringstream` cutie for generating messages on the fly. A quick look:-

```cpp
std::ostringstream ostr;

ostr « “GetFileSize – File: " « filePath.c_str() « “\tSize: " « fileSize « " bytes.";
```

The message thus constructed can be then directed to any destination – file, standard error, UI etc. That is the core of our solution.

However the message construction must be based on a format specification. One good advantage of a format specification is that it gives a world view of the message that would be constructed\logged; while on the other hand, it is cryptic to read and know the message from a `std::ostringstream` construct as as above. That means we are thinking of blending and innovating a logging construct which involves printf-like format specification with `std::ostringstream`. Although we seem to have solved the variable arguments problem, we are back to square on the format specification. Our aim is to get rid of the world where %ld has to be matched for a numeric or %s for a string. For that matter, even `std::ostringstream`‘s « operator does not do good with a parameter that is a `std::string`.

If that is our pain, then let us devise our own format specification, which provides type safety. By type safety we aim to never crash at runtime and also detect specification anomalies. So let us use the .NET style of format specification which uses argument index placeholders but the format specifier still is `%`. So for our GetFileSize example, the format specification string may look like the following:-

```text
GetFileSize – File: %0. Size: %1 bytes. User: %2. Is ‘%0’ read-only: %3
```

By now, you must be say wow! First good thing in the above format specification string is the repeating index placeholders (`%0`), which avoids specifying duplicate arguments. Other good things will be discussed in a short while.

We are ready with our format specification design – format specification and variable arguments. Now we need to merge these to construct messages on the fly. We need a way (via methods or such) to pass in the format specification, followed by argument passing. Besides that, we must be able to do log level based logging. That means I must be able to pass in the format spec and arguments, and say I want to log the message as Trace, Information, Warning or Error using the `LogXXX` methods in the logger. May be our logger usage could be:-

```cpp
Logger x(“GetFileSize – File: %0. Size: %1 bytes. User: %2. Is ‘%0’ read-only: %3”);

x « “C:\Temp\Sample.txt” « 2945 « Visitor « “True”;

x.LogInformation();
```

Horrible, Isn’t it? By doing it the ugly way, we realize there is an elegant way.

```cpp
Logger().LogInformation(“GetFileSize – File: %0. Size: %1 bytes. User: %2. Is "

“'%0' read-only: %3”) « “C:\Temp\Sample.txt” « 2945 « Visitor « “True”;
```

OR

```cpp
Logger().LogError(“Failed to get file size!");
```

That is how we will be logging. We create and log in a single line of code. Our Logger class will be overloading the « operator to intake the arguments passed, and will be making of the use of the destructor to log to the desired destination right after the line where logging is done.

### WHERE DO WE LOG?

As we discussed earlier, our Logger is transparent to the logging destination. And for that reason, I intend to keep the part of physical logging out of the Logger class. The Logger is an abstract class with `LogMessage` pure virtual function. And here is how our Logger is refined to:-

```cpp
enum LogSections

{

LOGSECTION_APPGENERAL,

LOGSECTION_APPINIT,

LOGSECTION_APPSHUTDOWN,

LOGSECTION_MODULEA,

LOGSECTION_MODULEB

// Add other log categories

};

enum LogLevel

{

LOGLEVEL_TRACE,

LOGLEVEL_INFO,

LOGLEVEL_WARNING,

LOGLEVEL_ERROR

};

struct MessageInfo

{

public: LogLevel Level;

public: LogSections Category;

public: std::string Message;

public: std::string Timestamp;

public: std::string ThreadID;

public: MessageInfo(LogLevel gLevel,

LogSections gSection) : Level(gLevel),

Category(gSection)

{

this-Timestamp = DateTimeAsString();

this-ThreadID = Thread::IDAsString();

}

};

class Logger

{

private: MessageInfo _mInfo;

private: std::string _fmtSpec;

public: Logger(LogLevel logLevel,

LogSections logSection,

- const std::string& fmtSpec)

  _mInfo(logLevel, logSection),

_fmtSpec(fmtSpec)

{

}

public: virtual ~Logger()

{

// Use PrepareStream private method that

// constructs the message from the _fmtSpec

// and arguments passed using overloaded the

// « operator.

_mInfo.Message = PrepareStream();

_mInfo.Timestamp = DateTimeAsString();

LogMessage(mi);

}

protected: virtual LogMessage(MessageInfo mi) = 0;

private: template<typename TLogger& operator <(T t);

};
```

The users are required to derive from the Logger class and implement the `LogMessage` method to perform the physical logging in the format they desire. For ease of use, loggers that log to standard error device and file are provided in the download.

### HIGHLIGHTS

The format specification (`%n`) considers only `%` followed by n as the indexed place holder, where n is any number in the range 0-256. Any other character after the % is not given any special treatment and is directed to the logging destination; except a `%` (after `%`) is for logging a `%`, like a � in C style logging. In short, a `%%` is an escape sequence for `%`.

Since Logger overloads `<<` operator and internally relies on `std::ostringstream`, any argument in essence should be a string-convertible. All simple types are identified and automatically converted to string for logging. For complex types and special logging formats, the user supplies the formatted string. For instance, if I want to log my class, I may (have to) provide a ToString method on the class that gives me the string representation of the class, which is not an unfair thing.

Since we used custom format specification with `%`, there is no possibility of argument-type mismatch, and no crashes due to the same. Besides, any argument passed that is not string-convertible results in a compiler error, which is one of the biggest benefits.

The argument count mismatch is safely handled avoiding runtime crashes. If the number of arguments passed (via `<<`) is less than the number of argument placeholders (`%n`), then asserts are issued for each argument placeholder for which the corresponding argument is not found, and the %n is directly logged. For instance, in the following line of log, `%2` is asserted for argument mismatch and the string `%2` is logged.

```cpp
Logger().LogInformation(“GetFileSize – File: %0. Size: %1 bytes. "

“User: %2. Is ‘%0’ read-only: %3”) « “C:\Temp\Sample.txt” « 2945 « Visitor;
```

If the number of arguments passed is greater than the number of placeholders, the extra arguments are ignored from logging. So all argument mismatches can be identified and resolved during compile time without doubt.

### LIMITATIONS

Although the specification is half .NET style, our Logger does not offer all formatting facilities – hex, spacing etc. All such things are kept outside of the Logger. This was not intentional but I thought to start the Logger simple. So if you want to output a number in hex, the ToHexString static method of the Logger class may be used.

```cpp
Logger(“Hex number: %0”, Logger::ToHexString(1000));
```

The maximum number of arguments that can be specified (in the format spec) is 256. At the time of writing this logger for my application, my application had no chance of having a format spec with more than 256 arguments. Besides, I thought a Logger that allows constructing a format spec with 256 arguments may be fancy enough but from the ease of use stand-point, reading and getting a world of view of the message is not that easy, and the purpose is beaten. However, for people who opine otherwise, this limitation can be easily gotten rid of from the code (remove an if condition), and you are free to construct a format spec with any number of arguments.