#import "SBLMatcherResult.h"


@implementation SBLMatcherResult

- (instancetype)initWithMatches:(BOOL)matches {
    return [self initWithMatches:matches expectedParameters:nil actualParameters:nil];
}

- (instancetype)initWithMatches:(BOOL)matches expectedParameters:(NSString *)expectedParameters actualParameters:(NSString *)actualParameters {
    if (self = [super init]) {
        _matches = matches;
        _expectedParameters = expectedParameters;
        _actualParameters = actualParameters;
    } return self;
}

@end