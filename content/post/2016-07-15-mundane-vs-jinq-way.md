---
title: Mundane vs JINQ Way
author: vivekragunathan
layout: post
date: 2016-07-15T06:27:45+00:00
url: /2016/07/15/mundane-vs-jinq-way/
categories:
  - Java
  - Programming
  - Software Design
  - Uncategorized
tags:
  - design
  - Java
  - jinq
  - LINQ

---
New things are not always instantly accepted. Beyond skepticism, new things challenge the comfort people are accustomed to. JINQ[^1] wasn't particularly welcomed. It was either discarded as unknown angel or worse ... ridiculed. However, JINQ still promises expressive succinct code.

<!--more-->

Here is an example (morphed from real-time code). Tell me what it is trying to do.

```java
public Map<String, CostInfo> calculateCostsByDept() {
	final Map<String, CostInfo> costMap = new HashMap<>();

	for (Employee employee : employees) {
		if (!employee.intern) {
				continue;
		}

		CostInfo costInfo = costMap.get(employee.department);

		if (costInfo == null) {
			costInfo = new CostInfo(
				employee.department,
				employee.hikePercent,
				employee.hikeAmount
			);

			costMap.put(employee.department, costInfo);
		              
			continue;
		}

		costInfo.update(employee.hikeAmount, employee.hikePercent);
      
	}

	return costMap;
}
```

Were you able to say what the code does without investing your brain power? If you say yes, bear in mind that the real code is nothing shy of a labyrinth. Wait to see JINQ in action.

But first, this is what the above blob of code does:

> From a list of employees, select those that are not interns. And in the list of interns, gather the cost to the company information for the employee (based on hike, say for the current year) by creating a `CostInfo` for the employee. Then group the list of `CostInfo` by department such that we get the cost information by department. 

Let us JINQ all the way:

```java
final Map<String, String> map = 
	new Enumerable<>(employees)
		.where(e -> !e.intern)
		.select(CostInfo::new)
		.toMap(
			c -> c.department,
			(m, v, c) -> v.update(c.hikeAmount, c.hikePercent)
		);
```

Doesn't JINQ make the code simple and clear enough for the reader to understand the intent instantly. Oh, dont say no. I bet it took only a few seconds for you to understand when expressed the JINQ way. Forget the mechanics, focus on the expressing intent.

If you are interested in the mechanics, dig in here[^2].

The difference demonstrated in the example above is based on a recent real time experience.

See this gist[^3] for the complete sample code.

[^1]: https://vivekragunathan.wordpress.com/2016/04/02/jinq/
[^2]: https://www.github.com/VivekRagunathan/JINQ
[^3]: https://gist.github.com/VivekRagunathan/c2a0f5b07b9a17ea89d5b75ce5176fa1