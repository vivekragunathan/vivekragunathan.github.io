---
title: scala-cli Cheatsheet
author: higherkindedtype
layout: page
date: 2021-10-21T00:00:00+00:00

---

### Compile file(s) / folder

```bash
scala-cli compile Hello.scala

# Compile with dependent classes
scala-cli compile Hello.scala Includes.scala

# Compiles all Scala files in the folder
scala-cli compile .
```

### Compile and run Scala files / folder

```bash
# Compile and run `main` in Hello.scala
scala-cli run Hello.scala

# `run` command is the default and may be omitted for running the class
scala-cli Hello.scala

# Compile and run `main` with all associated files listed
scala-cli Hello.scala Utils.scala

# Compile the whole directory and run `main`
scala-cli .
```

### Running Scripts

**HelloScript.sc**

```bash
#!/usr/bin/env scala-cli
println("What a wonderful world!")
```

```bash
scala-cli run HelloScript.sc
```

### Running gist

```bash
scala-cli https://gist.github.com/<user-handle>/<gist-id>
```

### Specify Dependencies

```bash
scala-cli compile Hello.scala --dependency org.typelevel::cats-core:2.6.1

scala-cli compile Hello.scala --jar /path/to/library.jar
```

### Watch for changes

```bash
scala-cli --watch .

scala-cli --watch Hello.scala

scala-cli compile --watch Hello.scala
```

### Specify Scala Version

```bash
scala-cli compile --scala 2.13.6 Hello.scala
```

### Picks the highest corresponding stable Scala version

```bash
scala-cli compile --scala 2.12 Hello.scala
scala-cli compile --scala 2 Hello.scala
scala-cli compile --scala 3 Hello.scala
```

### Compiler Options

```bash
scala-cli compile Hello.scala -Xlint:unused
```

### Compiler Plugins

```bash
scala-cli compile \
  --scala 2.13 \
  --compiler-plugin com.olegpy:better-monadic-for:0.3.1 \
  Hello.scala
```

### Specify main

If there is more than one `main` found:

```bash
➜ scala-cli .

Compiling project (Scala 3.0.2, JVM)
Compiled project (Scala 3.0.2, JVM)
Found several main classes: Hello, Includes
```

... in that case:

```bash
scala-cli --main-class Includes .

Compiling project (Scala 3.0.2, JVM)
Compiled project (Scala 3.0.2, JVM)
Includes says hi!
```

### Specify JVM

```bash
scala-cli --jvm graalvm:21 .
```

### Packaging

Create a distributable library (eg. Maven)

```bash
scala-cli package --library Hello.scala -o hello.jar
javap -cp hello.jar hello.Hello
```

### Create a light-weight executable/launcher JAR

```bash
scala-cli package Hello.scala -o hello
```

### Create an heavy-weight executable assembly

```bash
scala-cli package --assembly Hello.scala -o hello
```

### Create an executable and package into a docker image

```bash
scala-cli package --docker Hello.scala --docker-image-repository hello-docker
```

### Create a native executable

```bash
scala-cli package --native Hello.scala -o hello-native

scala-cli package --native -S 2.13 --main-class Hello . -o hello-native
```

### REPL

```bash
➜ scala-cli repl .
Compiling project (Scala 3.0.2, JVM)
Compiled project (Scala 3.0.2, JVM)
Warning: found classes defined in the root package (Hello, Hello$, Includes, Includes$, test, test$, test_sc, test_sc$). These will not be accessible from the REPL.

scala> Includes.run(Array.empty)
Includes says hi!

scala> Hello.main(Array.empty)
Scala says Hello!  **  2021-10-22T11:23:47.327515

scala> Includes.echo("1234567890")
You said: 1234567890
```

### Scalafmt

There are some [known](https://scala-cli.virtuslab.org/docs/commands/fmt#current-limitations) limitation(s); hopefully for the time being.

```bash
scala-cli fmt

scala-cli fmt --check

scala-cli fmt --dialect scala212
```

### Clean

Removed all generated files (primarily those in `.scala/`)

```bash
scala-cli clean .
```
