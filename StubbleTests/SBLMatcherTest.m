#import <XCTest/XCTest.h>
#import "Stubble.h"
#import "SBLTestingClass.h"
#import "SBLTestingBlockCreator.h"

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

- (void)testWhenMethodStubbedWithAnyMatcherThenCorrectValueIsReturned {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
	[when([mock methodWithObject:any()]) thenReturn:@"one"];
	[when([mock methodWithInteger:any(NSInteger)]) thenReturn:@"two"];
	
	XCTAssertEqualObjects([mock methodWithObject:@11], @"one");
	XCTAssertEqualObjects([mock methodWithObject:@42], @"one");
	XCTAssertEqualObjects([mock methodWithObject:nil], @"one");
	
	XCTAssertEqualObjects([mock methodWithInteger:11], @"two");
	XCTAssertEqualObjects([mock methodWithInteger:42], @"two");
	XCTAssertEqualObjects([mock methodWithInteger:0], @"two");
}

- (void)testWhenMultipleArgumentMethodHasMatcherForOneArgumentThenOtherArgumentIsUsedForMatching {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
	
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

- (void)testAnyMatcherWorksForManyArgumentTypes {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    SBLTestingClass *mock2 = mock(SBLTestingClass.class);
	[when([mock methodWithBool:any(BOOL)]) thenReturn:@"return"];
	[when([mock methodWithInteger:any(NSInteger)]) thenReturn:@"return"];
	[when([mock methodWithPrimitiveReference:any(NSInteger *)]) thenReturn:@"return"];
	[when([mock methodWithReference:any(__autoreleasing NSString **)]) thenReturn:@"return"];
	[when([mock methodWithSelector:any(SEL)]) thenReturn:@"return"];
	[when([mock methodWithCGRect:any(CGRect)]) thenReturn:@"return"];
	[when([mock methodWithStruct:any(SBLTestingStruct)]) thenReturn:@"return"];
	[when([mock methodWithStructReference:any(SBLTestingStruct *)]) thenReturn:@"return"];
	[when([mock methodWithBlock:any()]) thenReturn:@"return"];
	[when([mock2 methodWithBlock:any(SBLTestingBlock)]) thenReturn:@"return"];
	[when([mock methodWithObject:any()]) thenReturn:@"return"];
	[when([mock2 methodWithObject:any(NSNumber *)]) thenReturn:@"return"];
	[when([mock methodWithClass:any()]) thenReturn:@"return"];
	[when([mock2 methodWithClass:any(Class)]) thenReturn:@"return"];
	
	XCTAssertEqualObjects([mock methodWithInteger:23], @"return");
	XCTAssertEqualObjects([mock methodWithBool:YES], @"return");
	NSInteger integer = 42;
	XCTAssertEqualObjects([mock methodWithPrimitiveReference:&integer], @"return");
	NSString *string = @"42";
	XCTAssertEqualObjects([mock methodWithReference:&string], @"return");
	XCTAssertEqualObjects([mock methodWithSelector:@selector(testAnyMatcherWorksForManyArgumentTypes)], @"return");
	XCTAssertEqualObjects([mock methodWithCGRect:CGRectMake(10, 1, 30, 50)], @"return");
	SBLTestingStruct testingStruct = { 1, YES, "other stuff" };
	XCTAssertEqualObjects([mock methodWithStruct:testingStruct], @"return");
	XCTAssertEqualObjects([mock methodWithStructReference:&testingStruct], @"return");
	SBLTestingBlock block = ^(int integer, NSObject *object) {
		NSLog(@"block");
	};
	XCTAssertEqualObjects([mock methodWithBlock:block], @"return");
	XCTAssertEqualObjects([mock methodWithClass:[NSArray class]], @"return");
	XCTAssertEqualObjects([mock2 methodWithClass:[NSArray class]], @"return");
	XCTAssertEqualObjects([mock methodWithObject:@2], @"return");
	XCTAssertEqualObjects([mock2 methodWithObject:@2], @"return");
}

- (void)testCaptureCapturesArgumentInWhen {
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    BOOL capturedBool = NO;
    NSInteger capturedInteger = 0;
    NSNumber *capturedObject = nil;
    __block BOOL capturedBlockRun = NO;
	SBLTestingBlock capturedBlock = nil;
	NSTimeInterval capturedTimeInterval;
	CGRect capturedRect;

	when([mock methodWithBool:capture(&capturedBool)]);
	when([mock methodWithTimeInterval:capture(&capturedTimeInterval)]);
	when([mock methodWithInteger:capture(&capturedInteger)]);
	when([mock methodWithObject:capture(&capturedObject)]);
	when([mock methodWithBlock:capture(&capturedBlock)]);
	when([mock methodWithCGRect:capture(&capturedRect)]);

    [mock methodWithBool:YES];
    XCTAssertTrue(capturedBool);
    [mock methodWithTimeInterval:1337.0423];
    XCTAssertEqual(capturedTimeInterval, 1337.0423);
    [mock methodWithInteger:42];
    XCTAssertEqual(capturedInteger, (NSInteger)42);
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
    SBLTestingClass *mock = mock(SBLTestingClass.class);
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
    XCTAssertEqual(capturedInteger, (NSInteger)42);
    XCTAssertEqualObjects(capturedObject, @42);
    if (capturedBlock) {
        capturedBlock(1, @1);
    }
    XCTAssertTrue(capturedBlockRun);
}

- (void)testBlockCaptureWorksWhenWeakReferenceIsUsedInBlock {
    SBLTestingBlock capturedBlock = nil;
    SBLTestingClass *mock = mock(SBLTestingClass.class);

    SBLMatcherTestBlockRunner *runner = [[SBLMatcherTestBlockRunner alloc] initAndPassBlockToMock:mock];

	verifyTimes(atLeast(1), [mock methodWithBlock:capture(&capturedBlock)]);

    if (capturedBlock) {
        capturedBlock(1, @(42));
    }

    XCTAssertEqualObjects(runner.objectPassedToBlock, @(42));
}

- (void)testBlockCaptureCapturesTwoBlocks {
    NSString *capturedString1 = nil;
    NSString *capturedString2 = nil;
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    
    [mock methodWithArgument1:@"abc" argument2:@"Capture1"];
    [mock methodWithArgument1:@"xyz" argument2:@"Capture2"];
    
    verify([mock methodWithArgument1:@"abc" argument2:capture(&capturedString1)]);
    verify([mock methodWithArgument1:@"xyz" argument2:capture(&capturedString2)]);
    
    XCTAssertEqualObjects(capturedString1, @"Capture1");
    XCTAssertEqualObjects(capturedString2, @"Capture2");
}

- (void)testWhenVerificationIsMadeThenMockNoLongerCapturesArgumentsForThatVerify {
    NSString *capturedString = nil;
    SBLTestingClass *mock = mock(SBLTestingClass.class);
    
    [mock methodWithArgument1:@"abc" argument2:@"original"];
    
    verify([mock methodWithArgument1:@"abc" argument2:capture(&capturedString)]);
    
    [mock methodWithArgument1:@"abc" argument2:@"new"];
    
    XCTAssertEqualObjects(capturedString, @"original");
}

- (void)testWhenABlockIsCapturedAndThenTheBlockLeavesOriginalScopeThenItIsStillAvailableToCall {
    SBLTestingBlockCreator *creator = [[SBLTestingBlockCreator alloc] init];
    SBLTestingClass *sender = mock(SBLTestingClass.class);
    SBLTestingClass *receiver = mock(SBLTestingClass.class);
    creator.sender = sender;
    creator.receiver = receiver;
    SBLTestingBlock capturedBlock;
    
    when([sender methodWithBlock:capture(&capturedBlock)]);
    
    [creator runInBlockWithNumber:1337];
    
    capturedBlock(0, nil);

    verify([receiver methodWithInteger:1337]);
}

@end
