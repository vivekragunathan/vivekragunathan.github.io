---
title: Application Models
author: HKT
layout: page
url: /pages/app-models
date: 2016-08-27T15:50:00+00:00
featured_image: images/app-models.jpg
image: images/app-models.jpg
---

> This article was published also on [LinkedIn](https://www.linkedin.com/pulse/application-models-vivek-ragunathan).

A typical business application is composed of several flows or use-cases. Also, these flows consist of logical ones like a transaction that spans several flows. Take for instance an e-commerce application which consists of user registration/login, product lookup, and one of the most important interactions in an e-commerce application &#8211; the shopping cart, and much more. Although these application flows might appear to be discrete and independent of one another, it is after producing a working solution that we realize that these flows are inherently interrelated for one reason or another. The idea of designing stateless application flows is many times confused with the relation between the flows.

<!--more-->

At high level, say architectural, there are two ways to model a large scale application with such flows:

Pattern #1: One way, a common way, is to model the way we see it. In other words, the user clicks a button on the user interface, the associated request is serviced by some business logic on the web/application server by making database and third-party calls, and a response is delivered back to the user interface. The thought process here is to consider every flow as an independent vertical path. That is why it is customary in this line of thought to package all the logic that ties to its origin from the presentation layer as a single and independent module; often times named after the flow. It is not necessary that the business logic or the entire logic of servicing the request is built into a single class or method. But it is independent of the logic in other flows that are directly or indirectly related. In other words, this pattern establishes an environment where individual flows are sandboxed from the other flows.

Pattern #2: Another way to model application flows is to first examine and identify the key players in action and how they are related to one another; in each of the flows and the application in general. In this line of thought, it is always the player in action through which a flow is explained and implemented. The key players are types/objects that encapsulate yet centralize business logic associated with that player. In other words, we identify and create a network of players that involve in a flow wholly or in part, actively or passively. It is relatively a complex way to model compared to pattern #1 above.

In his book, [Patterns of Enterprise Application Architecture][1], [Martin Fowler][2], authoritative voice and pundit on enterprise architecture, explains the above patterns very well. He calls pattern #1 _Transaction Script_, and pattern #2 (_Rich_) _Domain Model_ (the name for the key players in action).

Conceptually, _Transaction Script_ establishes discrete vertical paths of execution to service requests while _Domain Model_ establishes layered (primarily horizontal but vertical too) wherein each layer is composed of a network of objects that communicate with one another to service a request.

The book does not conclusively recommend or discard either pattern. Well, a book shouldn&#8217;t be casting opinions but present and educate the reader of all the options in the domain. In that regard, Martin Fowler is commendable.

However, in large-scale applications, _Transaction Script_ does more harm than good despite its praise for simplicity. Yes, _Transaction Script_ is considered simple flexible and secure compared to _Domain Model_. On the other hand, _Transaction Script_ based applications, in reality, are not at its worst where every flow is packaged into a single class. But despite a decent design of interrelated classes within a flow, _Transaction Script_ still poses a big difficulty &#8211; **triplication** (exaggerating duplication). Another mistaken belief with _Transaction Script_ is sandboxing of application flows. A change, say defect fix or an enhancement, in one flow, does not affect others. _Bear in mind it is also difficult to propagate the change when desired_.

_Domain Model_ is inherently complex and time-consuming, at first. It takes a team (not an individual) to identify and define the domain models (key players in actions) and their relationships. The domain models must be brainstormed to confirm the effects that they produce are acceptable or tolerable across flows. Generally speaking, this is considered time-consuming and when prolonged inefficient. With a business that is expecting results all the time, it is possible that the opinion is cast on the team/individual than the pattern.

The reason why _Transaction Script_ is preferred over _Domain Model_ is the false sense of taming the unknown in a vast code base. The software engineer or the team can make change to a particular flow and be confident that the change will not impact other flows. Nor will the code change made in another flow will impact his flow of interest; one that he might be responsible for. He doesn&#8217;t have to wonder why a particular feature is not behaving as expected when no change has been made in a long time.

For instance, localization is one of hard problems that software product teams encounter day in and day out. By localization, I do not mean just the text/messages on the presentation layer but even application behavior. It is typical to build localized application behaviors as Transaction Scripts to sandbox the changes &#8211; defect fixes or enhancements, to a particular localized application behavior.

On the contrary, _Domain Model_ is less entertained because the software is built to function on the premise of object relations, which is inherent of unwanted or unexpected side-effects. Take the case of localization. Imagine the mesh of object relations that power all of the localized application behaviors. One can only hope that the changes to one part of the code prove harmless to the rest of the application.

In other words, _Transaction Script_ promises to control butterfly effect particularly by sandboxing while _Domain Model_ is believed not have have any such control.

Such kind of fear and anxiety of the unknown arises depending on who the subject is; if he or she is a software engineer or not (by profession), or worse, his expertise in designing software applications. It is the kind of anxiety one would experience if he is not a surgeon and was asked to stitch back a dissected body. One of the important facets of software development is identifying, understanding and representing object/entity relationships; most of the times real-world, virtual at times. So a software engineer, **ignore the skill levels and team structures**, is expected to understand the nature and complexity of object/entity relationships in the application. The complexity is inherent to any large scale problem. It has to be understood and addressed.

_Transaction Script_ will get an application up and running but the sheer mass of the code in a few release cycles will bring it down to its knees. In the initial stages of the application development, when we are excited to the see application coming to life, it is common not to realize how far the application can progress in such a mode of development. It might be as well be a long time but in the mean time the excitement and the results not only clouds judgement but software engineers and teams end up defending the way they built the application. Such defense curtails new ideas, innovation, progress.

Even to this day, humans have not completely understood long term effects. We might cruise for the next few days but we will face a time when what we have done so far will become a burden. _Transaction Script_ oriented models are a perfect example. So what about _Domain Model_? Ignoring the complexity, would it solve all the problems and we can cruise forever? Such a line of thought is irrational and not healthy. As software engineers, we shouldn&#8217;t expect a miracle to set the application in its right path of progress.

The way the above patterns play in the real world, I happen to relate _Transaction Script_ with Agile and _Domain Model_ with Waterfall. Software engineers have been convinced that Agile and Waterfall are orthogonal and Agile yields faster and superior results than Waterfall. When teams are constantly demanded of results in the name of feedback for their product, Agile fits the need in the name of _Transaction Script_. Mind you, it is not Agile that is at fault. Agile has been institutionalized to discipline software engineers to think small and think only of the near-time end results rather than investing time and thought in building it the right way. Of course, what is _right_ is always put to debate.

* * *

<small>Image borrowed from <a href="http://www.binding-problem.com/binding-problem.jpg">here</a> using Google Search</small>

 [1]: http://www.informit.com/store/patterns-of-enterprise-application-architecture-9780321127426
 [2]: http://www.martinfowler.com
