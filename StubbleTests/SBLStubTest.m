#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"
#import "SBLTestingProtocol.h"

@interface SBLStubTest : XCTestCase

@end

@implementation SBLStubTest

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
	
	NSArray *array = @[@"item1", @"item2"];
	[WHEN([mock methodWithArray:array]) thenReturn:expectedArray];
	
    XCTAssertEqual(([mock methodWithArray:array]), expectedArray);
}

- (void)testWhenVariableArgumentMethodIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
    [WHEN([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]) thenReturn:@"alpha"];
	// TODO - attempt to find a way to match a va_list
    //[WHEN([mock methodWithVariableNumberOfArguments:@"1", @"2", @"7", @"4", nil]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects(([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]), @"alpha");
    //XCTAssertEqualObjects(([mock methodWithVariableNumberOfArguments:@"1", @"2", @"7", @"4", nil]), @"beta");
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

- (void)testWhenMethodStubbedWithActionThenActionOccurs {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	__block NSString *string = nil;
	[WHEN([mock methodWithNoReturn]) thenDo:^{ string = @"action"; }];
	
	[mock methodWithNoReturn];
	
	XCTAssertEqualObjects(string, @"action");
}

- (void)testWhenMethodStubbedWithActionsThenActionsOccurInOrder {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	__block NSMutableString *string = [NSMutableString string];
	[[WHEN([mock methodWithNoReturn]) thenDo:^{ [string appendString:@"action1-"]; }] thenDo:^{  [string appendString:@"action2"]; }];
	
	[mock methodWithNoReturn];
	
	XCTAssertEqualObjects(string, @"action1-action2");
}

- (void)testWhenMethodStubbedWithInvocationActionThenInvocationIsPassedToActionBlockBeforeInvoke {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	__block NSInteger counter = 0;
	__block NSNumber *capturedNumber = nil;
	[WHEN([mock methodWithObject:any()]) thenDoWithInvocation:^(NSInvocation *invocation) {
		[invocation getArgument:&capturedNumber atIndex:2];
		NSString *returnString = [NSString stringWithFormat:@"return %d", counter++];
		[invocation setReturnValue:&returnString];
	}];
	
	NSString *returnedString = [mock methodWithObject:@(42)];
	XCTAssertEqualObjects(capturedNumber, @(42));
	XCTAssertEqualObjects(returnedString, @"return 0");
	
	returnedString = [mock methodWithObject:@(13.12)];
	XCTAssertEqualObjects(capturedNumber, @(13.12));
	XCTAssertEqualObjects(returnedString, @"return 1");
}

- (void)testAllActionsRunInOrderAdded {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	NSMutableArray *actionOrder = [NSMutableArray array];
	SBLInvocationActionBlock invocationAction = ^(NSInvocation *invocation) {
		NSString *returnString = @"invocationActionReturn";
		[invocation setReturnValue:&returnString];
		[actionOrder addObject:@"invocationAction"];
	};
	SBLActionBlock action = ^{
		[actionOrder addObject:@"action"];
	};
	
	[[[WHEN([mock methodWithObject:@(1)]) thenDoWithInvocation:invocationAction] thenDo:action] thenReturn:@"returnValue"];
	[[[WHEN([mock methodWithObject:@(2)]) thenDo:action] thenDoWithInvocation:invocationAction] thenReturn:@"returnValue"];
	[[[WHEN([mock methodWithObject:@(3)]) thenDoWithInvocation:invocationAction] thenReturn:@"returnValue"] thenDo:action];
	[[[WHEN([mock methodWithObject:@(4)]) thenDo:action] thenReturn:@"returnValue"] thenDoWithInvocation:invocationAction];
	
	NSString *returnedString = [mock methodWithObject:@(1)];
	XCTAssertEqualObjects(actionOrder, (@[@"invocationAction",  @"action"]));
	XCTAssertEqualObjects(returnedString, @"returnValue");
	[actionOrder removeAllObjects];
	
	returnedString = [mock methodWithObject:@(2)];
	XCTAssertEqualObjects(actionOrder, (@[@"action", @"invocationAction"]));
	XCTAssertEqualObjects(returnedString, @"returnValue");
	[actionOrder removeAllObjects];
	
	returnedString = [mock methodWithObject:@(3)];
	XCTAssertEqualObjects(actionOrder, (@[@"invocationAction",  @"action"]));
	XCTAssertEqualObjects(returnedString, @"returnValue");
	[actionOrder removeAllObjects];
	
	returnedString = [mock methodWithObject:@(4)];
	XCTAssertEqualObjects(actionOrder, (@[@"action",  @"invocationAction"]));
	XCTAssertEqualObjects(returnedString, @"invocationActionReturn");
	[actionOrder removeAllObjects];
}

- (void)testNilCanBeMatched {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[WHEN([mock methodWithObject:nil]) thenReturn:@"return"];
	
	XCTAssertEqualObjects([mock methodWithObject:nil], @"return");
}

- (void)testWhenProtocolIsStubbedThenCorrectValueIsReturned {
    id<SBLTestingProtocol> mock = [SBLMock mockForProtocol:@protocol(SBLTestingProtocol)];
	
	[WHEN([mock protocolMethodWithInteger:42]) thenReturn:@"2"];
	[WHEN([mock protocolMethodWithInteger:3]) thenReturn:@"1"];
	[WHEN([mock protocolMethodWithObject:@(71)]) thenReturn:@"3"];
	[WHEN([mock protocolMethodWithObject:nil]) thenReturn:@"5"];
	[WHEN([mock protocolMethodWithObject:@(0)]) thenReturn:@"4"];
	
	XCTAssertEqualObjects([mock protocolMethodWithObject:nil], @"5");
	XCTAssertEqualObjects([mock protocolMethodWithObject:@(71)], @"3");
	XCTAssertEqualObjects([mock protocolMethodWithObject:@(0)], @"4");
	XCTAssertEqualObjects([mock protocolMethodWithInteger:42], @"2");
	XCTAssertEqualObjects([mock protocolMethodWithInteger:3], @"1");
}

- (void)testEncode {
	const char *encodingClass = @encode(__typeof__([NSObject class]));
	const char *encodingProtocol = @encode(__typeof__(@protocol(SBLMockObject)));
	
	NSLog(@"class: %s", encodingClass);
	NSLog(@"protocol: %s", encodingProtocol);
	NSLog(@"protocol class: %@", NSStringFromClass([(id)@protocol(SBLMockObject) class]));
}

@end
