---
title: Selective Combinations
author: vivekragunathan
layout: post
date: 2016-05-16T07:00:08+00:00
url: /2016/05/16/resource-combinations/
categories:
  - Algos and Puzzles
  - Uncategorized
summary: |
  > You have a list of strings with which you have generate ordered selective combinations of strings starting with the first string in the list. Let us say the list of strings is `abc`, `def` and `ghi`. I have to generate ordered combinations of the above list restricted to the ones starting with abc.

---
Consider this scenario:

> You have a list of strings with which you have generate ordered selective combinations of strings starting with the first string in the list. Let us say the list of strings is `abc`, `def` and `ghi`. I have to generate ordered combinations of the above list restricted to the ones starting with `abc`.

So that would be as follows:

```
abc def ghi

abc def

abc ghi

abc
```

<!--more-->

If the problem sounds abstract, here is the real situation. <!--more--> I have a list of parameters with which I have to select the best matching and available resource (a file in my application config folder). Let us say, the parameter values are

`config`, `type`, and [`Locale`]() (say `en_US` for this discussion). So I have to go find the best matching file for the given parameters but in the following order:

```java
config\_type\_en_US.json

config_type.json

config\_en\_US.json

config.json
```

Not a difficult one, eh? Only that, at the time of this writing, the number of parameters was not fixed but could be more (definitely not hundreds or thousands) but more than three.

**The non-solution**

Alright, let us not talk about generating all possible combinations of the given list of strings, and pluck the ones starting with the first string in the list.

**Solution #1**

The conventional technique or the _don&#8217;t overengineer_ advice is to write a helper method with a bunch of nested `if`s; something I will not allow myself to succumb to. This helper method, although appears to be insignificant in the might of other things in the application, is going to be source of several problems later; at least the one related to resource selection.

**Solution #3**

A slightly better way is to have a predefined ordered set of strings that represent the filename pattern such as:

```java

private static final String[] resourceSelectionPatterns = {
	"{p1}\_{p2}\_{loc}",
	"{p1}_{p2}",
	"{p1}_{loc}",
	"{p1}"
};

public static String findResource(
    String param1,
    String param2,
    Locale locale
) throws IOException {

	for (String pattern : patterns) {
		final String resName =
			pattern
				.replaceFirst("{p1}", param1)
				.replaceFirst("{p2}", param2)
				.replaceFirst("{loc}", locale.toString());

		final String fileName = resName + ".json";

		if (new File(fileName).exists()) {
				return resName;
		}
	}

	throw new IOException("No matching resource found");
}
```

This is better than nested `if`s which I would not bother to show the code. But even this is not really better. First, when there are more parameters in the equation, I have to go update `resourceSelectionPatterns` with the corresponding patterns and in the right order, and `findResource` method too. Also, the `replaceFirst` calls could create many throw-away `String`s. Of course, you can use a `StringBuilder` but that does not make it all better.

**Take a step back**

What I want is to generate the filename segments (or the equivalent patterns) _dynamically_ based on the given set of input strings so that the solution is _write once and for all_ (any count of parameters). We can assume that the order of the generated patterns is dictated by the order of the input strings.

**Finale**

If we can represent the input parameters in a more succinct format like a number and if we can identify a pattern among the numerical representation for each parameter, then we should be able to generate the filename segments _dynamically_.

If we assume each parameter to be a bit of an integer, first parameter being the most significant bit, then the bit representations for the input &#8211; `config`, `type`, `en_US` would be as follows:

```java
0000 0111 // 7 => config\_type\_en_US

0000 0110 // 6 => config_type

0000 0101 // 5 => config\_en\_US.json

0000 0100 // 4 => config.json
```

Well, I am sure you see the pattern. The integer representation of each filename segment decrements by 1 from the most specialized filename and stops at the least specialized one. This is true of any set of parameters and the selective combinations are generated dynamically.

Writing the code now for this solution should be a pie, the pleasure of which I will leave it to you.

Thanks to [Sammy](https://www.linkedin.com/in/azhaguthasan) in helping me discover the solution!
