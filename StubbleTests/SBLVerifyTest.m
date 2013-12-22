#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

- (void)testWhenVerifyingForMethodThatWasCalledThatWasMadeThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	[mock methodReturningInt];

	XCTAssertNoThrow(verify([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];

    XCTAssertNoThrow(verify([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithNoReturn];

    XCTAssertNoThrow(verify([mock methodWithNoReturn]));
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	XCTAssertNoThrow(verify([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyingExactlyZeroTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(verifyTimes(times(0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingExactlyOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(verifyTimes(times(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingExactlyTwoTimes_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(verifyTimes(times(2), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(verifyTimes(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledLotsOfTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(verifyTimes(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

// TODO: Possible line to be drawn to only allow at least 1 time for between matches.
- (void)testWhenVerifyingBetwenZeroAndZeroTimes_WhenCalledZeroTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(verifyTimes(between(0, 0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingBetwenOneAndOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

    XCTAssertNoThrow(verifyTimes(between(1, 1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingBetwenOneAndThreeTimes_WhenCalledValidNumberOfTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithArray:@[@"arg1"]];
    XCTAssertNoThrow(verifyTimes(between(1, 3), [mock methodWithArray:@[@"arg1"]]));

    // TODO: Shouldn't have to recreate mock? Won't work without this currently.
    mock = [SBLMock mockForClass:SBLTestingClass.class];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
    XCTAssertNoThrow(verifyTimes(between(1, 3), [mock methodWithArray:@[@"arg1"]]));

    mock = [SBLMock mockForClass:SBLTestingClass.class];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
    XCTAssertNoThrow(verifyTimes(between(1, 3), [mock methodWithArray:@[@"arg1"]]));
}

- (void)testWhenVerifyingNever_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(verifyNever([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingNeverTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    XCTAssertNoThrow(verifyTimes(never(), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingTimesForMultipleMethodCallsThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];
    [mock methodWithNoReturn];
    [mock methodReturningString];
    [mock methodReturningInt];

    XCTAssertNoThrow(verify([mock methodWithNoReturn]));
    XCTAssertNoThrow(verify(times(2), [mock methodReturningInt]));
    XCTAssertNoThrow(verify(times(3), [mock methodReturningString]));
    XCTAssertNoThrow(verifyNever([mock methodReturningNSValue]));
}

- (void)testWhenVerifyCalledWithCommasThen {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

//	[mock methodWithArray:@[@"1", @"2", @"3"]];
//
//    XCTAssertNoThrow(verify([mock methodWithArray:@[@"1", @"2", @"3"]]));
    mock = [SBLMock mockForClass:SBLTestingClass.class];
    [mock methodWithArray:@[@"4", @"5", @"6"]];
    [mock methodWithArray:@[@"4", @"5", @"6"]];
    XCTAssertNoThrow(verifyTimes(times(2), [mock methodWithArray:@[@"4", @"5", @"6"]]));
}

@end
