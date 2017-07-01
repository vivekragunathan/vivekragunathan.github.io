---
layout: page
# TODO: Temporarily avoid display pages in the header
#title:  "Some Page 001"
date:   2016-07-04 23:33:00 -0800
categories: pages
parent_menu: Articles
---

# Advice to Young Programmers

_This is the summary of speech given by **Alex Stepenov**, Principal Scientist, Adobe Systems, at Adobe India on 30 Nov 2004._

* * *

## Study, Study and Study

- Never ever think that you have acquired all or most of the knowledge which exists in the world. Almost everybody in US at age of 14 and everybody in India at age of 24 starts thinking that he has acquired all the wisdom and knowledge that he needs. This should be strictly avoided.

- You should be habituated to studies...exactly in the same way as you are habituated to brushing teeth and taking bath every morning. The habit of study must become a ‘part of your blood’. And the study should be from both the areas: CS, since it is your profession, and something from non- CS...Something which doesnot relate to your work. This would expand your knowledge in other field too. A regular study, everyday, is extremely essential. It doesnot matter whether you study of 20 minutes of 2 hours, but consistency is a must.

- You should always study basics and fundamentals. There is no point in going for advanced topics. When I was at the age of 24, I wanted to do PhD in program verification, though I was not able to understand anything from that. The basic reason was that my fundamental concepts were not clear. Studying ‘Algebraic Geometry’ is useless if you donot understand basics in Algebra and Geometry. Also, you should always go back and re- read and re-iterate over the fundamental concepts. What is the exact definition of _fundamental_? The stuff which is around for a while and which forms basic part of the concepts can be regarded as more fundamental. Of course, everybody understands what a fundamental means.

- Here are few books which I would strongly recommend that every CS professional should read and understand.

	- **Structure and Interpretation of Computer Programs** by Albenson and Sussman 
	
	  I personally donot like the material present in this book and I do have some objections about it but this is the best book I have ever seen which explains all the concepts in programming in a clear and excellent way. This book is available online at http://mitpress.mit.edu/sicp/

	- **Introduction to Computer Architecture**: by Hennessy and Patterson.
	
	  How many of you have shipped the programs by writing them in assembly? A very good understanding of basics of how a computer operates is what every CS professional must have. H&P Wrote two books on CA. I am talking about their first book, the introductory text for understanding basic aspects of how a computer works. Even if you feel that you know whatever is written in that book, donot stop reading. It’s good to revise basics again and again.

	- **Fundamentals of Programming** by Donald Knuth.
	
	  The core of CS is algorithms and Data structures. Every CS professional must have the 3 volumes of Knuth’s Book on programming. It really doesnot matter if you take 30 years of your life to understand what Knuth has written, what is more important is that you read atleast some part of that book everyday without fail.

	- **Introduction to Algorithms** by Cormen, Leiserson and Rivest 
	  
	  This book should be read daily to keep your concepts fresh. This is the best book for fundamental concepts in algorithms.

## Learn Professional Ethics

- As a CS Professional, you are morally obliged to do a good job. What this means is that you are supposed to do your job not for your manager but for yourself. This is already told in Bhagwatgeeta : Doing duties of your life.

- The direct implication of this is: never ever write a bad code. You don’t need to be fastest and run after shipping dates; rather you need to write quality code. Never write junk code. Rewrite it till it is good. Thoroughly test every piece of code that you write. Donot write codes which are “sort of allright”. You might not achieve perfection, but atleast your code should be of good quality.

- Let me quote my own example in this context. You might have heard about STL, The Standard Template Library that ships in with C++ compilers. I wrote it 10 years ago, in 1994. While implementing one of the routines in the STL, namely the “search routine”, I was a bit lazy and instead of writing a good linear order implementation of KMP which was difficult to code, I wrote a best quadratic implementation. I knew that I could make the search faster by writing a linear-order implementation, but I was lazy and I did not do that. And, after 10 years of my writing STL, exactly the same implementation is still used inside STL and STL ships with an inefficient quadratic implementation of search routine even today!! You might ask me: why can’t you rewrite that? Well...I cannot, because that code is no more my property!! Further, nobody today will be interested in a standalone efficient STL ...people would prefer one which automatically ships out with the compiler itself.

- Moral is, you should have aesthetic beauty built inside you. You should “feel” uneasy on writing bad code and should be eager to rewrite the code till it becomes upto the quality. And to the judge the quality, you need to develop sense regarding which algorithms to use under what circumstances.

## Figure out your Goals

- Always aspire doing bigger things in life

- “Viewing promotion path as your career” is a completely wrong goal. If you are really interested in studying and learning new things, never ever aspire for being a manager. Managers cannot learn and study...they have no time. “Company ladder aspiration” is not what should be important for you.

- You might feel that you want to do certain things which you cannot do till you become a manager. When you become a manager, you will soon realize that now you just cannot do anything!

- You will have a great experience as programmers. But if you care for people and love people, you will never enjoy being a manager...most good managers are reluctant managers. If you see people as people, you cannot survive at management level.

- Always aspire for professional greatness. Our profession is very beautiful because we create abstract models and implement them in reality. There is a big fun in doing that. We have a profession which allows us to do creative things and even gives nice salary for that.

- The three biggest mistakes that people usually make are aiming for money, aiming for promotion and aiming for fame. The moment you get some of these, you aspire for some more...and then there is no end. I donot mean that you shouldnot earn money, but you should understand how much money would satisfy your needs. Bill Clinton might be the richest person in the world; he is certainly not the happiest. Our lives are far better than his.

- Find your goal, and do best in the job that you have. Understand that what is in your pocket doesnot matter...what is in your brain finally matters. Money and fame donot matter. Knowledge matters.

## Follow your culture

I have seen the tradition that whatever junk is created in US, it rapidly spreads up in the rest of the world, and India is not an exception for this. This cultural change creates a very strong impact on everybody’s life. Habits of watching spicy Bollywood or Hollywood movies and listening to pop songs and all such stupid stuff gets very easily cultivated in people of your age...but believe me, there is nothing great in that. This all just makes you run away from your culture. And there is no wisdom in running away from your culture. Indian culture, which has great Vedas and stories like Mahabharata and Bhagwatgeeta is really great and even Donald Knuth enjoys reading that. You should understand that fundamental things in Indian culture teach you a lot and you should never forget them.

Finally, I would like to conclude by saying that it’s your life. Do not waste it on stupid things. Develop your tests, and start the fight.
