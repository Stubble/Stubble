#import "SBLOngoingWhen.h"

@protocol SBLMockObject <NSObject>

@property (nonatomic, readonly) SBLOngoingWhen *currentOngoingWhen;
@property (nonatomic, readonly) NSInvocation *lastVerifyInvocation;
@property (nonatomic, readonly) NSArray *actualInvocations;

@end