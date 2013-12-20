#import "SBLClassMockObjectBehavior.h"

@interface SBLClassMockObjectBehavior ()

@property (nonatomic, readonly) Class mockedClass;

@end

@implementation SBLClassMockObjectBehavior

- (instancetype)initWithClass:(Class)aClass {
	if (self = [super init]) {
		_mockedClass = aClass;
	}
	return self;
}

- (NSMethodSignature *)mockObjectMethodSignatureForSelector:(SEL)aSelector {
    return [self.mockedClass instanceMethodSignatureForSelector:aSelector];
}

- (BOOL)mockObjectRespondsToSelector:(SEL)aSelector {
    return [self.mockedClass instancesRespondToSelector:aSelector];
}

- (BOOL)mockObjectIsKindOfClass:(Class)aClass {
    return [self.mockedClass isSubclassOfClass:aClass];
}

- (BOOL)mockObjectConformsToProtocol:(Protocol *)aProtocol {
    return [self.mockedClass conformsToProtocol:aProtocol];
}

@end
