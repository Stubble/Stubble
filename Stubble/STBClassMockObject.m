#import "STBClassMockObject.h"
#import "STBStubbleCore.h"

@interface STBClassMockObject ()

@property (nonatomic) Class mockedClass;
@property (nonatomic, readwrite) STBOngoingWhen *currentOngoingWhen;

@end

@implementation STBClassMockObject

- (id)initWithClass:(Class)class {
    self.mockedClass = class;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	if (STBStubbleCore.core.whenInProgress) {
		[STBStubbleCore.core whenMethodInvokedForMock:self];
		self.currentOngoingWhen = [[STBOngoingWhen alloc] initWithInvocation:invocation];
		NSLog(@"captured invocation %@", invocation);
	} else {
		id returnValue = self.currentOngoingWhen.returnValue;
		[invocation setReturnValue:&returnValue];
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