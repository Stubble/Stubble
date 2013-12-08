#import "STBMock.h"
#import "STBClassMockObject.h"

@implementation STBMock

+ (id)mockForClass:(Class)class {
    return [[STBClassMockObject alloc] initWithClass:class];
}

@end
