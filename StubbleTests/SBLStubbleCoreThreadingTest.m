#import <XCTest/XCTest.h>
#import "SBLTransactionManager.h"

@interface SBLStubbleCoreThreadingTest : XCTestCase

@end

@implementation SBLStubbleCoreThreadingTest

- (void)testStubbleCoreIsSharedInstanceOnMainThread {
	SBLTransactionManager *core1 = [SBLTransactionManager currentTransactionManager];
	SBLTransactionManager *core2 = [SBLTransactionManager currentTransactionManager];
	
	XCTAssertEqual(core1, core2);
}

- (void)testStubbleCoreIsSharedInstanceOnBackgroundThread {
	__block SBLTransactionManager *core1 = nil;
	__block SBLTransactionManager *core2 = nil;
	
	dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		core1 = [SBLTransactionManager currentTransactionManager];
		core2 = [SBLTransactionManager currentTransactionManager];
	});
	
	XCTAssertEqual(core1, core2);
}

- (void)testStubbleCoreIsDifferentInstanceOnOtherThread {
	SBLTransactionManager *core1 = [SBLTransactionManager currentTransactionManager];
	__block SBLTransactionManager *core2 = nil;
	
	dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		core2 = [SBLTransactionManager currentTransactionManager];
	});
	
	XCTAssertNotEqual(core1, core2);
}

@end
