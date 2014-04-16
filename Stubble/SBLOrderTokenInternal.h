#import "SBLOrderToken.h"
#import "SBLInvocationRecord.h"

@interface SBLOrderTokenInternal : SBLOrderToken

@property (nonatomic) long currentCallOrder;
@property (nonatomic, readonly) NSArray *expectedCallDescriptions;
@property (nonatomic, readonly) NSArray *actualCalls;

- (void)addExpectedCallDescription:(NSString *)callDescription;
- (void)addActualCall:(SBLInvocationRecord *)actualCall;

@end