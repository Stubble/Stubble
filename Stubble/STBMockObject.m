#import "STBMockObject.h"
#import "STBClassMockObject.h"

@implementation STBMockObject

+ (id)mockForClass:(Class)class {
    return [[STBClassMockObject alloc] initWithClass:class];
}

@end
