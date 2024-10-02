---
title: Now I'll have padding both ways
author: higherkindedtype
layout: post
url: /posts/css-padding-props
date: 2023-02-08
categories:
  - CSS
summary: |
  In my CSS tinkering endeavors, I can't believe I was ignorant of the existence of the very properties that I have been longing for. I am delighted I finally found it.
---

I have heard [Douglas Crockford](https://www.crockford.com/about.html) say CSS is an abomination. Or something to that effect. We can't argue with the man. He is the authority on the subject and knows what he is saying. 

However, for the rest of us hobbyists, CSS is a boon. A magic wand, if you will, for turning ugly[^1] web pages into something better. Better for reading, printing, or other things like partially extracting content. I do it all the time because there are a gazillion ugly web pages that could have been far more beautiful.

I have been ***dabbling*** with CSS for a long time to revamp the look and feel of web pages, which otherwise are illegible to my eyes. My eyes don't like just any font family, size, or style. And don't get me started on the clutter on these web pages. You would have to excavate the content that matters.

One of the properties that I use for tinkering is `padding`. More often than not, I find myself wanting to change just the horizontal or the vertical padding.

As you can see from the [syntax](https://developer.mozilla.org/en-US/docs/Web/CSS/padding) for padding below, there isn't exactly one to exclusively control either the horizontal or the vertical padding.

```css
padding: 1em;						/* Apply to all four sides */

padding: 5% 10%;				/* top and bottom | left and right */

padding: 1em 2em 2em;		/* top | left and right | bottom */

padding: 5px 1em 0 2em;	/* top | right | bottom | left */
```

What's the problem with the syntax?

- The main problem with the syntax is the necessity to specify values for the sides, especially the ones I don't intend to change.

- I may not have access to the original values for the sides. They come from somewhere in the labyrinth of the page - HTML/CSS. Or the value is assigned dynamically.

- The worst part is that predefined values like `auto` or `inherit` do not work. Perhaps there is a way to make it work. I have not come across it. Hey, remember, I am just a hobbyist!

Problem no more! I am ashamed, surprised, and delighted today that I found two properties for individually controlling horizontal and vertical paddings.

Meet:

- [`padding-inline`](https://developer.mozilla.org/en-US/docs/Web/CSS/padding-inline)

- [`padding-block`](https://developer.mozilla.org/en-US/docs/Web/CSS/padding-block)

Let me explain my emotions:

- *Ashamed*: I have been ignorant of the existence of these properties. Perhaps I did not do due diligence looking for these properties.

- *Surprised*: These properties did not surface in a search or other during all these years of tinkering with CSS.

- *Delighted*:  I found something I needed for a long time.

NOTE:

The padding properties above work in tandem with the `writing-mode` property. The web pages I typically deal with do not specify a `writing-mode` property defaulting to the value `horizontal-tb`. So, my mind automatically maps `padding-inline` to horizontal padding (left, right) and `padding-block` to vertical padding (top and bottom).

***

Some tools related to this post that I use and love:

- [Amino](https://aminoeditor.com/) CSS

- [Article Parser](https://articleparser.vercel.app) by [@lucasew](https://github.com/lucasew/)

- [Arc](https://arc.net) Browser (Has built-in support for manipulating page styles, and I ♥️ it)

[^1]: I can't tolerate the home pages of true geniuses like [Richard Stallman](https://www.stallman.org) and [Bjarne Stroustoup](https://www.stroustrup.com). They deserve a facial uplift for me to enjoy reading them. It is one of my use cases for dabbling with CSS.