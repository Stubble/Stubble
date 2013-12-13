#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLMatcherTest : XCTestCase

@end

@implementation SBLMatcherTest

- (void)testWhenMethodStubbedWithAnyMatcherThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[WHEN([mock methodWithObject:any()]) thenReturn:@"one"];
	[WHEN([mock methodWithInteger:any()]) thenReturn:@"two"];
	
	XCTAssertEqualObjects([mock methodWithObject:@11], @"one");
	XCTAssertEqualObjects([mock methodWithObject:@42], @"one");
	XCTAssertEqualObjects([mock methodWithObject:nil], @"one");
	
	XCTAssertEqualObjects([mock methodWithInteger:11], @"two");
	XCTAssertEqualObjects([mock methodWithInteger:42], @"two");
	XCTAssertEqualObjects([mock methodWithInteger:0], @"two");
}

- (void)testWhenMultipleArgumentMethodHasMatcherForOneArgumentThenOtherArgumentIsUsedForMatching {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[WHEN([mock methodWithArgument1:@"arg1" argument2:any()]) thenReturn:@"one"];
	[WHEN([mock methodWithArgument1:@"arg2" argument2:any()]) thenReturn:@"two"];
	[WHEN([mock methodWithArgument1:any() argument2:@"arg3"]) thenReturn:@"three"];
	[WHEN([mock methodWithArgument1:any() argument2:@"arg4"]) thenReturn:@"four"];
	
	XCTAssertEqualObjects([mock methodWithArgument1:@"arg1" argument2:@"other stuff"], @"one");
	XCTAssertEqualObjects([mock methodWithArgument1:@"arg2" argument2:@"other stuff"], @"two");
	XCTAssertEqualObjects([mock methodWithArgument1:@"stuff" argument2:@"arg3"], @"three");
	XCTAssertEqualObjects([mock methodWithArgument1:@"stuff" argument2:@"arg4"], @"four");
	XCTAssertNil([mock methodWithArgument1:@"stuff" argument2:@"other stuff"]);
}

@end
