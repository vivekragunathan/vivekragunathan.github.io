---
title: Cool Regex Testers !!!
author: vivekragunathan
layout: post
date: 2014-07-23T11:30:28+00:00
url: /2014/07/23/cool-regex-testers/
categories:
  - Programming
  - Uncategorized
tags:
  - online regex
  - regex
  - testers
  - tools

---
<p style="font-family:Open Sans;">
  Anytime I have to play with regular expressions, I use one of the online regex testing web sites to come up with the regex I need. Last couple of times I had to come up with a regex for most common everyday stuff like dates and such. Oh yeah, last time it was date actually. I had a server response that had a date in the format yyyy-mm-dd, <a href="http://www.w3.org/QA/Tips/iso-date" target="_blank">ISO format</a>. I was working with JavaScript, and initially I was naive to use the <a href="http://www.w3schools.com/jsref/jsref_obj_date.asp" target="_blank">Date</a> class to parse the date in the response. Turned that there is difference in the way the date is interpreted by Firefox and other browsers.
</p>

<p style="font-family:Open Sans;">
  Ok, this is not a rant post about the <code>Date</code> class but actually share some sites that help you with regular expressions, of course at different levels. Here is a list of such sites:
</p>

<div style="font-family:Open Sans, Source Code Pro, Consolas, Courier;">
  <blockquote>
    <p>
      <a href="http://regexpal.com/" target="_blank">http://regexpal.com/</a>
    </p>
  </blockquote>
  
  <blockquote>
    <p>
      <a href="http://regex101.com/" target="_blank">http://regex101.com</a>
    </p>
  </blockquote>
  
  <blockquote>
    <p>
      <a href="http://rubular.com/" target="_blank">http://rubular.com/</a>
    </p>
  </blockquote>
  
  <blockquote>
    <p>
      <a href="https://www.debuggex.com/" target="_blank">https://www.debuggex.com/</a>
    </p>
  </blockquote>
  
  <blockquote>
    <p>
      <a href="http://www.freeformatter.com/regex-tester.html" target="_blank">http://www.freeformatter.com/regex-tester.html</a>
    </p>
  </blockquote>
</div>

<p style="font-family:Open Sans;">
  In the above list, I like the last but not the least &#8211; <a href="http://freeformatter.com/" target="_blank">freeformatter.com</a>. The cool thing about freeformatter is that it lists a lot of commonly used patterns such as emails, ip address etc. And I was lucky to find the ISO date pattern too, which saved me time. The uncool thing about it though, unlike other sites, is not haptic to the regex or input you type; instead requires an old-style submit button click to validate your expressions, and also does not show the matches (or capture groups).
</p>

<p style="font-family:Open Sans;">
  Thought it will help anyone playing a lot with regular expressions!
</p>

<p style="font-family:Open Sans;">
  <small><b>PS: </b>The actual issue with Date was not directly with the parsing but later on when the getDate, getDay, getMonth methods are used. While other browsers took the browser&#8217;s time zone into account, Firefox did not. I was too bored to proceed with Date, and resorted to regex to parse out the date parts from my response. Here is the snippet of the code I used:<br /> </small>
</p>

[code language=&#8221;javascript&#8221;]function formatDate(yyyymmdd) {
    
var matches = yyyymmdd.match(/^(ISO DATE REGEX PATTERN)$/);

if (matches == null) { return yyyymmdd; }

var yyyy = matches[1];
    
var mm = matches[2];
    
var dd = matches[3];

var date = new Date(yyyy, mm &#8211; 1, dd);

return DAYS[date.getDay()].substring(0, 3)
      
+ ", "
      
+ MONTHS[date.getMonth()].substring(0, 3)
      
+ " " + date.getDate()
      
+ ", " + date.getFullYear();
  
}[/code]