---
title: Linked List Quiz – Part II !!!
author: vivekragunathan
layout: post
date: 2012-10-31T18:30:21+00:00
url: /2012/11/01/linked-list-quiz-part-ii/
categories:
  - Algos and Puzzles
  - Uncategorized

---
In the previous [post](/2012/06/18/linked-list-quiz-part-i), we saw the academic (not general purpose) version of a linked list used to solve the puzzles, and solved the following puzzles on linked list.

- Reverse the list recursively
- Reverse the list iteratively
- Find if a list is cyclic

In this part, I will be solving the remaining two puzzles that I listed in the last part.

**Finding the cyclic node in a cyclic linked list**

1. According to my solution, the node which is actually supposed to be the end of the linked list is the cyclic node. Let us call `Cn`. Taking node `Cn` as the cyclic one has an advantage wherein you can break the cycle; assign `Cn->next = nullptr;`
2. But some people take the node after Cn as the cyclic node. The node after Cn is the node somewhere back in the list. This way it is not possible to break the cycle as we would traversed past Cn.

```cpp
LinkedList::Node* LinkedList::FindCyclicNode() const
{
   int iterCount = 0;

   auto jmpBy1Ptr = root;
   auto jmpBy2Ptr = root;

   while (jmpBy1Ptr != nullptr && jmpBy2Ptr != nullptr && jmpBy2Ptr->Next() != nullptr)
   {
      jmpBy1Ptr = jmpBy1Ptr->Next();
      jmpBy2Ptr = jmpBy2Ptr->Next()->Next();

      if (jmpBy1Ptr == jmpBy2Ptr)
      {
         const int noOfNodesInLoop = CountNoOfNodesInLoop(jmpBy1Ptr);

         cout << "No of nodes in loop: " << noOfNodesInLoop << std::endl;

         auto p1= root;
         auto p2 = GetNthNode(noOfNodesInLoop - 1); // zero based index

         cout << "Node at index " << noOfNodesInLoop << ": " << p2->Item() << std::endl;

         // Pointers meet at eye of the loop (this node is as per point #2 above)

         while (p1 != p2)
         {
            p1 = p1->Next();
            p2 = p2->Next();
         }

         // This piece of code takes you to the loop starting node (this node is as per #1 above)
         p2 = p2->Next();

         while(p2->Next() != p1)
         {
            p2 = p2->Next();
         }

         return p2;
      }

      ++iterCount;
   }

   return nullptr;
}

int LinkedList::CountNoOfNodesInLoop(Node* stopNode) const
{
   int count = 1;
   auto p1 = stopNode;
   auto p2 = stopNode;

   while (p1->Next() != p2)
   {
      p1 = p1->Next();
      ++count;
   }

   return count;
}
```

The code above is the result of several iterations of discussions with Azhagu. It wasn't written that way the first time. The first version was much complex and naive. I think it looks better now. What do you say?

**Reversing every K nodes in the list**

This is an interesting puzzle. You should not reverse the whole list instead only every K nodes, where `N >= K > 1` and N is the number of nodes in the list. For instance, if you reverse 2 nodes (`K = 2`) in the following list:

```
1 -> 2 -> 3 -> 4 -> 5 -> 6
```

the resulting list would be

```
2 -> 1 -> 4 -> 3 -> 6 -> 5
```

```cpp
void LinkedList::Reverse(int k)
{
   prevHead = nullptr;

   auto head = root;
   root = _Reverse(head, k);
   head = head->Next();

   while (head != nullptr)
   {
      _Reverse(head, k);
      head = head->Next();
   }

   prevHead = nullptr;
}

LinkedList::Node* LinkedList::_Reverse(Node* head, int k)
{
   int iter = k;

   Node* current = head;
   Node* prev = nullptr;
   Node* next = nullptr;

   while (current != nullptr && iter >= 1)
   {
      next = current->Next();
      current->Next() = prev;

      if (next == nullptr)
      {
         break;
      }

      prev = current;
      current = next;
      --iter;
   }

   if (prevHead != nullptr)
   {
      prevHead->Next() = next != nullptr ? prev : current;
   }

   prevHead = head;
   head->Next() = next;

   return prev;
}
```

I hope the code covers all the corner cases of the puzzle. Give it a try and let me know if it all works for you.
