#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"
#import "SBLVerificationResult.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

- (void)setUp {
    [super setUp];
}

#pragma mark - Verify Success Tests

- (void)testWhenVerifyingForMethodThatWasCalledThatWasMadeThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	[mock methodReturningInt];

	//[self recordFailureWithDescription:@"hi" inFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__ expected:YES];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithNoReturn];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithNoReturn]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyingExactlyZeroTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyTwoTimes_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(2), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledTwoTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
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
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

// TODO: Possible line to be drawn to only allow at least 1 time for between matches.
- (void)testWhenVerifyingBetwenZeroAndZeroTimes_WhenCalledZeroTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(0, 0), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetwenOneAndOneTime_WhenCalledOneTime_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 1), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetwenOneAndThreeTimes_WhenCalledValidNumberOfTimes_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithArray:@[@"arg1"]];
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 3), [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);

    // TODO: Shouldn't have to recreate mock? Won't work without this currently.
    mock = [SBLMock mockForClass:SBLTestingClass.class];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
	result = SBLVerifyTimesImpl(between(1, 3), [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);

    mock = [SBLMock mockForClass:SBLTestingClass.class];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
	result = SBLVerifyTimesImpl(between(1, 3), [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);
}

//- (void)testWhenVerifyingNever_WhenNotCalled_ThenNoExceptionIsThrown {
//    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
//
//    XCTAssertNoThrow(verifyNever([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
//}

- (void)testWhenVerifyingNeverTimes_WhenNotCalled_ThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	SBLVerificationResult *result = SBLVerifyTimesImpl(never(), [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingTimesForMultipleMethodCallsThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

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
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

//	[mock methodWithArray:@[@"1", @"2", @"3"]];
//
//    verify([mock methodWithArray:@[@"1", @"2", @"3"]]);
	
    mock = [SBLMock mockForClass:SBLTestingClass.class];
    [mock methodWithArray:@[@"4", @"5", @"6"]];
    [mock methodWithArray:@[@"4", @"5", @"6"]];
    verifyTimes(times(2), [mock methodWithArray:@[@"4", @"5", @"6"]]);
}

- (void)testMultipleVerifiesDoesNotCauseCrash {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

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
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was not called at least 1 times");
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodWithManyArguments:@"1" primitive:2 number:@3];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"2" primitive:2 number:@3]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodWithManyArguments:primitive:number:' was not called at least 1 times");
	
	result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"1" primitive:1 number:@3]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodWithManyArguments:primitive:number:' was not called at least 1 times");
	
	result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithManyArguments:@"1" primitive:2 number:@1]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodWithManyArguments:primitive:number:' was not called at least 1 times");
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeNotCalledThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(1), [mock methodWithNoReturn]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodWithNoReturn' was not called at least 1 times");
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyIsCalledZeroTimesThenAnExpectedExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(1), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was not called at least 1 times");
}

- (void)testWhenVerifyIsCalledTooFewTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(2), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was not called at least 2 times");
}

- (void)testWhenVerifyTimesIsCalledTooManyTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodReturningInt];
    [mock methodReturningInt];
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(times(2), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called more than 2 times");
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledOnceThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodReturningInt];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(never(), [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called more than 0 times");
}

- (void)testWhenVerifyAtLeastTwoTimesIsOnlyCalledOneTimeThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(atLeast(2), [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was not called at least 2 times");
}

- (void)testWhenVerifyBetweenIsCalledTooFewTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(2, 3), [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was not called at least 2 times");
}

- (void)testWhenVerifyBetweenIsCalledTooManyTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [mock methodReturningString];
    [mock methodReturningString];
    [mock methodReturningString];
	
	SBLVerificationResult *result = SBLVerifyTimesImpl(between(1, 2), [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was called more than 2 times");
}

@end
