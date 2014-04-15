#import "SBLTransactionManager.h"
#import "SBLErrors.h"
#import "SBLTimesMatcher.h"
#import "SBLOrderTokenInternal.h"
#import "SBLMock.h"

@interface SBLTransactionManager ()

@property (nonatomic) SBLTransactionManagerState state;
@property (nonatomic) SBLMockObject *currentMock;
@property (nonatomic) SBLOrderTokenInternal *currentOrderToken;
@property (nonatomic, readonly) NSMutableArray *matchers;
@property (nonatomic) int numberOfCallsDuringTransaction;

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

- (void)prepareForWhen {
    [self verifyState:SBLTransactionManagerStateAtRest];
    self.state = SBLTransactionManagerStateStubInProgress;
}

- (void)whenMethodInvokedForMock:(SBLMockObject *)mock {
    [self verifyState:SBLTransactionManagerStateStubInProgress];
    self.numberOfCallsDuringTransaction++;
    self.currentMock = mock;
	[self.currentMock.sblCurrentStubbedInvocation setMatchers:[NSArray arrayWithArray:self.matchers]];
}

- (SBLStubbedInvocation *)performWhen {
    [self verifyState:SBLTransactionManagerStateStubInProgress];
    [self verifyTransactionCallCountWithLowError:SBLBadWhenNoCallsErrorMessage highError:SBLBadWhenTooManyCallsErrorMessage];
    SBLStubbedInvocation *when = self.currentMock.sblCurrentStubbedInvocation;
    [self clear];
    return when;
}

- (void)clear {
    self.currentMock = nil;
    self.currentOrderToken = nil;
	[self.matchers removeAllObjects];
    self.state = SBLTransactionManagerStateAtRest;
    self.numberOfCallsDuringTransaction = 0;
}

- (void)addMatcher:(SBLMatcher *)matcher {
	if (self.state == SBLTransactionManagerStateAtRest) {
		[self throwUsage:SBLBadMatcherRegistration];
	}
	[self.matchers addObject:matcher];
}

- (void)prepareForVerify:(SBLOrderToken *)orderToken {
    [self verifyState:SBLTransactionManagerStateAtRest];
    self.currentOrderToken = (SBLOrderTokenInternal *)orderToken;
    self.state = SBLTransactionManagerStateVerifyInProgress;
}

- (void)verifyMethodInvokedForMock:(SBLMockObject *)mock {
    [self verifyState:SBLTransactionManagerStateVerifyInProgress];
    self.numberOfCallsDuringTransaction++;
    self.currentMock = mock;
    [self.currentMock.sblVerifyInvocation setMatchers:[NSArray arrayWithArray:self.matchers]];
}

- (SBLVerificationResult *)performVerifyNumberOfTimes:(SBLTimesMatcher *)timesMatcher {
    [self verifyState:SBLTransactionManagerStateVerifyInProgress];
    [self verifyTransactionCallCountWithLowError:SBLBadVerifyNoCallsErrorMessage highError:SBLBadVerifyTooManyCallsErrorMessage];
    SBLVerificationResult *result = nil;
	@try {
         result = [self.currentMock sblVerifyInvocationOccurredNumberOfTimes:timesMatcher orderToken:self.currentOrderToken];
	} @finally {
		[self clear];
	}
	return result;
}

- (SBLOrderTokenInternal *)createOrderToken {
    return [[SBLOrderTokenInternal alloc] init];
}

- (void)verifyTransactionCallCountWithLowError:(NSString *)lowError highError:(NSString *)highError {
    if (self.numberOfCallsDuringTransaction == 0) {
        [self throwUsage:lowError];
    } else if (self.numberOfCallsDuringTransaction > 1) {
        [self throwUsage:highError];
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
