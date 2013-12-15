#import "SBLStubbedInvocation.h"
#import "SBLInvocationRecord.h"

@protocol SBLMockObject <NSObject>

@property (nonatomic, readonly) SBLStubbedInvocation *currentStubbedInvocation;
@property (nonatomic, readonly) NSArray *actualInvocations;
@property (nonatomic, readonly) SBLInvocationRecord *verifyInvocation;

- (void)verifyInvocationOccurred;
- (void)verifyInvocationOccurredNumberOfTimes:(NSInteger)times;

@end