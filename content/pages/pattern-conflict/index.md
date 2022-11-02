---
title: Pattern Conflict
author: vivekragunathan
layout: page
url: /pages/pattern-conflict
date: 2010-10-08T17:56:18+00:00
summary: Are your classes that implement the Template Method Design Pattern “Decorator aware”?

---

Are your classes that implement the Template Method Design Pattern “Decorator aware”?

------

> This article was co-authored with [Sanjeev](http://www.codeproject.com/script/Articles/MemberArticles.aspx?amid=172038) and [published](https://www.codeproject.com/KB/architecture/DecoratorVsTemplateMethod.aspx) on  [CodeProject](www.codeproject.com) titled _“Please don’t fail me!” – Decorator says to Template method_

------

## Introduction

This article is a result of serendipity that I experienced when implementing a small framework. As an ardent fan of design patterns I tend to use them where ever I could. I had a few classes in my framework in which I used the “Template Method” Design Pattern. When I wanted to extend my classes without modifying them, the first pattern that came to my mind was the Decorator Design Pattern. This article explains what problems I encountered during this implementation and how they were circumvented. Do these patterns gel well? Please read on to find out the answer.

## Assumptions

This article assumes knowledge in the following areas

- Object Oriented Programming
- Design Patterns, especially Decorator and Template Method.

## Problem

Consider a Shape class like the one below, which is the base class for all Shapes, viz Circle, Rectangle, Square, etc.

```cpp
class Shape
{
public: typedef void (Shape::*TemplateMethodFuncPtr)();
private: std::string _ type;

public: Shape(const std::string& type) : _ type (type)
        {
        }

public: std::string Type() const
        {
           return _type;
        }

protected: virtual void CreateDC() = 0;
protected: virtual void InitDC() = 0;
protected: virtual void Paint() = 0;
protected: virtual void ReleaseDC() = 0;

public: void Draw()
        {
           cout << "Drawing " << Type();

           CreateDC();
           InitDC();
           Paint();
           ReleaseDC();
        }
};
```

The Shape class listed above implements the template method design pattern via the Draw method. The custom shapes like Circle or Rectangle would have to implement the pure virtual functions – CreateDC, InitDC, Paint, ReleaseDC – in order to be drawn. For instance, a Circle shape may be hypothetically implemented as follows:-

```cpp
class Circle : public Shape
{
public: Circle() : Shape("Circle")
        {
        }

protected: void CreateDC()
           {
              cout << std::endl << "Circle::CreateDC";
           }

protected: void InitDC()
           {
              cout << std::endl << "Circle::InitDC";
           }

protected: void ReleaseDC()
           {
              cout << std::endl << "Circle::ReleaseDC";
           }

protected: void Paint()
           {
              cout << std::endl << "Circle::Paint";
           }
};
```

The typical usage of the above classes would be as follows:-

```cpp
void main()
{
   //
   // Previous Code...
   //

   Shape* s = new Circle();
   s->Draw();

   //
   // Later Code...
   //
}
```

The output of the above program should be obvious.

As in the story of any application development, the Circle must be extensible without modifying the existing classes. For instance, the Circle may be filled; its border color and thickness may be changed, and so on. Let us say we want to fill the Circle. We have a couple of options:-

Derive a class from Circle, say FilledCircle and override the Paint method – This technique is not scalable, and cannot be used for filling other types of shapes. Besides, this is an approach which would result in a combinatorial explosion of classes depending on the extenders desired.

Use a decorator, say ShapeFiller – This technique is extremely scalable since we can apply this to any Shape class.

Per the topic of the discussion, we choose Option #2.

Following is a hypothetical implementation of the ShapeFiller (Decorator) class:-

```cpp
class ShapeFiller : public Shape
{
private: Shape* _shape;

public: ShapeFiller(Shape* shapeTobeFilled)
            : Shape(shapeTobeFilled->Name()),
           _shape(shapeTobeFilled)
        {
        }

protected: void CreateDC()
           {
              // CDC1: Call the underlying shape's CreateDC
              _shape->CreateDC();

              cout << std::endl <InitDC();

              cout << std::endl <ReleaseDC();

              cout << std::endl <Paint();

              // Paint2: Custom logic to fill the shape
              // (forget the color). Do you see it filling?

              cout << std::endl << "ShapeFiller::CreateDC";
           }
};
```

There are several things to be observed in the above implementation.

The above class will not compile, complaining the following error:-

```
error C2248: 'Shape::CreateDC' : cannot access protected member declared in class 'Shape'
error C2248: 'Shape::InitDC' : cannot access protected member declared in class 'Shape'
error C2248: 'Shape::ReleaseDC' : cannot access protected member declared in class 'Shape'
error C2248: 'Shape::Paint' : cannot access protected member declared in class 'Shape'
```

Although no custom logic is required in the CreateDC, InitDC and ReleaseDC methods of the ShapeFiller, they must have to be implemented simply as place holders forwarding calls to the underlying shape (needless those methods are pure virtual). The quickest remedy may seem to have default (empty) implementation for the above methods in the Shape class. Doing so would not be creating (init and release) the DC when using the ShapeFiller class. In other words, application will misbehave (probably crash) when attempting to Paint().

The other (ugly) remedy may be making the protected methods – CreateDC, InitDC, ReleaseDC – public. It is a bad design choice. In the Object Oriented world, it is a crime.

So that is the problem – Attempting to extend a class that implements Template Method design pattern using Decorator design pattern results in a near-predicament situation.

**Intent of Decorator Pattern [GoF]**

- Attach additional responsibilities to an object dynamically.
- Decorators provide a flexible alternative to sub-classing for extending functionality.

**Intent of Template Method Pattern [GoF]**

- Define the skeleton of an algorithm in an operation, deferring some steps to subclasses.
- Template Method lets subclasses redefine certain steps of an algorithm without letting them to change the algorithm’s structure.

As stated in the intent, the Decorator pattern avoids sub-classing while the Template Method pattern relies on it. Secondly, the Template Method need not publicize all the steps involved in an algorithm. On the other hand, the Decorator pattern relies on the public interface of the class it intends to decorate. Evidently, in our case, adopting the decorator pattern blows the purpose of the Template Method pattern.

### Conclusion – Is there a Solution?

Yes and No.

**YES**

Approach 1: Make the class that uses the template method design pattern Decorator Pattern aware

Consider the new Shape class

```cpp
class Shape
{
friend class ShapeDecoratorBase;

public: typedef void (Shape::*TemplateMethodFuncPtr)();
private: std::string _ type;

public: Shape(const std::string& type) : _ type (type)
        {
        }

public: std::string Type() const
        {
           return _type;
        }

protected: virtual void CreateDC() = 0;
protected: virtual void InitDC() = 0;
protected: virtual void Paint() = 0;
protected: virtual void ReleaseDC() = 0;

public: void Draw()
        {
                            cout << "Drawing " << Type();

           CreateDC();
           InitDC();
           Paint();
           ReleaseDC();
        }
};
```

Instead of every individual decorator bloat the code with redundant code that forwards calls to the underlying shape object, a common ShapeDecoratorBase base class is introduced. In other words, ShapeDecoratorBase truly implements the decorator pattern. This class is made a friend of the Shape class (Yes, a friend. Some readers think that using friends is a bad design, I suggest them to follow the link “When to use friends”). The individual decorators may now derive from ShapeDecoratorBase and implement the Paint method to decorate the underlying shape.

The ShapeDecoratorBase class is defined as follows:-

```cpp
class ShapeDecoratorBase : public Shape
{
protected: Shape* _shape;

public: ShapeDecoratorBase (Shape* shapeTobeFilled) : Shape(shapeTobeFilled->Name()),
           _shape(shapeTobeFilled)
        {
           cout << std::endl << "ShapeDecoratorBase Ctor";
        }

public: ~DecoratorBase()
        {
           cout << std::endl << "ShapeDecoratorBase Dtor";
        }

protected: void CreateDC()
           {
              cout << std::endl << "ShapeDecoratorBase::CreateDC";

              // CDC1: Call the underlying shape's CreateDC
              _shape->CreateDC();
           }

protected: void InitDC()
           {
              cout << std::endl << "ShapeDecoratorBase::CreateDC";

              // IDC1: Call the underlying shape's CreateDC
              _shape->InitDC();
           }

protected: void ReleaseDC()
           {
              cout << std::endl << "ShapeDecoratorBase::CreateDC";

              // RDC1: Call the underlying shape's ReleaseDC
              _shape->ReleaseDC();
           }

protected: void Paint()
           {
              cout << std::endl << "ShapeDecoratorBase::Paint";

              // Paint1: First call the underlying shape's CreateDC
              _shape->Paint();
           }
};
```

Here is the revised implementation of the ShapeFiller Decorator class

```cpp
class ShapeFiller : public ShapeDecoratorBase
{
public: ShapeFiller(Shape* shapeTobeFilled) : ShapeDecoratorBase(shapeTobeFilled)
        {
           cout << std::endl << "ShapeFiller Ctor";
        }

public: ~ShapeFiller()
        {
           cout << std::endl << "ShapeFiller Dtor";
        }

protected: void Paint()
           {
              DecoratorBase::Paint();

              // Paint2: Custom logic to fill the shape (forget the color).
              // Do you see it filling?

              cout << std::endl << "ShapeFiller::CreateDC";
           }
};
```

The ShapeFiller class now works as expected. We can now have more classes like ShapeBorderThickener etc implemented similarly.

Approach 2: Using member function pointers to implement the template method design pattern. This technique is not discussed further since it is a far less elegant approach than Approach 1. In other words, it hurts the eyes of an object oriented programmer. However, the source code is attached for reference.

### Downside

The major downside of these two approaches is that both require access to the source code of the base class (The Shape class in our case). This might not be possible in all situations. If the framework implementer had not given forethought about this problem, we are led to an impasse to choosing an elegant solution.

Needless to say, the ShapeDecoratorBase class has to be provided by the framework designer and not by the user of the framework.

It must be understood that it is not just the Template Method class that should be made aware of the Decorator but it is the Programmer/Framework designer who must be aware of such scenarios. It is the framework designer who decides if a class should be made extensible or not.

### NO

The situation cannot be resolved if the source of the base class is not accessible. If the template method class is NOT implemented to be Decorator aware, the Decorator Pattern cannot be used.

The other option, which is inheritance, has to be pursued that has its own set of problems.

## The final word

I hope this article has brought to light a subtle and interesting issue when using the decorator design pattern with the Template Method design pattern.

“When you implement a framework, give a thought if your classes that implement the Template method design pattern need to be made Decorator aware”

Happy Designing!