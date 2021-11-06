---
title: Just-In-Time (JIT) Compilation
author: vivekragunathan
layout: page
date: 2014-10-01T04:27:30+00:00

---
> <small>An excerpt from the book <a href="">Professional .NET v2.0</a></small> 

* * *

The Just in Time (JIT) Compiler gets its name because it compiles your managed code into executable native code on the fly. That is, it compiles the IL just as it&#8217;s needed. Understanding how the JIT works, again, isn&#8217;t strictly necessary in order to be productive with managed code. In fact, those not familiar with assembly-level programming might feel a little uncomfortable with the content in this section; if you&#8217;ve never programmed in a language like C or C++, for example, then you are sure to feel a little lost. Don&#8217;t fret; you can safely skim over this section and come back after you&#8217;ve worked with the CLR a little more. But for those who read through, it will give you some internals-style insight into how things work in the runtime.

### Compilation Process Overview

By default, the method table for each CTS type contains a slot for each method the type defines, including methods it has inherited from base classes. A &#8220;slot&#8221; is just a pointer to the memory address holding that method&#8217;s code; the collection of slots for a single type is called its _vtable_(a.k.a. vtbl, virtual table). This is much like the vtable C++ instances refer to. An object on the heap (to which a reference points) uses the first DWORD to point at that object&#8217;s method table. Following that pointer is the object&#8217;s runtime field data. This, among the overall JIT compilation process (explained below), is illustrated in <a style="text-decoration:none;color:#325984;" href="http://codeidol.com/csharp/net-framework/Inside-the-CLR/Just-In-Time-%28JIT%29-Compilation/#ch03fig06">Figure 3-6</a>.<figure style="width: 640px" class="wp-caption aligncenter">

<a href="http://codeidol.com/img/net-framework/fig147_01_0.jpg" target="_blank"><img src="http://codeidol.com/img/net-framework/fig147_01_0.jpg" alt="JIT compilation overview" width="640" height="480" border="1" /></a><figcaption class="wp-caption-text">JIT compilation overview</figcaption></figure> 

All vtable slots contain an instruction (either a call or a jmp, we&#8217;ll see the difference in a moment) and a pointer to the IL for that slot. Initially, the instruction in each slot calls a shared piece of code, called the _pre-JIT stub_. This stub is responsible for invoking the JIT Compiler (which resides inmscorjit.dll) to generate native code for the method being called, back-patching the method-table slot with a jmp to the new location of the dynamically allocated code, and finishing with a jmp to that code. Thus, all slots that have already been jitted simply contain an unconditional jmp to the target jitted code in the instruction part of their slot. Having a jmp in the slot enables fast execution of calls with the overhead of only a single jmp instruction.

The JIT Compiler of course makes a number of intelligent operations while it is producing your code. For example, it will inline methods that are sufficiently small and don&#8217;t involve complex loops. It also performs many traditional compiler optimizations such as loop unrolling and dead code elimination. Code that is never exercised will not be jitted, and thus it won&#8217;t impact your working set. And of course any machine-specific features such as extended registers and preferences for instruction layout can be made, since compilation happens on the actual machine itself.

Unfortunately, the CLR JIT has to lose some intelligence in favor of code generation speed. Remember, it&#8217;s actually compiling your code as your application runs, so producing code that_executes fast_ isn&#8217;t always as important as _producing code fast_ that executes. A utility called NGen enables you to precompile managed code into native images, which doesn&#8217;t have this restriction. (Although, at the moment NGen <a style="text-decoration:none;color:#325984;" name="379"></a><a style="text-decoration:none;color:#325984;" name="idx-126"></a>doesn&#8217;t make any additional optimizations over what the ordinary JIT does. But of course the CLR Team is free to make these changes in the future — they are implementation details.) We discuss NGen further in <a style="text-decoration:none;color:#325984;" href="http://codeidol.com/csharp/net-framework/Inside-the-CLR/Just-In-Time-%28JIT%29-Compilation/BBL0025.html#397">Chapter 4</a>.

### Method Call Internals

When a method call is made, the caller and callee methods must communicate a set of information with each other. We call the abstraction that contains this information an _activation frame_. The caller supplies the this pointer for instance methods, additional arguments for the method, and stack address information, while the receiver must give back the return value of the method and ensures that the stack has been cleaned up. All of this requires that a standard method-calling process be in place. This is referred to as a calling convention, of which there are several options on Windows.

Activation frames are implemented using a combination of registers and the physical OS stack, and are managed by the CLR&#8217;s JIT Compiler. There isn&#8217;t a &#8220;single activation frame object&#8221;; as noted above it&#8217;s a convention followed by the caller and callee. In addition to that, the CLR manages its own stack of frames to mark transitions in the stack, for example unmanaged to native calls, security asserts, and uses the information to mark the addresses of GC roots that are active in the call stack. These are stored in the TEB.

There are a number of ways to make method calls on the CLR. From entirely static to entirely dynamic (e.g. call, callvirt, calli, delegates), and everywhere in between, we&#8217;ll take a look at those in this section. The primary difference between the various method calls is the mechanism used to find the target address to which the generated native code must call.

We&#8217;ll use this set of types in our examples below:

[code lang=csharp]
  
using System;
  
using System.Runtime.CompilerServices;

class Foo
  
{
      
[MethodImpl(MethodImplOptions.NoInlining)]
      
public int f(string s, int x, int y)
      
{
          
Console.WriteLine("Foo::f({0},{1},{2})", s, x, y);
          
return x*y;
      
}

[MethodImpl(MethodImplOptions.NoInlining)]
      
public virtual int g(string s, int x, int y)
      
{
          
Console.WriteLine("Foo::g({0},{1},{2})", s, x, y);
          
return x+y;
      
}
  
}

class Bar : Foo
  
{
      
[MethodImpl(MethodImplOptions.NoInlining)]
      
public override int g(string s, int x, int y)
      
{
          
Console.WriteLine("Bar::g({0},{1},{2})", s, x, y);
          
return x-y;
      
}
  
}

delegate int Baz(string s, int x, int y);
  
[/code]

Furthermore, we&#8217;ll imagine the following variables are in scope for examples below:

[code lang=csharp]
  
Foo f = new Foo();
  
Bar b = new Bar();
  
[/code]

### A Word on the fastcall Calling Convention

The CLR&#8217;s jitted code uses the fastcall Windows calling convention. This permits the caller to supply the first two arguments (including this in the case of instance methods) in the machine&#8217;s ECX andEDX registers. Registers are significantly faster than using the machine&#8217;s stack, which is where the remaining arguments are supplied, in right-to-left order (using the push instruction).

### Ordinary Calls (call)

You might have already guessed the primary native code difference between an ordinary call and a virtual call based on the description above. Simply put, a virtual call looks at the method-table of the object against which the method is dispatching to determine the method-table slot to use for thecall, while others just use the token supplied at the call-site to determine statically which method-table slot to inspect. Slot offsets for both styles of calls are determined statically at JIT time, so they are quite fast; virtual methods ensure that their versions of methods inherited from base classes occupy the same slots so that the index for a particular method doesn&#8217;t depend on type.

Normal method calls (i.e., the IL call instruction, or callvirts to nonvirtual methods) are very fast. The JIT Compiler is able to burn the precise address of the target method-table slot at the call-site because it knows the location statically at compile time. Let&#8217;s consider an example:

[code lang=csharp]
  
int ff = f.f("Hi", 10, 10);
  
int bf = b.f("Hi", 10, 10);
  
[/code]

In this case, we&#8217;re calling the method f as defined on Foo. Although we use the b variable in the second line to make the call, f is nonvirtual and thus the call always goes through Foo&#8217;s definition. The jitted native code for both (in this example, IA-32 code) will be nearly identical:

[code lang=csharp]
  
mov ecx,esi
  
mov edx,dword ptr ds:[01B4303Ch]
  
push 0Ah
  
push 0Ah
  
[/code]

Remember, the first two arguments are passed in ECX and EDX, respectively. Our this pointer (constructed above with the Foo f = new Foo() C# code) resides in ESI, and thus we simply mov it into ECX. Then we move the pointer to the string &#8220;Hi&#8221; into EDX; the exact address clearly will change based on your program. Since we are passing two additional parameters to the method beyond the two which are stored in a register, we pass them using the machine&#8217;s stack; 0Ah is hexadecimal for the integer 10, so we push two onto the stack (one each for each argument).

Lastly, we make a call to a statically known address. This address refers to the appropriate method-table slot, in this case Foo::f&#8217;s, and is discovered at JIT compile time by matching the supplied method token with the internal CLR method-table data structure:

[code lang=csharp]
  
call FFFC0D28
  
[/code]

The second call — through the b variable — differs only in that it passes b&#8217;s value in the ECXregister. The target address of the call is the same:

[code lang=csharp]
  
mov ecx,edi
  
mov edx,dword ptr ds:[01B4303Ch]
  
push 0Ah
  
push 0Ah
  
call FFFC0D28
  
[/code]

After performing the call to FFFC0D28 in this example, the stub will either jmp straight to the jitted code or invoke the JIT compiler (with a call) as needed.

### Virtual Method Calls (callvirt)

A virtual method is very much like ordinary calls, except that it must look up the target of the call at runtime based on the this object. For example, consider this code:

[code lang=csharp]
  
int fg = f.g("Hi", 10, 10);
  
int bg = b.g("Hi", 10, 10);
  
[/code]

The manner in which the this pointer and its arguments are passed is identical to the call example above. ESI is moved into ECX for the dispatch on f and EDI is moved into ECX for the dispatch on b. The difference is that the call target can&#8217;t be burned into the call-site. Instead, we use the method-table to get at the address:

[code lang=csharp]
  
mov eax,dword ptr [ecx]
  
call dword ptr [eax+38h]
  
[/code]

We first dereference ECX, which holds the this pointer, and store the result in EAX. Then we add38h to EAX to get at the correct slot in the vtable. Because this vtable was discovered using the thispointer, the address will differ for f and b, and the call through b will end up going through the override. We call the address of that slot. Remember, we stated above that all classes in a hierarchy use the same offsets for methods, meaning that this same offset can be used for all derived classes.

The full IA-32 for this calling sequence (using the f pointer) is:

[code lang=csharp]
  
mov ecx,esi
  
mov edx,dword ptr ds:[01B4303Ch]
  
push 0Ah
  
push 0Ah
  
mov eax,dword ptr [ecx]
  
call dword ptr [eax+38h]
  
[/code]

Again, the only difference when b is used is that EDI, instead of ESI, is moved into ECX.

### Indirect Method Calls (calli)

C# doesn&#8217;t supply a mechanism with which to emit a calli instruction in the IL. You can, of course, emit code using the Reflection.Emit namespace (described in <a style="text-decoration:none;color:#325984;" href="http://codeidol.com/csharp/net-framework/Inside-the-CLR/Just-In-Time-%28JIT%29-Compilation/BBL0076.html#1307">Chapter 14</a>), but an example would introduce more complexity than necessary. If you were to imagine that a calli sequence were being JIT compiled, the only difference introduced would be that the native call instruction would perform a call dword ptr [exx], where exx is the register in which the target address of the calli was found; that is, it calls the address to which the indirect pointer refers. All of the arguments would be passed in accordance to the method token supplied to the calli instruction.

### Dynamic Method Calls (Delegates, Others)

There is a range of dynamic method calls available. Many of them are part of the dynamic programming infrastructure — discussed in depth in <a style="text-decoration:none;color:#325984;" href="http://codeidol.com/csharp/net-framework/Inside-the-CLR/Just-In-Time-%28JIT%29-Compilation/BBL0076.html#1307">Chapter 14</a> — and thus won&#8217;t be explored in depth here. They are all variants on the same basic premise, which is that some piece of runtime functionality is able to look up the method-table information at runtime to make a method dispatch.

Delegates were described in detail in <a style="text-decoration:none;color:#325984;" href="http://codeidol.com/csharp/net-framework/Inside-the-CLR/Just-In-Time-%28JIT%29-Compilation/BBL0014.html#70">Chapter 2</a>. We&#8217;ll use them as the basis for our discussion here. Recall that a delegate is essentially a strongly typed function pointer type, an instance of which has two pieces of information: the target object (to be passed as this), and the target method. Each delegate type has a special Invoke method whose signature matches the function over which it has been formed. The CLR supplies the implementation of this method, which enables it to perform lightweight dispatch to the underlying method.

A call to a delegate looks identical to a call to a normal method. The difference is that the target is the delegate&#8217;s Invoke method-table slot instead of the underlying function. Arguments are laid out as with any other type of call (i.e.,_fastcall). The implementation of Invoke simply patches the ECXregister to contain the target object reference (supplied at delegate construction time) and uses the method token (also supplied at delegate construction time) to jump to the appropriate method-slot. There is very little overhead in this process, which makes delegate dispatch on the order of zero to one times slower than a simple virtual method call.

### A Word on More Dynamic Invocation Mechanisms

The various other styles of method dispatch — such as Type.InvokeMember, MethodInfo.Invoke, and so forth — all add a certain level of overhead for binding to the target method. Delegates don&#8217;t ordinarily suffer from this because the method token is embedded in the IL. You may dynamically construct and invoke delegates (e.g., with DynamicInvoke), which does add a comparable level of overhead for the construction and binding. Lastly, the more dynamic mechanisms listed above tend to pass arguments in as object[]s, meaning that the dispatching code inside the CLR must transform that into the appropriate calling convention to perform the invocation (and then do the necessary marshaling on the return).

### Prologues and Epilogues

Every method is responsible for performing a set of actions (called a _prologue_ and _epilogue_) to set up the activation frame and return back to the caller at the end. The fastcall convention dictates that the callee is responsible for &#8220;cleaning the stack&#8221;; this simply means that the caller must ensure that any modifications to the stack (e.g., for arguments) have been restored prior to the return. In summary, this process involves:

  * The current stack address is saved (which is a back-link to the caller&#8217;s stack frame) by pushing the EBP (base pointer) address onto the stack. The current value of ESI (stack pointer, implicitly used by push, pop, call, ret) is then stored in EBP, forming the beginning of the called method&#8217;s new activation frame. This process enables the callee to later restore the stack during the prologue to its position just prior to the method call simply by popping the address back into EBP.
  * If the function intends to modify registers EDI or ESI (among others), it must save them on its stack during the prologue and restore them in the epilogue.
  * ESP is decremented by a number of bytes (the stack grows downward), equal to the number of bytes necessary to store the method&#8217;s local variables. Local variables are initialized, usually by just storing 0 into the various offsets relative to EBP, for example mov dword ptr [ebp-10h],0.
  * The body of the method is then executed. It references items passed and stored on the stack using an offset from EBP, for example arguments and locals, throughout its method body.
  * The callee &#8220;cleans the stack&#8221; by restoring the EBP and ESP stack pointers to their previous values, essentially doing the reverse of what the prologue did. It uses the ret instruction to restore the previous EIP (which call implicitly saved on the stack) and (optionally) returns a value to the caller.
  * Execution continues as normal at the next instruction (EIP) after the call was made.

Throughout the process of executing method calls, the physical stack is growing and shrinking (which simply means the EBP and ESP pointers refer to varying locations on the stack), and causes activation frames to be conceptually pushed and popped off (by the prologues and epilogues).

### Viewing Stack Frames

The whole process of constructing activation frames is visible at a high level when you view a stack trace, for example in the debugger, resulting from an exception, or by capturing one manually:

[code lang=csharp]
  
using System;
  
using System.Diagnostics;

class Foo
  
{
      
static void Main()
      
{
          
A();
      
}

static void A()
      
{
          
B(10, 50);
      
}

static void B(int x, int y)
      
{
          
C("Hello", x * y);
  
<a style="text-decoration:none;color:#325984;" name="393"></a><a style="text-decoration:none;color:#325984;" name="idx-131"></a>
      
}
      
static void C(string label, int num)
      
{
          
StackTrace trace = new StackTrace();
          
Console.WriteLine(trace.ToString());
      
}
  
}
  
[/code]

Running this program prints out some information about the chain of activation frames leading up to the new StackTrace() statement in C:

[code lang=csharp]
      
at Foo.C(String label, Int32 num) in c:\&#8230;\stack.cs:line 23
      
at Foo.B(Int32 x, Int32 y) in c:\&#8230;\stack.cs:line 18
      
at Foo.A() in c:\&#8230;\stack.cs:line 13
      
at Foo.Main() in c:\&#8230;\stack.cs:line 8
  
[/code]

Most of the interesting information is not captured in this view — you&#8217;ll have to drop down into a debugger to get the low-level details — but this at least demonstrates the high-level bits of information.

### 64-Bit Support

Versions 1.0 and 1.1 of the CLR only had a JIT Compiler that produced code targeting 32-bit x86 and IA-32 instruction sets. With the introduction of 2.0, the JIT Compiler also produces code to target Intel&#8217;s 64-bit Itanium family of processors (IA-64), and AMD&#8217;s 64-bit family of processors (AMD-64 or x64). AMD&#8217;s instruction set is actually very similar to the IA-32 (a.k.a. x86) instruction set, of course, with widened storage for 64-bit native data. The Itanium IA-64 instruction set, on the other hand, is vastly different. A full description of these differences is entirely beyond the scope of this book.