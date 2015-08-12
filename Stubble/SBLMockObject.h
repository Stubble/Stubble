#import "SBLStubbedInvocation.h"
#import "SBLTimesMatcher.h"
#import "SBLVerificationResult.h"
#import "SBLOrderTokenInternal.h"

@interface SBLMockObject : NSProxy

+ (instancetype)sblMockForClass:(Class)class;
+ (instancetype)sblDynamicMockForClass:(Class)class;
+ (instancetype)sblMockForProtocol:(Protocol *)protocol;

@property (nonatomic, readonly) SBLStubbedInvocation *sblCurrentStubbedInvocation;
@property (nonatomic, readonly) SBLInvocationRecord *sblVerifyInvocation;

- (SBLVerificationResult *)sblVerifyMockNotCalled;

- (SBLVerificationResult *)sblVerifyInvocationOccurredNumberOfTimes:(SBLTimesMatcher *)times orderToken:(SBLOrderTokenInternal *)orderToken;
- (void)sblResetMock;

@end