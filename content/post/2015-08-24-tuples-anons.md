---
title: An Unfair World of Tuples, Anons., var and auto
author: vivekragunathan
layout: post
date: 2015-08-24T01:10:27+00:00
url: /2015/08/24/tuples-anons/
categories:
  - .NET
  - 'C#'
  - C++
  - Java
  - Uncategorized
  - Unmanaged
tags:
  - anonymous type
  - anonymous-class
  - anonymous-types
  - auto
  - 'C#'
  - Java
  - tuples
  - var

---
It all began when I wanted to return more than one value from one of the methods. Although my attempts ended futile, it was fun exploring and musing how things could have been.

There are at least a couple of options to return multiple values from a method:-

  1. return an instance of a class that holds the values
  2. return a tuple

<!--more-->

Well, both the options are nothing unusual; not extraordinary either. If the method always returns closely/directly related values (say employee details), a class would be the default choice. Otherwise, if the method returns discrete or loosely related values, a tuple would be appropriate. In the latter case, one could still define a class with a really clumsy name (if naming is not something of importance to the person or team). But how many would you create?

I was looking at something better &#8211; an anonymous type <sup id="fnref-697-1"><a href="#fn-697-1">1</a></sup>. Why? Because I did not want a class, and my values being discrete, I did not want to access the return values as `Item0`, `Item1` etc. (on the calling side). Looks erghhh! I wanted the client code to be type safe and explicit when accessing the return values &#8230; without declaring a clumsy-named class. Anonymous types are a great way to do that. It is exactly how LINQ query makes elegant use of anonymous types to return strongly typed projections of the queried data. All good except **it is not possible to return an anonymous type from a method**. Duh!

For instance, we would not be able to define something like this:-

[code lang=csharp]
  
public var GiveMeAnonType(String symbol, double amount) {
      
return new { Symbol = symbol, Amount = amount };
  
}
  
[/code]

It is not that you cannot have a `return` statement with an anonymous type in a method. You can. But how do we declare the return type of the function? It would have been marvelous to name it using `var`. The `var` keyword is scoped and does not transcend declaration boundaries (methods). The C# design team seems to have purposely enforced such a limitation. To what purpose, that I am not aware of.

That said, let us explore ways to circumvent this limitation and try return an anonymous type from a function.

**`object`**: The method could return an `object` in place of `var`. Hopefully no language rule or restriction could break that. Although we overcome the limitation, we don&#8217;t solve the purpose. On the calling side, we would have to play gimmicks to access the properties of the actual anonymous type returned:-

  * Use reflection to access the properties. This does not provide compile time type safety. Besides, just imagine the mess. You would start to think a clumsy-named class is far better.
  * You could cast the`object` to a type and establish compile time type safety. Since it is an anonymous type, we cannot cast it by its name. However, we could rely on an intrinsic detail that anonymous type declarations with the same properties and order would share the same compiler-generated type. So if I were to use the above `GiveMeAnonType` method in this context, it would be as follows:- 
    [code lang=csharp]
  
    public object GiveMeAnonType(String symbol, double amount)
  
    {
      
    return new { Symbol = symbol, Amount = amount };
  
    }
    
    public void CallingMethod()
  
    {
      
    object result = GiveMeAnonType("$", 44.99);
      
    var wow = Cast(result, new { Symbol = "", Amount = 0.0 });
      
    // wow is now a compile time type safe! Oh, don't look at
      
    // the ugly second parameter in the Cast call.
  
    }
    
    private T Cast(object obj, T type)
  
    {
      
    return (T) obj;
  
    }
  
    [/code]</li> </ul> 
    
    Also, note that if it weren&#8217;t an anonymous type, we wouldn&#8217;t need the second parameter (`T type`) in the `Cast` method. If you don&#8217;t wish to push further, the above trick solves the purpose (to a certain extent). Except the code is not really fluid, and they say, **Don&#8217;t help the compiler**. In this case, the compiler looks like a broken robot, and we are soldering a disconnect so that it dances to our tune. Let me tell you why it is not fluid. First, if the compiler folks were to change the strategy of reusing the compiler generated type for the anonymous type declaration, we are broke. Second, if `GiveMeAnonType` were to change the parameters of the anonymous type, agreed that we would get compilation errors in the `CallingMethod` but that&#8217;s when our soldering wears out.
    
    **`dynamic`**: Well, that seems to be a smart option:-
    
    [code lang=csharp]
  
    public dynamic GiveMeAnonType(String symbol, double amount) {
      
    return new { Symbol = symbol, Amount = amount };
  
    }
    
    public void CallingMethod()
  
    {
      
    dynamic wow = GiveMeAnonType("$", 44.99);
      
    Console.WriteLine("{0}, {1}", wow.Symbol, wow.Amount); // Cool!
  
    }
  
    [/code]
    
    That looks really clean and beautiful. Beauty is skin deep! With `dynamic`, we lose compile-time type safety.
    
    Ignoring performance constraints, given a choice I would go for `dynamic` because at least I don&#8217;t have to solder with the `Cast` method and the explicit dummy and match anonymous type as the second parameter.
    
    **Scenario**
    
    Imagine you are writing a web service that returns, let us say, employee information. Only that it returns what was asked for. For instance, if only the employee&#8217;s name and designation was requested then that&#8217;s what would be returned. The point is although we know the entire gamut of employee details, what would be returned, subset or whole, is determined at runtime.
    
    In such a case, we would neither want to create a combinatorial explosion of classes `EmployeeWithXXXProperties` class nor do we want to twiddle with Dictionary (or `Hashmap` sort of things). Yes, you are thinking `dynamic`. But we discussed it before &#8211; type safety and all that. I am thinking anonymous types!
    
    **The commission**
    
    Typically, somewhere in one of the methods in the call graph for the above service call, we would be gathering the necessary properties to be returned back. It is possible that these properties might have to be massaged a bit before sending it out. For instance, imagine Customer instead of Employee, and we would want to mask the credit card number; something like that. That means even our own code/infrastructure would have to access these properties in an explicit type safe way. It is not just one place where the ugly detail of gathering the Employee properties (into a HashMap or class) would be hidden.
    
    Now you might also counter me back &#8211; Even if there was a way to create and return anonymous types to solve this problem, parts of the code up in the call graph might not be able to access one of the properties (`anon.Name`) if that property is not part of the anonymous type returned. For instance, if the method did not return, say Designation, as part of the anonymous type, and if the caller was accessing it as `anon.Designation`, it would throw compilation error! Excellent observation. Let me explain.
    
    There are several things at play here. Let us analyze with a couple of cases:
    
      * A simple case. Client requests a bunch of properties (`getEmployeeDetails`). We (the server) knows what they are, knows how to gather them, creates an anonymous type with those properties and returns it. The upper layer that has the infrastructure for serializing outgoing objects serializes it to JSON or XML or whatever, and the data goes over the wire to the client. There is no massaging or that sort of thing involved here.
      * Let us try to combine all non-simple cases into one case here. The reason is there are many ways to handle it depending on the real-time context. For us now, say we are returning credit card, and such properties should be massaged (not necessarily masked or even drop it!). In such cases, the gatherer method is responsible for having the control of what should be exposed or returned. In other words, data massaging is the gatherer method or class&#8217;s responsibility so that other parts of the code are not littered with checks, exception handling and such. The `getCustomerDetails` service call hierarchy, in essence, would be very much like `getEmployeeDetails` hierarchy (they differ in the data gathering details)
    
    Now you are awake, and ask, **OK, what if other parts of the code need to access one of these properties (`anon.Property`)?** Yes, there are options:
    
      * Other parts (I imagine _part_) of the code in the current context would itself be prudent of the fact that it would have to inspect the existence of the property. Either this _other part(s)_ of the code would be expecting an anonymous type and wouldn&#8217;t shy away using inspection based access. Or it would be expecting an `Employee` or `Customer`, in which case the gatherer we discussed would be the one to talk to this other part of the code.
      * Even in the case, when this **other part(s) of the code** were to unwillingly adopt inspection before access, how would it performed typed checks in the first place? The code cannot have `anon.SomeProperty` even inside of a condition that checks if the property exists. Conditional check or not, it would throw compilation errors for a flow that does not return an anonymous type with the property. This is a classic scenario for using `dynamic`. Yes, it wouldn&#8217;t provide compile time type-safety. But we are in such a realm where the code optionally does something with a type that it does not know of; nobody knows of for that matter. This piece of code, I would imagine, to be an orthogonal piece in the design rather than something that is embedded in the getCustomerDetails sequence. I would imagine it to be some facility that when given a `dynamic` object would massage the properties based on the property&#8217;s existence or value. Yes, there are checks involved.
    
    However, if asked to choose, I would go with option #1, and let the gatherer deal with it. That way, the massaging is a low-level detail of this sequence. I think it is easier and better to reason our code when it is typed; `massageData(Employee)`.
    
    **Utopia**
    
    Let us assume if C# were to allow returning anonymous types with the `var` keyword (or another keyword), imagine how fluid the code would be. The compiler would be aware of the (anonymous) type and the type information would flow without friction and noise. Yes, there will be rules and restrictions around such a feature. Yes, there are people who wouldn&#8217;t understand the purpose of the feature and start using anonymous types all over. Some will fall in love with the feature that their code will no more have named types as `class`es or `struct`s. But that is not good enough reason to experience this feature in reality. It might as well prove to be a better alternative to `Tuple`s.
    
    Unlike C++, where `tuple` is defined using variadic templates (:clap: :clap: :clap:), most other languages including C# explicitly declare distinct class overloads distinguished by the number of generic parameters. :-1:
    
    **Meanwhile Elsewhere**
    
    Usually, C++ has something in stock for such odd problems<sup id="fnref-697-2"><a href="#fn-697-2">2</a></sup>. The matter is you should be willing to look back. And the difference is the syntax is either clumsy or [crazy][1]. Many concepts available in the form of refined constructs in current day languages would available in crude forms. If not, it would be available in a very limited form.
    
    So let us see if we can return anonymous types in C++, limited or brief nevertheless. In C++, we cannot create anonymous types the way we do in C#. We do can create anonymous types, though &#8230; as [lambdas][2].
    
    [code lang=cpp]
  
    auto count = count_if(numbers.begin(), numbers.end(), [](int x) {
     
    return x > 5;
  
    });
  
    [/code]
    
    I am sure you know where lambda is in the above code. The C++ compiler creates an anonymous class for the lambda as [functor][3].
    
    So we proved we can create an anonymous class in C++. Let us now return one.
    
    [code lang=cpp]
  
    auto anon = [](int x) {
      
    return x * x;
  
    }
    
    auto GiveMeAnon() -> decltype(anon) {
      
    return anon;
  
    }
    
    void main() {
      
    auto anon = GiveMeAnon();
      
    auto r = anon(5);
      
    cout << r << endl; // prints 25;
  
    }
  
    [/code]
    
    I know you feel a leech on your back.
    
    That&#8217;s where it all ends in C++, just when we proved that we can return anonymous types. Yes, you pointed out that we are not actually returning an anonymous type constructed right at the return site. But hey, we at least got something.
    
    `auto` is more or less `var` with a syntactic difference that it can be used as return type place holder for functions. However, the `decltype` addendum is mandatory <sup id="fnref-697-3"><a href="#fn-697-3">3</a></sup>.
    
    **`try ... finally`**
    
    It is not uncommon these days that part or whole of an application is based on data passing between the server and the client(s), and the data is dynamic that it wouldn&#8217;t be worthwhile defining or at least hand code the data model classes. Creating classes/types on the fly and passing them around is not new in JavaScript. It is time for languages like C# to invent a way to create, pass around and work with such types &#8211; anonymous yet compile-time type-safe.
    
    So here is a challenge, obviously to the, C# team if they can crack this thing out &#8211; anonymous types on the fly. Yes, there are challenges, corner cases and all that. Remember a few years back, there was no [yield][4], no [`async`&#8211;`await`][5] etc. We have them now. I believe we should be able to invent something around anonymous types.
    
    **State of Bliss**
    
    Ignorance is bliss and is itself a state of bliss. Java programmers wouldn&#8217;t mind or care about any or all of what we discussed. They have got the `for` loop for all problems. :laughing:
    
    I was trying all this with Java, and finally ended up using [tuples][6].
    
    * * *
    
    <li id="fn-697-1">
      The term <strong>anonymous types</strong> refers to the feature in C# while <strong>anonymous class</strong> refers to another feature in Java. They are similar and distinct in their own ways. However, in this post, the terms could have been used interchangeably in the context of C#.&#160;<a href="#fnref-697-1">&#8617;</a>
    </li>
    <li id="fn-697-2">
      See Also<a href="https://vivekragunathan.wordpress.com/2010/10/03/thinking-currying/">Think Currying</a>, <a href="https://vivekragunathan.wordpress.com/2008/04/09/extension-methods-a-polished-c-feature/">Extension Methods – A Polished C++ Feature</a>&#160;<a href="#fnref-697-2">&#8617;</a>
    </li>
    <li id="fn-697-3">
      The intricate details of <code>auto</code> and <code>decltype</code> are beyond the scope of this post.&#160;<a href="#fnref-697-3">&#8617;</a> </fn></footnotes>

 [1]: https://vivekragunathan.wordpress.com/2011/03/27/crazybraces/
 [2]: https://msdn.microsoft.com/en-us/library/Dd293608.aspx
 [3]: https://msdn.microsoft.com/en-US/library/Aa985932.aspx
 [4]: https://msdn.microsoft.com/en-us/library/vstudio/9k7k7cf0%28v=vs.110%29.aspx
 [5]: https://msdn.microsoft.com/en-us/library/hh191443.aspx
 [6]: http://www.javatuples.org