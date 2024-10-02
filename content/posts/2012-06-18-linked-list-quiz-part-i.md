---
title: Linked List Quiz – Part I !!!
author: vivekragunathan
layout: post
date: 2012-06-17T18:30:44+00:00
url: /2012/06/18/linked-list-quiz-part-i/
categories:
  - Algos and Puzzles
  - Uncategorized

---
A short while back, Sammy quizzed me on linked list based problems; singly linked list.

I am recording those problems, solutions and my experience as a two part series. In the first part, I am introducing the linked list class, which I wrote for packaging the implementation of the solutions. This class pertains to the context of the problem(s) and cannot be used as a general purpose linked list. A std::list might more pertinent in the context of the general purpose implementation of a list.

Here are some of the problems that Sammy asked me to solve:-

- Reverse the list recursively
- Reverse the list iteratively
- Find if the list is cyclic
- Find the node that causes the cycle (and break the cycle)
- Reverse every K nodes in the list

I will be solving reversing the list (both iteratively and recursively) and finding if the list is cyclic problems in this episode.

```cpp
#pragma once

#include
#include

using namespace std;

template<typename T>
class LinkedList
{
public: class Node
        {
        private: T item;
        private: Node* next;

        public: Node(const T& item)
                {
                     this->item = item;
                     this->next = nullptr;
                }

        public: Node(const T& item, Node* next)
                {
                     this->item = item;
                     this->next = next;
                }

        public: T& Item()
                {
                     return this->item;
                }

        public: const T& Item() const
                {
                     return this->item;
                }

        public: LinkedList::Node*& Next()
                {
                     return this->next;
                }
        };

private: LinkedList::Node* root;
private: LinkedList::Node* end;

public: LinkedList()
        {
           root = end = nullptr;
        }

public: ~LinkedList()
        {
            // If a cycle exists, break it; else the delete loop
            // below will never end, and lead to undefined behavior/crash.
            if (IsCyclic())
            {
               auto cyclicNode = FindCyclicNode();
               cyclicNode->Next() = nullptr;
            }

            // Delete all nodes
            auto current = root;
            while (current != nullptr)
            {
               auto temp = current->Next();
               delete current;
               current = temp;
            }
        }

public: Node* operator[](int index) const
        {
            return GetNthNode(index);
        }

public: LinkedList::Node* GetNthNode(int index) const // index is zero-based.
        {
            auto node = root;
            while (index >= 0 && node != nullptr)
            {
               node = node->Next();
               --index;
            }

            return node;
        }

public: Node* Append(T item)
        {
           Node* node = new Node(item);
           if (root == nullptr)
           {
              root = end = node;
           }
           else
           {
              end->Next() = node;
              end = node;
           }

           return node;
        }

public: LinkedList::Node* Root() const
        {
           return this->root;
        }

public: void Print(std::ostream& ostr = std::cout,
           const std::string& separator = " -> ",
           const std::string& terminator = "\r\n")
        {
           Node* currentNode = root;

           while (currentNode != nullptr)
           {
              const bool lastNode = currentNode->Next() == nullptr;
              const std::string linkText = (lastNode ? "" : separator);
              ostr << currentNode->Item() << linkText.c_str();
              currentNode = currentNode->Next();
           }

           ostr << terminator.c_str();
        }

public: void ReverseIteratively();
public: void ReverseRecusively();
public: bool IsCyclic() const;

private: Node* UnitReverse(Node* current, Node* next);
}
```

The above list class allows creating cycles in the list (see `Node::Next()` method). The Node::Next method returns a reference to the next item pointer in the list, which allows pointing it to a previous Node in the list. The linked list class will be improved based on the problem being solved.

Since reversing the list recursively came to me naturally, I'll go with it first. It was natural since the unit work of reversal involving current and next pointers is repeated until there are no more nodes in the list.

```cpp
void LinkedList::ReverseRecursively()
{
   root = UnitReverse(root, nullptr);
}

Node* LinkedList::UnitReverse(Node* current, Node* next)
{
   if (current == nullptr)
   {
      return nullptr;
   }

   if (next == nullptr)
   {
      // First time call.
      next = current->Next();
      current->Next() = nullptr;
      end = current;
   }

   Node* nextNext = next->Next();
   next->Next() = current;

   if (nextNext == nullptr)
   {
      // Reached end of list!
      return next;
   }

   return UnitReverse(next, nextNext);
}
```

Iterative version of reversal. Cute, eh!

```cpp
void LinkedList::ReverseIteratively()
{
   Node* current = this->root;
   Node* prev = nullptr;
   Node* next = nullptr;

   while (current != nullptr)
   {
     next = current->Next();
     current->Next() = prev;

     if (next == nullptr)
     {
        break;
     }

     prev = current;
     current = next;
   }

   this->end = this->root;
   this->root = current;   
}
```

A cycle in a list is where the next pointer of the current node points to one of the previous nodes in the list; like the one below.

```
1 -> 2 -> 3 -> 4 -> 5 ->
          ^------------|
```

Above, the list doesn't end at 5, instead cycles back to 3. And as everybody knows, a traversal of the nodes in the list would never end. If one was using a traditional list implementation, it would not have allowed creating cycle(s) deliberately. However, the data from which the list is created may bear cycles or back references, in which case the data is assumed to corrupt. For instance, an employee reporting to manager, and the manager reporting back to the employee. But our list implementation above, for the purposes of illustration of the problem at hand, allows creating cycles. And we will see a solution later to resolve them too.

Finding if there is a cycle in the list was tough for me. I sort of need a hammer and some hints from Sammy.

```cpp
bool IsCyclic() const
{   
   auto jmpBy1Ptr = root;
   auto jmpBy2Ptr = root;

   while (jmpBy1Ptr != nullptr
      && jmpBy2Ptr != nullptr
      && jmpBy2Ptr->Next() != nullptr)
   {
      jmpBy1Ptr = jmpBy1Ptr->Next();
      jmpBy2Ptr = jmpBy2Ptr->Next()->Next();

      if (jmpBy1Ptr == jmpBy2Ptr)
      {
         cout << "Stop node is " << jmpBy1Ptr->Item() << std::endl;
         return true;
      }
   }

   return false;
}
```

Here is some code to test the above methods:-

```cpp
void main()
{
   LinkedList ll;
   LinkedList::Node* lastNode = nullptr;

   for (int i = 1; i <= 10; ++i)
   {
      lastNode = ll.Append(i);
   }

   cout << "Initial Sequence...." << std::endl;
   ll.Print();

   cout << "Reverse (iteratively)..." << std::endl;
   ll.ReverseIteratively();
   ll.Print();

   cout << "Reverse (recursively).....Back to original sequence!" << std::endl;
   ll.ReverseRecursively();
   ll.Print();

   // This should return false, as the list has no cycles yet.
   cout << "IsCyclic: " << ll.IsCyclic() << std::endl;    // Get the 4th node from root (element 4)
   auto node = ll.Root()->Next()->Next()->Next();

   // Point the last node to the 4th node (a previous node in the list).
   // This creates a cycle or loop.
   lastNode->Next() = node;

   // This should return true now!
   cout << "IsCyclic: " << ll.IsCyclic() << std::endl;
}
```

We'll see the rest of the problems in the next episode. Let me know your comments on the solution, implementation, and bugs if any!
