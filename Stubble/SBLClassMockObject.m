#import "SBLClassMockObject.h"
#import "SBLStubbleCore.h"

@interface SBLClassMockObject ()

@property (nonatomic, readonly) Class mockedClass;
@property (nonatomic, readonly) NSMutableArray *ongoingWhens;
@property (nonatomic, readonly) NSMutableArray *actualInvocationsArray;
@property (nonatomic) NSInvocation *lastVerifyInvocation;

@end

@implementation SBLClassMockObject

- (id)initWithClass:(Class)class {
    _mockedClass = class;
	_ongoingWhens = [NSMutableArray array];
    _actualInvocationsArray = [NSMutableArray array];
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	if (SBLStubbleCore.core.state == SBLStubbleCoreStateOngoingWhen) {
		[SBLStubbleCore.core whenMethodInvokedForMock:self];
		[self.ongoingWhens addObject:[[SBLOngoingWhen alloc] initWithInvocation:invocation]];
	} else if (SBLStubbleCore.core.state == SBLStubbleCoreStateOngoingVerify) {
        [SBLStubbleCore.core verifyMethodInvokedForMock:self];
        self.lastVerifyInvocation = invocation;
    } else {
		SBLOngoingWhen *matchingWhen = nil;
		for (SBLOngoingWhen *ongoingWhen in self.ongoingWhens.reverseObjectEnumerator) {
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

- (SBLOngoingWhen *)currentOngoingWhen {
	return [self.ongoingWhens lastObject];
}

@end