#import "SBLStubbedInvocation.h"
#import "SBLTimesMatcher.h"
#import "SBLVerificationResult.h"

@interface SBLMockObject : NSProxy

+ (instancetype)sblMockForClass:(Class)class;
+ (instancetype)sblMockForProtocol:(Protocol *)protocol;

@property (nonatomic, readonly) SBLStubbedInvocation *sblCurrentStubbedInvocation;
@property (nonatomic, readonly) SBLInvocationRecord *sblVerifyInvocation;
@property (nonatomic, readonly) NSUInteger *sblNumberOfInvocations;

- (SBLVerificationResult *)sblVerifyMockNotCalled;
- (SBLVerificationResult *)sblVerifyInvocationOccurredNumberOfTimes:(SBLTimesMatcher *)times;
- (void)sblResetMock;

@end