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

@end
