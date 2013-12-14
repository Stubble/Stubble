#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

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

- (void)testWhenVerifyIsCalledZeroTimesThenAnExpectedExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY_TIMES(1, [mock methodReturningInt]);
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
        VERIFY_TIMES(2, [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", @(2), @(1)]];
    }
}

- (void)testWhenVerifyIsCalledWithNegativeNumberThenAnExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningInt];

    @try {
        VERIFY_TIMES(-1, [mock methodReturningInt]);
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
        VERIFY_TIMES(2, [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed
                       reason:[NSString stringWithFormat:SBLVerifyCalledWrongNumberOfTimes, @"methodReturningInt", @(2), @(3)]];
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

#pragma mark - Utility methods

- (void)verifyException:(NSException *)theException ofName:(NSString *)name reason:(NSString *)reason {
    XCTAssertEqualObjects(theException.name, name);
    XCTAssertEqualObjects(theException.reason, reason);
}

@end