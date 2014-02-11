#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"
#import "SBLVerificationResult.h"
#import "SBLErrors.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

- (void)setUp {
    [super setUp];
}

#pragma mark - Verify Success Tests

- (void)testWhenVerifyingForMethodThatWasCalledThatWasMadeThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	[mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeThenNoExceptionThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithNoReturn];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithNoReturn]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenNoExceptionThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyingExactlyZeroTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyTwoTimes_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(2), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledLotsOfTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

// TODO: Possible line to be drawn to only allow at least 1 time for between matches.
- (void)testWhenVerifyingBetwenZeroAndZeroTimes_WhenCalledZeroTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(0, 0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetwenOneAndOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetweenOneAndThreeTimes_WhenCalledValidNumberOfTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithArray:@[@"arg1"]];
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 3), [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);

    mock = mock(SBLTestingClass.class);
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
	result = SBLVerifyTimesImpl(between(1, 3), [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);

    mock = mock(SBLTestingClass.class);
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
	result = SBLVerifyTimesImpl(between(1, 3), [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingNeverWhenNotCalledThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyTimesImpl(never(), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);
}

- (void)testWhenVerifyingTimesForMultipleMethodCallsThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];
    [mock methodWithNoReturn];
    [mock methodReturningString];
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(1), [mock methodWithNoReturn]);
	XCTAssertTrue(result.successful);
	result = SBLVerifyTimesImpl(times(2), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
	result = SBLVerifyTimesImpl(times(3), [mock methodReturningString]);
	XCTAssertTrue(result.successful);
	result = SBLVerifyTimesImpl(never(), [mock methodReturningNSValue]);
	XCTAssertTrue(result.successful);
}

- (void)testVerifyCanBeCalledWithCommas {
    SBLTestingClass *mock =  mock(SBLTestingClass.class);
    [mock methodWithArray:@[@"4", @"5", @"6"]];
    [mock methodWithArray:@[@"4", @"5", @"6"]];
    verifyTimes(times(2), [mock methodWithArray:@[@"4", @"5", @"6"]]);
}

- (void)testMultipleVerifiesDoesNotCauseCrash {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithObject:@(22)];

    @autoreleasepool {
        verifyTimes(times(1), [mock methodWithObject:any()]);
    }

    @autoreleasepool {
        verifyTimes(times(1), [mock methodWithObject:any()]);
    }

    @autoreleasepool {
        verifyTimes(times(1), [mock methodWithObject:any()]);
    }
}

#pragma mark - Verify Failure Tests

- (void)testWhenVerifyingForMethodThatWasNeverCalledThenExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodWithManyArguments:@"1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"2" primitive:2 number:@3]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
	
	result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"1" primitive:1 number:@3]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
	
	result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"1" primitive:2 number:@1]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeNotCalledThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithNoReturn]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyIsCalledZeroTimesThenAnExpectedExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

- (void)testWhenVerifyingExactNumberOfTimesAndMethodIsCalledTooFewTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(2), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called 1 time (expected exactly 2)");
}

- (void)testWhenVerifyingExactNumberOfTimesAndMethodIsCalledTooManyTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodReturningInt];
    [mock methodReturningInt];
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(1), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called 3 times (expected exactly 1)");
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledOnceThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(never(), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called 1 time (expected no calls)");
}

- (void)testWhenVerifyingAtLeastAndTheMethodIsCalledFewerTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodReturningString];
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(3), [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was called 2 times (expected at least 3)");
}

- (void)testWhenVerifyingBetweenAndMethodIsCalledTooFewTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(2, 3), [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was called 1 time (expected between 2 and 3)");
}

- (void)testWhenVerifyingBetweenAndMethodIsCalledTooManyTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodReturningString];
    [mock methodReturningString];
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 2), [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was called 3 times (expected between 1 and 2)");
}

#pragma mark - Verify No Interactions Tests

- (void)testWhenVerifyingNoInteractionsWhenMockNotCalledThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    SBLVerificationResult *result = SBLVerifyNoInteractionsImpl(mock);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);
}

- (void)testWhenVerifyingNoInteractionsWhenDifferentMockCalledThenResultIsSuccessful {
    SBLTestingClass *mock1 = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);

    [mock2 methodReturningBool];

    SBLVerificationResult *result = SBLVerifyNoInteractionsImpl(mock1);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);
}

- (void)testWhenVerifyingNoInteractionsWhenMockCalledThenTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningBool];

    SBLVerificationResult *result = SBLVerifyNoInteractionsImpl(mock);
    XCTAssertFalse(result.successful);
    XCTAssertEqualObjects(result.failureDescription, SBLMethodWasCalledUnexpectedly);
}

- (void)testWhenVerifyingNoInteractionsAndSecondMockIsCalledThenOnlySecondMockFailsWithTheCorrectMessage {
    SBLTestingClass *mock1 = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);

    [mock2 methodReturningBool];

    SBLVerificationResult *result1 = SBLVerifyNoInteractionsImpl(mock1);
    SBLVerificationResult *result2 = SBLVerifyNoInteractionsImpl(mock2);
    XCTAssertTrue(result1.successful);
    XCTAssertFalse(result2.successful);
    XCTAssertEqualObjects(result2.failureDescription, SBLMethodWasCalledUnexpectedly);
}

#pragma mark - Resetting Mocks

- (void)testWhenMockIsResetThenVerifyOfPreviousCallFails {
	SBLTestingClass *mock = mock(SBLTestingClass.class);

	[mock methodReturningBool];

	SBLVerificationResult *result1 = SBLVerifyTimesImpl(times(1), [mock methodReturningBool]);

	resetMock(mock);

	SBLVerificationResult *result2 = SBLVerifyTimesImpl(times(1), [mock methodReturningBool]);

	XCTAssertTrue(result1.successful);
	XCTAssertFalse(result2.successful);
}

- (void)testWhenMockIsResetThenPreviousWhenCallsAreRemoved {
	SBLTestingClass *mock = mock(SBLTestingClass.class);

	[when([mock methodReturningString]) thenReturn:@"value1"];

	resetMock(mock);

	NSString *string = [mock methodReturningString];

	XCTAssertNil(string);
}

@end
