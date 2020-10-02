---
title: Non-FP to FP Conversion Caveat
author: vivekragunathan
layout: post
date: 2019-02-19
url: /2019/02/19/fp-conversion-caveat
categories:
  - Functional Programming
---

Sometimes you learn the best from others; by watching. This post is based on such an instance. A fellow engineer on my team was investigating a nagging issue - **partially-successful operations or rather operations that left data in an inconsistent state**. It goes without saying that I take no credit for the time and effort spent on the investigation nor for the fix. I am just the messenger. And as a responsible programmer 🤓, I am sharing it with the rest of the world.

We use Scala in my team and have been trying to be (pure) functional (as much). Hmmm … *trying to be functional*? Yeah, because the truth is not always black and white.

- The team started as beginners in Scala. Compared to the days of humble origin, the quality of *functional* code today is definitely better. That means there are parts of code that could still be improved to be truly functional.

- Parts of the Scala (code) that interface with Java libraries and such seem to have to inclined towards convenience than *pure functional* code. This predates my time with the team. But I would assume the team was new to the*functional* paradigm and sure did their best to maintain the balance of pure functional code vs convenience.

> Writing (pure) functional code builds character if not anything else.

Not throwing exceptions is one such ideal of functional code. Having happily thrown exceptions for decades, the team took it up as a discipline and a challenge to start not throwing exceptions; instead report errors otherwise through functional means like using `Either` and such[^1]. It went well and was satisfying that we are one step closer to the ideal.

This is when instances of partially-successful operations were reported. The issue had got to do with code running database transactions. The helper method that wrapped code to run inside of a transaction was relying on exceptions to rollback transactions and so were other parts of the code in tune with the helper throwing exceptions. Now that the refactored code was no longer throwing exceptions and resorted to calmer error reporting via `Either` and such, the helper method running the transaction was not aware of a failure. A failure might surface elsewhere where certain invariants are found to be broken (because of the failure unseen or unhandled) By then, the chance to rollback the transaction was already lost.

The fix was relatively simple to look for standard error reporting counterparts in functional code and rollback the transaction.

It is easy to think of this incident as a mistake by the team. Or think of it as having overlooked such a basic and simple effect of adopting of functional programming. Not really! Consider logging if you decide to log *functionally*. Remember logging / IO is impure, and there was ways around it. In such a scenario, one should be aware of the order and timing of the logs, which is no big deal when you choose to write directly to your destination. I am sure there are other similar instances of *Ahaa!* if not revelation when making that real shift into functional programming.

The lesson we learnt is that we got our chance to be aware of the impact a change from non-functional to functional style is going to lay on the functionality. What are some of yours?

As always, there is details to the grand scheme. I have shrunk the might of the scheme to simple helper method and such so that we can focus on the caveat of converting non-functional code to functional style.

[^1]: For error reporting, we use one of `Either`, `Option`, and cats -`Validated`, `ValidatedNel` etc.
