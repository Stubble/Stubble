#import "SBLMatcher.h"
#import "SBLMockObject.h"
#import "SBLOrderToken.h"

typedef enum {
    SBLTransactionManagerStateAtRest,
    SBLTransactionManagerStateStubInProgress,
    SBLTransactionManagerStateVerifyInProgress,
} SBLTransactionManagerState;

@interface SBLTransactionManager : NSObject

@property (nonatomic, readonly) SBLTransactionManagerState state;

+ (instancetype)currentTransactionManager;

- (void)clear;

- (void)prepareForWhen;
- (void)whenMethodInvokedForMock:(SBLMockObject *)mock;
- (SBLStubbedInvocation *)performWhen;

- (void)prepareForVerify:(SBLOrderToken *)orderToken;
- (void)verifyMethodInvokedForMock:(SBLMockObject *)mock;
- (SBLVerificationResult *)performVerifyNumberOfTimes:(SBLTimesMatcher *)timesMatcher;

- (void)addMatcher:(SBLMatcher *)matcher;

- (SBLOrderToken *)createOrderToken;

@end