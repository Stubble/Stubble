#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"

@interface SBLKeyValueCodingTest : XCTestCase

@end

@implementation SBLKeyValueCodingTest

- (void)testWhenGetValueForKeyIsCalledForAMethodReturningAnObjectThenStubbedValueIsReturned {
	SBLTestingClass *mock1 = mock(SBLTestingClass.class);
	[when(mock1.methodReturningString) thenReturn:@"Value1"];

	id value1 = [mock1 valueForKey:NSStringFromSelector(@selector(methodReturningString))];
	XCTAssertEqualObjects(value1, @"Value1");

	[when(mock1.methodReturningString) thenReturn:@"Value2"];

	id value2 = [mock1 valueForKey:NSStringFromSelector(@selector(methodReturningString))];
	XCTAssertEqualObjects(value2, @"Value2");
}

- (void)testWhenGetValueForKeyIsCalledForAMethodReturningAPrimitiveThenBoxedValueIsReturned {
	SBLTestingClass *mock1 = mock(SBLTestingClass.class);
	[when(mock1.methodReturningLong) thenReturn:@1337L];

	id value1 = [mock1 valueForKey:NSStringFromSelector(@selector(methodReturningLong))];
	XCTAssertEqualObjects(value1, @1337L);
}

//- (void)testWhenValuesAreStubbedThenTheyCanBeUsedInAPredicate {
//	SBLTestingClass *mock1 = mock(SBLTestingClass.class);
//	[when(mock1.methodReturningLong) thenReturn:@1L];
//	SBLTestingClass *mock2 = mock(SBLTestingClass.class);
//	[when(mock2.methodReturningLong) thenReturn:@2L];
//	SBLTestingClass *mock3 = mock(SBLTestingClass.class);
//	[when(mock3.methodReturningLong) thenReturn:@3L];
//
//	NSArray *array = @[mock1, mock2, mock3];
//
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"methodReturningLong >= 2"];
//	NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
//
//	XCTAssertEqualObjects(filteredArray, (@[mock2, mock3]));
//}

@end