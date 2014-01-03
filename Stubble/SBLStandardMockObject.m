#import "SBLStandardMockObject.h"
#import "SBLTransactionManager.h"
#import "SBLErrors.h"
#import "SBLTimesMatcher.h"
#import "SBLProtocolMockObjectBehavior.h"
#import "SBLClassMockObjectBehavior.h"

@interface SBLStandardMockObject ()

@property (nonatomic, readonly) id<SBLMockObjectBehavior> behavior;
@property (nonatomic, readonly) NSMutableArray *stubbedInvocations;
@property (nonatomic, readonly) NSMutableArray *actualInvocationsArray;
@property (nonatomic, readwrite) SBLInvocationRecord *verifyInvocation;

@end

@implementation SBLStandardMockObject

- (id)initWithClass:(Class)class {
	return [self initWithBehavior:[[SBLClassMockObjectBehavior alloc] initWithClass:class]];
}

- (id)initWithProtocol:(Protocol *)protocol {
	return [self initWithBehavior:[[SBLProtocolMockObjectBehavior alloc] initWithProtocol:protocol]];
}

- (instancetype)initWithBehavior:(id<SBLMockObjectBehavior>)behavior {
    _behavior = behavior;
	_stubbedInvocations = [NSMutableArray array];
    _actualInvocationsArray = [NSMutableArray array];
	return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	if (SBLTransactionManager.currentTransactionManager.state == SBLTransactionManagerStateStubInProgress) {
		[self.stubbedInvocations addObject:[[SBLStubbedInvocation alloc] initWithInvocation:invocation]];
		[SBLTransactionManager.currentTransactionManager whenMethodInvokedForMock:self];
	} else if (SBLTransactionManager.currentTransactionManager.state == SBLTransactionManagerStateVerifyInProgress) {
        self.verifyInvocation = [[SBLInvocationRecord alloc] initWithInvocation:invocation];
        [SBLTransactionManager.currentTransactionManager verifyMethodInvokedForMock:self];
    } else {
		// Find Matching Stub
		SBLStubbedInvocation *matchingWhen = nil;
		for (SBLStubbedInvocation *ongoingWhen in self.stubbedInvocations.reverseObjectEnumerator) {
			if ([ongoingWhen matchesInvocation:invocation]) {
				matchingWhen = ongoingWhen;
				break;
			}
		}
		
		// Perform Actions
		for (SBLInvocationActionBlock action in matchingWhen.actionBlocks) {
			action(invocation);
		}
		
		// Invoke and Record Invocation
		[invocation invokeWithTarget:nil];
        [invocation retainArguments];
        [self.actualInvocationsArray addObject:invocation];
	}
}

- (NSArray *)actualInvocations {
    return self.actualInvocationsArray;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.behavior mockObjectMethodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [self.behavior mockObjectRespondsToSelector:selector];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self.behavior mockObjectIsKindOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
	return [self.behavior mockObjectConformsToProtocol:aProtocol];
}

- (SBLStubbedInvocation *)currentStubbedInvocation {
	return [self.stubbedInvocations lastObject];
}

- (SBLVerificationResult *)verifyInvocationOccurredNumberOfTimes:(SBLTimesMatcher *)timesMatcher {
    [self validateTimesMatcherUsage:timesMatcher];

    NSInteger atLeastTimes = timesMatcher.atLeast;
    NSInteger atMostTimes = timesMatcher.atMost;
    NSInteger invocationCount = 0;
    BOOL methodWithMatchingSignatureCalled = NO;
    for (NSInvocation *actualInvocation in self.actualInvocations) {
        if ([self.verifyInvocation matchesInvocation:actualInvocation]) {
            invocationCount++;
        } else if ([actualInvocation selector] == [self.verifyInvocation selector]){
            methodWithMatchingSignatureCalled = YES;
        }
    }
	
	BOOL success = YES;
	NSString *failureMessage = nil;
	// TODO better messaging
	if (invocationCount < atLeastTimes) {
		success = NO;
		failureMessage = [NSString stringWithFormat:@"Method '%@' was not called at least %ld times", NSStringFromSelector(self.verifyInvocation.selector), (long)atLeastTimes];
	} else if (invocationCount > atMostTimes) {
		success = NO;
		failureMessage = [NSString stringWithFormat:@"Method '%@' was called more than %ld times", NSStringFromSelector(self.verifyInvocation.selector), (long)atMostTimes];
	}
	
	return [[SBLVerificationResult alloc] initWithSuccess:success failureDescription:failureMessage];
}

- (void)validateTimesMatcherUsage:(SBLTimesMatcher *)timesMatcher {
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