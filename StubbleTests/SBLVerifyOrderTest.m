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

@end
