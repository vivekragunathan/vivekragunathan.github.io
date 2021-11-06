---
title: .NET Reflection Extravanganza !!!
author: vivekragunathan
layout: post
date: 2006-05-11T22:40:00+00:00
url: /2006/05/11/net-reflection-extravanganza/
categories:
  - .NET
  - CLR
---

Over the past few weeks, I have been involved with this module that got the best of both worlds - .NET and I, 😁.

Ok, this was the problem. We have a COM server, let us name it Server. I had to write an assembly in C#, let us call it Bridge, that will listen to all of the events fired by the Server and perform an action Action. To keep that Action simple, let us assume we have to log them to the database. But the Server fires **hundreds** of events, and it is not wise to write up static event handlers for all of them. Also, if more events are (ever) added in the future, the Bridge should be able to support it without code changes.

The twist in the game was that this was a brown + green field development project. That demanded a wise solution - learn from the past and better the future.

<!--more-->

So, I came up with a different approach with the incredible Reflection in .NET. All of the events fired by the Server, its prototype and other relevant information can be got through reflection. For each of the event methods, an event sink [event handler] can be generated at runtime. This means I have to create a method at runtime matching the prototype of the event. The dynamic method thus generated runtime has to appended with some method body performing the desired `Action`, and then has to be registered as the event sink for the corresponding event. So, when the event is fired by the Server, the dynamically created event handler is called without any intervention. This is the theme of my solution. This keeps the Bridge unaffected for any event related changes in the Server.

Implementing this solution was a great and exciting adventure, although a tiring one too.

I was able to get the event information about the events fired by Server through reflection. I used the following sort of code for generating the dynamic method or the supposedly the dynamic event handler:-

```csharp
using System;
using System.Threading;
using System.Reflection;
using System.Reflection.Emit;

class TaskDynamicEventHandler
{
	public static void CreateDynamicEventHandler(
		ref TypeBuilder myTypeBld,
		string methodName,
		Type[] eventMethodParameters,
		Type eventreturnType
	)
	{
		MethodBuilder myMthdBld =
			myTypeBld.DefineMethod(
				methodName,
				MethodAttributes.Public | MethodAttributes.Static,
				eventreturnType,
				eventMethodParameters
			);

		ILGenerator ILout = myMthdBld.GetILGenerator();
		int numParams = eventMethodParameters.Length;

		for (byte x = 0; x < numParams; x++)
		{
			// Load the parameter onto the evaulation stack
			ILout.Emit(OpCodes.Ldarg_S, x);
		}

		// Use the above sort of logic to access the event parameter
		// values and then package into a hashtable, and then call
		// a static method HandleEvent in TaskDynamicEventHandler,
		// which takes the hashtable as a parameter. All the code is
		// generated in IL using ILGenerator.
		ILout.Emit(OpCodes.Ret);
	}

	public static void Main()
	{
		AppDomain myDomain = Thread.GetDomain();
		AssemblyName asmName = new AssemblyName("DynamicAssembly1");

		AssemblyBuilder myAsmBuilder =
			myDomain.DefineDynamicAssembly(
					asmName,
					AssemblyBuilderAccess.RunAndSave
			);

		ModuleBuilder myModule = myAsmBuilder.DefineDynamicModule("DynamicModule1", "MyDynamicAsm.dll");
		TypeBuilder myTypeBld = myModule.DefineType("MyDynamicType", TypeAttributes.Public);
		string dynamicMethodName = "DynamicEventHandler";

		CreateDynamicEventHandler(
			myTypeBld,
			dynamicMethodName,
			eventMethodParameters,
			eventreturnType
		);

		Type myType = myTypeBld.CreateType();
		myAsmBuilder.Save("MyDynamicAsm.dll");
	}
}
```

The drawback in this approach was that a dynamic assembly+module+type was getting created for each event. This was not efficient enough, and so slightly altered the logic to create the dynamic assembly+module+type once and add the methods [dynamic event handlers] to the dynamic type.

Though a level of efficiency may have been achieved, it was not elegant enough to be satisfied. The dynamic event handlers [DEH] are all methods of a specific type belonging to a different assembly that is generated at run-time, and these DEH do not belong to the same assembly as the `TaskDynamicEventHandler` class. The responsibility of the DEHs was to read its parameter name and values at runtime, package them into a hash table, and call a method `HandleEvent` of `TaskDynamicEventHandler`, and it is in `HandleEvent` that the actual job of logging is done. Well, the actual job is not only logging but other things that require access to the members of `TaskDynamicEventHandler`. So the non-elegance here was that `HandleEvent` was exposed as `public` `static` method so that the DEH in the dynamic assembly could call, which lead to the ugliness where `HandleEvent` was exposed to the outside world from the assembly to which `TaskDynamicEventHandler` belongs to. So `HandleEvent` cannot be non-public. But it was required for other reasons to be an instance method.

   + Here is the most interesting part. The aim was then make the DEH call an instance method of the `TaskDynamicEventHandler` ie `HandleEvent`. How do you make a static method call an instance method ? Well, if I have an object reference of the `TaskDynamicEventHandler` class in the DEH execution, and IF i can load that on to the evaluation stack [using the IL code/ILGenerator], then i call an instance method. That was the pain and it was pretty tricky and interesting that everybody to whomever I explained could not correctly grasp that the ‘this’ used during the compiled code will not be the same in the runtime IL code of the DEH, and neither can I load an object reference without me creating it or getting it as a parameter. That is all the .NET type security. You will not be given any chance to do `reinterpret\_cast` kind of stuff at all. But you can pass the `TaskDynamicEventHandler` object reference [`this`] to the DEH but that beats the goal where the prototype of the DEH will not match the prototype of its corresponding event and so cannot act as a sink.

```csharp
// returnType - event method's return type
// parameterTypes - event method's parameter types list
ArrayList parameterTypes = new ArrayList(parameterTypes);
parameterTypes.Insert(0, this.GetType());

DynamicMethod dynamicEventHandler =
  new DynamicMethod(
    methodName,
    returnType,
    (Type[]) parameterTypes.ToArray(typeof(Type)),
    typeof(TaskDynamicEventHandler)
  );
```

Hence the DEH is now a part of the same assembly and class and it can call even non-public methods. Efficiency was well achieved but still elegant was a few feet away. The dynamic method created and added to `TaskDynamicEventHandler` using DynamicMethod class is a static method and hence cannot access instance methods of `TaskDynamicEventHandler`, although it can access non-public methods.

   + Here is the most interesting part. The aim of this iteration is to make the DEH call an instance method of the `TaskDynamicEventHandler` ie `HandleEvent`. How do you make a static method call an instance method ? Well, if I have an object reference of the `TaskDynamicEventHandler` class during the DEH execution, and if i can load that on to the evaluation stack [using the IL code/ILGenerator], then i call an instance method. Things are going to get interesting now. The difference between an instance and static method is that an instance method has the object reference, to which it belongs, as the first parameter while a static method does not. Though syntactically, the object reference is not added, the compiler adds it. So while creating the dynamic method [DEH] for an event, the `TaskDynamicEventHandler` object reference [this] is added as the first parameter to the event parameter list. This makes the DEH seem to be an instance method. So during runtime, when an event is fired, its corresponding DEH executes, the `Lgarg\_0` in the IL code represents the object reference it belongs to, and it is the same as that for `HandleEvent`.

   + But even now the `HandleEvent` is public and is vulnerable for improper usage. I made it a virtual method. That is fun, and now it is entirely the user’s responsibility to avoid improper usage, and it is up to the user to override `HandleEvent` to do whatever he wants.
   + Few minor things- Added `Trace`.`WriteLine` in the IL code using ILGenerator for debugging; Added try-catch exception blocks for catching exceptions, but unfortunately does not seem to work.

All of these approaches until the final efficient and elegant solution took several iterations of revisit and review. I will not able to explain about the difficulties and tough IL debugging experience that I went through trying to make the `HandleEvent` an instance virtual method, although I will be able to share the joy and knowledge now. It was a great experience !!!
