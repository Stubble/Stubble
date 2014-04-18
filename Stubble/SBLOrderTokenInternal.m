#import "SBLOrderTokenInternal.h"
#import "SBLInvocationRecord.h"

@interface SBLOrderTokenInternal()

@property (nonatomic, readonly) NSMutableArray *expectedDescriptionArray;
@property (nonatomic, readonly) NSMutableArray *actualCallArray;

@end

@implementation SBLOrderTokenInternal

- (instancetype)init {
    self = [super init];
    _expectedDescriptionArray = [NSMutableArray array];
    _actualCallArray = [NSMutableArray array];
    return self;
}

- (void)addExpectedCallDescription:(NSString *)callDescription {
    [self.expectedDescriptionArray addObject:callDescription];
}

- (NSArray *)expectedCallDescriptions {
    return self.expectedDescriptionArray;
}

- (void)addActualCall:(SBLInvocationRecord *)actualCall {
    [self.actualCallArray addObject:actualCall];
}

- (NSArray *)actualCalls {
    return [self.actualCallArray sortedArrayUsingComparator:^NSComparisonResult(SBLInvocationRecord *first, SBLInvocationRecord *second) {
        return [@(first.callOrder) compare:@(second.callOrder)];
    }];
}

@end