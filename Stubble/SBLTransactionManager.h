#import "SBLClassMockObject.h"
#import "SBLStubbedInvocation.h"
#import "SBLMatcher.h"

typedef enum {
    SBLTransactionManagerStateAtRest,
    SBLTransactionManagerStateStubInProgress,
    SBLTransactionManagerStateVerifyInProgress,
} SBLTransactionManagerState;

#define SBLBadWhenErrorMessage @"called WHEN without specifying a method call on a mock"
#define SBLBadVerifyErrorMessage @"called VERIFY without specifying a method call on a mock"
#define SBLBadUsage @"SBLBadUsage"
#define SBLBadTimesProvided @"Number of times must be 0 or more"

@interface SBLTransactionManager : NSObject

@property (nonatomic, readonly) SBLTransactionManagerState state;

+ (instancetype)currentTransactionManager;

- (void)clear;

- (void)prepareForWhen;
- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock;
- (SBLStubbedInvocation *)performWhen;

- (void)prepareForVerify;
- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock;
- (void)performVerify;
- (void)performVerifyNumberOfTimes:(int)times;

- (void)addMatcher:(SBLMatcher *)matcher;

@end