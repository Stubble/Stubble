#import "STBOngoingWhen.h"
#import "STBStubbleCore.h"

@implementation STBOngoingWhen


- (STBOngoingWhen *)thenReturn:(id)returnValue {
    [STBStubbleCore.core returnValueSetForCurrentWhen:returnValue];

    // TODO eventually self can be used for some type of chaining
    return self;
}

@end