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

- (void)testWhenMixingArgumentTypes_AllNonNSObjectTypesMustHaveMatchersOrNoneDo {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	[WHEN([mock methodWithArgument1:@"arg1" argument2:100 argument3:101 argument4:any() argument5:YES]) thenReturn:@"one"];
	[WHEN([mock methodWithArgument1:any() argument2:102 argument3:103 argument4:any() argument5:YES]) thenReturn:@"two"];
	[WHEN([mock methodWithArgument1:@"arg2" argument2:any() argument3:any() argument4:@"arg3" argument5:any()]) thenReturn:@"three"];
	[WHEN([mock methodWithArgument1:any() argument2:104 argument3:105 argument4:@"arg5" argument5:YES]) thenReturn:@"four"];

	XCTAssertEqualObjects([mock methodWithArgument1:@"arg1" argument2:2 argument3:3 argument4:any() argument5:YES], @"one");
	XCTAssertEqualObjects([mock methodWithArgument1:any() argument2:3 argument3:4 argument4:any() argument5:YES], @"two");
	XCTAssertEqualObjects([mock methodWithArgument1:@"arg2" argument2:any() argument3:any() argument4:@"arg3" argument5:any()], @"three");
	XCTAssertEqualObjects([mock methodWithArgument1:any() argument2:104 argument3:105 argument4:@"arg5" argument5:YES], @"four");
	
	XCTAssertThrows([WHEN([mock methodWithArgument1:@"arg1" argument2:2 argument3:any() argument4:any() argument5:any()]) thenReturn:@"one"]);
	XCTAssertThrows([WHEN([mock methodWithArgument1:@"arg1" argument2:2 argument3:3 argument4:any() argument5:any()]) thenReturn:@"one"]);
}

@end
