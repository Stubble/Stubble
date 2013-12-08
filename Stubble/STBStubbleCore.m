#import "STBStubbleCore.h"

@implementation STBStubbleCore

+ (void)prepareForWhen {
    // TODO: set a flag that mocks can read telling them that the next call is actually a stub setup
}

+ (id)performWhen {
    // TODO clear the flag?  We could also do that in the mock itself.
    return nil;
}

- (id)thenReturn:(id)returnValue {
    // TODO this actually probaly belongs on a different speciallized interface that will be returned from the WHEN macro.  Probably from the performWhen method.
    return nil;
}

@end