#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"
#import "SBLErrors.h"

@interface SBLExceptionTest : XCTestCase

@end

@implementation SBLExceptionTest

#pragma mark - When Tests

- (void)testWhenWhenIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        [when(string.length) thenReturn:@1];
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e) {
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadWhenErrorMessage];
    }
}

#pragma mark - Verify Tests

- (void)testWhenVerifyingForMethodThatWasNeverCalledThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        verify([mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodReturningInt, but method was not called"];
    }
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    @try {
        verify([mock methodWithManyArguments:@"2" primitive:2 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:, but method was called with differing parameters"];
    }

    @try {
        verify([mock methodWithManyArguments:@"1" primitive:1 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:, but method was called with differing parameters"];
    }

    @try {
        verify([mock methodWithManyArguments:@"1" primitive:2 number:@1]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:, but method was called with differing parameters"];
    }
}

- (void)testWhenVerifyIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        verify(string.length);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadVerifyErrorMessage];
    }
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeNotCalledThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        verify([mock methodWithNoReturn]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason: @"Expected methodWithNoReturn, but method was not called"];
    }
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyIsCalledZeroTimesThenAnExpectedExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        verifyTimes(times(1), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:@"Expected methodReturningInt, but method was not called"];
    }
}

- (void)testWhenVerifyIsCalledTooFewTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        verifyTimes(times(2), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", (long)2, (long)1]];
    }
}

- (void)testWhenVerifyTimesIsCalledWithNegativeNumberThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        verifyTimes(times(-1), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadTimesProvided];
    }
}

- (void)testWhenVerifyTimesIsCalledTooManyTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];
    [mock methodReturningInt];
    [mock methodReturningInt];

    @try {
        verifyTimes(times(2), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", (long)2, (long)3]];
    }
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledOnceThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        verifyTimes(never(), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", (long)0, (long)1]];
    }
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledMultipleTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];
    [mock methodReturningInt];
    [mock methodReturningInt];

    @try {
        verifyTimes(never(), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", (long)0, (long)3]];
    }
}

- (void)testWhenVerifyAtLeastTimesIsCalledWithZeroThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        verifyTimes(atLeast(0), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadAtLeastTimesProvided];
    }
}

- (void)testWhenVerifyAtLeastOneTimeIsNeverCalledThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        verifyTimes(atLeast(1), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:@"Expected methodReturningString, but method was not called"];
    }
}

- (void)testWhenVerifyAtLeastTwoTimesIsOnlyCalledOneTimeThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];

    @try {
        verifyTimes(atLeast(2), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningString", (long)2, (long)1]];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithABadMinTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];

    @try {
        verifyTimes(between(-1, 2), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadTimesProvided];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithBadAtMostTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];

    @try {
        verifyTimes(between(2, -1), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadTimesProvided];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithBadAtMostGreaterThanAtMostTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];

    @try {
        verifyTimes(between(1, 0), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLAtLeastCannotBeGreaterThanAtMost];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithAtMostTimeLessThanAtLeastTimeThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];

    @try {
        verifyTimes(between(2, 1), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLAtLeastCannotBeGreaterThanAtMost];
    }
}

- (void)testWhenVerifyBetweenIsCalledTooFewTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];

    @try {
        verifyTimes(between(2, 3), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningString", (long)2, (long)1]];
    }
}

- (void)testWhenVerifyBetweenIsCalledTooManyTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningString];
    [mock methodReturningString];

    @try {
        verifyTimes(between(1, 2), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningString", (long)2, (long)3]];
    }
}


#pragma mark - Utility methods

- (void)verifyException:(NSException *)theException ofName:(NSString *)name reason:(NSString *)reason {
    XCTAssertEqualObjects(theException.name, name);
    XCTAssertEqualObjects(theException.reason, reason);
}

@end