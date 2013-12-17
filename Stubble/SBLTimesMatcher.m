#import "SBLTimesMatcher.h"

@interface SBLTimesMatcher ()

@property (nonatomic) int atLeast;

@end

@implementation SBLTimesMatcher

+ (instancetype)atLeast:(int)times {
    SBLTimesMatcher *timesMatcher = [[SBLTimesMatcher alloc] init];
    [timesMatcher setAtLeast:times];
    return timesMatcher;
}

@end