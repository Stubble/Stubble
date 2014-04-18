#import "SBLMockCore.h"

// AssertMacros.h defines a legacy macro for verify
#ifdef verify
#undef verify
#endif

#define when(methodCall...) SBLWhen(methodCall)
#define verifyCalled(methodCall...) SBLVerify(methodCall)
#define verify(methodCall...) verifyCalled(methodCall)
#define verifyNever(methodCall...) SBLVerifyNever(methodCall)
#define verifyTimes(timesMatcher, methodCall...) SBLVerifyTimes(timesMatcher, methodCall)
#define verifyInOrder(orderToken, methodCall...) SBLVerifyInOrder(orderToken, methodCall)
#define verifyTimesInOrder(timesMatcher, orderToken, methodCall...) SBLVerifyTimesInOrder(timesMatcher, orderToken, methodCall)
#define verifyNoInteractions(mock) SBLVerifyNoInteractions(mock)
#define resetMock(mock) SBLResetMock(mock)

#define times(times) SBLTimes(times)
#define atLeast(times) SBLAtLeast(times)
#define never() SBLNever()
#define once() SBLOnce()
#define atLeastOnce() SBLAtLeastOnce()
#define between(atLeast, atMost) SBLBetween(atLeast, atMost)

#define any(argumentType...) SBLAny(argumentType)
#define capture(captorReference) SBLCapture(captorReference)

#define mock(classOrProtocol) SBLMock(classOrProtocol)
#define orderToken() SBLOrderToken()