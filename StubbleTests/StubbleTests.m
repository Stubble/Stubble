#import <XCTest/XCTest.h>
#import "STBMock.h"

@interface STBFoo : NSObject

- (NSString *)methodReturningString;

- (int)methodReturningInt;

@end

@implementation STBFoo

- (NSString *)methodReturningString {
    return @"123";
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

@end
