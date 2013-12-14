#import "SBLStubbedInvocation.h"
#import "SBLInvocationRecord.h"

@protocol SBLMockObject <NSObject>

@property (nonatomic, readonly) SBLStubbedInvocation *currentStubbedInvocation;
@property (nonatomic, readonly) NSArray *actualInvocations;

- (void)verifyInvocationOccurred;
- (void)verifyInvocationOccurredNumberOfTimes:(NSUInteger *)times;

@end