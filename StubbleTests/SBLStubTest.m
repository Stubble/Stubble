#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"
#import "SBLTestingProtocol.h"

@interface SBLStubTest : XCTestCase

@end

@implementation SBLStubTest

- (void)testWhenPrimitiveMethodWithNoParametersIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when(mock.methodReturningInt) thenReturn:@5];

    XCTAssertEqual(mock.methodReturningInt, 5);
}

- (void)testWhenObjectMethodWithNoParametersIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when(mock.methodReturningString) thenReturn:@"alpha"];
	
    XCTAssertEqualObjects(mock.methodReturningString, @"alpha");
}

- (void)testWhenObjectMethodReturnsNSValueWithObjectThenCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	NSObject *expectedObject = [[NSObject alloc] init];
	
    [when(mock.methodReturningNSValue) thenReturn:[NSValue valueWithNonretainedObject:expectedObject]];
	
    XCTAssertEqual([mock.methodReturningNSValue nonretainedObjectValue], expectedObject);
}

- (void)testWhenCommaIsPassedToMacroCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	NSArray *expectedArray = @[@"item3"];
	
	NSArray *array = @[@"item1", @"item2"];
	[when([mock methodWithArray:array]) thenReturn:expectedArray];
	
    XCTAssertEqual(([mock methodWithArray:array]), expectedArray);
}

- (void)testWhenVariableArgumentMethodIsStubbedThenCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]) thenReturn:@"alpha"];
	// TODO - attempt to find a way to match a va_list
    //[when([mock methodWithVariableNumberOfArguments:@"1", @"2", @"7", @"4", nil]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects(([mock methodWithVariableNumberOfArguments:@"1", @"2", @"3", @"4", nil]), @"alpha");
    //XCTAssertEqualObjects(([mock methodWithVariableNumberOfArguments:@"1", @"2", @"7", @"4", nil]), @"beta");
}

- (void)testWhenMethodIsNotStubbedItReturnsNil {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodReturningString]) thenReturn:@"alpha"];
	
    XCTAssertNil([mock methodReturningNSValue]);
}

- (void)testWhenMethodsAreStubbedThenBothReturnCorrectValue {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodReturningString]) thenReturn:@"alpha"];
    [when([mock methodReturningNSValue]) thenReturn:@42];
	
    XCTAssertEqualObjects([mock methodReturningNSValue], @42);
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
}

- (void)testWhenMethodIsStubbedItReturnsCorrectValueMultipleTimes {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodReturningString]) thenReturn:@"alpha"];
	
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
}

- (void)testWhenMethodIsStubbedAgainItReturnsNewValue {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodReturningString]) thenReturn:@"alpha"];
    XCTAssertEqualObjects([mock methodReturningString], @"alpha");
	
    [when([mock methodReturningString]) thenReturn:@"beta"];
    XCTAssertEqualObjects([mock methodReturningString], @"beta");
}

- (void)testWhenMethodStubbedWithDifferentValuesReturnsCorrectValueForBoth {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodWithArray:@[@"1"]]) thenReturn:@"alpha"];
    [when([mock methodWithArray:@[@"2"]]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects([mock methodWithArray:@[@"1"]], @"alpha");
    XCTAssertEqualObjects([mock methodWithArray:@[@"2"]], @"beta");
}

- (void)testWhenMethodStubbedWithDifferentValuesInOtherArgumentReturnsCorrectValueForBoth {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodWithManyArguments:@"1" primitive:2 number:@3]) thenReturn:@"alpha"];
    [when([mock methodWithManyArguments:@"1" primitive:2 number:@4]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:2 number:@3], @"alpha");
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:2 number:@4], @"beta");
}

- (void)testWhenMethodStubbedWithDifferentNSIntegersThenCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
    [when([mock methodWithManyArguments:@"1" primitive:5 number:@3]) thenReturn:@"alpha"];
    [when([mock methodWithManyArguments:@"1" primitive:8 number:@3]) thenReturn:@"beta"];
	
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:5 number:@3], @"alpha");
    XCTAssertEqualObjects([mock methodWithManyArguments:@"1" primitive:8 number:@3], @"beta");
}

- (void)testWhenMethodStubbedWithActionThenActionOccurs {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	__block NSString *string = nil;
	[when([mock methodWithNoReturn]) thenDo:^{ string = @"action"; }];
	
	[mock methodWithNoReturn];
	
	XCTAssertEqualObjects(string, @"action");
}

- (void)testWhenMethodStubbedWithActionsThenActionsOccurInOrder {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	__block NSMutableString *string = [NSMutableString string];
	[[when([mock methodWithNoReturn]) thenDo:^{ [string appendString:@"action1-"]; }] thenDo:^{  [string appendString:@"action2"]; }];
	
	[mock methodWithNoReturn];
	
	XCTAssertEqualObjects(string, @"action1-action2");
}

- (void)testWhenMethodStubbedWithInvocationActionThenInvocationIsPassedToActionBlockBeforeInvoke {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	__block NSInteger counter = 0;
	__block NSNumber *capturedNumber = nil;
	[when([mock methodWithObject:any()]) thenDoWithInvocation:^(NSInvocation *invocation) {
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
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	NSMutableArray *actionOrder = [NSMutableArray array];
	SBLInvocationActionBlock invocationAction = ^(NSInvocation *invocation) {
		NSString *returnString = @"invocationActionReturn";
		[invocation setReturnValue:&returnString];
		[actionOrder addObject:@"invocationAction"];
	};
	SBLActionBlock action = ^{
		[actionOrder addObject:@"action"];
	};
	
	[[[when([mock methodWithObject:@(1)]) thenDoWithInvocation:invocationAction] thenDo:action] thenReturn:@"returnValue"];
	[[[when([mock methodWithObject:@(2)]) thenDo:action] thenDoWithInvocation:invocationAction] thenReturn:@"returnValue"];
	[[[when([mock methodWithObject:@(3)]) thenDoWithInvocation:invocationAction] thenReturn:@"returnValue"] thenDo:action];
	[[[when([mock methodWithObject:@(4)]) thenDo:action] thenReturn:@"returnValue"] thenDoWithInvocation:invocationAction];
	
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
    SBLTestingClass *mock = mock(SBLTestingClass.class);

	[when([mock methodWithObject:nil]) thenReturn:@"return"];

	XCTAssertEqualObjects([mock methodWithObject:nil], @"return");
}

- (void)testBlockCanBeMatched {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    
	SBLTestingBlock block = ^(int integer, NSObject *object) {
		NSLog(@"block");
	};
	[when([mock methodWithBlock:block]) thenReturn:@"return"];

	XCTAssertEqualObjects([mock methodWithBlock:block], @"return");
}

- (void)testWhenProtocolIsStubbedThenCorrectValueIsReturned {
    id<SBLTestingProtocol> mock = mock(@protocol(SBLTestingProtocol));
	
	[when([mock protocolMethodWithInteger:42]) thenReturn:@"2"];
	[when([mock protocolMethodWithInteger:3]) thenReturn:@"1"];
	[when([mock protocolMethodWithObject:@(71)]) thenReturn:@"3"];
	[when([mock protocolMethodWithObject:nil]) thenReturn:@"5"];
	[when([mock protocolMethodWithObject:@(0)]) thenReturn:@"4"];
	
	XCTAssertEqualObjects([mock protocolMethodWithObject:nil], @"5");
	XCTAssertEqualObjects([mock protocolMethodWithObject:@(71)], @"3");
	XCTAssertEqualObjects([mock protocolMethodWithObject:@(0)], @"4");
	XCTAssertEqualObjects([mock protocolMethodWithInteger:42], @"2");
	XCTAssertEqualObjects([mock protocolMethodWithInteger:3], @"1");
}

- (void)testEncode {
	const char *encodingClass = @encode(__typeof__([NSObject class]));
	const char *encodingProtocol = @encode(__typeof__(@protocol(NSObject)));
	
	NSLog(@"class: %s", encodingClass);
	NSLog(@"protocol: %s", encodingProtocol);
	NSLog(@"protocol class: %@", NSStringFromClass([(id)@protocol(NSObject) class]));
}

@end
