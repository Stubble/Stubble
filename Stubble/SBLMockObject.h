#import "SBLStubbedInvocation.h"
#import "SBLTimesMatcher.h"
#import "SBLVerificationResult.h"

#define SBLVerifyFailed @"SBLVerifyFailed"
#define SBLVerifyCalledWrongNumberOfTimes @"Expected %@ to be called %ld times, but was called %ld times"

@interface SBLMockObject : NSProxy

+ (instancetype)mockForClass:(Class)class;
+ (instancetype)mockForProtocol:(Protocol *)protocol;

@property (nonatomic, readonly) SBLStubbedInvocation *currentStubbedInvocation;
@property (nonatomic, readonly) NSArray *actualInvocations;
@property (nonatomic, readonly) SBLInvocationRecord *verifyInvocation;
@property (nonatomic, readonly) NSUInteger *numberOfInvocations;

- (void)verifyMockNotCalled;
- (SBLVerificationResult *)verifyInvocationOccurredNumberOfTimes:(SBLTimesMatcher *)times;

@end