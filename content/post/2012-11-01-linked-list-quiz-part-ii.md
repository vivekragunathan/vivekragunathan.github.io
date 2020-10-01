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
<p style="font-family:Tahoma;font-size:11pt;">
  In the last <a title="Linked List Quiz - Part I" href="http://developerexperience.blogspot.in/2012/06/linked-list-quiz-part-i.html" target="_blank">part</a>, we saw the academic (not general purpose) version of a Linked List used to solve the puzzles, and solved the following puzzles on linked list.
</p>

<ul style="font-family:Tahoma;font-size:11pt;">
  <li>
    Reverse the list recursively
  </li>
  <li>
    Reverse the list iteratively
  </li>
  <li>
    Find if a list is cyclic
  </li>
</ul>

<p style="font-family:Tahoma;font-size:11pt;">
  In this part, I will be solving the remaining two puzzles that I listed in the last part.
</p>

<p style="font-family:Tahoma;font-size:11pt;font-weight:bold;">
  Finding the cyclic node in a cyclic linked list
</p>

<ol style="font-family:Tahoma;font-size:11pt;">
  <li>
    According to my solution, the node which is actually supposed to be the end of the linked list is the cyclic node. Let us call Cn. Taking node Cn as the cyclic one has an advantage wherein you can break the cycle; assign <span style="font-family:Consolas;">Cn->next = nullptr;</span>
  </li>
  <li>
    But some people take the node after Cn as the cyclic node. The node after Cn is the node somewhere back in the list. This way it is not possible to break the cycle as we would traversed past Cn.
  </li>
</ol>

<pre style="font-family:Consolas;font-size:11pt;">LinkedList::Node* LinkedList::FindCyclicNode() const
{
   int iterCount = 0;

   auto jmpBy1Ptr = root;
   auto jmpBy2Ptr = root;

   while (jmpBy1Ptr != nullptr && jmpBy2Ptr != nullptr && jmpBy2Ptr-&gt;Next() != nullptr)
   {
      jmpBy1Ptr = jmpBy1Ptr-&gt;Next();
      jmpBy2Ptr = jmpBy2Ptr-&gt;Next()-&gt;Next();

      if (jmpBy1Ptr == jmpBy2Ptr)
      {
         const int noOfNodesInLoop = CountNoOfNodesInLoop(jmpBy1Ptr);

         cout &lt;&lt; "No of nodes in loop: " &lt;&lt; noOfNodesInLoop &lt;&lt; std::endl;

         auto p1= root;
         auto p2 = GetNthNode(noOfNodesInLoop - 1); // zero based index

         cout &lt;&lt; "Node at index " &lt;&lt; noOfNodesInLoop &lt;&lt; ": " &lt;&lt; p2-&gt;Item() &lt;&lt; std::endl;          // Pointers meet at eye of the loop (this node is as per point #2 above)          while (p1 != p2)          {             p1 = p1-&gt;Next();
            p2 = p2-&gt;Next();
         }

         // This piece of code takes you to the loop starting node (this node is as per #1 above)
         p2 = p2-&gt;Next();
         while(p2-&gt;Next() != p1)
         {
            p2 = p2-&gt;Next();
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

   while (p1-&gt;Next() != p2)
   {
      p1 = p1-&gt;Next();
      ++count;
   }

   return count;
}</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  The code above is the result of several iterations of discussions with Azhagu. It wasn&#8217;t written that way the first time. The first version was much complex and naive. I think it looks better now. What do you say?
</p>

<p style="font-family:Tahoma;font-size:11pt;font-weight:bold;">
  Reversing every K nodes in the list
</p>

<p style="font-family:Tahoma;font-size:11pt;">
  This is an interesting puzzle. You should not reverse the whole list instead only every K nodes, where N >= K > 1 and N is the number of nodes in the list. For instance, if you reverse 2 nodes (K = 2) in the following list
</p>

<pre style="font-family:Consolas;font-size:11pt;">1 -&gt; 2 -&gt; 3 -&gt; 4 -&gt; 5 -&gt; 6</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  the resulting list would be
</p>

<pre style="font-family:Consolas;font-size:11pt;">2 -&gt; 1 -&gt; 4 -&gt; 3 -&gt; 6 -&gt; 5</pre>

<pre style="font-family:Consolas;font-size:11pt;">void LinkedList::Reverse(int k)
{
   prevHead = nullptr;

   auto head = root;
   root = _Reverse(head, k);
   head = head-&gt;Next();

   while (head != nullptr)
   {
      _Reverse(head, k);
      head = head-&gt;Next();
   }

   prevHead = nullptr;
}

LinkedList::Node* LinkedList::_Reverse(Node* head, int k)
{
   int iter = k;

   Node* current = head;
   Node* prev = nullptr;
   Node* next = nullptr;

   while (current != nullptr && iter &gt;= 1)
   {
      next = current-&gt;Next();
      current-&gt;Next() = prev;

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
      prevHead-&gt;Next() = next != nullptr ? prev : current;
   }

   prevHead = head;
   head-&gt;Next() = next;

   return prev;
}</pre>

<p style="font-family:Tahoma;font-size:11pt;">
  I hope the code covers all the corner cases of the puzzle. Give it a try and let me know if it all works for you.
</p>