---
title: Confluence Alternatives
author: higherkindedtype
layout: post
url: /posts/confluence-alternatives
date: 2022-01-23
categories:
  - Scala
  - Anorm
summary: |
  Is Confluence your documentation / knowledge-management system? Are you sick of its shortcomings? Poor and non-standard rendering. Lack of markdown support. Weird and inconsistent handling of unicode. Do you still think Confluence is a boon for document writing? Just be aware that there are better alternatives. 
---

> <small>UPDATE: This post was [featured](https://hackernoon.com/confluence-is-for-the-uninformed-document-management-alternatives-to-confluence) on [hakernoon](https://www.hakernoon.com) 🎉</small>

I have been using Confluence for a long time now. I should say the experience so far has been _revolting_. Read on to know why, and learn that there are alternatives, if you wish to look for an alternative.

### Stipulations

- This document is highly opinionated. You have been warned. Warning aside, keep an open mind. Just enjoy the review.
- This document was not written on impulse. I have been collecting pain points of Confluence for quite some time; every time I got bitten. And I have not mentioned all of it; left some nit-picking ones.
- The pain points are primarily based on the expectations of a developer. Confluence may appear to be a boon for a non-developer who is content with blocks and blocks of text with a few other things - tables, pictures, and not keen on presentation. Or they are content with the presentation/rendering too.
- I have not listed the pros of Confluence because they are not winning factors. They are just must-haves.
- The Confluence I am referring to here is the self-hosted version, and not the cloud version.
- Last but not least, this post is not a crusade against Confluence or Atlassian. It is a outrage against a product that *in my opinion* is simply below mediocre in modern day standards for document writing and knowledge management.

### **Extremely unpleasant reading and writing experience**

- Inconsistent line and paragraph spacing
- Non-standard width for document pages. That's horrible. If you don't know what I am talking about, check my extremely naive attempt with CSS for to make Confluence look[^1] like standard page-width document.
- It is a shame Atlassian does not support Markdown. It is 2022! Support for markdown is a must-have for any document writing these days.
- No control over fonts and styles (except the inadequate presets)
- ... and many more

### **Uncompromising Downsides**

- No straight-forward way to know with the whom the document is shared with
- Lose formatting and sometimes content if the computer goes to sleep (or disconnects from VPN) when left in the edit mode
- Unicode / emoji support and copy-pasting rich text from other sources is quirky. Worst is that it would take forever to understand that was the problem.
- Usability of commenting is primitive
  - There is no view or way (say an on-demand sidebar) to see all the comments.
  - Commenting (saving) is erratic when you paste text from elsewhere, especially like a browser. Almost always, comments with unicode characters reports error saving, with a irrelevant error message.
- Have you tried reordering the child pages of a given (parent) page? If you have not, you are lucky. There isn't a view that lists the child pages where you can drag-drop or slide up-down and set the child order of a parent page in one go.  You do that on a per child page basis to say what the order of that child page is.
- Tables are atrocious.


### Annoying Downsides

- No mobile app (at least not for self-hosted version). Extremely poor mobile experience in the browser.
- In the edit mode ...
  - When the content is longer than the current view height, you will see two scrollbars. One is for your content. The other is for the parent container of your content, which when scrolled down will reveal a nav bar sorts with the option to save, publish or discard
    ![img-02](/images/2022/confluence/confluence-bottom-bar.png)

- No real support for collaborative editing and other collaborative features.
- Does not have concept of *publishing* for sharing. Enjoy the doc update email spam!
- AFAIK there is concept of team and spaces and moderators. Just dump everything and make it insanely hard to find in the labyrinth of nested hierarchies. The other option - bookmark of all confluence 🤣. While the organization is usually blamed on the team / personnel configuring Confluence, I see it as an inevitable outcome of a poorly designed product. 
- Macros are a love-hate deal.

### **Some Nice Alternatives**

*... in no particular order*

- [Nuclino](https://www.nuclino.com/) (for [Engineering](https://www.nuclino.com/teams/engineering))
- [bit.ai](https://bit.ai/features)
- [Document360](https://document360.io/features-editors-writers/)
- [Slite](https://slite.com/)
- [Slab](https://slab.com/)
- [Readme](https://readme.com)
- The following honorable mentions may lack sophistication such as access control and  commenting (in the conventional sense) but bear in mind that vast majority of documentation of open source projects runs on such ones, in some form or fashion.
  - [mkdocs](https://mkdocs.org)
  - [ReadTheDocs](https://readthedocs.org)
  - [GitBook](https://www.gitbook.com) (free and paid versions)
  - ... and many more


I spent decent amount of time and effort experimenting with each of the alternatives above - creating accounts, traiging the features, particularly the ones that Confluence falls short of. I found them definitely way better than Confluence. Each one makes its own trade off. In other words, no product is perfect but the limitations / shortcomings are beyond the problems that Confluence made me write this post.

**My Conclusion**

> Confluence is the de facto documentation and knowledge management tool of the uninformed.

Same goes to JIRA.

***

P.S: StackOverflow for [**Teams**](https://stackoverflow.com/teams) is a good option while addressing the Q&A part of the knowledge base.


[^1]: Extremely naive attempt with CSS for standard page-width for documents. ![img](/images/2022/confluence/confluence-custom-css.png)

