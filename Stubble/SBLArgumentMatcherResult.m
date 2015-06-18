#import "SBLArgumentMatcherResult.h"

@implementation SBLArgumentMatcherResult

- (instancetype)initWithMatches:(BOOL)matches expectedArgumentForLogging:(NSObject *)expectedArgument actualArgumentForLogging:(NSObject *)actualArgument {
    if (self = [super init]) {
        _matches = matches;
        _expectedArgumentStringValue = expectedArgument.debugDescription;
        _actualArgumentStringValue = actualArgument.debugDescription;
    }
    return self;
}

@end