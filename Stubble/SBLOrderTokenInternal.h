#import "SBLOrderToken.h"

@interface SBLOrderTokenInternal : SBLOrderToken

@property (nonatomic) long currentCallOrder;
@property (nonatomic, readonly) NSArray *actualCallDescriptions;

- (void)addActualCallDescription:(NSString *)callDescription;

@end