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

@end
