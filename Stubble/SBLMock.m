#import "SBLMock.h"
#import "SBLClassMockObject.h"

@implementation SBLMock

+ (id)mockForClass:(Class)class {
    return [[SBLClassMockObject alloc] initWithClass:class];
}

+ (id)mockForProtocol:(Protocol *)protocol {
    return [[SBLClassMockObject alloc] initWithProtocol:protocol];
}

@end
