---
title: 'JAR Tips: Loading dependencies'
author: vivekragunathan
layout: post
date: 2015-09-13T19:42:16+00:00
url: /2015/09/14/jar-tips-loading-dependencies
categories:
  - Java
  - Programming
  - Uncategorized

---
If you are writing a typical console based application in Windows, you would end up with an executable (exe). You might also have one or more dependent libraries (DLL). The question is where do we place these DLLs so that they are picked up at runtime by the application; loaded and consumed. Actually it is no brainer, just put them along side the console application executable. Or you could place the DLLs in the *System32* directory. Or you could add the directory to the *PATH*. Well, my point was actually to say that the DLLs can be simply placed alongside the executable and it would be picked up.

<!--more-->

If you have been spoiled like me with Windows ease, you would find it a bit odd to meddle with the Java JARs. Again, if you are writing a typical console based application in Java[^1], and if your application depends on one or more libraries [JARs], where do we place these JARs so that your application will pick them up for loading and consuming at runtime?

Few things to note:

- You have to configure your project such that the JAR is an executable and not a consumable library.
- Of course, placing the dependent JARs alongside your application would not work.
- I will be using Maven for the project scaffold and build purposes.

First let us make an executable JAR. Let us Maven to tell Java that there is an entry point in the JAR that the runtime should use start executing unlike just loading the JAR.

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>2.4</version>
    ....
</plugin>
```

Now we have to specify the Java compiler to bake in the directories where to look for dependent JARs aka provide additional [classpath](http://docs.oracle.com/javase/tutorial/essential/environment/paths.html) [^2] so that the runtime will look up and load them. We will instruct Maven to deal with that.

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>2.4</version>
    <configuration>
        <archive>
            <manifest>
                <mainClass>fully-scoped-class-name-that-contains-main-method</mainClass>
                <addClasspath>true</addClasspath>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

Code is better than a thousand words. You can [grab](https://gitlab.com/VivekRagunathan/jarload.git) a working sample and see it for yourself. Should you need to add or re-define the lookup directory, you could add a `classpathPrefix` or additional `Class-Path` under `manifestEntries` in the pom file depending on your scenario.

Now we have an executable JAR that can load its dependent JARs from the current directory.

[^1]: Don’t wonder that I am comparing Java and Windows – a language/technology with an operating system. 
[^2]: You could use `CLASSPATH` environment variable to specify the dependent JARs location. But be aware that changes to `CLASSPATH` is applicable system-wide, and might work against us in times of conflict between applications on the same machine. Besides, it is better to have the configuration changes local to our application. 
