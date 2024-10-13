---
title: Cross-JDK Compilation in SBT
author: higherkindedtype
layout: post
url: /posts/sbt-xcompile-jdk
date: 2024-10-13
tags: [ 'scala', 'sbt' ]

---

Recently, I had to cross-compile a bunch of Scala library repositories for JDK 11 and JDK 17. I was hoping SBT would natively support specifying the related configuration in `build.sbt` similar to `crossScalaVersions`.  I came across some references to plugins that seemed to do the job. But I couldn't find anything in their documentation that  proved they supported compiling for different JDK versions. They only seemed[^1] to provide better management and configuration options for cross compiling different Scala versions.

Unless there really exists a (better) way, let me show you what I went with. Just to be clear, SBT supports compiling for different JDK versions. It is not as fancy as you would think:

```scala
sbt -java-home <path/to/jdk11> package
sbt -java-home <path/to/jdk17> package
```

The caveat is you *have to* run the build more than once; like twice above. And that is what I *had to* go with. Well, the job doesn't end there. There are other things to take care of when cross compiling.

## Conditional Compilation

If you have code that uses JDK version specific types or features, you would have to conditionally compile it based on the JDK version. Why conditional compilation? Because ...

- Newer and richer features like [advanced](https://openjdk.org/jeps/441) pattern matching or [string templates](https://openjdk.org/jeps/430)
- Deprecated or removed packages and types such as `sun.security.x509`, `sun.misc.Unsafe` etc.

In such cases, the awesome [ifdef](https://github.com/eed3si9n/ifdef) plugin is your friend for conditional compilation. Here is how to set it up:

```scala
// Add this to plugins.sbt
addSbtPlugin("com.eed3si9n.ifdef" % "sbt-ifdef" % "0.3.0")
```

```scala
// Drop this in the `project/` folder
import sbt._
import sbt.Keys._
import com.eed3si9n.ifdef.sbtifdef._

object JdkConditionalCompilationSetupPlugin extends AutoPlugin {
  override def requires: Plugin = IfDefPlugin
  override def trigger = allRequirements

  object autoImport {
    val jdkVersion = settingKey[String]("JDK version")
  }

  override def projectSettings: Seq[Setting[_]] = Seq(
    jdkVersion := System.getProperty("java.specification.version"),
    ifDefSettings += IfDefConf("jdk", jdkVersion.value)
  )
}
```

The above plugin is enabled automatically without having to add it explicitly to the `.enblePlugins` list.

With that, you have enabled JDK version based conditional compilation like so:

```scala
import com.eed3si9n.ifdef.{ifdef, ifndef}

class TheBusinessLogicClass {
  @ifdef("jdk:11")
  def legacyStyleImpl(): Unit = {
    // JDK 11 specific implementation. Think a big
    // bloat of if-else based logic. Because we did
    // not have pattern matching back then.
  }

  @ifdef("jdk:17")
  def newerRicherImpl(): Unit = {
    // JDK 17 specific implementation; using
    // pattern matching and other features!
  }
}
```

Likewise, you can use `@ifndef("jdk:11")` annotation on methods that you want to exclude from compilation when not running on a certain JDK version (11 in this case).

> Highlight: `ifdef` also supports `&` and `|` operators. e.g. `@ifdef("jdk:9 | jdk:11")`

## Artifact Naming

Here is the rub. While you are able to compile for different JDK versions, when you publish, the artifacts will be published to the same path, which means they will end up overwriting each other. Duh!

We have to differentiate the artifacts published either by its name or path. Also a visual confirmation, if you will, that you are dealing with the right artifact for a given JDK version.

Following are some options:

- Update `artifactName` setting to include the JDK version

```scala
artifactName := { (sv: ScalaVersion, module: ModuleID, artifact: Artifact) =>
  val jdkVersion = System.getProperty("java.specification.version")
  s"${artifact.name}-${module.revision}-jdk$jdkVersion.${artifact.extension}"
}
```

- Publish to different paths (based on JDK version) in the Artifactory.

```scala
publishTo := {
	val jdkVersion = System.getProperty("java.specification.version")
	Some("release repo" at s"https://artifactory.mycompany.com/artifactory/<repo-path>/jdk$jdkVersion")
}
```

- Include JDK version in your project or artifact version.

```scala
version := {
  val jdkVersion = System.getProperty("java.specification.version")
	s"1.2.3-$jdkVersion"
}
```

There is no absolute winner. The choice depends on the factors such as team standards, operational and company policies etc. The simplest of them all - using JDK version in project version, may not be appealing because it does not follow semantic versioning; if you wish to stick to that.

---

[^1]: If my understanding of those plugins is not right or if there is some plugin that offers cross compiling for different JDKs, I would love to know.
