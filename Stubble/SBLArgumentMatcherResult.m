#import "SBLArgumentMatcherResult.h"

@implementation SBLArgumentMatcherResult

#define UNKNOWN_TYPE @"unknown type"

- (instancetype)initWithMatches:(BOOL)matches expectedArgument:(NSString *)expectedArgument actualArgument:(NSString *)actualArgument {
    if (self = [super init]) {
        _matches = matches;
        _expectedArgumentStringValue = [self.class stringFromArgumentString:expectedArgument];
        _actualArgumentStringValue = [self.class stringFromArgumentString:actualArgument];
    }
    return self;
}

+ (NSString *)stringFromArgumentString:(NSString *)argument {
    return argument ?: UNKNOWN_TYPE;
}

@end