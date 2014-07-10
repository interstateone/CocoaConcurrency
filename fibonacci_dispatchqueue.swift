import Cocoa

func fibonacci(index: UInt) -> UInt {
    switch (index) {
        case 0, 1:
            return index
        default:
            return fibonacci(index - 1) + fibonacci(index - 2)
    }
}

println("--- Concurrent Queue ---")
let concurrentQueue = dispatch_queue_create("ca.brandonevans.GCDQueueDemo.Concurrent", DISPATCH_QUEUE_CONCURRENT);
dispatch_apply(10, concurrentQueue, { fibNum in
    println("fibonacci number \(fibNum): \(fibonacci(fibNum))")
})

println("\n--- Serial Queue ---")
let serialQueue = dispatch_queue_create("ca.brandonevans.GCDQueueDemo.Serial", DISPATCH_QUEUE_SERIAL);
dispatch_apply(10, serialQueue, { fibNum in
    println("fibonacci number \(fibNum): \(fibonacci(fibNum))")
})

println("\n--- Concurrent Queue with barriers ---")
for fibNum in 1...10 {
	dispatch_barrier_async(concurrentQueue, {
		println("fibonacci number \(fibNum): \(fibonacci(UInt(fibNum)))")
	})
}