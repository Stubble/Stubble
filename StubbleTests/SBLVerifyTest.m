#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

- (void)testWhenVerifyingForMethodThatWasNeverCalledThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	XCTAssertThrows(VERIFY([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodThatWasCalledThatWasMadeThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[mock methodReturningInt];

	XCTAssertNoThrow(VERIFY([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodThatWasNotTheLastMethodCalledThenNoExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodReturningString];
    [mock methodReturningInt];
    [mock methodReturningString];

    XCTAssertNoThrow(VERIFY([mock methodReturningInt]));
}

- (void)testWhenVerifyingForMethodWithCorrectParametersThenNoExceptionThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

	XCTAssertThrows(VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
	
	[mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	XCTAssertNoThrow(VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

- (void)testWhenVerifyingForMethodWithDifferentParametersThenExceptionIsThrown {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    [mock methodWithManyArguments:@"1" primitive:2 number:@3];

    XCTAssertThrows(VERIFY([mock methodWithManyArguments:@"2" primitive:2 number:@3]));
    XCTAssertThrows(VERIFY([mock methodWithManyArguments:@"1" primitive:1 number:@3]));
    XCTAssertThrows(VERIFY([mock methodWithManyArguments:@"1" primitive:2 number:@1]));
}

@end
