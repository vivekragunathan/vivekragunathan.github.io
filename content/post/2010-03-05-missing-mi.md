---
title: Missing MI !!!
author: vivekragunathan
layout: post
date: 2010-03-05T17:10:00+00:00
url: /2010/03/05/missing-mi/
categories:
  - .NET
  - 'C#'
  - CodeProject
  - Uncategorized
tags:
  - 'C#'
  - codeproject
  - MI

---
We all know C# does not offer multiple inheritance but offers arguments that programmers can live without it. It is true in almost all cases, especially all cat and animal or employee and manager projects. I have seen a few cases where if C# offered multiple inheritance, the solution would have been natural, elegant and succinct.

Imagine that I have a component (UI, non-UI, doesn’t matter). You can make calls into the component, which does some interesting work for you. Imagine that the component takes an interface `IComponentCallback` to notify its parent. So I would do is have my parent class derive from `IComponentCallback` interface and pass this to the component. The code would look something like this:-

```cpp
interface IComponentCallback
{
   void Callback1();
   bool Callback2();
   void Callback3(int old, int new);
}

class SomeComponent
{
   // The parent on whom callbacks are made
   private IComponentCallback _parent = null;

   public SomeCompoent(IComponentCallback cmpCallback)
   {
      // Imagine that callbacks would not be made      
      // if cmpCallback is null

      _parent = cmpCallback;
   }

   // Other methods in which _parent shall be used
   // for making the callbacks.
}

class Parent : IComponentCallback
{
   private SomeComponent _someComponent = null;

   public Parent()
   {
      _someComponent = new SomeComponent(this as IComponentCallback);
   }

   #region IComponentCallback methods implementation

   void IComponentCallback.Callback1()
   {
      // Code making use of this callback
   }

   bool IComponentCallback.Callback2()
   {
      // Possible code to provide some    
      return true;
   }

   void Callback3(int old, int new)
   {
      // Code making use of old\new
   }

   #endregion
}

void Main(string[] args)
{
   // .... code ...

   // Instantiating a parent which would create
   // SomeComponent and establish itself as the
   // callback sink.
   Parent p = new Parent();

   // ... Code ...
}
```

This is a typical case where the instantiator is the callback sink. And this case is natural and usual. There may be cases where one class instantiates and holds the component while a different class acts as the callback sink. That… is not the topic of our discussion.

Now imagine our parent is a Form class. I am sure you might have come across this case where a Form hosts a UI or non-UI component and you want the callback sink as methods in your class so that you can update the UI directly. What follows may necessarily be the common case but I encountered it more than a few times. In our application, any parent could host the component. There were certain things common to do when processing the callback and hence we wrote a (base) class implementing `IComponentCallback` and which represents the component callback sink. Since C# does not support MI, any of our custom forms could not be derived from the callback sink class, since they are already derived from System.Windows.Form class.

Now it is not wise to argue that one may use delegates or that this implementation is bad or this is a corner case. I have practically encountered this a few times where the component we are talking about is from a third party. In some cases, the component was our own and implemented for callback mechanism, called plugin, whose intent is quite opposite to event notification. Most others might have _No MI in C#_ in mind and would have the sink class as a member of the Form (parent). I don’t see that natural but compulsion.

Anyways, a case exists, and of course you can live without MI.
