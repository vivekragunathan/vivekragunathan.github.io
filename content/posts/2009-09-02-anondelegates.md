---
title: Curious Case Of Anonymous Delegates !!!
author: vivekragunathan
layout: post
date: 2009-09-02T18:29:00+00:00
url: /2009/09/02/anondelegates/
categories:
  - 'C#'
  - CodeProject
  - Uncategorized

---
<a href="http://msmvps.com/blogs/senthil/default.aspx" target="_blank">Senthil</a> has left us thrilled in his <a href="http://msmvps.com/blogs/senthil/archive/2009/09/01/anonymous-methods-as-event-handlers-part-1.aspx" target="_blank">new post</a>, and also inspired me to write about the <a href="http://msdn.microsoft.com/en-us/library/0yw3tz5k(VS.80).aspx" target="_blank">topic</a>. Although, anonymous delegates have become a mundane stuff amongst programmers, there is still these subtle stuff left unexplored. Alright, let us try to answer Senthil&#8217;s question before he unravels the mystery in his next post.

A delegate is identified by its target. The target is the method to be executed on a delegate invocation and its associated instance or type. If the target is an instance method, the delegate preserves the target method pointer and the object instance. If the target is a static method, the delegate preserves the target method pointer and the type to which it belongs. So when a code like the one below to register a method to an event (or multicast delegate) is executed, a delegate object (EventHandler here) with the target information embedded is created and added to the invocation list of the event (or multicast delegate, KeyPressed here).

<pre style="font-family:Consolas;font-size:12pt;background-color:#eeeeee;">class SomeForm
{
   private Control control = new Control();

   public void OnFormLoad(object sender, EventArgs args)
   {
      control.KeyPressed += new EventHandler(OnKeyPressed);
   }

   // Rest of the code omitted to be succinct
};</pre>

Likewise, when unregistering the method handler, a new (EventHandler) delegate object is created with the same target information as above. As said earlier, a delegate is identified by its target. In other words, the Equals override on the delegate uses the target information for comparing two delegate objects. Hence in the following code that unregisters the method handler, the invocation list is searched for a delegate instance with the specified target information (Method: OnKeyPressed, Instance: SomeForm instance).

In the case of anonymous delegates, the compiler transforms the inline method code into a

  * static method, if the inline method code does not use any of the class&#8217;s instance members or local variables or if it uses only the static members of the class.
  * instance method, if the inline method code uses at least one class member, any or no static members, and no local variables.
  * class with a method that represents the inline method code, if the inline method code uses local variables no matter whether it uses the class members or not.

Those might not be the extensive set of rules but sure are enough for our discussion. Given the following questionable code,

<pre style="font-family:Consolas;font-size:12pt;background-color:#eeeeee;">public EventHandler IfEnabledThenDo(EventHandler actualAction)
{
   return (sender, args) =&gt; {
      if (args.Control.Enabled)
      {
         actualAction(sender, args);
      }
   };
}

public void Initialize()
{
   control.KeyPressed += IfEnabledThenDo(control_KeyPressed);
}

public void Destroy()
{
   control.KeyPressed -= IfEnabledThenDo(control_KeyPressed);
}</pre>

we realize, without doubt, that the anonymous delegate (returned by IfEnabledThenDo) would be transported into a compiler generated anonymous class. Later when IfEnabledThenDo is called for registering\unregistering the method handler, an instance of anonymous class is created and the (EventHandler) delegate is returned. And here lies the subtlety. Although the delegate from IfEnabledThenDo targets the method inside the anonymous class, the instance preserved as a part of the target information are different during registration and un-registration. In other words, the target method of the delegate returned by IfEnabledThenDo belong to different instances of the anonymous class. Hence the pretty code to unregister the (key pressed) method handler would not be actually unregistering since there would be a delegate previously registered in the invocation list of the (KeyPressed) event with the target instance same as the one used in the unregistration line of code. Very subtle!

Usually the hand written code tends to keep the registration and unregistration of the method handlers in the same class and so belong to the respective instances. Not so when you like watching the compiler magic.

Let us wait and see what <a href="http://msmvps.com/blogs/senthil/default.aspx" target="_blank">Senthil</a> says.
