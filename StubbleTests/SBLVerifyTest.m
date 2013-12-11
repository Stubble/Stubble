#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testVerifyCallNotMade_ThrowsException {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	XCTAssertThrows(VERIFY([mock methodReturningInt]));
}

- (void)testVerifyCallThatWasMade_DoesNotThrowException {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[mock methodReturningInt];
	
	XCTAssertNoThrow(VERIFY([mock methodReturningInt]));
}

- (void)testVerifyCallThatWasMade_OnComplexCall_DoesNotThrowException {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	XCTAssertThrows(VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
	
	[mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	XCTAssertNoThrow(VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

@end
