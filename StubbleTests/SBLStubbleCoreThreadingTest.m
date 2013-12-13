#import <XCTest/XCTest.h>
#import "SBLStubbleCore.h"

@interface SBLStubbleCoreThreadingTest : XCTestCase

@end

@implementation SBLStubbleCoreThreadingTest

- (void)testStubbleCoreIsSharedInstanceOnMainThread {
	SBLStubbleCore *core1 = [SBLStubbleCore core];
	SBLStubbleCore *core2 = [SBLStubbleCore core];
	
	XCTAssertEqual(core1, core2);
}

- (void)testStubbleCoreIsSharedInstanceOnBackgroundThread {
	__block SBLStubbleCore *core1 = nil;
	__block SBLStubbleCore *core2 = nil;
	
	dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		core1 = [SBLStubbleCore core];
		core2 = [SBLStubbleCore core];
	});
	
	XCTAssertEqual(core1, core2);
}

- (void)testStubbleCoreIsDifferentInstanceOnOtherThread {
	SBLStubbleCore *core1 = [SBLStubbleCore core];
	__block SBLStubbleCore *core2 = nil;
	
	dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		core2 = [SBLStubbleCore core];
	});
	
	XCTAssertNotEqual(core1, core2);
}

@end
