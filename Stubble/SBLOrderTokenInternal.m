#import "SBLOrderTokenInternal.h"

@interface SBLOrderTokenInternal()

@property (nonatomic, readonly) NSMutableArray *descriptions;

@end

@implementation SBLOrderTokenInternal

- (instancetype)init {
    self = [super init];
    _descriptions = [NSMutableArray array];
    return self;
}

- (void)addActualCallDescription:(NSString *)callDescription {
    [self.descriptions addObject:callDescription];
}

- (NSArray *)actualCallDescriptions {
    return self.descriptions;
}

@end