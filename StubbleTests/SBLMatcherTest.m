#import <XCTest/XCTest.h>
#import "SBLMock.h"
#import "SBLTestingClass.h"

@interface SBLMatcherTestBlockRunner : NSObject

- (id)initAndPassBlockToMock:(SBLTestingClass *)mock;

@property (nonatomic, readonly) SBLTestingClass *mock;
@property (nonatomic) NSObject *objectPassedToBlock;

@end

@implementation SBLMatcherTestBlockRunner

- (id)initAndPassBlockToMock:(SBLTestingClass *)mock {
    if (self = [super init]) {
        _mock = mock;
        [self passBlockToMock];
    }
    return self;
}

- (void)passBlockToMock {
    __weak SBLMatcherTestBlockRunner *weakSelf = self;
    [self.mock methodWithBlock:^(int integer, NSObject *object) {
        weakSelf.objectPassedToBlock = object;
    }];
}

@end

@interface SBLMatcherTest : XCTestCase

@property (nonatomic) NSObject *capturedObject;

@end

@implementation SBLMatcherTest

// also broken due to literals
- (void)testWhenMethodStubbedWithAnyMatcherThenCorrectValueIsReturned {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[when([mock methodWithObject:any()]) thenReturn:@"one"];
	[when([mock methodWithInteger:any()]) thenReturn:@"two"];
	
	XCTAssertEqualObjects([mock methodWithObject:@11], @"one");
	XCTAssertEqualObjects([mock methodWithObject:@42], @"one");
	XCTAssertEqualObjects([mock methodWithObject:nil], @"one");
	
	XCTAssertEqualObjects([mock methodWithInteger:11], @"two");
	XCTAssertEqualObjects([mock methodWithInteger:42], @"two");
	XCTAssertEqualObjects([mock methodWithInteger:0], @"two");
}

// also broken due to literals
- (void)testWhenMultipleArgumentMethodHasMatcherForOneArgumentThenOtherArgumentIsUsedForMatching {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[when([mock methodWithArgument1:@"arg1" argument2:any()]) thenReturn:@"one"];
	[when([mock methodWithArgument1:@"arg2" argument2:any()]) thenReturn:@"two"];
	[when([mock methodWithArgument1:any() argument2:@"arg3"]) thenReturn:@"three"];
	[when([mock methodWithArgument1:any() argument2:@"arg4"]) thenReturn:@"four"];
	
	XCTAssertEqualObjects([mock methodWithArgument1:@"arg1" argument2:@"other stuff"], @"one");
	XCTAssertEqualObjects([mock methodWithArgument1:@"arg2" argument2:@"other stuff"], @"two");
	XCTAssertEqualObjects([mock methodWithArgument1:@"stuff" argument2:@"arg3"], @"three");
	XCTAssertEqualObjects([mock methodWithArgument1:@"stuff" argument2:@"arg4"], @"four");
	XCTAssertNil([mock methodWithArgument1:@"stuff" argument2:@"other stuff"]);
}

- (void)testMatcherWorksForManyArgumentTypes {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
	
	[when([mock methodWithBool:any()]) thenReturn:@"return"];
	[when([mock methodWithPrimitiveReference:any()]) thenReturn:@"return"];
	// TODO make object references (ie: (NSString * __autoreleasing *)) work somehow too...
	//[when([mock methodWithReference:any()]) thenReturn:@"return"];
	[when([mock methodWithSelector:any()]) thenReturn:@"return"];
	[when([mock methodWithCGRect:anyCGRect()]) thenReturn:@"return"];
	SBLTestingStruct validStruct = { 1, YES, NULL };
	[when([mock methodWithStruct:anyWithPlaceholder(validStruct)]) thenReturn:@"return"];
	[when([mock methodWithStructReference:any()]) thenReturn:@"return"];
	[when([mock methodWithClass:any()]) thenReturn:@"return"];
	[when([mock methodWithBlock:any()]) thenReturn:@"return"];
	
	XCTAssertEqualObjects([mock methodWithBool:YES], @"return");
	NSInteger integer = 42;
	XCTAssertEqualObjects([mock methodWithPrimitiveReference:&integer], @"return");
	//NSString *string = @"42";
	//XCTAssertEqualObjects([mock methodWithReference:&string], @"return");
	XCTAssertEqualObjects([mock methodWithSelector:@selector(testMatcherWorksForManyArgumentTypes)], @"return");
	XCTAssertEqualObjects([mock methodWithCGRect:CGRectMake(10, 1, 30, 50)], @"return");
	SBLTestingStruct testingStruct = { 1, YES, "other stuff" };
	XCTAssertEqualObjects([mock methodWithStruct:testingStruct], @"return");
	XCTAssertEqualObjects([mock methodWithStructReference:&testingStruct], @"return");
	XCTAssertEqualObjects([mock methodWithClass:[NSArray class]], @"return");
	SBLTestingBlock block = ^(int integer, NSObject *object) {
		NSLog(@"block");
	};
	XCTAssertEqualObjects([mock methodWithBlock:block], @"return");
}

- (void)testCaptureCapturesArgumentInWhen {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
    BOOL capturedBool = NO;
    NSInteger capturedInteger = 0;
    NSNumber *capturedObject = nil;
    __block BOOL capturedBlockRun = NO;
    SBLTestingBlock capturedBlock = nil;

	when([mock methodWithBool:capture(&capturedBool)]);
	when([mock methodWithInteger:capture(&capturedInteger)]);
	when([mock methodWithObject:capture(&capturedObject)]);
	when([mock methodWithBlock:capture(&capturedBlock)]);

    [mock methodWithBool:YES];
    XCTAssertTrue(capturedBool);
    [mock methodWithInteger:42];
    XCTAssertEqual(capturedInteger, 42);
    [mock methodWithObject:@42];
    XCTAssertEqualObjects(capturedObject, @42);
    [mock methodWithBlock:^(int integer, NSObject *object) {
        capturedBlockRun = YES;
    }];
    if (capturedBlock) {
        capturedBlock(1, @1);
    }
    XCTAssertTrue(capturedBlockRun);
}

- (void)testCaptureCapturesArgumentInVerify {
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];
    BOOL capturedBool = NO;
    NSInteger capturedInteger = 0;
    NSNumber *capturedObject = nil;
    __block BOOL capturedBlockRun = NO;
    SBLTestingBlock capturedBlock = nil;

    [mock methodWithBool:YES];
    [mock methodWithInteger:42];
    [mock methodWithObject:@42];
    [mock methodWithBlock:^(int integer, NSObject *object) {
        capturedBlockRun = YES;
    }];

	verifyTimes(atLeast(1), [mock methodWithBool:capture(&capturedBool)]);
	verifyTimes(atLeast(1), [mock methodWithInteger:capture(&capturedInteger)]);
	verifyTimes(atLeast(1), [mock methodWithObject:capture(&capturedObject)]);
	verifyTimes(atLeast(1), [mock methodWithBlock:capture(&capturedBlock)]);

    XCTAssertTrue(capturedBool);
    XCTAssertEqual(capturedInteger, 42);
    XCTAssertEqualObjects(capturedObject, @42);
    if (capturedBlock) {
        capturedBlock(1, @1);
    }
    XCTAssertTrue(capturedBlockRun);
}

- (void)testBlockCaptureWorksWhenWeakReferenceIsUsedInBlock {
    SBLTestingBlock capturedBlock = nil;
    SBLTestingClass *mock = [SBLMock mockForClass:SBLTestingClass.class];

    SBLMatcherTestBlockRunner *runner = [[SBLMatcherTestBlockRunner alloc] initAndPassBlockToMock:mock];

	verifyTimes(atLeast(1), [mock methodWithBlock:capture(&capturedBlock)]);

    if (capturedBlock) {
        capturedBlock(1, @(42));
    }

    XCTAssertEqualObjects(runner.objectPassedToBlock, @(42));
}

@end
