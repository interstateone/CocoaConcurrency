CocoaConcurrency
================

Examples of concurrency with Cocoa (and related libraries) from the ground up

## Examples
- [fibonacci_pthread.c](fibonacci_pthread.c): Calculates the first n numbers in the Fibonacci sequence using a pthread per number.
- [fibonacci_nsthread.m](fibonacci_nsthread.m): Calculates the first n numbers in the Fibonacci sequence using a NSThread per number.
- [fibonacci_nsthread.swift](fibonacci_nsthread.swift): A straightforward port of the previous example to Swift just for fun.
- [nsrunloop.m](nsrunloop.m): "Visualize" the progress of an NSRunLoop using a run loop observer.
- [recursivelock.swift](recursivelock.swift): A simple implementation of a recursive lock that can "lock" a thread more than once without deadlocking.

## Resources
- [Threading Programming Guide (Apple)](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Multithreading/Introduction/Introduction.html) If you pick one link, pick this. Read all of it and follow all of the links. It'll take you a while and that's okay.
- [Mastering Threads on Mac OS X (Dr. Dobb's)](http://www.drdobbs.com/parallel/mastering-threads-on-macos-x/232602177) Some quick examples with POSIX threads and NSThreads
- [The App Launch Sequence on iOS (Ole Begemann)](http://oleb.net/blog/2011/06/app-launch-sequence-ios/) This article isn't directly relevant to concurrency, but I found it while looking into run loops and might help bridge understanding of small examples to an actual iOS or Mac app.
- [Recursive Locks (Brent Simmons)](http://inessential.com/2013/09/24/recursive_locks) It's funny, I probably glossed over this post when Brent first wrote it because I only had a slight idea as to what a recursive lock might be, and yet here I am again. All three links in this post are great.
- [Scheduling support for concurrency and parallelism in the Mach operating system (David L. Black)](http://repository.cmu.edu/cgi/viewcontent.cgi?article=2949&context=compsci) Includes details and comparisons of the design of Mach's scheduler. 
- [A Tour of OSAtomic (Mike Ash)](https://www.mikeash.com/pyblog/friday-qa-2011-03-04-a-tour-of-osatomic.html) A brief overview including compare and swap, spinlocks and memory barriers.
