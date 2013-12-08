#import <XCTest/XCTest.h>
#import "STBMockObject.h"
#import "STBStubbleCore.h"

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

#define WHEN(__METHOD_CALL) ({ [STBStubbleCore prepareForWhen]; __METHOD_CALL; [STBStubbleCore performWhen]; })

//#define BOX(X) ({__typeof__(X) __x = (X); [NSValue value:__x withObjCType:@encode(__typeof__(X))];})

//#define WHEN(X) ({__typeof__(X) __x = (X); (IS_OBJECT(__x) ? DO_WHEN(__x) : DO_WHEN(@(__x)));})
//#define WHEN(X) ({__typeof__(X) __x = (X); DO_WHEN(__x);})
//#define WHEN(X) ({__typeof__(X) __x = (X); DO_WHEN([NSValue value:__x withObjCType:@encode(__typeof__(X))]);})

- (void)testExample {
     STBFoo *mock = [STBMockObject mockForClass:STBFoo.class];

    [WHEN(mock.methodReturningInt) thenReturn:@5];
    [WHEN(mock.methodReturningString) thenReturn:@"alpha"];
//    [[STBStubbleCore when:mock.methodReturningInt] thenReturn:5];

}

@end
