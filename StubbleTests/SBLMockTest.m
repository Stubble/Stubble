#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLOngoingWhen.h"

@interface SBLTestingClass : NSObject

- (NSString *)methodReturningString;

- (int)methodReturningInt;

@end

@implementation SBLTestingClass

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

- (NSValue *)methodReturningNSValue {
    return @123;
}

- (NSString *)methodWithManyArguments:(NSString *)argument1 primitive:(NSInteger)argument2 number:(NSNumber *)number {
	return @"123";
}

@end


@interface SBLMockTest : XCTestCase

@end

@implementation SBLMockTest

- (void)testWhenPrimitiveMethodWithNoParametersIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN(mock.methodReturningInt) thenReturn:@5];

    XCTAssertEqual(mock.methodReturningInt, 5);
}

- (void)testWhenObjectMethodWithNoParametersIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN(mock.methodReturningString) thenReturn:@"alpha"];
	
    XCTAssertEqualObjects(mock.methodReturningString, @"alpha");
}

- (void)testWhenObjectMethodReturnsNSValueWithObjectThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	NSObject *expectedObject = [[NSObject alloc] init];
	
    [WHEN(mock.methodReturningNSValue) thenReturn:[NSValue valueWithNonretainedObject:expectedObject]];
	
    XCTAssertEqual([mock.methodReturningNSValue nonretainedObjectValue], expectedObject);
}

- (void)testWhenCommaIsPassedToMacroCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	NSArray *expectedArray = @[@"item3"];
	
	[WHEN([mock methodWithArray:@[@"item1", @"item2"]]) thenReturn:expectedArray];
	
    XCTAssertEqual(([mock methodWithArray:@[@"item1", @"item2"]]), expectedArray);
}

- (void)testWhenVariableArgumentMethodIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]) thenReturn:@"alpha"];
	
    XCTAssertEqualObjects(([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]), @"alpha");
}

- (void)testWhenMethodIsNotStubbedItReturnsNil {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodReturningString]) thenReturn:@"alpha"];
	
    XCTAssertNil([mock methodReturningNSValue]);
}

- (void)testWhenMethodsAreStubbedThenBothReturnCorrectValue {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodReturningString]) thenReturn:@"alpha"];
    [WHEN([mock methodReturningNSValue]) thenReturn:@42];
	
    XCTAssertEqualObjects([mock methodReturningNSValue], @42);
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
}

- (void)testWhenMethodIsStubbedItReturnsCorrectValueMultipleTimes {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodReturningString]) thenReturn:@"alpha"];
	
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
}

- (void)testWhenMethodIsStubbedAgainItReturnsNewValue {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodReturningString]) thenReturn:@"alpha"];
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
	
    [WHEN([mock methodReturningString]) thenReturn:@"beta"];
    XCTAssertEqualObjects([mock methodReturningString], @"beta");
}

- (void)testWhenMethodStubbedWithDifferentValuesReturnsCorrectValueForBoth {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodWithArray:@[@"1"]]) thenReturn:@"alpha"];
    [WHEN([mock methodWithArray:@[@"2"]]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects([mock methodWithArray:@[@"1"]], @"alpha");
    XCTAssertEqualObjects([mock methodWithArray:@[@"2"]], @"beta");
}

- (void)testWhenMethodStubbedWithDifferentValuesInOtherArgumentReturnsCorrectValueForBoth {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodWithManyArguments:@"1" primitive:2 number:@3]) thenReturn:@"alpha"];
    [WHEN([mock methodWithManyArguments:@"1" primitive:2 number:@4]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:2 number:@3], @"alpha");
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:2 number:@4], @"beta");
}

- (void)testWhenMethodStubbedWithDifferentNSIntegersThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodWithManyArguments:@"1" primitive:5 number:@3]) thenReturn:@"alpha"];
    [WHEN([mock methodWithManyArguments:@"1" primitive:8 number:@3]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:5 number:@3], @"alpha");
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:8 number:@3], @"beta");
}

@end
