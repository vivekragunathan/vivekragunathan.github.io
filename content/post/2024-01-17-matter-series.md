---
title: "Matter Feature Request - Series"
author: higherkindedtype
layout: post
url: /posts/matter-series
date: 2024-01-17
tags: [ 'matter', 'rss', 'blogs' ]
summary: |
  Function overloading is every day business in statically typed languages. Not all languages. Go has make it everything [hard](https://go.dev/doc/faq#overloading). 🙄 But function overloading in dynamic languages are not really sought after.

---

### Prelude

- This is a composite feature request, meaning there are multiple parts to the target feature requested. So, it may be broken down and implemented  iteratively to deliver the final product.
- Take the  design aspects of the feature  discussed here lightly. Matter’s design team is  definitely way more creative than me. I am sure they will improve it greatly if Matter decides to take up this feature request.

### Feature Description

One could easily say that [Matter](https://hq.getmatter.com) is the best app for reading articles / posts. Many times authors produce a series of posts under a given title. The count of posts in a series range from 3 to 15.

Here is an example of an excellent series: [Coding and ADHD Brains](https://abbeyperini.hashnode.dev/coding-and-adhd-adhd-brains). I think there are 5 posts in the series.

#### Pain point #1

The only way add import these posts in a series into Matter is to add them one by one. Instead it would be great to bulk import. For example, provide a list of post urls (in the input box when you click **+** in the app) to import them in one go. This solves one piece of the puzzle.

#### Pain point #2

Even if bulk import is implemented, there is still a pain point in terms of organization. Bulk import would just import all the urls and *litter it in the Queue*. It is not inherently possible to say that these posts belong to a series (unless the author decides to use the same title with a part number).

You could provide the option to assign Tags for all the posts during bulk import. *But Tags are not the right taxonomy for this case* (although it is convenient to assign Tags during bulk import). What would be great is to support an alternative taxonomy. Let us call it *Series*.

- You should be able to create a *Series* to which you should be able to add new urls or already imported posts / articles. In the Queue, the *Series* should show up as a line item with ▶ icon on the right denoting that there are posts inside.
- During bulk import, Matter should provide an option to either create a Series for the posts being imported or assign to an existing Series.

While there are standards like RSS or atom, AFAIK, there isn’t any standard for denoting a series. If such a standard exists, Matter could import the series of posts into a  Series automatically, which would be super awesome.

I have shared this request with the Matter team a few weeks back. Let us see what they decide.
