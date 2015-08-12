#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLCoreDataParent.h"
#import "SBLCoreDataChild.h"
#import "SBLVerificationResult.h"
#import "SBLErrors.h"
#import <UIKit/UIKit.h>

@interface SBLCoreDataUsageHelper : NSObject

- (void)addChild:(SBLCoreDataChild *)child toParent:(SBLCoreDataParent *)parent;

@end

@implementation SBLCoreDataUsageHelper

- (void)addChild:(SBLCoreDataChild *)child toParent:(SBLCoreDataParent *)parent {
	[parent addChildrenObject:child];
}

@end

@interface SBLCoreDataTest : XCTestCase

@end

@implementation SBLCoreDataTest

- (void)testWhenStubIsCreatedForObjectValuesThenTheyCanBeRetrieved {
	SBLCoreDataParent *mock = mock(SBLCoreDataParent.class);
	[when(mock.booleanObject) thenReturn:@YES];
	[when(mock.stringObject) thenReturn:@"String1"];
	[when(mock.doubleObject) thenReturn:@12.34];

	XCTAssertEqualObjects(mock.booleanObject, @YES);
	XCTAssertEqualObjects(mock.stringObject, @"String1");
	XCTAssertEqualObjects(mock.doubleObject, @12.34);
}

- (void)testWhenStubIsCreatedForPrimitiveValuesThenTheyCanBeRetrieved {
	SBLCoreDataParent *mock = mock(SBLCoreDataParent.class);
	[when(mock.booleanValue) thenReturn:@YES];

	XCTAssertTrue(mock.booleanValue);

	[when(mock.booleanValue) thenReturn:@NO];

	XCTAssertFalse(mock.booleanValue);
}

- (void)testWhenPrimitiveIsRetrievedAndThenStubbedThenItCanStillReturnTheCorrectValue {
	SBLCoreDataParent *mock = mock(SBLCoreDataParent.class);

	XCTAssertEqual(0, mock.intValue);

	[when(mock.intValue) thenReturn:@1337];

	XCTAssertEqual(1337, mock.intValue);
}

- (void)testWhenPrimitiveValuesAreSetThenTheyCanBeVerified {
	SBLCoreDataParent *mock = mock(SBLCoreDataParent.class);

	mock.intValue = 123;
	int64_t bigValue = 0x0123456789ABCDEF;
	int64_t notIt1 = 0x1123456789ABCDEF;
	int64_t notIt2 = 0x0123456789ABCDE0;
	mock.longValue = bigValue;

	SBLVerificationResult *result1 = SBLVerifyImpl(times(1), nil, [mock setIntValue:123]);
	XCTAssertTrue(result1.successful);
	SBLVerificationResult *result2 = SBLVerifyImpl(times(0), nil, [mock setIntValue:456]);
	XCTAssertTrue(result2.successful);
	SBLVerificationResult *result3 = SBLVerifyImpl(times(0), nil, [mock setIntValue:0]);
	XCTAssertTrue(result3.successful);
	SBLVerificationResult *result4 = SBLVerifyImpl(times(0), nil, [mock setBooleanValue:YES]);
	XCTAssertTrue(result4.successful);
	SBLVerificationResult *result5 = SBLVerifyImpl(times(1), nil, [mock setLongValue:bigValue]);
	XCTAssertTrue(result5.successful);
	SBLVerificationResult *result6 = SBLVerifyImpl(times(0), nil, [mock setLongValue:notIt1]);
	XCTAssertTrue(result6.successful);
	SBLVerificationResult *result7 = SBLVerifyImpl(times(0), nil, [mock setLongValue:notIt2]);
	XCTAssertTrue(result7.successful);
}

- (void)testWhenObjectValuesAreSetThenTheyCanBeVerified {
	NSString *string1a = [[NSString alloc] initWithUTF8String:"ABC"];
	NSString *string1b = [[NSString alloc] initWithUTF8String:"ABC"];
	NSString *string2 = [[NSString alloc] initWithUTF8String:"XYZ"];
	XCTAssertNotEqual(string1a, string1b);
	SBLCoreDataParent *mock = mock(SBLCoreDataParent.class);

	mock.stringObject = string1a;
	mock.doubleObject = nil;

	SBLVerificationResult *result1 = SBLVerifyImpl(times(1), nil, [mock setStringObject:string1b]);
	XCTAssertTrue(result1.successful);
	SBLVerificationResult *result2 = SBLVerifyImpl(times(0), nil, [mock setStringObject:nil]);
	XCTAssertTrue(result2.successful);
	SBLVerificationResult *result3 = SBLVerifyImpl(times(0), nil, [mock setStringObject:string2]);
	XCTAssertTrue(result3.successful);
	SBLVerificationResult *result4 = SBLVerifyImpl(times(1), nil, [mock setDoubleObject:nil]);
	XCTAssertTrue(result4.successful);
}

- (void)testWhenVerifyingGeneratedMethodCallForStubThenResultIsSuccessful {
	SBLCoreDataChild *mockChild = mock(SBLCoreDataChild.class);
	SBLCoreDataParent *mockParent = mock(SBLCoreDataParent.class);

	SBLCoreDataUsageHelper *helper = [[SBLCoreDataUsageHelper alloc] init];
	[helper addChild:mockChild toParent:mockParent];
	verifyTimes(times(1),[mockParent addChildrenObject:mockChild]);

	[helper addChild:mockChild toParent:mockParent];
	[helper addChild:mockChild toParent:mockParent];
	verifyTimes(times(3),[mockParent addChildrenObject:mockChild]);
}

@end