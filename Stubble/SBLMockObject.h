#import "SBLStubbedInvocation.h"
#import "SBLInvocationRecord.h"

@protocol SBLMockObject <NSObject>

@property (nonatomic, readonly) SBLStubbedInvocation *currentStubbedInvocation;
@property (nonatomic, readonly) SBLInvocationRecord *lastVerifyInvocation;
@property (nonatomic, readonly) NSArray *actualInvocations;

- (void)verifyLastInvocation;

@end