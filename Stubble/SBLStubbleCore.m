#import "SBLStubbleCore.h"

@interface SBLStubbleCore ()

@property(nonatomic, readwrite) BOOL whenInProgress;
@property(nonatomic) id<SBLMockObject> mockForCurrentWhen;

@property(nonatomic, readwrite) BOOL verifyInProgress;
@property(nonatomic) id<SBLMockObject> mockForCurrentVerify;

@end

@implementation SBLStubbleCore

+ (id)core {
    static dispatch_once_t once;
    static SBLStubbleCore *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)prepareForWhen {
    self.mockForCurrentWhen = nil;
    self.whenInProgress = YES;
}

- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock {
    self.mockForCurrentWhen = mock;
}

- (SBLOngoingWhen *)performWhen {
    if (!self.mockForCurrentWhen) {
		// TODO throw exception here
        NSLog(@"Error: called WHEN without calling a mock method.");
    }
	self.whenInProgress = NO;
    return self.mockForCurrentWhen.currentOngoingWhen;
}

- (void)prepareForVerify {
    NSLog(@"prepareForVerify");
    self.mockForCurrentVerify = nil;
    self.verifyInProgress = YES;
}

- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock {
	self.mockForCurrentVerify = mock;
}

- (void)performVerify {
    NSLog(@"performVerify");
    if (!self.mockForCurrentVerify) {
		// TODO throw exception here
        NSLog(@"Error: called VERIFY without calling a mock method.");
    }

    NSInteger invocationCount = 0;
    NSInvocation *mockInvocation = self.mockForCurrentVerify.lastVerifyInvocation;
    for (NSInvocation *actualInvocation in self.mockForCurrentVerify.actualInvocations) {
        if ([self.class actualInvocation:actualInvocation matchesMockInvocation:mockInvocation]) {
            invocationCount++;
        }
    }

    self.verifyInProgress = NO;
    if (!invocationCount) {
        [NSException raise:@"SBLVerifyFailed" format:@"Expected %@", NSStringFromSelector(mockInvocation.selector)];
    }
}

+ (BOOL)actualInvocation:(NSInvocation *)actual matchesMockInvocation:(NSInvocation *)mock {
    BOOL matchingInvocation = actual.selector == mock.selector;
    for (int i = 2; i < actual.methodSignature.numberOfArguments; i++) {
        // Need unsafe unretained here - http://stackoverflow.com/questions/11874056/nsinvocation-getreturnvalue-called-inside-forwardinvocation-makes-the-returned
        __unsafe_unretained id argumentMatcher = nil;
        __unsafe_unretained id argument = nil;
        [mock getArgument:&argumentMatcher atIndex:i];
        [actual getArgument:&argument atIndex:i];

        if ([self typeIsObject:[mock.methodSignature getArgumentTypeAtIndex:i]]) {
            matchingInvocation &= [argumentMatcher isEqual:argument];
        } else {
            matchingInvocation &= argumentMatcher == argument;
        }
    }

    NSLog(@"actualInvocation:matchesMockInvocation: returned %d", matchingInvocation);
    return matchingInvocation;
}

+ (BOOL)typeIsObject:(const char *)type {
    return strcmp(type, "@") == 0;
}

@end
