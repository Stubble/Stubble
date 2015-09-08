#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"
#import "SBLTestingProtocol.h"
#import <UIKit/UIKit.h>

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
		void *pointer = NULL;
		[invocation getArgument:&pointer atIndex:2];
		capturedNumber = (__bridge NSNumber *)(pointer);
		NSString *returnString = [NSString stringWithFormat:@"return %ld", (long)counter++];
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

- (void)testWhenClassIsStubbedThenCorrectMockObjectDescriptionIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    SBLMockObject *mockedObject = (SBLMockObject *)mock;

    NSString *expectedDescription = @"Mocking class SBLTestingClass";
    
    XCTAssertEqualObjects([mockedObject debugDescription], expectedDescription);
}

- (void)testWhenProtocolIsStubbedThenCorrectMockObjectDescriptionIsReturned {
    id<SBLTestingProtocol> mock = mock(@protocol(SBLTestingProtocol));
    SBLMockObject *mockedProtocol = (SBLMockObject *)mock;
    
    NSString *expectedDescription = @"Mocking protocol SBLTestingProtocol";
    
    XCTAssertEqualObjects([mockedProtocol debugDescription], expectedDescription);
}

- (void)testWhenIntegerNumberIsReturnedFromStubMethodThatReturnsADoubleThenTheCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [when(mock.methodReturningDouble) thenReturn:@123];

    XCTAssertEqualWithAccuracy(mock.methodReturningDouble, 123.0, 0.0000000001);
}

- (void)testWhenNSNumbersNotExactlyMatchingTypeAreReturnedFromStubMethodsThatReturnPrimitivesThenCorrectPrimitivesAreReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    [when(mock.methodReturningInt) thenReturn:@123];
    [when(mock.methodReturningChar) thenReturn:@123];
    [when(mock.methodReturningUnsignedChar) thenReturn:@123];
    [when(mock.methodReturningShort) thenReturn:@123];
    [when(mock.methodReturningUnsignedShort) thenReturn:@123];
    [when(mock.methodReturningUnsignedInt) thenReturn:@123];
    [when(mock.methodReturningLong) thenReturn:@123];
    [when(mock.methodReturningUnsignedLong) thenReturn:@123];
    [when(mock.methodReturningLongLong) thenReturn:@123];
    [when(mock.methodReturningUnsignedLongLong) thenReturn:@123];
    [when(mock.methodReturningFloat) thenReturn:@123];
    [when(mock.methodReturningDouble) thenReturn:@123];
    [when(mock.methodReturningBool) thenReturn:@0];

    int a = 123;
    char b = 123;
    unsigned char c = 123;
    short d = 123;
    unsigned short e = 123;
    unsigned int f = 123;
    long g = 123;
    unsigned long h = 123;
    long long i = 123;
    unsigned long long j = 123;
    float k = 123;
    double l = 123;
    BOOL m = NO;

    XCTAssertEqual(mock.methodReturningInt, a);
    XCTAssertEqual(mock.methodReturningChar, b);
    XCTAssertEqual(mock.methodReturningUnsignedChar, c);
    XCTAssertEqual(mock.methodReturningShort, d);
    XCTAssertEqual(mock.methodReturningUnsignedShort, e);
    XCTAssertEqual(mock.methodReturningUnsignedInt, f);
    XCTAssertEqual(mock.methodReturningLong, g);
    XCTAssertEqual(mock.methodReturningUnsignedLong, h);
    XCTAssertEqual(mock.methodReturningLongLong, i);
    // FIXME: Getting intermittent test failures for this assert in AppCode
    XCTAssertEqual(mock.methodReturningUnsignedLongLong, j);
    XCTAssertEqual(mock.methodReturningFloat, k);
    XCTAssertEqual(mock.methodReturningDouble, l);
    XCTAssertEqual(mock.methodReturningBool, m);
}

@end
