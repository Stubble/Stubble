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

- (SBLStubbedInvocation *)invokeWhenMethodForObjectInBlock:(InvokeMethodBlock)block;
- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock;

- (void)invokeVerifyMethodForObjectInBlock:(InvokeMethodBlock)block times:(SBLTimesMatcher *)timesMatcher;
- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock;

- (void)addMatcher:(SBLMatcher *)matcher;

@end