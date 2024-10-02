---
title: Cool Regex Testers
author: HKT
layout: post
date: 2014-07-23T11:30:28+00:00
url: /2014/07/23/cool-regex-testers/
categories:
  - Programming
  - Uncategorized
tags: [ 'online-regex', 'regex', 'testers', 'tools' ]

---

Anytime I have to play with regular expressions, I use one of the online regex testing web sites to come up with the regex I need. Last couple of times I had to come up with a regex for most common everyday stuff like dates and such. Oh yeah, last time it was date actually. I had a server response that had a date in the format `yyyy-mm-dd`, [ISO format](http://www.w3.org/QA/Tips/iso-date). I was working with JavaScript, and initially I was naive to use the [`Date`](http://www.w3schools.com/jsref/jsref_obj_date.asp) class to parse the date in the response. Turned that there is difference in the way the date is interpreted by Firefox and other browsers.

Ok, this is not a rant post about the `Date`  class but actually share some sites that help you with regular expressions, of course at different levels. Here is a list of such sites:

> [http://regexpal.com/](http://regexpal.com/)
> [http://regex101.com/](http://regex101.com/)
> [http://rubular.com/](http://rubular.com/)
> [https://www.debuggex.com/](https://www.debuggex.com/)
> [http://www.freeformatter.com/regex-tester.html](http://www.freeformatter.com/regex-tester.html)

In the above list, I like the last but not the least - [freeformatter.com](http://freeformatter.com). The cool thing about _freeformatter_ is that it lists a lot of commonly used patterns such as emails, ip address etc. And I was lucky to find the ISO date pattern too, which saved me time. The uncool thing about it though, unlike other sites, is not haptic to the regex or input you type; instead requires an old-style submit button click to validate your expressions, and also does not show the matches (or capture groups).

Thought it will help anyone playing a lot with regular expressions!

<small>**PS:** The actual issue with Date was not directly with the parsing but later on when the getDate, getDay, getMonth methods are used. While other browsers took the browser'&#8217;'s time zone into account, Firefox did not. I was too bored to proceed with Date, and resorted to regex to parse out the date parts from my response. Here is the snippet of the code I used:</small>

```csharp
function formatDate(yyyymmdd) {
  var matches = yyyymmdd.match(/^(ISO DATE REGEX PATTERN)$/);

  if (matches == null) { return yyyymmdd; }

  var yyyy = matches[1];
  var mm = matches[2];
  var dd = matches[3];
  var date = new Date(yyyy, mm - 1, dd);

  return DAYS[date.getDay()].substring(0, 3)
    + ", "
    + MONTHS[date.getMonth()].substring(0, 3)
    + " " + date.getDate()
    + ", " + date.getFullYear();
}
```
