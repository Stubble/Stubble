#import "STBClassMockObject.h"
#import "STBStubbleCore.h"

@interface STBClassMockObject ()

@property(nonatomic) Class mockedClass;
@property(nonatomic) NSInvocation *currentWhenInvocation;

@end

@implementation STBClassMockObject

- (id)initWithClass:(Class)class {
    self.mockedClass = class;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [STBStubbleCore.core whenMethodInvokedForMock:self];
    self.currentWhenInvocation = invocation;
    NSLog(@"mock got invocation %@", invocation);
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

- (void)setReturnValueForCurrentWhen:(id)value {
    // TODO save that value for later return
    // TODO verify that it makes sense for the current invocation
}


@end