#import "SBLClassMockObject.h"
#import "SBLStubbleCore.h"

@interface SBLClassMockObject ()

@property (nonatomic) Class mockedClass;
@property (nonatomic, readwrite) SBLOngoingWhen *currentOngoingWhen;

@end

@implementation SBLClassMockObject

- (id)initWithClass:(Class)class {
    self.mockedClass = class;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	if (SBLStubbleCore.core.whenInProgress) {
		[SBLStubbleCore.core whenMethodInvokedForMock:self];
		self.currentOngoingWhen = [[SBLOngoingWhen alloc] initWithInvocation:invocation];
		NSLog(@"captured invocation %@", invocation);
	} else {
		if (self.currentOngoingWhen.shouldUnboxReturnValue) {
			void *buffer = malloc([[invocation methodSignature] methodReturnLength]);
			[self.currentOngoingWhen.returnValue getValue:buffer];
			[invocation setReturnValue:buffer];
		} else {
			id returnValue = self.currentOngoingWhen.returnValue;
			[invocation setReturnValue:&returnValue];
		}
		[invocation invokeWithTarget:nil];
	}
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

@end