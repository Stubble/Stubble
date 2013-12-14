#import "SBLClassMockObject.h"
#import "SBLTransactionManager.h"

@interface SBLClassMockObject ()

@property (nonatomic, readonly) Class mockedClass;
@property (nonatomic, readonly) NSMutableArray *stubbedInvocations;
@property (nonatomic, readonly) NSMutableArray *actualInvocationsArray;
@property (nonatomic, readwrite) SBLInvocationRecord *verifyInvocation;

@end

@implementation SBLClassMockObject

- (id)initWithClass:(Class)class {
    _mockedClass = class;
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
		SBLStubbedInvocation *matchingWhen = nil;
		for (SBLStubbedInvocation *ongoingWhen in self.stubbedInvocations.reverseObjectEnumerator) {
			if ([ongoingWhen matchesInvocation:invocation]) {
				matchingWhen = ongoingWhen;
				break;
			}
		}
		if (matchingWhen.shouldUnboxReturnValue) {
			void *buffer = malloc([[invocation methodSignature] methodReturnLength]);
			[matchingWhen.returnValue getValue:buffer];
			[invocation setReturnValue:buffer];
		} else {
			id returnValue = matchingWhen.returnValue;
			[invocation setReturnValue:&returnValue];
		}
		[invocation invokeWithTarget:nil];
        [self.actualInvocationsArray addObject:invocation];
	}
}

- (NSArray *)actualInvocations {
    return self.actualInvocationsArray;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.mockedClass instanceMethodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [self.mockedClass instancesRespondToSelector:selector];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self.mockedClass isSubclassOfClass:aClass];
}

- (SBLStubbedInvocation *)currentStubbedInvocation {
	return [self.stubbedInvocations lastObject];
}

- (void)verifyInvocationOccurredNumberOfTimes:(int)times {
    if (times < 0){
        [NSException raise:SBLBadUsage format:SBLBadTimesProvided];
    }

    NSInteger invocationCount = 0;
    for (NSInvocation *actualInvocation in self.actualInvocations) {
        if ([self.verifyInvocation matchesInvocation:actualInvocation]) {
            invocationCount++;
        }
    }

    if (!invocationCount && times > 0){
        // TODO get the line numbers in the exception
        // TODO tell them if it was the parameters that were wrong, or if the method simply wasn't called
        // TODO tell them what the expected parameters are
        [NSException raise:SBLVerifyFailed format:@"Expected %@", NSStringFromSelector(self.verifyInvocation.selector)];
    } else if (invocationCount != times) {
        [NSException raise:SBLVerifyFailed format:SBLVerifyCalledWrongNumberOfTimes, NSStringFromSelector(self.verifyInvocation.selector), times, invocationCount];
    }
}

- (void)verifyInvocationOccurred {
    [self verifyInvocationOccurredNumberOfTimes:1];
}

@end