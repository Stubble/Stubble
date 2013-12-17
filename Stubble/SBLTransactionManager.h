#import "SBLClassMockObject.h"
#import "SBLStubbedInvocation.h"
#import "SBLMatcher.h"

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

- (void)prepareForVerify;
- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock;
//- (void)performVerify;
- (void)performVerifyNumberOfTimes:(int)times;

- (void)addMatcher:(SBLMatcher *)matcher;

@end