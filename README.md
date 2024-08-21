# Swiftlet
#### A Quizlet clone built entirely with Swift and accessible through the CLI
### Why
One of my favorite studying tools is Quizlet. It is one of the few applications that I find the premium version worth paying for. It makes it easy to create flashcards and review them.

However, since it is a web application and rich with features, there can be quite a lot of bloat. Sometimes, Quizlet seems to just shut down and throws me into a white screen, which is frustrating when I am in the study "flow."

Because of this, I wanted to recreate the fundamentals of Quizlet with stripped down functionality to just what I needed: flashcards.
#### How
The way that Quizlet is setup lends itself well to a file system. There are sets (files) which are stored in folders (directories). This made my choice of platform easy, as the terminal is the quickest way to interact with your computer's files. This also means that Swiftlet is entirely local and personal.

My choice of language was a bit more esoteric and personal. I like Swift a lot, it has a beautiful type set and is easy to interact with. It is also wicked fast, which lent itself to the project at hand.
#### Result
##### Questions
![ ](QuestionCode.png)
This code is responsible for getting a user's question and respective answer, and then storing it into a dictionary with a question number as a key.
##### Answers
![ ](AnswerCode.png)
This code compares the user's answer to a question. If the answer is correct, a point is added to their score. If the answer is incorrect, the user is given a chance to correct their mistake. If the corrected answer is still wrong, a point is deducted from their score.
##### Demo
![ ](Demo.mov)
