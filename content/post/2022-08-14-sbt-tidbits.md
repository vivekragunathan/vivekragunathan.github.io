---
draft: true
title: SBT Tidbits
author: higherkindedtype
layout: post
url: /posts/sbt-tidbits
aliases:
  - /posts/sbt-for-the-impatient
date: 2022-08-14
categories:
  - Scala
summary: |
  SBT is a lot of things; complex and powerful. Familiarity is the only way to tame SBT. Gaining familiarity is a daunting task with SBT. This post distills the mighty SBT into a few mantras to get you up and running in no time.

---

- sbt build is a collection of settings that are loaded from various places
    - global plugins (`~/.sbt/1.0/plugins`)
    - project plugins (`<project-folder>/project/`)
    - project settings (`build.sbt`)
- Cache `.ivy2` and `.sbt` on CI like the way it happens on local for speed
- `consoleProject` - Starts Scala interpreter with sbt and build definition
    - `buildStructure.eval.settings.size` - Prints the total number of settings found in the project
- Chain commands `sbt clean compile test:compile`
- `inspect <setting>` - `inspect tree SourceDirectory`, `inspect sourceDirectory`
- Force resolution from a specific resolver
    
    ```scala
    updateOptions := {
      val resolvers = Map("com.org" % "fancy-lib" % "1.0.0" -> myResolver)
    }
    ```
    
- Treat `Ctrl+C` to stop current task instead of exiting sbt
    
    ```scala
    cancelable in Global := true
    ```
    
    ```scala
    # To fork all test tasks (test, testOnly, and testQuick) 
    # and run tasks (run, runMain, Test / run, and Test / runMain),
    fork := true
    
    # To only fork Compile / run and Compile / runMain:
    Compile / run / fork := true
    
    # To enable forking all test tasks only
    Test / fork := true
    
    # -- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    
    # Use the following command to kill everything java 
    # except sbt (when fork is enabled)
    kill -9 `ps -h |
      grep java |
      grep -v sbt-launch |
      grep -v grep | awk '{print $1}'`
    ```
    
- `Test / testOptions += Tests.Argument("-oT")`
    - `-oI`: List failed tests at the end of the build cycle
    - `-oT`: List failed tests with a short stack trace
    - `-oG`: List failed tests with full stack trace

**Resources I am ever grateful for**

- [SBT - A Task Engine](https://jazzy.id.au/2015/03/03/sbt-task-engine.html)
- [SBT - A Declarative DSL](https://jazzy.id.au/2015/03/04/sbt-declarative-dsl.html)
- [How to waste less time with SBT](https://youtube.com/watch?v=qkQoKWBlWok)