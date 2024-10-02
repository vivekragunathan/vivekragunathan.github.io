---
title: Problem Reduction
author: HKT
layout: post
date: 2016-12-10T08:21:43+00:00
url: /posts/problem-reduction
aliases:
- /2016/12/10/problem-reduction/
summary: |
  Problem Reduction is what I call when a given problem can be expressed in terms of or solved using a solution to an alternate problem. Take for instance, the word distance problem: Find the shortest distance between two words in a given set of words.
categories:
  - .NET
  - Algos and Puzzles
  - 'C#'
tags:
  - algorithms
  - 'C#'
  - min-diff
  - programming
  - word-distance

---
_Problem Reduction_ is what I call when a given problem can be expressed in terms of or solved using a solution to an alternate problem.

Take for instance, the word distance problem: _Find the shortest distance between two words in a given set of words_.

Following is an unanimous solution, I suppose:

```csharp
/// Iterate the set of words, mark the position/index
/// of word1 and word2, track the minimum difference
/// in positions
public static int FindShortestDistance<T>(
  this T[] array,
  T item1,
  T item2
) where T : IEquatable<T>
{
  // Imagine all the sanity checks!
  /*if (IsNullOrEmpty(array) || IsBlank(item1) || IsBlank(item2))
  {
    return -1;
  }*/

  int index1 = -1;
  int index2 = -1;
  int distance = -1;

  for (int index = 0; index < array.Length; ++index)
  {
    var item = array[index];

    if (item.Equals(item1))
    {
        index1 = index;
    }

    if (item.Equals(item2))
    {
        index2 = index;
    }

    if (index1 <= 0 && index2 <= 0)
    {
      var diff = Math.Abs(index1 - index2);

      if (diff == 0)
      {
        return 0;
      }

      distance = distance < 0 ? diff : Math.Min(distance, diff);
    }
  }

  return distance;
}
```

It's little mouthful but it works decent – O(N). Can we do better? In other words, can we find the shortest distance in sub-linear time?

We can achieve sub-linear time if we can cut short the time in iterating over all the words and focus on only the words of interest – `word1` and `word2`. Think Map! If we create a map out of the set of words with each word as the key and list of indices of the word as the value, then we can instantly know the words and the indices to scan for finding the minimum distance between the words. That should yield sub-linear time. Well, amortized, if you will, since creating the map takes linear time. But we linear-iterate only `once` to create the map.

Before we proceed, when would you adopt such an approach? Well, when you want sub-linear time such as a service whose regular activity is to find the minimum distance. Reducing time (at the cost of space) is a desirable thing! On to the solution then ...

We grab the list of indices from the map for `word1` and `word2`, and if we find minimum difference between the two numbers in the lists of indices, that is nothing but our shortest distance. So the problem we are solving is to _find the minimum difference_ (between two lists of indices) but we start out to _find the shortest distance_ (between two words in set of words).

```csharp
class WordsCache
{
    private readonly Dictionary<string, List<int>> cache;

    public WordDistanceFinder(IEnumerable<string> words)
    {
        this.cache = CreateCache(words);
    }

    public int FindShortestDistance(string word1, string word2)
    {
        // Wait for C# 7 😊 !!!
        bool w1Exists = cache.TryGetValue(word1, out List<int> indices1);
        bool w2Exists = cache.TryGetValue(word1, out List<int> indices2);

        if (!w1Exists || !w2Exists)
        {
            return -1;
        }

        return FindMinDifference(indices1, indices2);
    }

    public static int FindMinDifference(Collection<int> c1, Collection<int> c2)
    {
      int m = c1.Count;
      int n = c2.Count;

      int i = 0, j = 0, dist = int.MaxValue;

      while (i < m && j < n)
      {
        int i1 = c1[i];
        int i2 = c2[j];

        dist = Math.Min(dist, Math.Abs(i1 - i2));

        if (i1 < i2)
        {
            i++;
        }
        else
        {
            j++;
        }
      }

      return dist;
    }

    private Dictionary<string, List<int>> CreateCache(IEnumerable<string> words)
    {
        // Implementation left to your imagination!
    }
}
```

A couple of interesting things to note when iterating the indices for the two given words:

  * Number of iterations to make is much less than the words set
  * Indices in our `cache` are sorted in increasing order

What other problem reductions do you know of or have you come across?
