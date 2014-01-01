#import "SBLStubbedInvocation.h"
#import "SBLInvocationRecord.h"
#import "SBLTimesMatcher.h"
#import "SBLVerificationResult.h"

#define SBLVerifyFailed @"SBLVerifyFailed"
#define SBLVerifyCalledWrongNumberOfTimes @"Expected %@ to be called %ld times, but was called %ld times"

@protocol SBLMockObject <NSObject>

@property (nonatomic, readonly) SBLStubbedInvocation *currentStubbedInvocation;
@property (nonatomic, readonly) NSArray *actualInvocations;
@property (nonatomic, readonly) SBLInvocationRecord *verifyInvocation;

- (SBLVerificationResult *)verifyInvocationOccurredNumberOfTimes:(SBLTimesMatcher *)times;

@end