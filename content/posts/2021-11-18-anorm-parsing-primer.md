---
title: Anorm Primer
author: higherkindedtype
layout: post
url: /posts/anorm-primer
date: 2021-11-18
categories:
  - Scala
  - Anorm
summary: |
  A primer on Anorm to use the interesting parts - core and combinator functions, as opposed to the mundane way of reading the column from `Row`. The post highlights situations when you don't have a predefined type for the parsed row, and you are dealing with discrete columns in the result set based on time and need.
---

Typically, you would read the results of an [Anorm](http://playframework.github.io/anorm/) query, and map to a already defined type - `case class`, something like this:

```scala
val persons: List[Person] =
  SQL("select id from ....")
    .on(...)
    .getRows()
    .map(toPerson)

final case class Person(id: Int, name: String, weight: Float)

def toPerson(row: Row): Person =
  Person(
    row[Int]("id"),
    row[String]("name"),
    row[Float]("weight"),
  )
```

There are times when you would want to read a single column. Or perhaps a set of columns for which you don't have a pre-defined type (like `Person` above). In such cases, you will toil as follows:

```scala
val ids: List[Int] =
SQL("select id from ....")
    .on(...)
    .getRows()
    .map(row => row[Int]("id"))

// or

val ps: List[(Int, String)] =
  SQL("select id from ....")
    .on(...)
    .getRows()
    .map { row =>
      (
        row => row[Int]("id"),
        row => row[String]("name")
      )
    }
```

Note that the following is different from what we are discussing here.

```scala
// NOTE: We are not talking about this !!!
val count: Long = SQL("select count(*) from users").as(scalar[Long].single)
```

### Using core Anorm functions

```scala
import anorm.{SQL, SqlParser}, SqlParser.{int, str, to}

val result: List[Int] =
  SQL("select id from persons where ...")
    .on(...)
    .as(int("id"))

val result: List[Int ~ String] =    // Anorm's type `~` for chanining types (much like shapeless HList)
  SQL("select id, name from ....")
    .on(...)
    .as(int("id") ~ str("name"))
```

### Anorm's parser combinators 101

Extracting a reusable parser for your query

```scala
val resultSetParser: ResultSetParser[List[Int ~ String]] = int("id") ~ str("name")
```

```scala
val parser: ResultSetParser[List[(Int, String)]] =
  resultSetParser.map { case n ~ p => (n, p) }

// Shorthand of the above using built-in `flatten` function
val parser: ResultSetParser[List[(Int, String)]] =
  resultSetParser.map(flatten).*

// The finishing touch!
val result: Map[Int, String] =
  SQL(query)
    .on(...)
    .as(parser)  // List[(Int, String)]
    .toMap
```

### A Bit More of Anorms' Parser Combinators

Anorm provides a bunch of other parser combinators. Check Anorm's documentation for more details but here is a teaser:

#### Explicit control of how much to read from the `ResultSet`

```scala
val parser: ResultSetParser[List[(String, Int)]] =
  for {
    name <- str("name")
    age  <- int("age")
  } yield name -> age


val exactlyOne: (String, Int)         = SELECT("select ...").as(parser.single)
val zeroOneOrMore: List[(String, Int) = SQL("select ...").as(parser.*)
val oneOrMore: List[(String, Int)     = SQL("select ...").as(parser.+)
```

#### The `to` combinator to the rescue

```scala
import anorm.SqlParser.{ int, str, to }

def show(name: String, age: Int): String =  s"...."

val parser: ResultSetParser[List[(String, Int)]] =
  str("name") ~ int("age").map(to(show _))
```

#### Parser using Pattern matching

```scala
val parser: ResultSetParser[List[(String, Int, Boolean)]] =
  str("name") ~ int("age") ~ str("millionaire").map {
    case n ~ l ~ "T" => (n, l, true)
    case n ~ l ~ "F" => (n, l, false)
  }.*
```
