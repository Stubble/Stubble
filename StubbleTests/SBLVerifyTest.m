#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLVerifyTest : XCTestCase

@end

@implementation SBLVerifyTest

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

    [mock methodWithManyArguments:@"arg1" primitive:2 number:@3];
	
	XCTAssertNoThrow(VERIFY([mock methodWithManyArguments:@"arg1" primitive:2 number:@3]));
}

@end
