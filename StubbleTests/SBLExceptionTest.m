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
        [WHEN(string.length) thenReturn:@1];
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e) {
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadWhenErrorMessage];
    }
}

#pragma mark - Verify Tests

- (void)testWhenVerifyingForMethodThatWasNeverCalledThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY([mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodReturningInt, but method was not called"];
    }
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    @try {
        VERIFY([mock methodWithManyArguments:@"2" primitive:2 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:, but method was called with differing parameters"];
    }

    @try {
        VERIFY([mock methodWithManyArguments:@"1" primitive:1 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:, but method was called with differing parameters"];
    }

    @try {
        VERIFY([mock methodWithManyArguments:@"1" primitive:2 number:@1]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:, but method was called with differing parameters"];
    }
}

- (void)testWhenVerifyIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        VERIFY(string.length);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadVerifyErrorMessage];
    }
}

- (void)testWhenVerifyingForMethodWithVoidReturnTypeNotCalledThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY([mock methodWithNoReturn]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason: @"Expected methodWithNoReturn, but method was not called"];
    }
}

#pragma mark - Verify Times Tests

- (void)testWhenVerifyIsCalledZeroTimesThenAnExpectedExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY_TIMES(times(1), [mock methodReturningInt]);
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
        VERIFY_TIMES(times(2), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", 2, 1]];
    }
}

- (void)testWhenVerifyTimesIsCalledWithNegativeNumberThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        VERIFY_TIMES(times(-1), [mock methodReturningInt]);
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
        VERIFY_TIMES(times(2), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", 2, 3]];
    }
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledOnceThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        VERIFY_TIMES(never(), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", 0, 1]];
    }
}

- (void)testWhenVerifyNeverIsCalledAndMethodIsCalledMultipleTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];
    [mock methodReturningInt];
    [mock methodReturningInt];

    @try {
        VERIFY_TIMES(never(), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", 0, 3]];
    }
}

- (void)testWhenVerifyAtLeastTimesIsCalledWithZeroThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        VERIFY_TIMES(atLeast(0), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadAtLeastTimesProvided];
    }
}

- (void)testWhenVerifyAtLeastOneTimeIsNeverCalledThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY_TIMES(atLeast(1), [mock methodReturningString]);
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
        VERIFY_TIMES(atLeast(2), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningString", 2, 1]];
    }
}

#pragma mark - Utility methods

- (void)verifyException:(NSException *)theException ofName:(NSString *)name reason:(NSString *)reason {
    XCTAssertEqualObjects(theException.name, name);
    XCTAssertEqualObjects(theException.reason, reason);
}

@end