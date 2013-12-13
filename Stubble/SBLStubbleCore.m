#import "SBLStubbleCore.h"

#define SBLBadUsage @"SBLBadUsage"
#define SBLVerifyFailed @"SBLVerifyFailed"

@interface SBLStubbleCore ()

@property(nonatomic, readwrite) SBLStubbleCoreState state;
@property(nonatomic) id<SBLMockObject> currentMock;

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

- (void)clear {
    self.currentMock = nil;
    self.state = SBLStubbleCoreStateAtRest;
}

- (void)prepareForWhen {
    [self verifyState:SBLStubbleCoreStateAtRest];
    self.state = SBLStubbleCoreStateOngoingWhen;
}

- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock {
    [self verifyState:SBLStubbleCoreStateOngoingWhen];
    self.currentMock = mock;
}

- (SBLOngoingWhen *)performWhen {
    [self verifyState:SBLStubbleCoreStateOngoingWhen];
    [self verifyMockCalled:@"called WHEN without specifying a method call on a mock"];

    SBLOngoingWhen *when = self.currentMock.currentOngoingWhen;
    [self clear];
    return when;
}

- (void)prepareForVerify {
    [self verifyState:SBLStubbleCoreStateAtRest];

    self.state = SBLStubbleCoreStateOngoingVerify;
}

- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock {
	self.currentMock = mock;
}

- (void)performVerify {
    [self verifyState:SBLStubbleCoreStateOngoingVerify];
    [self verifyMockCalled:@"called VERIFY without specifying a method call on a mock"];

    NSInteger invocationCount = 0;
    NSInvocation *mockInvocation = self.currentMock.lastVerifyInvocation;
    for (NSInvocation *actualInvocation in self.currentMock.actualInvocations) {
        if ([self.class actualInvocation:actualInvocation matchesMockInvocation:mockInvocation]) {
            invocationCount++;
        }
    }

    [self clear];
    if (!invocationCount) {
        // TODO get the line numbers in the exception
        // TODO tell them if it was the parameters that were wrong, or if the method simply wasn't called
        // TODO tell them what the expected parameters are
        [NSException raise:SBLVerifyFailed format:@"Expected %@", NSStringFromSelector(mockInvocation.selector)];
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
    return matchingInvocation;
}

+ (BOOL)typeIsObject:(const char *)type {
    return strcmp(type, "@") == 0;
}


- (void)verifyMockCalled:(NSString *)message {
    if (!self.currentMock) {
        [self throwUsage:message];
    }
}

- (void)verifyState:(SBLStubbleCoreState)expectedState {
    if (self.state != expectedState) {
        [self throwUsage:[NSString stringWithFormat:@"Expected state %@ but was %@.  Do not use the SBLStubbleCore class directly.", [self descriptionFromState:expectedState], [self descriptionFromState:self.state]]];
    }
}

- (NSString *)descriptionFromState:(SBLStubbleCoreState)state {
    NSString *description;
    if (state == SBLStubbleCoreStateAtRest) {
        description = @"SBLStubbleCoreStateAtRest";
    } else if (state == SBLStubbleCoreStateOngoingWhen) {
        description = @"SBLStubbleCoreStateOngoingWhen";
    } else if (state == SBLStubbleCoreStateOngoingVerify) {
        description = @"SBLStubbleCoreStateOngoingVerify";
    } else {
        description = @"UNKNOWN";
    }
    return description;
}

- (void)throwUsage:(NSString *)message {
    [self clear];
    [NSException raise:SBLBadUsage format:message];
}

@end
