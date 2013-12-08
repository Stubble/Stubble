#import "SBLMock.h"
#import "SBLClassMockObject.h"

@implementation SBLMock

+ (id)mockForClass:(Class)class {
    return [[SBLClassMockObject alloc] initWithClass:class];
}

@end
