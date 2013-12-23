#import "SBLClassMockObject.h"
#import "SBLStubbedInvocation.h"
#import "SBLMatcher.h"

@class SBLTimesMatcher;

typedef void(^InvokeMethodBlock)();

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
- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock;
- (SBLStubbedInvocation *)performWhen;

- (void)invokeVerifyMethodForObjectInBlock:(InvokeMethodBlock)block times:(SBLTimesMatcher *)timesMatcher;
- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock;

- (void)addMatcher:(SBLMatcher *)matcher;

@end