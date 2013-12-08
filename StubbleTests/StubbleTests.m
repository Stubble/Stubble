#import <XCTest/XCTest.h>
#import "STBMock.h"
#import "STBOngoingWhen.h"

@interface STBFoo : NSObject

- (NSString *)methodReturningString;

- (int)methodReturningInt;

@end

@implementation STBFoo

- (NSString *)methodReturningString {
    return @"123";
}

- (NSArray *)methodWithArray:(NSArray *)array {
	return array;
}

- (id)methodWithVariableNumberOfArguments:(id)argument1, ... {
	return @"";
}

- (int)methodReturningInt {
    return 123;
}

@end


@interface StubbleTests : XCTestCase

@end

@implementation StubbleTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testWhenPrimitiveMethodWithNoParametersIsStubbedThenCorrectValueIsReturned {
    STBFoo *mock = [STBMock mockForClass:STBFoo.class];
	
    [WHEN(mock.methodReturningInt) thenReturn:@5];

    XCTAssertEqual(mock.methodReturningInt, 5);
}

- (void)testWhenObjectMethodWithNoParametersIsStubbedThenCorrectValueIsReturned {
    STBFoo *mock = [STBMock mockForClass:STBFoo.class];

    [WHEN(mock.methodReturningString) thenReturn:@"alpha"];

    XCTAssertEqualObjects(mock.methodReturningString, @"alpha");
}

- (void)testWhenCommaIsPassedToMacroCorrectValueIsReturned {
    STBFoo *mock = [STBMock mockForClass:STBFoo.class];
	NSArray *expectedArray = @[@"item3"];
	
	[WHEN([mock methodWithArray:@[@"item1", @"item2"]]) thenReturn:expectedArray];
	
    XCTAssertEqual(([mock methodWithArray:@[@"item1", @"item2"]]), expectedArray);
}

- (void)testWhenVariableArgumentMethodIsStubbedThenCorrectValueIsReturned {
    STBFoo *mock = [STBMock mockForClass:STBFoo.class];
	
    [WHEN([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]) thenReturn:@"alpha"];
	
    XCTAssertEqualObjects(mock.methodReturningString, @"alpha");
}

@end
