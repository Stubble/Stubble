#import "STBClassMockObject.h"

@interface STBClassMockObject ()

@property(nonatomic) Class mockedClass;

@end

@implementation STBClassMockObject

- (id)initWithClass:(Class)class {
    self.mockedClass = class;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
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


@end