#import "SBLInvocationMatchResult.h"


@implementation SBLInvocationMatchResult

- (instancetype)initWithInvocationMatches:(BOOL)invocationMatches argumentMatcherResults:(NSArray *)argumentMatcherResults {
    if (self = [super init]) {
        _invocationMatches = invocationMatches;
        _argumentMatcherResults = argumentMatcherResults;
    } return self;
}

@end