#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"
#import "SBLErrors.h"

@class mockObject;

@interface SBLExceptionTest : XCTestCase

@end

@implementation SBLExceptionTest

- (void)testWhenWhenIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        [when(string.length) thenReturn:@1];
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e) {
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadWhenNoCallsErrorMessage];
    }
}

- (void)testWhenMultipleStubsAreCalledInASingleWhenThenAnErrorIsThrown {
    SBLTestingClass *mock1 = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);

    [when(mock1.methodReturningInt) thenReturn:@1];

    @try {
        [when([mock2 methodWithInteger:mock1.methodReturningInt]) thenReturn:@"1 passed in"];
        XCTFail(@"mock1 and mock2 were both called in the same when, but no error was thrown");
    } @catch (NSException *e) {
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadWhenTooManyCallsErrorMessage];
    }
}

- (void)testWhenVerifyIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        verify(string.length);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadVerifyNoCallsErrorMessage];
    }
}

- (void)testWhenMultipleStubsAreCalledInASingleVerifyThenAnErrorIsThrown {
    SBLTestingClass *mock1 = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);

    [when(mock1.methodReturningInt) thenReturn:@1];

    [mock2 methodWithInteger:mock2.methodReturningInt];

    @try {
        verifyCalled([mock2 methodWithInteger:mock1.methodReturningInt]);
        XCTFail(@"mock1 and mock2 were both called in the same verify, but no error was thrown");
    } @catch (NSException *e) {
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadVerifyTooManyCallsErrorMessage];
    }
}

- (void)testWhenVerifyTimesIsCalledWithNegativeNumberThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];

    @try {
        verifyTimes(times(-1), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadTimesProvided];
    }
}

- (void)testWhenVerifyAtLeastTimesIsCalledWithZeroThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];

    @try {
        verifyTimes(atLeast(0), [mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadAtLeastTimesProvided];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithABadMinTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];

    @try {
        verifyTimes(between(-1, 2), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadTimesProvided];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithBadAtMostTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];

    @try {
        verifyTimes(between(2, -1), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadTimesProvided];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithBadAtMostGreaterThanAtMostTimesThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];

    @try {
        verifyTimes(between(1, 0), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLAtLeastCannotBeGreaterThanAtMost];
    }
}

- (void)testWhenVerifyBetweenIsCalledWithAtMostTimeLessThanAtLeastTimeThenAnExceptionIsThrown {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningString];

    @try {
        verifyTimes(between(2, 1), [mock methodReturningString]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLAtLeastCannotBeGreaterThanAtMost];
    }
}

- (void)testWhenMatcherIsRegisteredOusideOfWhenOrVerifyThenExceptionIsThrown {
    @try {
		(void)any();
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadMatcherRegistration];
    }
}

#pragma mark - Utility methods

- (void)verifyException:(NSException *)theException ofName:(NSString *)name reason:(NSString *)reason {
    XCTAssertEqualObjects(theException.name, name);
    XCTAssertEqualObjects(theException.reason, reason);
}

@end