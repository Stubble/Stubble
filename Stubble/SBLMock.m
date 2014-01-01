#import "SBLMock.h"
#import "SBLStandardMockObject.h"

@implementation SBLMock

+ (id)mockForClass:(Class)class {
    return [[SBLStandardMockObject alloc] initWithClass:class];
}

+ (id)mockForProtocol:(Protocol *)protocol {
    return [[SBLStandardMockObject alloc] initWithProtocol:protocol];
}

@end
