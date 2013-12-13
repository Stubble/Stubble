#import "SBLStubbleCore.h"

#define SBLBadUsage @"SBLBadUsage"

@interface SBLStubbleCore ()

@property (nonatomic, readwrite) SBLStubbleCoreState state;
@property (nonatomic) id<SBLMockObject> currentMock;
@property (nonatomic, readonly) NSMutableArray *matchers;

@end

@implementation SBLStubbleCore

+ (instancetype)core {
	NSString *key = NSStringFromClass([self class]);
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	SBLStubbleCore *core = threadDictionary[key];
	if (!core) {
		core = [[self alloc] init];
		threadDictionary[key] = core;
	}
    return core;
}

- (id)init {
	if (self = [super init]) {
		_matchers = [NSMutableArray array];
	}
	return self;
}

- (void)clear {
    self.currentMock = nil;
	[self.matchers removeAllObjects];
    self.state = SBLStubbleCoreStateAtRest;
}

- (void)addMatcher:(SBLMatcher *)matcher {
	[self.matchers addObject:matcher];
}

- (void)prepareForWhen {
    [self verifyState:SBLStubbleCoreStateAtRest];
    self.state = SBLStubbleCoreStateOngoingWhen;
}

- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock {
    [self verifyState:SBLStubbleCoreStateOngoingWhen];
    self.currentMock = mock;
	[self.currentMock.currentStubbedInvocation setMatchers:[NSArray arrayWithArray:self.matchers]];
}

- (SBLStubbedInvocation *)performWhen {
    [self verifyState:SBLStubbleCoreStateOngoingWhen];
    [self verifyMockCalled:@"called WHEN without specifying a method call on a mock"];

    SBLStubbedInvocation *when = self.currentMock.currentStubbedInvocation;
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
	@try {
		[self.currentMock verifyLastInvocation];
	}
	@catch (NSException *exception) {
		@throw exception;
	}
	@finally {
		[self clear];
	}
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
    [NSException raise:SBLBadUsage format:@"%@", message];
}

@end
