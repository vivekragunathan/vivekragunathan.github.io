---
title: Invoking methods with out and ref – Finale !!!
author: vivekragunathan
layout: post
date: 2010-12-21T13:24:39+00:00
url: /2010/12/21/out-ref-finale/
categories:
  - .NET
  - 'C#'
  - Uncategorized

---
Alright, it is a long wait. And I am going to keep it short.

Recap of the problem: Why did the `ref` variable in SomeMethod not get the expected result (`DayOfWeek`.`Friday`) when called from a different thread?

Boxing. Yes, that is the culprit. Sometimes, it is subtle to note. `DayOfWeek` is an `enum` – a value type. When the method is called from a different thread, we put the argument (`arg3`) in an object array, and that’s where the value gets boxed. So we happen to assign the resultant value to the boxed value.

So how do resolve the issue? Simple. Assign the value back from the object array to the `ref` variable.

```csharp
int SomeMethod(
	string arg1,
	string arg2,
	ref DayOfWeek arg3
)
{
    if (Dispatcher.CheckAccess())
    {
        var funcDelegate = (Func<string, string, DayOfWeek, int>)SomeMethod;

        var args = new object[] {
            arg1,
            arg2,
            arg3
        };

        int retVal = Dispatcher.Invoke(funcDelegate, args);
        arg3 = args[2];

        return retVal;
    }

    // No more implementation
    arg3 = DayOfWeek.Friday;

    return 1234;
}
```

It may not be worth the wait but it is subtle enough to plant a bug in the code; tough enough to be noted.
