Today, we question our beliefs! Is string really immutable?

```cs
string message = "Hello World!";

Console.WriteLine(message);        // Prints "Hello World!"

unsafe {  
    int length = message.Length;

    fixed (char *p = message) {
        for (int index = 0; index < length; ++index) {
            *(p + index) = '?';
        }
    }
}

Console.WriteLine(message);     // Prints what? See for yourself!  
```

It is unsafe to play with the beliefs we grew up with. In our case, string is immutable. In other words, it is unsafe to tamper the invariants of a system, at least not wise to do so without knowing what we are doing and the after effects.

First, let us understand a bit about the code:
   * Since we are about to embark on a journey never taken before, so we declare it is unsafe. We are going to be dealing with the dirty stuff like pointers and addresses … in a managed environment. Or are we entering the gray area where _managed_ is _unmanaged_? Basics is always considered dirty.
   * Under the hood, a .NET string is similar to a COM BSTR. That means, length prefixed or not, it is a sequence of chars that we should be able to iterate over if we obtain a pointer to its base address. And that’s what we do. We grab a pointer to the base address, iterate and leave the user to wonder with a ?. In the snippet above, we simply assign ? to all indices of the string.
   * The interesting part is fixed. I truly love this part. If you have worked with .NET interop (like managed and unmanaged – C++/CLI), you too will love this.
   * While we happily grab the pointer and iterate the string, the GC could kick in, freeze our code and swoop the string to a different address by the end of the collection. When our code wakes up, it would happily be writing junk at the same location assuming that the original string is still there. Marking the code with fixed instructs the GC to leave the string where it is and collect the rest of the objects.

Alright, so? Why would you want to do all these nasty things rather than using string with the guarantee that it provides – immutability? True. Immutability is the fruit that we taste for the work done elsewhere.

>Microsoft is good at eating its own dog food. The general principle of Microsoft’s systems is yield explicit control in the form of APIs while the principles of the system remain the same for you, me and Microsoft.

Other than constant literals and non-dynamically created strings, strings created at runtime cannot be immutable. For instance, when a string has to be created out of a `StringBuilder`, the `ToString(`) method uses unsafe yet wise code to create a final immutable string. If it weren’t the case and string was nothing but inherently immutable, every character added to a string would produce a copy and the GC would be running all the time instead of our code. :)

Another scenario: You have quantitative evidence that you are going to gain performance or efficiency by manipulating your string (needless to say, a very lengthy one) in place rather than typically creating copies when manipulating using the string APIs. This would rather be an umbrella of uses cases when you would go unsafe. But you will also have to wise enough at the same time that the string you are playing with is not shared (at least not used) with any other thread _when you are manipulating its contents_. A word of caution or consolation, `StringBuilder`, for that matter, is not thread-safe. So know, I mean really know, what you are doing.

You might be wondering, “_That’s a lot of words for such a petty thing_”. Maybe! But I am excited to talk about it. It is a matter of taste. Gotta be likeminded to enjoy it. Or like Scott says, “_You should know what is behind the drain_”.
