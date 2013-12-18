#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

- (void)testWhenVerifyingForMethodThatWasCalledThatWasMadeThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[mock methodReturningInt];

	XCTAssertNoThrow(VERIFY([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];

    XCTAssertNoThrow(VERIFY([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithNoReturn];

    XCTAssertNoThrow(VERIFY([mock methodWithNoReturn]));
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	XCTAssertNoThrow(VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyingExactlyOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(VERIFY_TIMES(TIMES(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingExactlyTwoTimes_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(VERIFY_TIMES(TIMES(2), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingForMethodTwoTimes_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(VERIFY_TIMES(TIMES(2), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingNever_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(VERIFY_NEVER([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingZeroTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(VERIFY_TIMES(TIMES(0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingNeverTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(VERIFY_TIMES(NEVER(), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingTimesForMultipleMethodCallsThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];
    [mock methodWithNoReturn];
    [mock methodReturningString];
    [mock methodReturningInt];

    XCTAssertNoThrow(VERIFY([mock methodWithNoReturn]));
    XCTAssertNoThrow(VERIFY_TIMES(TIMES(2), [mock methodReturningInt]));
    XCTAssertNoThrow(VERIFY_TIMES(TIMES(3), [mock methodReturningString]));
    XCTAssertNoThrow(VERIFY_NEVER([mock methodReturningNSValue]));
}

@end
