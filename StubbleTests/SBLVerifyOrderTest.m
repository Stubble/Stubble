#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"

@interface SBLVerifyOrderTest : XCTestCase

@end

@implementation SBLVerifyOrderTest

#pragma mark - Verify Success Tests

- (void)testWhenVerifyingTwoCallsOnASingleMockInOrderAndTheyAreNotInOrderThenVerifyFails {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];
    [mock methodReturningBool];

    SBLOrderToken *orderToken = orderToken();
    SBLVerificationResult *result1 = SBLVerifyImpl(atLeast(1), orderToken, [mock methodReturningBool]);
    XCTAssertTrue(result1.successful);
    SBLVerificationResult *result2 = SBLVerifyImpl(atLeast(1), orderToken, [mock methodReturningInt]);
    XCTAssertFalse(result2.successful);

    XCTAssertTrue([result2.failureDescription rangeOfString:@"methodReturningBool"].location != NSNotFound);
    XCTAssertTrue([result2.failureDescription rangeOfString:@"methodReturningInt"].location != NSNotFound);
    XCTAssertTrue([result2.failureDescription.lowercaseString rangeOfString:@"order"].location != NSNotFound);
}

- (void)testWhenVerifingMultipleCallsOnASingleMockAndTheyAreInTheCorrectOrderThenVerifyPasses {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningBool];
    [mock methodReturningInt];
    [mock methodReturningInt];

    SBLOrderToken *orderToken = orderToken();
    SBLVerifyImpl(atLeast(1), orderToken, [mock methodReturningBool]);
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), orderToken, [mock methodReturningInt]);
    XCTAssertTrue(result.successful);
}

- (void)testWhenCallsAreInterleavedOnASingleMockAndOrderIsBeingCheckedThenVerifyFails {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodReturningInt];
    [mock methodReturningBool];
    [mock methodReturningInt];

    SBLOrderToken *orderToken1 = orderToken();
    SBLVerifyImpl(atLeast(1), orderToken1, [mock methodReturningBool]);
    SBLVerificationResult *result1 = SBLVerifyImpl(atLeast(1), orderToken1, [mock methodReturningInt]);
    XCTAssertFalse(result1.successful);

    SBLOrderToken *orderToken2 = orderToken();
    SBLVerifyImpl(atLeast(1), orderToken2, [mock methodReturningInt]);
    SBLVerificationResult *result2 = SBLVerifyImpl(atLeast(1), orderToken2, [mock methodReturningBool]);
    XCTAssertFalse(result2.successful);
}

- (void)testWhenOrderIsCheckedOnMultipleMocksAndTheOrderIsNotCorrectThenVerifyFails {
    SBLTestingClass *mock1 = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);
    SBLTestingClass *mock3 = mock(SBLTestingClass.class);

    [mock1 methodReturningBool];
    [mock3 methodReturningInt];
    [mock2 methodReturningInt];

    SBLOrderToken *orderToken = orderToken();
    SBLVerificationResult *result1 = SBLVerifyImpl(once(), orderToken, [mock1 methodReturningBool]);
    SBLVerificationResult *result2 = SBLVerifyImpl(once(), orderToken, [mock2 methodReturningInt]);
    SBLVerificationResult *result3 = SBLVerifyImpl(once(), orderToken, [mock3 methodReturningInt]);
    XCTAssertTrue(result1.successful);
    XCTAssertTrue(result2.successful);
    XCTAssertFalse(result3.successful);
}

- (void)testWhenOrderVerificationFailsThenMessageIncludesActualAndExpectedCalls {
    SBLTestingClass *mock1 = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);
    SBLTestingClass *mock3 = mock(SBLTestingClass.class);

    [mock1 methodReturningBool];
    [mock1 methodReturningBool];
    [mock3 methodReturningString];
    [mock2 methodReturningInt];
    [mock2 methodReturningInt];

    SBLOrderToken *orderToken = orderToken();
    SBLVerifyImpl(between(1, 4), orderToken, [mock1 methodReturningBool]);
    SBLVerifyImpl(times(2), orderToken, [mock2 methodReturningInt]);
    SBLVerificationResult *result = SBLVerifyImpl(atLeast(1), orderToken, [mock3 methodReturningString]);

    NSString *message = result.failureDescription;
    XCTAssertEqualObjects(message, @"Method 'methodReturningString' was called out of order. Expected "
            "methodReturningBool (between 1 and 4), methodReturningInt (exactly 2), methodReturningString (at least 1)"
            " but got "
            "methodReturningBool (2 times), methodReturningString, methodReturningInt (2 times)");
}

- (void)testWhenMethodsWithParametersCalledInTheCorrectOrderThenVerifyPasses {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithInteger:15];
    [mock methodWithInteger:30];

    SBLOrderToken *orderToken = orderToken();
    SBLVerificationResult *result1 = SBLVerifyImpl(atLeast(1), orderToken, [mock methodWithInteger:15]);
    XCTAssertTrue(result1.successful);

    SBLVerificationResult *result2 = SBLVerifyImpl(atLeast(1), orderToken, [mock methodWithInteger:30]);
    XCTAssertTrue(result2.successful);
}

- (void)testWhenMethodsWithParametersAreCalledOutOfOrderThenVerifyFails {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [mock methodWithInteger:30];
    [mock methodWithInteger:15];

    SBLOrderToken *orderToken = orderToken();
    SBLVerificationResult *result1 = SBLVerifyImpl(atLeast(1), orderToken, [mock methodWithInteger:15]);
    XCTAssertTrue(result1.successful);

    SBLVerificationResult *result2 = SBLVerifyImpl(atLeast(1), orderToken, [mock methodWithInteger:30]);
    XCTAssertFalse(result2.successful);
}

@end
