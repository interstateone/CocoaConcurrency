/* A quick implementation of a recursive lock

   Note that the documentation for NSLock says the following:

   "You should not use this class to implement a recursive lock.
    Calling the lock method twice on the same thread will lock up your thread permanently.
    Use the NSRecursiveLock class to implement recursive locks instead."

   I'm taking this to mean that you shouldn't use NSLock as a replacement for NSRecursiveLock, but not that you can't use it to mimic its behaviour.
   It also seems that recursive locks are a uh... contentious topic.
   The specific details of both sides are still a bit over my head, but suffice it to say that it's worth examining your design if you plan on using them.
*/

import Cocoa


class RecursiveLock {
    var lockCount = 0
    var isLocked: Bool {
        get {
            return lockCount > 0
        }
    }
    var _lock: NSLock
    var lockingThread: NSThread? = nil
    
    init() {
        _lock = NSLock()
    }
    
    func lock() {
        if !isLocked {
            _lock.lock()
            lockingThread = NSThread.currentThread()
        }
        else if let thread = lockingThread {
            assert(thread == NSThread.currentThread(), "Attempting to lock a different thread than the original locking thread.")
        }
        lockCount += 1
    }
    func unlock() {
        if !isLocked {
            return
        }
        if let thread = lockingThread {
            assert(thread == NSThread.currentThread(), "Attempting to lock a different thread than the original locking thread.")
        }
        lockCount -= 1
        if lockCount == 0 {
            _lock.unlock()
            lockingThread = nil
        }
    }
}


let lock = RecursiveLock();
lock.lock()

for i in 1..100 {
    lock.lock()
    println("\(i)");
    lock.unlock()
}

lock.unlock()

println("Is locked? \(lock.isLocked)")