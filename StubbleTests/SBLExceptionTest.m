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
        [self verifyException:e ofName:SBLBadUsage reason:BadWhenErrorMessage];
    }
}

#pragma mark - Verify Tests

- (void)testWhenVerifyingForMethodThatWasNeverCalledThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY([mock methodReturningInt]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodReturningInt"];
    }
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    @try {
        VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:"];
    }
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    @try {
        VERIFY([mock methodWithManyArguments:@"2" primitive:2 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:"];
    }

    @try {
        VERIFY([mock methodWithManyArguments:@"1" primitive:1 number:@3]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:"];
    }

    @try {
        VERIFY([mock methodWithManyArguments:@"1" primitive:2 number:@1]);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLVerifyFailed reason:@"Expected methodWithManyArguments:primitive:number:"];
    }
}

- (void)testWhenVerifyIsNotCalledOnAMockMethodThenAnExceptionIsThrown {
    NSString *string = @"string";

    @try {
        VERIFY(string.length);
        XCTFail(@"Should have thrown NSException!");
    } @catch (NSException *e){
        [self verifyException:e ofName:SBLBadUsage reason:BadVerifyErrorMessage];
    }
}

#pragma mark - Utility methods

- (void)verifyException:(NSException *)theException ofName:(NSString *)name reason:(NSString *)reason {
    XCTAssertEqualObjects(theException.name, name);
    XCTAssertEqualObjects(theException.reason, reason);
}

@end