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

+ (instancetype)never {
    return [[SBLTimesMatcher alloc] init];
}

+ (instancetype)exactly:(NSInteger)minTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:minTimes];
}

+ (instancetype)atLeast:(NSInteger)minTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:NSIntegerMax];
}

+ (instancetype)between:(int)minTimes andAtMost:(int)maxTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:maxTimes];
}

@end