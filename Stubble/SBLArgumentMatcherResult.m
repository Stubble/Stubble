#import "SBLArgumentMatcherResult.h"


@implementation SBLArgumentMatcherResult

- (instancetype)initWithMatches:(BOOL)matches {
    return [self initWithMatches:matches expectedArgument:nil actualArgument:nil];
}

- (instancetype)initWithMatches:(BOOL)matches expectedArgument:(NSString *)expectedArgument actualArgument:(NSString *)actualArgument {
    if (self = [super init]) {
        _matches = matches;
        _expectedArgumentStringValue = expectedArgument;
        _actualArgumentStringValue = actualArgument;
    } return self;
}

@end