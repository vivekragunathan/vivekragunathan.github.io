---
title: Restricting sum type instance creation
author: higherkindedtype
layout: post
url: /posts/restrict-sum-types-creation
date: 2022-05-25
categories:
  - Scala
summary: |
  With Scala sum types, you can establish type strictness. But can you restrict creation of instances of sum types? So that you can guarantee that the values they hold pertain to the types defined.

---

I love ADTs and the compile time guarantee of exhaustiveness. Makes your business logic robust. Unfortunately, while the robustness pertains to the type, how do you ensure the guarantee also applies to the value held by instance of the type? In other words, we should prevent creating rogue instances of sum types with invalid values.

Consider the following ADT to understand how users have provided their names.  Ignore the logic behind determining how the different naming patterns are deduced. The `parse` method below is good enough to discuss the question in hand.

```scala
sealed trait Name

object Name {
  case class OnlyFirstName(value: String) extends Name

  case class FirstAndLastName(
    first: String,
    last: String
  ) extends Name
  
  case class FullName(
    first: String,
    middle: String,
    last: String
  ) extends Name
  
  def parse(raw: String): Validated[Name] = 
    if (…) new OnlyFirstName(…).valid
    else if (…) new FirstAndLastName(…).valid
    else if (…) new FullName(…).valid
    else "…".invalid
}
```

The definition is all good, provides the desired type robustness in narrowing down what exactly the user has provided as input. But there is a problem that the definition does not address.

It is still possible, anywhere in your application code, to create an instance of `OnlyFirstName` with a value that represents the full name. Might not be a big deal for user's name but I am sure you would agree you need such a guarantee for a real domain model in real time. 

> Wouldn't you like to have the absolute guarantee that the sum types can and will be only created as part of its definition (file where your `sealed trait` is defined)? Especially as part of and after input validation.

I bet you do. So, here is the trick to establish that guarantee:

```scala
// UserProvidedName.scala
sealed trait Name

object Name {
  sealed abstract case class OnlyFirstName(value: String) extends Name

  sealed abstract case class FirstAndLastName(
    first: String,
    last: String
  ) extends Name
  
  sealed abstract case class FullName(
    first: String,
    middle: String,
    last: String
  ) extends Name
  
  def parse(raw: String): Validated[Name] = 
    if (...) new OnlyFirstName(...) {}.valid
    else if (...) new FirstAndLastName(...) {}).valid
    else if (...) new FullName() {}.valid
    else "...".invalid
}
```

  * `abstract` - Prevent creating instances of the sum types; anonymous instances can still be created. See the `parse` method creating instances.
  * `sealed` - Prevent extending the types elsewhere but this file
  * `case class` - So that we can still pattern match sum types

Thus, the only way to create an instance of the sum types is by calling the `parse` method while maintaining the guarantees of sum types. 💥