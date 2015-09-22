#import <XCTest/XCTest.h>
#import <Stubble/Stubble.h>
#import "SBLTestingDynamicObject.h"
#import "SBLVerificationResult.h"
#import "SBLErrors.h"
#import <UIKit/UIKit.h>

@interface SBLDynamicMockTest : XCTestCase

@end

@implementation SBLDynamicMockTest

- (void)testWhenStubIsCreatedForObjectValuesThenTheyCanBeRetrieved {
	SBLTestingDynamicObject *mock = dynamicMock(SBLTestingDynamicObject.class);
	NSObject *value1 = [[NSObject alloc] init];
	NSObject *value2 = [[NSObject alloc] init];
	NSObject *value3 = [[NSObject alloc] init];
	[when(mock.getValue1) thenReturn:value1];
	[when(mock.getValue2) thenReturn:value2];
	[when(mock.value3) thenReturn:value3];

	XCTAssertEqualObjects(mock.getValue1, value1);
	XCTAssertEqualObjects(mock.getValue2, value2);
	XCTAssertEqualObjects(mock.value3, value3);
}

- (void)testWhenStubIsCreatedForPrimitiveValuesThenTheyCanBeRetrieved {
	SBLTestingDynamicObject *mock = dynamicMock(SBLTestingDynamicObject.class);
	int integer1 = 1234;
	int integer2 = 2345;
	int integer3 = 3456;
	[when(mock.getInt1) thenReturn:@(integer1)];
	[when(mock.getInt2) thenReturn:@(integer2)];
	[when(mock.integer3) thenReturn:@(integer3)];

	XCTAssertEqual(mock.getInt1, integer1);
	XCTAssertEqual(mock.getInt2, integer2);
	XCTAssertEqual(mock.integer3, integer3);
}

- (void)testWhenPrimitiveValuesAreSetThenTheyCanBeVerified {
	SBLTestingDynamicObject *mock = dynamicMock(SBLTestingDynamicObject.class);

	[mock putInt1:123];

	SBLVerificationResult *result1 = SBLVerifyImpl(times(1), nil, [mock putInt1:123]);
	XCTAssertTrue(result1.successful);
	SBLVerificationResult *result2 = SBLVerifyImpl(times(0), nil, [mock putInt1:234]);
	XCTAssertTrue(result2.successful);
}


@end