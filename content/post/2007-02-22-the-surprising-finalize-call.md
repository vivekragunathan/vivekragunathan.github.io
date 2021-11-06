---
title: The Surprising Finalize Call !!!
author: vivekragunathan
layout: post
date: 2007-02-21T20:27:00+00:00
url: /2007/02/22/the-surprising-finalize-call/
categories:
  - .NET
  - 'C#'
  - CLR
  - CodeProject
  - Uncategorized

---
Guess the output of the following program:-

```csharp
class SomeClass : IDisposable
{
  public SomeClass()
  {
		Trace.WriteLine("SomeClass - Attempting instance creation");
		throw new Exception("Ohh !!! Not Now");
	}

	public void Dispose()
	{
		Trace.WriteLine("SomeClass::Dispose");
	}

	~SomeClass()
	{
		Trace.WriteLine("SomeClass::Finalizer");
	}
}

int Main(string args[]){
	try{
		SomeClass sc = new SomeClass();
  }
	catch(Exception ex){
		Trace.WriteLine("Main - {0}", ex.Message);
  }
}
```

<!-- more -->

This will be the output of the program:-

```bash
SomeClass - Attempting instance creation
Ohh !!! Not Now SomeClass::Finalizer
```

If you are surprised with the last line of the output, the post has served its purpose. In the .NET [managed] world, the garbage collector is entirely responsible for memory management – allocation and deallocation. In C#, an instance of a class is created using the new keyword. When an instance creation is requested, first memory for the instance is allocated followed by a call to the [appropriate] constructor of the class.

To explain the surprising output, the constructor is called after the memory is allocated by the GC. When the constructor throws exception, the object or resource creation is interrupted but the memory cannot deallocated instantly since the GC is entirely responsible for memory deallocation. The GC follows a complex and non-deterministic style for deallocating or reclaiming an allocated chunk of memory. The finalizer method is the last call made on a managed object just before reclaiming memory. Hence in the above case, the finalizer is being called before reclaiming the memory allocated for an instance of SomeClass.

The above behavior is very much different from the unmanaged C++ where when the instance creation is interrupted [by throwing an exception], the allocated memory is deallocated and reclaimed instantaneously. Also the destructor is not called in this case.

P.S: Thinking of a more detailed post on non-deterministic destruction.
