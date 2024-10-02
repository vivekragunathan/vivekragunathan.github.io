---
title: Quiz - Beauty of Numbers
author: HKT
layout: post
date: 2011-07-01T19:39:08+00:00
url: /2011/07/02/quiz-beauty-of-numbers/
categories:
  - Algos and Puzzles
  - Uncategorized

---

Sriram quizzed:

>Imagine there is a queue of people for getting a ticket for a movie or somehing. Where should be standing in the queue to last until the manager or some guy keeps removing people at odd indices. For instance, if the queue has 5 people given a token A to E, first we remove the first set of odd numbered positions in the queue, so A, C and E are gone. Now B and D remain. Again we remove the odd numbered positions. This time B alone is gone, and D is the winner. So in a queue like that, what is the lucky position you should hold so that you survive the wave of removals?

***

**Solution**

One hint that should be  helpful in building our solution is that we got to get retained after every wave of removal (until nobody else remains). That means it got to be really some special number or special kind of number. We could do what functional programmers would do. Write down the steps of removal for every queue size N, and it is not worth trying for very large N; in our case, even 20 or 30 could be large. But the point is we could iterate the steps manually and find a position K for every queue size N, where K is the position that remains after all the waves of removal. Once we are done with that, we should stare intensely 😂 on every K to derive a pattern, which would tell us something about those Ks, and with that we should be able to solve the problem.

Ok, let us try that real quick. I will be skipping the individual iterations and directly putting the number K for every N. You can do the homework of individually iterating the wave of removal.

- A queue size of 1 does not make sense.
- Programmatic indices start from zero, while our home work\manual method indices start from 1.

| Queue Size (N) | Lucky Position (K) |
| :------------: | :----------------: |
| 2              | 2                  |
| 3              | 2                  |
| 4              | 4                  |
| 5              | 4                  |
| 6              | 4                  |
| 7              | 4                  |
| 8              | 8                  |
| 9              | 8                  |
| 10             | 8                  |
| 11             | 8                  |
| 12             | 8                  |
| 13             | 8                  |
| 14             | 8                  |
| 15             | 8                  |
| 16             | 16                 |

I have done that manual iteration for you and produced the Ks. By now, you should have seen the pattern in the Ks. Yep, _K should be a power of two_. So to be lucky to escape the wave, we got to be at a position that is the highest possible power of two; for any given queue size N.

If we were to write a program (or a game with this logic), it would be composed of the following functions:-

```csharp
int GetLuckyPosition(uint queueSize)
{
   // 0 and 1 are cases of invalid input.
   if (queueSize <= 1)
   {
      return 0;
   }

   // TODO: Suggest a better approach to find the K.
   for (int k = queueSize; k >= 2; --k)
   {
      if (IsPowerOfTwo(k))
      {
         return k;
      }
   }

   // Should never get here;
   return 0;
}

bool IsPowerofTwo(int num)
{
   return num & (num - 1) == 0;
}
```

In a power of two series, the on-bit keeps shifting to the left, and the same bit keeps shifting to the right during the wave of removals. I would say that K oscillates to settle at one position to survive. It is not about whether K is odd or even because when every wave strikes to remove, the even positions could become odds and vice versa. Only a power of two happens to remain at an even position, and hence it survives.
