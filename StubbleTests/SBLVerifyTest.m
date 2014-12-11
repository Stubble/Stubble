#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"
#import "SBLVerificationResult.h"
#import "SBLErrors.h"
#import <UIKit/UIKit.h>

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
	
	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithNoReturn];

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithNoReturn]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingForMethodWithPointerThatMatchesThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    NSInteger *integerPointer = (NSInteger *) 1;
    [mock methodWithPrimitiveReference:integerPointer];

    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithPrimitiveReference:integerPointer]);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);
}

- (void)testWhenVerifyingForMethodWithStructThatMatchesThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    NSInteger *integerPointer = (NSInteger *) 1;
    [mock methodWithPrimitiveReference:integerPointer];

    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithPrimitiveReference:integerPointer]);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);

    [mock methodWithCGRect:CGRectZero];

    result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithCGRect:CGRectZero]);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);

    SBLTestingStruct testingStruct1 = {1, YES, "other stuff"};
    [mock methodWithStruct:testingStruct1];

    result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithStruct:testingStruct1]);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);
}

- (void)testWhenVerifyingForMethodWithUnknownTypeThatMatchesThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    const char *cArray1[1] = {"a"};
    [mock methodWithCArray:cArray1];

    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithCArray:cArray1]);
    XCTAssertTrue(result.successful);
    XCTAssertNil(result.failureDescription);
}

- (void)testWhenVerifyingNilObjectThatMatchesThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithObject:nil];

    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithObject:nil]);

    XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingNullBlockThatMatchesThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithBlock:NULL];

    SBLVerificationResult *result = SBLVerifyImpl(times(1), nil, [mock methodWithBlock:NULL]);

    XCTAssertTrue(result.successful);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyingExactlyZeroTimes_WhenNotCalled_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyImpl(times(0), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyOneTime_WhenCalledOneTime_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyImpl(times(1), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingExactlyTwoTimes_WhenCalledTwoTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyImpl(times(2), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastOneTime_WhenCalledTwoTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
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

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetwenZeroAndZeroTimes_WhenCalledZeroTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyImpl(between(0, 0), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetwenOneAndOneTime_WhenCalledOneTime_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];

	SBLVerificationResult *result = SBLVerifyImpl(between(1, 1), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingBetweenOneAndThreeTimes_WhenCalledValidNumberOfTimes_ThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithArray:@[@"arg1"]];
	SBLVerificationResult *result = SBLVerifyImpl(between(1, 3), nil, [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);

    mock = mock(SBLTestingClass.class);
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
	result = SBLVerifyImpl(between(1, 3), nil, [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);

    mock = mock(SBLTestingClass.class);
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
    [mock methodWithArray:@[@"arg1"]];
	result = SBLVerifyImpl(between(1, 3), nil, [mock methodWithArray:@[@"arg1"]]);
	XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingNeverWhenNotCalledThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyImpl(never(), nil, [mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
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

	SBLVerificationResult *result = SBLVerifyImpl(times(1), nil, [mock methodWithNoReturn]);
	XCTAssertTrue(result.successful);
	result = SBLVerifyImpl(times(2), nil, [mock methodReturningInt]);
	XCTAssertTrue(result.successful);
	result = SBLVerifyImpl(times(3), nil, [mock methodReturningString]);
	XCTAssertTrue(result.successful);
	result = SBLVerifyImpl(never(), nil, [mock methodReturningNSValue]);
	XCTAssertTrue(result.successful);
}

- (void)testVerifyCanBeCalledWithCommas {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
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

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentArgumentsThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithBool:YES];

    NSString *expectedFailureMessageFormat = @"Method 'methodWithBool:' was called, but with differing arguments. Expected: %@ \rActual: %@";
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithBool:NO]);
    XCTAssertFalse(result.successful);
    NSArray *actualArray = @[@"YES"];
    NSArray *expectedArray = @[@"NO"];
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    expectedFailureMessageFormat = @"Method 'methodWithManyArguments:primitive:number:' was called, but with differing arguments. Expected: %@ \rActual: %@";
	result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"2" primitive:2 number:@3]);
	XCTAssertFalse(result.successful);
    actualArray = @[@"1", @"2", @"3"];
    expectedArray = @[@"2", @"2", @"3"];
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

	result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"1" primitive:1 number:@3]);
	XCTAssertFalse(result.successful);
    expectedArray = @[@"1", @"1", @"3"];
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

    result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"1" primitive:2 number:@1]);
    XCTAssertFalse(result.successful);
    expectedArray = @[@"1", @"2", @"1"];
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentPrimitiveParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyPrimitiveArguments:(int) 123
                                  shortArg:(short) 123
                                   longArg:(long) 123
                               longLongArg:(long long) 123
                                 doubleArg:(double) 12.3
                                  floatArg:(float) 12.3
                                   uIntArg:(unsigned int) 123
                                 uShortArg:(unsigned short) 123
                                  uLongArg:(unsigned long) 123
                                   charArg:(char) 'w'
                                  uCharArg:(unsigned char) 123
                                   boolArg:(bool) YES];

    NSString *expectedFailureMessageFormat = @"Method 'methodWithManyPrimitiveArguments:shortArg:longArg:longLongArg:doubleArg:floatArg:uIntArg:uShortArg:uLongArg:charArg:uCharArg:boolArg:' was called, but with differing arguments. Expected: %@ \rActual: %@";
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyPrimitiveArguments:(int)234
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
    NSArray *expectedArray = @[@"234", @"234", @"234", @"234", @"23.4", @"23.4", @"234", @"234", @"234", @"x", @"234", @"NO"];
    NSArray *actualArray = @[@"123", @"123", @"123", @"123", @"12.3", @"12.3", @"123", @"123", @"123", @"w", @"123", @"YES"];
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentPointerParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    NSInteger *primitivePointer1 = (NSInteger *)1;
    NSInteger *primitivePointer2 = (NSInteger *)2;

    [mock methodWithPrimitiveReference:primitivePointer1];

    NSArray *actual = @[[NSString stringWithFormat:@"%p", primitivePointer1]];
    NSArray *expected = @[[NSString stringWithFormat:@"%p", primitivePointer2]];
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithPrimitiveReference:primitivePointer2]);
    XCTAssertFalse(result.successful);
    NSString *expectedFailureMessageFormat = @"Method '%@' was called, but with differing arguments. Expected: %@ \rActual: %@";
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithPrimitiveReference:", expected, actual];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

    const char* cArray1 = (const char *){"1"};
    const char* cArray2 = (const char *){"2"};
    [mock methodWithCArray:&cArray1];
    expectedFailureMessageFormat = @"Method '%@' was called, but with differing arguments. Expected: %@ \rActual: %@";
    actual = @[[NSString stringWithFormat:@"%p", &cArray1]];
    expected = @[[NSString stringWithFormat:@"%p", &cArray2]];
    result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithCArray:&cArray2]);
    XCTAssertFalse(result.successful);
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithCArray:", expected, actual];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentStructParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    CGRect expectedRect = CGRectMake(0, 1, 0, 1);
    CGRect actualRect = CGRectZero;

    [mock methodWithCGRect:actualRect];

    NSArray *actual = @[NSStringFromCGRect(CGRectZero)];
    NSArray *expected = @[NSStringFromCGRect(expectedRect)];
    NSString *expectedFailureMessageFormat = @"Method '%@' was called, but with differing arguments. Expected: %@ \rActual: %@";

    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithCGRect:expectedRect]);
    XCTAssertFalse(result.successful);
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithCGRect:", expected, actual];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

    SBLTestingStruct testingStruct1 = {1, NO, "aefaef"};
    SBLTestingStruct testingStruct2 = {2, NO, "aefaef"};
    [mock methodWithStruct:testingStruct1];

    result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithStruct:testingStruct2]);
    expected = @[@"struct"];
    actual = @[@"struct"];
    XCTAssertFalse(result.successful);
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithStruct:", expected, actual];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentNilParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    [mock methodWithManyArguments:nil primitive:2 number:@3];

    NSArray *expected = @[@"1", @"2", @"nil"];
    NSArray *actual = @[@"nil", @"2", @"3"];
    NSString *expectedFailureMessageFormat = @"Method '%@' was called, but with differing arguments. Expected: %@ \rActual: %@";
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:@"1" primitive:2 number:nil]);
    XCTAssertFalse(result.successful);
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithManyArguments:primitive:number:", expected, actual];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentNumericParametersThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithTimeInterval:12.3];

    NSString *expectedFailureMessageFormat = @"Method '%@' was called, but with differing arguments. Expected: %@ \rActual: %@";
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithTimeInterval:12.4]);
    XCTAssertFalse(result.successful);
    NSArray *expectedArray = @[@"12.4"];
    NSArray *actualArray = @[@"12.3"];
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithTimeInterval:", expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);

    [mock methodWithInteger:123];

    result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithInteger:124]);
    XCTAssertFalse(result.successful);
    expectedArray = @[@"124"];
    actualArray = @[@"123"];
    expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, @"methodWithInteger:", expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithDifferentArgumentsIncludingAnyThenHelpfulMessageIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    NSString *expectedFailureMessageFormat = @"Method 'methodWithManyArguments:primitive:number:' was called, but with differing arguments. Expected: %@ \rActual: %@";
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithManyArguments:any() primitive:3 number:any()]);
    XCTAssertFalse(result.successful);
    NSArray *expectedArray = @[@"(any)", @"3", @"(any)"];
    NSArray *actualArray = @[@"1", @"2", @"3"];
    NSString *expectedFailureDescription = [NSString stringWithFormat:expectedFailureMessageFormat, expectedArray, actualArray];
    XCTAssertEqualObjects(result.failureDescription, expectedFailureDescription);
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeNotCalledThenTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodWithNoReturn]);
    XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyIsCalledZeroTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), nil, [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
    XCTAssertNotNil(result.failureDescription);
}

- (void)testWhenVerifyingExactNumberOfTimesAndMethodIsCalledTooFewTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];

	SBLVerificationResult *result = SBLVerifyImpl(times(2), nil, [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called 1 time (expected exactly 2)");
}

- (void)testWhenVerifyingExactNumberOfTimesAndMethodIsCalledTooManyTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];
    [mock methodReturningInt];
    [mock methodReturningInt];

	SBLVerificationResult *result = SBLVerifyImpl(times(1), nil, [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called 3 times (expected exactly 1)");
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledOnceThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];

	SBLVerificationResult *result = SBLVerifyImpl(never(), nil, [mock methodReturningInt]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningInt' was called 1 time (expected no calls)");
}

- (void)testWhenVerifyNeverIsCalledButWithDifferingParametersThenTheTestPasses {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithInteger:2];

    SBLVerificationResult *result = SBLVerifyImpl(never(), nil, [mock methodWithInteger:1]);
    XCTAssertTrue(result.successful);
    result = SBLVerifyImpl(never(), nil, [mock methodWithInteger:3]);
    XCTAssertTrue(result.successful);
    result = SBLVerifyImpl(never(), nil, [mock methodWithInteger:4]);
    XCTAssertTrue(result.successful);
}

- (void)testWhenVerifyingAtLeastAndTheMethodIsCalledFewerTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];
    [mock methodReturningString];

	SBLVerificationResult *result = SBLVerifyImpl(atLeast(3), nil, [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was called 2 times (expected at least 3)");
}

- (void)testWhenVerifyingBetweenAndMethodIsCalledTooFewTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];

	SBLVerificationResult *result = SBLVerifyImpl(between(2, 3), nil, [mock methodReturningString]);
	XCTAssertFalse(result.successful);
	XCTAssertEqualObjects(result.failureDescription, @"Method 'methodReturningString' was called 1 time (expected between 2 and 3)");
}

- (void)testWhenVerifyingBetweenAndMethodIsCalledTooManyTimesThenTheTestFailsWithTheCorrectMessage {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];
    [mock methodReturningString];
    [mock methodReturningString];

	SBLVerificationResult *result = SBLVerifyImpl(between(1, 2), nil, [mock methodReturningString]);
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

- (void)testWhenVerifyingNoInteractionsWhenMethodStubbedThenResultIsSuccessful {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    [when([mock methodReturningBool]) thenReturn:@YES];
    
    SBLVerificationResult *result = SBLVerifyNoInteractionsImpl(mock);
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

	SBLVerificationResult *result1 = SBLVerifyImpl(times(1), nil, [mock methodReturningBool]);

    resetMock(mock);

	SBLVerificationResult *result2 = SBLVerifyImpl(times(1), nil, [mock methodReturningBool]);

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
