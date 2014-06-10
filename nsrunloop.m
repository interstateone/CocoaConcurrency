/*

This is an example that helps visualize the execution of a run loop.
It creates a run loop and adds an observer, then uses a timer to print out a timestamp.
The observer prints each stage of the run loop's defined process.

We can adjust the number of loops, the timeout for the run loop and the timer's interval to see how that effects the number of timer firings or whether it's fired at all.

*/

#import <Foundation/Foundation.h>


@interface Announcer : NSObject

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter; 

- (void)announceTime;

@end


@implementation Announcer

- (instancetype)init {
	self = [super init];
	if (!self) return nil;
	
	_dateFormatter = [[NSDateFormatter alloc] init];
	_dateFormatter.dateFormat = @"hh:mm:ss.SSS";
	
	return self;
}

- (void)announceTime {
	NSLog(@"Current time is %@", [_dateFormatter stringFromDate:[NSDate date]]);
}

@end


void runLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
	NSString *activityString;
	switch (activity) {
		case kCFRunLoopEntry:
			activityString = @"entry";
			break;
		case kCFRunLoopBeforeTimers:
			activityString = @"before timers";
			break;
		case kCFRunLoopBeforeSources:
			activityString = @"before sources";
			break;
		case kCFRunLoopBeforeWaiting:
			activityString = @"before waiting";
			break;
		case kCFRunLoopAfterWaiting:
			activityString = @"after waiting";
			break;
		case kCFRunLoopExit:
			activityString = @"exit";
			break;
		default:
			break;
	}
	NSLog(@"Run loop activity: %@", activityString);
}


int main(int argc, char *argv[]) {
	@autoreleasepool {
		// "The UIApplicationMain function in iOS (or NSApplication in OS X) starts an application’s main loop as part of the normal startup sequence."
		// In this example we need to run the main thread's run loop manually since we aren't using a UIApplication or NSApplication as an entry point to an actual application
	    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	 
	    // Create a run loop observer and attach it to the run loop.
	    CFRunLoopObserverContext context = {0, NULL, NULL, NULL, NULL};
	    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserver, &context);
	 
	    if (observer) {
	        CFRunLoopRef cfLoop = [runLoop getCFRunLoop];
	        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
	    }
	 
	    // Create and schedule the timer.
		// scheduledTimerWithTimeInterval:target:selector:repeats: automatically adds the timer to the current run loop
		// You could do so explicitly with timerWithTimeInterval:invocation:repeats: and addTimer:forMode:
		Announcer *announcer = [[Announcer alloc] init];
	    [NSTimer scheduledTimerWithTimeInterval:0.1 target:announcer selector:@selector(announceTime) userInfo:nil repeats:YES];
	
	    NSInteger loopCount = 10;
	    do {
	        // Run the run loop 10 times to let the timer fire.
			NSLog(@"Running the loop");
	        [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
	        loopCount--;
	    }
	    while (loopCount);
	}
}