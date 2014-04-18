#import "SBLTimesMatcher.h"

@interface SBLTimesMatcher ()

@property (nonatomic) NSInteger atLeast;
@property (nonatomic) NSInteger atMost;

@end

@implementation SBLTimesMatcher

- (instancetype)init {
    return [self initWithAtLeast:0 upTo:0];
}

- (instancetype)initWithAtLeast:(NSInteger)minTimes upTo:(NSInteger)maxTimes {
    if (self = [super init]) {
        _atLeast = minTimes;
        _atMost = maxTimes;
    }
    return self;
}

- (NSString *)formattedTimes {
    NSString *formattedTimes;
    if (self.atMost == 0) {
        formattedTimes = @"no calls";
    } else if (self.atMost == NSIntegerMax) {
        formattedTimes = [NSString stringWithFormat:@"at least %ld", (long)self.atLeast];
    } else if (self.atMost == self.atLeast) {
        formattedTimes = [NSString stringWithFormat:@"exactly %ld", (long)self.atLeast];
    } else {
        formattedTimes = [NSString stringWithFormat:@"between %ld and %ld", (long)self.atLeast, (long)self.atMost];
    }
    return formattedTimes;
}

+ (instancetype)never {
    return [[SBLTimesMatcher alloc] init];
}

+ (instancetype)exactly:(NSInteger)times {
    return [[SBLTimesMatcher alloc] initWithAtLeast:times upTo:times];
}

+ (instancetype)atLeast:(NSInteger)minTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:NSIntegerMax];
}

+ (instancetype)between:(NSInteger)minTimes andAtMost:(NSInteger)maxTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:maxTimes];
}

@end