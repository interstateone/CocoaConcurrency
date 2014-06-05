import Cocoa

class Runner {
    var conditionLock: NSConditionLock

    init(lock: NSConditionLock) {
        conditionLock = lock
    }
    
    @objc func fibonacci(indexNumber: NSNumber) {
        let index = indexNumber.integerValue
        conditionLock.lock()
        let result = self.calculateFibonacci(index)
        println("fibonacci number \(index): \(result)")
        conditionLock.unlockWithCondition(conditionLock.condition + 1)
    }
    
    func calculateFibonacci(index: Int) -> Int {
        switch (index) {
            case 0, 1:
                return index
            default:
                return calculateFibonacci(index - 1) + calculateFibonacci(index - 2)
        }
    }
}

let conditionLock = NSConditionLock(condition: 0)
for fibNum in 0..10 {
    let runner = Runner(lock: conditionLock)
    let thread = NSThread(target: runner, selector: "fibonacci:", object: fibNum)
    thread.start()
}
conditionLock.lockWhenCondition(10)
