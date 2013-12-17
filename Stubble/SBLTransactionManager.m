#import "SBLTransactionManager.h"
#import "SBLErrors.h"
#import "SBLTimesMatcher.h"

@interface SBLTransactionManager ()

@property (nonatomic, readwrite) SBLTransactionManagerState state;
@property (nonatomic) id<SBLMockObject> currentMock;
@property (nonatomic, readonly) NSMutableArray *matchers;

@end

@implementation SBLTransactionManager

+ (instancetype)currentTransactionManager {
	NSString *key = NSStringFromClass([self class]);
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	SBLTransactionManager *core = threadDictionary[key];
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


- (SBLStubbedInvocation *)invokeWhenMethodForObjectInBlock:(InvokeMethodBlock)block {
	// Prepare
    [self verifyState:SBLTransactionManagerStateAtRest];
    self.state = SBLTransactionManagerStateStubInProgress;
	
	// Run
	block();
	
	// Finish
    [self verifyState:SBLTransactionManagerStateStubInProgress];
    [self verifyMockCalled:SBLBadWhenErrorMessage];
	
    SBLStubbedInvocation *when = self.currentMock.currentStubbedInvocation;
    [self clear];
    return when;
}

- (void)clear {
    self.currentMock = nil;
	[self.matchers removeAllObjects];
    self.state = SBLTransactionManagerStateAtRest;
}

- (void)addMatcher:(SBLMatcher *)matcher {
	[self.matchers addObject:matcher];
}

- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock {
    [self verifyState:SBLTransactionManagerStateStubInProgress];
    self.currentMock = mock;
	[self.currentMock.currentStubbedInvocation setMatchers:[NSArray arrayWithArray:self.matchers]];
}

- (void)invokeVerifyMethodForObjectInBlock:(InvokeMethodBlock)block times:(SBLTimesMatcher *)timesMatcher {
    // Prepare
    [self verifyState:SBLTransactionManagerStateAtRest];
    self.state = SBLTransactionManagerStateVerifyInProgress;

    // Run
    block();

    // Finish
    [self verifyState:SBLTransactionManagerStateVerifyInProgress];
    [self verifyMockCalled:SBLBadVerifyErrorMessage];
    @try {
        [self.currentMock verifyInvocationOccurredNumberOfTimes:timesMatcher];
    } @finally {
        [self clear];
    }
}

- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock {
	self.currentMock = mock;
	[self.currentMock.verifyInvocation setMatchers:[NSArray arrayWithArray:self.matchers]];
}

- (void)verifyMockCalled:(NSString *)errorMessage {
    if (!self.currentMock) {
        [self throwUsage:errorMessage];
    }
}

- (void)verifyState:(SBLTransactionManagerState)expectedState {
    if (self.state != expectedState) {
        [self throwUsage:[NSString stringWithFormat:@"Expected state %@ but was %@.  Do not use the SBLStubbleCore class directly.", [self descriptionFromState:expectedState], [self descriptionFromState:self.state]]];
    }
}

- (NSString *)descriptionFromState:(SBLTransactionManagerState)state {
    NSString *description;
    if (state == SBLTransactionManagerStateAtRest) {
        description = @"SBLStubbleCoreStateAtRest";
    } else if (state == SBLTransactionManagerStateStubInProgress) {
        description = @"SBLStubbleCoreStateOngoingWhen";
    } else if (state == SBLTransactionManagerStateVerifyInProgress) {
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
