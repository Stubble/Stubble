#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLMatcherTest : XCTestCase

@end

@implementation SBLMatcherTest

// also broken due to literals
//- (void)testWhenMethodStubbedWithAnyMatcherThenCorrectValueIsReturned {
//    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
//	
//	[WHEN([mock methodWithObject:any()]) thenReturn:@"one"];
//	[WHEN([mock methodWithInteger:any()]) thenReturn:@"two"];
//	
//	XCTAssertEqualObjects([mock methodWithObject:@11], @"one");
//	XCTAssertEqualObjects([mock methodWithObject:@42], @"one");
//	XCTAssertEqualObjects([mock methodWithObject:nil], @"one");
//	
//	XCTAssertEqualObjects([mock methodWithInteger:11], @"two");
//	XCTAssertEqualObjects([mock methodWithInteger:42], @"two");
//	XCTAssertEqualObjects([mock methodWithInteger:0], @"two");
//}

// also broken due to literals
//- (void)testWhenMultipleArgumentMethodHasMatcherForOneArgumentThenOtherArgumentIsUsedForMatching {
//    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
//	
//	[WHEN([mock methodWithArgument1:@"arg1" argument2:any()]) thenReturn:@"one"];
//	[WHEN([mock methodWithArgument1:@"arg2" argument2:any()]) thenReturn:@"two"];
//	[WHEN([mock methodWithArgument1:any() argument2:@"arg3"]) thenReturn:@"three"];
//	[WHEN([mock methodWithArgument1:any() argument2:@"arg4"]) thenReturn:@"four"];
//	
//	XCTAssertEqualObjects([mock methodWithArgument1:@"arg1" argument2:@"other stuff"], @"one");
//	XCTAssertEqualObjects([mock methodWithArgument1:@"arg2" argument2:@"other stuff"], @"two");
//	XCTAssertEqualObjects([mock methodWithArgument1:@"stuff" argument2:@"arg3"], @"three");
//	XCTAssertEqualObjects([mock methodWithArgument1:@"stuff" argument2:@"arg4"], @"four");
//	XCTAssertNil([mock methodWithArgument1:@"stuff" argument2:@"other stuff"]);
//}

- (void)testMatcherWorksForManyArgumentTypes {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[WHEN([mock methodWithBool:any()]) thenReturn:@"return"];
	[WHEN([mock methodWithPrimitiveReference:any()]) thenReturn:@"return"];
	// TODO make object references (ie: (NSString * __autoreleasing *)) work somehow too...
	//[WHEN([mock methodWithReference:any()]) thenReturn:@"return"];
	[WHEN([mock methodWithSelector:any()]) thenReturn:@"return"];
//	[WHEN([mock methodWithCGRect:anyCGRect()]) thenReturn:@"return"];
	SBLTestingStruct validStruct = { 1, YES, NULL };
	[WHEN([mock methodWithStruct:anyWithPlaceholder(validStruct)]) thenReturn:@"return"];
	[WHEN([mock methodWithStructReference:any()]) thenReturn:@"return"];
	[WHEN([mock methodWithClass:any()]) thenReturn:@"return"];
	
	XCTAssertEqualObjects([mock methodWithBool:YES], @"return");
	NSInteger integer = 42;
	XCTAssertEqualObjects([mock methodWithPrimitiveReference:&integer], @"return");
	//NSString *string = @"42";
	//XCTAssertEqualObjects([mock methodWithReference:&string], @"return");
	XCTAssertEqualObjects([mock methodWithSelector:@selector(testMatcherWorksForManyArgumentTypes)], @"return");
//	XCTAssertEqualObjects([mock methodWithCGRect:CGRectMake(10, 1, 30, 50)], @"return");
	SBLTestingStruct testingStruct = { 1, YES, "other stuff" };
	XCTAssertEqualObjects([mock methodWithStruct:testingStruct], @"return");
	XCTAssertEqualObjects([mock methodWithStructReference:&testingStruct], @"return");
	XCTAssertEqualObjects([mock methodWithClass:[NSArray class]], @"return");
}

@end
