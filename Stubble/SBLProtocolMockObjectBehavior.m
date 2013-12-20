#import "SBLProtocolMockObjectBehavior.h"
#import <objc/runtime.h>

@interface SBLProtocolMockObjectBehavior ()

@property (nonatomic, readonly) Protocol *mockedProtocol;

@end

@implementation SBLProtocolMockObjectBehavior

- (instancetype)initWithProtocol:(Protocol *)aProtocol {
	if (self = [super init]) {
		_mockedProtocol = aProtocol;
	}
	return self;
}

- (NSMethodSignature *)mockObjectMethodSignatureForSelector:(SEL)aSelector {
	struct objc_method_description description = [self methodDescriptionForSelector:aSelector];
	return [NSMethodSignature signatureWithObjCTypes:description.types];
}

- (BOOL)mockObjectRespondsToSelector:(SEL)aSelector {
    return [self methodDescriptionForSelector:aSelector].name != NULL;
}

- (struct objc_method_description)methodDescriptionForSelector:(SEL)aSelector {
	struct objc_method_description description;
	description = protocol_getMethodDescription(self.mockedProtocol, aSelector, NO, YES);
	if (description.name == NULL) {
		description = protocol_getMethodDescription(self.mockedProtocol, aSelector, YES, YES);
	}
	return description;
}

- (BOOL)mockObjectIsKindOfClass:(Class)aClass {
    return NO;
}

- (BOOL)mockObjectConformsToProtocol:(Protocol *)aProtocol {
    return protocol_conformsToProtocol(self.mockedProtocol, aProtocol);
}

@end
