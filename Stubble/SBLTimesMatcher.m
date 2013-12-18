#import "SBLTimesMatcher.h"

@interface SBLTimesMatcher ()

@property (nonatomic) int atLeast;
@property (nonatomic) int atMost;

@end

@implementation SBLTimesMatcher

- (instancetype)init {
    return [self initWithAtLeast:0 upTo:0];
}

- (instancetype)initWithAtLeast:(int)minTimes upTo:(int)maxTimes {
    if (self = [super init]){
        _atLeast = minTimes;
        _atMost = maxTimes;
    }
    return self;
}

+ (instancetype)never {
    return [[SBLTimesMatcher alloc] init];
}

+ (instancetype)exactly:(int)minTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:minTimes];
}

+ (instancetype)atLeast:(int)minTimes {
    return [[SBLTimesMatcher alloc] initWithAtLeast:minTimes upTo:INT_MAX];
}

@end