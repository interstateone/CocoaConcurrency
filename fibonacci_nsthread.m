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
		NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:0];
		
		for (NSInteger index = 0; index < 10; index += 1) {
			Runner *runner = [[Runner alloc] initWithConditionLock:conditionLock];
			NSThread *thread = [[NSThread alloc] initWithTarget:runner selector:@selector(fibonacci:) object:@(index)];
			[thread start];
		}
		
		[conditionLock lockWhenCondition:10];
	}
}
