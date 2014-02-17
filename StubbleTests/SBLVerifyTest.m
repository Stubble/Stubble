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

- (void)testWhenVerifyingForMethodThatWasCalledThatWasMadeThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	[mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithNoReturn];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithNoReturn]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyingExactlyZeroTimes_WhenNotCalled_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyOneTime_WhenCalledOneTime_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyTwoTimes_WhenCalledTwoTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(2), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledTwoTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledLotsOfTimes_ThenResultIsSuccessful {
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

- (void)testWhenVerifyingBetwenZeroAndZeroTimes_WhenCalledZeroTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(0, 0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetwenOneAndOneTime_WhenCalledOneTime_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetweenOneAndThreeTimes_WhenCalledValidNumberOfTimes_ThenResultIsSuccessful {
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

- (void)testWhenVerifyingForMethodThatWasNeverCalledThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    NSString *expectedFailureMessageFormat = @"Method 'methodWithManyArguments:primitive:number:' was called, but with differing arguments. Expected: %@ \rActual: %@";
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"2" primitive:2 number:@3]);
	XCTAssertFalse(result.successful);
    NSArray *expectedArray = @[@"1", @"2", @"3"];
    NSArray *actualArray = @[@"2", @"2", @"3"];
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

	result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"1" primitive:1 number:@3]);
	XCTAssertFalse(result.successful);
    actualArray = @[@"1", @"1", @"3"];
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

    result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"1" primitive:2 number:@1]);
    XCTAssertFalse(result.successful);
    actualArray = @[@"1", @"2", @"1"];
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentPrimitiveParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyPrimitiveArguments:(int)123
                                  shortArg:(short)123
                                   longArg:(long)123
                               longLongArg:(long long)123
                                 doubleArg:(double)12.3
                                  floatArg:(float)12.3
                                   uIntArg:(unsigned int)123
                                 uShortArg:(unsigned short)123
                                  uLongArg:(unsigned long)123
                                   charArg:(char)'w'
                                  uCharArg:(unsigned char)123
                                   boolArg:(bool)YES];

    NSString *expectedFailureMessageFormat = @"Method 'methodWithManyPrimitiveArguments:shortArg:longArg:longLongArg:doubleArg:floatArg:uIntArg:uShortArg:uLongArg:charArg:uCharArg:boolArg:' was called, but with differing arguments. Expected: %@ \rActual: %@";
    SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyPrimitiveArguments:(int)234
        shortArg:(short)234
        longArg:(long)234
        longLongArg:(long long)234
        doubleArg:(double)23.4f
        floatArg:(float)23.4f
        uIntArg:(unsigned int)234
        uShortArg:(unsigned short)234
        uLongArg:(unsigned long)234
        charArg:(char)'x'
        uCharArg:(unsigned char)234
        boolArg:(bool)NO]);

    XCTAssertFalse(result.successful);
    NSArray *expectedArray = @[@"123", @"123", @"123", @"123", @"12.3", @"12.3", @"123", @"123", @"123", @"w", @"123", @"YES"];
    NSArray *actualArray = @[@"234", @"234", @"234", @"234", @"23.4", @"23.4", @"234", @"234", @"234", @"x", @"234", @"NO"];
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeNotCalledThenTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithNoReturn]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyIsCalledZeroTimesThenTheTestFailsWithTheCorrectMessage {
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
