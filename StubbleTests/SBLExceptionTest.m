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

- (void)testWhenVerifyIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        verify(string.length);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:SBLBadVerifyErrorMessage];
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


#pragma mark - Utility methods

- (void)verifyException:(NSException *)theException ofName:(NSString *)name reason:(NSString *)reason {
    XCTAssertEqualObjects(theException.name, name);
    XCTAssertEqualObjects(theException.reason, reason);
}

@end