#import "SBLMockObject.h"
#import "SBLTransactionManager.h"
#import "SBLErrors.h"
#import "SBLProtocolMockObjectBehavior.h"
#import "SBLClassMockObjectBehavior.h"
#import "SBLInvocationMatchResult.h"
#import "SBLOrderTokenInternal.h"
#import "SBLMock.h"

@interface SBLMockObject ()

@property (nonatomic, readonly) id<SBLMockObjectBehavior> sblBehavior;
@property (nonatomic, readonly) NSMutableArray *sblStubbedInvocations;
@property (nonatomic, readonly) NSMutableArray *sblActualInvocations;
@property (nonatomic, readwrite) SBLInvocationRecord *sblVerifyInvocation;
@property (nonatomic, readwrite) NSUInteger *sblNumberOfInvocations;

@end

@implementation SBLMockObject

+ (id)sblMockForClass:(Class)class {
    return [[SBLMockObject alloc] initWithBehavior:[[SBLClassMockObjectBehavior alloc] initWithClass:class]];
}

+ (id)sblMockForProtocol:(Protocol *)protocol {
    return [[SBLMockObject alloc] initWithBehavior:[[SBLProtocolMockObjectBehavior alloc] initWithProtocol:protocol]];
}

- (instancetype)initWithBehavior:(id<SBLMockObjectBehavior>)behavior {
    _sblBehavior = behavior;
	_sblStubbedInvocations = [NSMutableArray array];
    _sblActualInvocations = [NSMutableArray array];
    _sblNumberOfInvocations = 0;
	return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [self.sblBehavior mockObjectMethodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)selector {
	return [self.sblBehavior mockObjectRespondsToSelector:selector];
}

- (BOOL)isKindOfClass:(Class)aClass {
	return [self.sblBehavior mockObjectIsKindOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
	return [self.sblBehavior mockObjectConformsToProtocol:aProtocol];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    self.sblNumberOfInvocations++;

	if (SBLTransactionManager.currentTransactionManager.state == SBLTransactionManagerStateStubInProgress) {
		[self.sblStubbedInvocations addObject:[[SBLStubbedInvocation alloc] initWithInvocation:invocation]];
		[SBLTransactionManager.currentTransactionManager whenMethodInvokedForMock:self];
	} else if (SBLTransactionManager.currentTransactionManager.state == SBLTransactionManagerStateVerifyInProgress) {
        self.sblVerifyInvocation = [[SBLInvocationRecord alloc] initWithInvocation:invocation];
        [SBLTransactionManager.currentTransactionManager verifyMethodInvokedForMock:self];
    } else {
		// Record Invocation
		SBLInvocationRecord *invocationRecord = [[SBLInvocationRecord alloc] initWithInvocation:invocation];
        [self.sblActualInvocations addObject:invocationRecord];
		
		// Find Matching Stub
		SBLStubbedInvocation *matchingWhen = nil;
		for (SBLStubbedInvocation *ongoingWhen in self.sblStubbedInvocations.reverseObjectEnumerator) {
            SBLInvocationMatchResult *invocationMatchResult = [ongoingWhen matchResultForInvocation:invocationRecord];
			if (invocationMatchResult.invocationMatches) {
				matchingWhen = ongoingWhen;
				break;
			}
		}
		
		// Perform Actions
		for (SBLInvocationActionBlock action in matchingWhen.actionBlocks) {
			action(invocation);
		}
		
		// Invoke Invocation
		[invocation invokeWithTarget:nil];
	}
}

- (void)sblResetMock {
	[self.sblActualInvocations removeAllObjects];
	[self.sblStubbedInvocations removeAllObjects];
}

- (SBLVerificationResult *)sblVerifyMockNotCalled {
    if ([self sblNumberOfInvocations]) {
        return [[SBLVerificationResult alloc] initWithSuccess:NO failureDescription:SBLMethodWasCalledUnexpectedly];
    }
    return [[SBLVerificationResult alloc] initWithSuccess:YES failureDescription:nil];
}

- (SBLStubbedInvocation *)sblCurrentStubbedInvocation {
	return [self.sblStubbedInvocations lastObject];
}

- (SBLVerificationResult *)sblVerifyInvocationOccurredNumberOfTimes:(SBLTimesMatcher *)timesMatcher orderToken:(SBLOrderTokenInternal *)orderToken {
	[self sblValidateTimesMatcherUsage:timesMatcher];

    NSInteger atLeastTimes = timesMatcher.atLeast;
    NSInteger atMostTimes = timesMatcher.atMost;
    NSInteger invocationCount = 0;
    long largestCallOrder = 0L;
    long smallestCallOrder = LONG_MAX;
    NSMutableArray *mismatchedMethodCalls = [NSMutableArray array];
    for (SBLInvocationRecord *actualInvocation in self.sblActualInvocations) {
        SBLInvocationMatchResult *invocationMatchResult = [self.sblVerifyInvocation matchResultForInvocation:actualInvocation];
        if (invocationMatchResult.invocationMatches) {
            largestCallOrder = MAX(actualInvocation.callOrder, largestCallOrder);
            smallestCallOrder = MIN(actualInvocation.callOrder, smallestCallOrder);
            invocationCount++;
        } else {
            if ([invocationMatchResult.argumentMatcherResults count]) {
                [mismatchedMethodCalls addObject:invocationMatchResult.argumentMatcherResults];
            }
        }
    }

    NSString *expectedString;
    if (atMostTimes == 0) {
        expectedString = @"(expected no calls)";
    } else if (atMostTimes == NSIntegerMax) {
        expectedString = [NSString stringWithFormat:@"(expected at least %ld)", (long)atLeastTimes];
    } else if (atMostTimes == atLeastTimes) {
        expectedString = [NSString stringWithFormat:@"(expected exactly %ld)", (long)atLeastTimes];
    } else {
        expectedString = [NSString stringWithFormat:@"(expected between %ld and %ld)", (long)atLeastTimes, (long)atMostTimes];
    }
    NSString *callDescription = [NSString stringWithFormat:@"%@ %@", NSStringFromSelector(self.sblVerifyInvocation.selector), expectedString];
    [orderToken addActualCallDescription:callDescription];

    BOOL correctOrder = orderToken.currentCallOrder < smallestCallOrder;
    orderToken.currentCallOrder = largestCallOrder;

	BOOL correctCallCount = atLeastTimes <= invocationCount && invocationCount <= atMostTimes;
	NSString *failureMessage = nil;
    if (!correctCallCount) {
        NSString *countString = invocationCount == 1 ? @"1 time" : [NSString stringWithFormat:@"%ld times", (long)invocationCount];
        NSString *actualString = [NSString stringWithFormat:@"Method '%@' was called %@ ", NSStringFromSelector(self.sblVerifyInvocation.selector), countString];

        failureMessage = [actualString stringByAppendingString:expectedString];

        if ([mismatchedMethodCalls count]) {
            failureMessage = [self buildMismatchedArgumentsMessageWithArgMatcherResults:mismatchedMethodCalls[0]];
        }
    } else if (!correctOrder) {
        NSString *expectedOrder = [orderToken.actualCallDescriptions componentsJoinedByString:@", "];
        failureMessage = [NSString stringWithFormat:@"Method '%@' was called out of order.  Expected (%@)", NSStringFromSelector(self.sblVerifyInvocation.selector), expectedOrder];
    }
	return [[SBLVerificationResult alloc] initWithSuccess:correctCallCount && correctOrder failureDescription:failureMessage];
}

- (NSString *)buildMismatchedArgumentsMessageWithArgMatcherResults:(NSArray *)argMatcherResults {
    NSMutableArray *expectedArguments = [NSMutableArray array];
    NSMutableArray *actualArguments = [NSMutableArray array];
    for (SBLArgumentMatcherResult *argumentMatcherResult in argMatcherResults) {
        if (argumentMatcherResult.expectedArgumentStringValue) {
            [expectedArguments addObject:argumentMatcherResult.expectedArgumentStringValue];
        } else {
            [expectedArguments addObject:@"unknown type"];
        }
    }
    for (SBLArgumentMatcherResult *argumentMatcherResult in argMatcherResults) {
        if (argumentMatcherResult.actualArgumentStringValue) {
            [actualArguments addObject:argumentMatcherResult.actualArgumentStringValue];
        } else {
            [actualArguments addObject:@"unknown type"];
        }
    }
    NSString *differingArgumentsMessage = @"Method '%@' was called, but with differing arguments. Expected: %@ \rActual: %@";
    return [NSString stringWithFormat:differingArgumentsMessage, NSStringFromSelector(self.sblVerifyInvocation.selector), expectedArguments, actualArguments];
}

- (void)sblValidateTimesMatcherUsage:(SBLTimesMatcher *)timesMatcher {
    if (timesMatcher.atMost == NSIntegerMax && timesMatcher.atLeast < 1) {
        [NSException raise:SBLBadUsage format:SBLBadAtLeastTimesProvided];
    } else if (timesMatcher.atLeast < 0 || timesMatcher.atMost < 0) {
        [NSException raise:SBLBadUsage format:SBLBadTimesProvided];
    } else if (timesMatcher.atLeast > timesMatcher.atMost || timesMatcher.atMost < timesMatcher.atLeast) {
        [NSException raise:SBLBadUsage format:SBLAtLeastCannotBeGreaterThanAtMost];
    } else if (timesMatcher.atMost == INT_MAX && timesMatcher.atLeast < 1) {
        [NSException raise:SBLBadUsage format:SBLBadAtLeastTimesProvided];
    }
}

@end