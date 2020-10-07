---
title: Anonymous Classes vs Delegates !!!
author: vivekragunathan
layout: post
date: 2011-03-08T17:10:16+00:00
url: /2011/03/08/anonymous-classes-vs-delegates/
categories:
  - 'C#'
  - Uncategorized

---

I am not a java programmer. By that, I do not mean I am against Java. As a programmer by profession and passion, I try to learn things along the way. That includes a little of bit of Java. I should say that my proper encounter, so to say, with Java is a simple application that I am trying out with Android. There might be some hard core differences and/or limitations in the Android version of Java. But I am almost certain that I am using only primary level features of Java.

In android, there is this <span style="font-family:Consolas;font-size:11pt;">OnClickListener</span> interface, which is used as a callback interface for a button click. So, it is used something like this:-

```csharp
// Create an anonymous implementation of OnClickListener
private OnClickListener mCorkyListener = new OnClickListener() {
    public void onClick(View v) {
        // do something when the button is clicked
    }
};

protected void onCreate(Bundle bundle) {
    ...

    Button button = (Button)findViewById(R.id.someButton);
    button.setOnClickListener(new OnClickListener() {
        @Override
        public void onClick(View v) {
          // Click handler action code...
        }
    });
    ...
}
```

`OnClickListener`, which is an interface with a single method `onClick`, represents _a type for the button click event_. The highlighted portion of the code that registers an event handler for the button click action is called an Anonymous Class definition. That is some really some clever syntax; although it seems a wrong tool for our purpose here. Actually the click event requires only a method to call when the button is clicked. Nothing more. So why do we need an interface here?

I know of a better way in C#. Back there, it is called a `delegate`. In simple words, a delegate is an object-oriented pointer to a function, and it could point to any public \ private instance \ static function of any class. So a delegate is a good fit for our situation here. If the highlighted portion of the code (event registration) were to be written in C#:-

```csharp
button.setOnClickListener(delegate(View v) {
    // Click handler action code....
});
```

I have gone one step further and used an anonymous delegate, which is even more succinct. Sometimes, less syntactic noise is a good feeling for a programmer. I am not doing a language war here. I am just trying to vote for delegates in Java. I am not sure if they are already there in one of the latest versions.

But there is a C# fanatic inside of me, which compels me to show the world how better and good-looking (see pascal casing) C# code actually is.

```csharp
protected void OnCreate(Bundle bundle)
{
    var button = FindViewById&lt;Button&gt;(R.Id.SomeButton);
     button.Click += delegate(View v) {
        // Click handler code.
    };
}
```

Beauty lies in the eyes of the beholder!

Nevertheless, anonymous class is definitely a wonderful and powerful syntax, but does not look good in the example above.
