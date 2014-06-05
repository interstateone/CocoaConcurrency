#import <Foundation/Foundation.h>


@interface Runner : NSObject

@property (nonatomic, strong, readonly) NSConditionLock *conditionLock;

- (instancetype)initWithConditionLock:(NSConditionLock *)conditionLock;
- (void)fibonacci:(NSNumber *)indexNumber;

@end


@implementation Runner

- (instancetype)initWithConditionLock:(NSConditionLock *)conditionLock {
	self = [super init];
	if (!self) return nil;
	_conditionLock = conditionLock;
	return self;
}

- (void)fibonacci:(NSNumber *)indexNumber {
	@autoreleasepool {
		NSInteger index = [indexNumber integerValue];
			
		[self.conditionLock lock];
		NSInteger result = [self calculateFibonacci:index];
		NSLog(@"fibonacci number %ld: %ld", (long)index, (long)result);
		[self.conditionLock unlockWithCondition:[self.conditionLock condition] + 1];	
	}
}

- (NSInteger)calculateFibonacci:(NSInteger)index {
	if (index <= 1) return index;
	return [self calculateFibonacci:index - 1] + [self calculateFibonacci:index - 2];
}

@end


int main(int argc, char *argv[]) {
	@autoreleasepool {
		// From Apple's Threading Guide (https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Multithreading/AboutThreads/AboutThreads.html#//apple_ref/doc/uid/10000057i-CH6-SW16)
		//
		// "A process runs until all non-detached threads have exited. By default, only the application’s main thread is created as non-detached, but you can create other threads that way as well."
		// Because pthreads are by default non-detached a lock is not required for the pthread example to finish calculating all of the Fibonacci numbers
		// NSThreads are detached by default, so in this case we're using a condition lock to block the main thread until all other threads have finished
		NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:0];
		
		for (NSInteger index = 0; index < 10; index += 1) {
			Runner *runner = [[Runner alloc] initWithConditionLock:conditionLock];
			NSThread *thread = [[NSThread alloc] initWithTarget:runner selector:@selector(fibonacci:) object:@(index)];
			[thread start];
		}
		
		[conditionLock lockWhenCondition:10];
	}
}
