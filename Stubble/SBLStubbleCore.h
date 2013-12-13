#import "SBLClassMockObject.h"
#import "SBLStubbedInvocation.h"
#import "SBLMatcher.h"

typedef enum {
    SBLStubbleCoreStateAtRest,
    SBLStubbleCoreStateOngoingWhen,
    SBLStubbleCoreStateOngoingVerify,
} SBLStubbleCoreState;

@interface SBLStubbleCore : NSObject

@property (nonatomic, readonly) SBLStubbleCoreState state;

+ (instancetype)core;

- (void)clear;

- (void)prepareForWhen;
- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock;
- (SBLStubbedInvocation *)performWhen;

- (void)prepareForVerify;
- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock;
- (void)performVerify;

- (void)addMatcher:(SBLMatcher *)matcher;

@end