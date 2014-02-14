#import "SBLMockCore.h"

// AssertMacros.h defines a legacy macro for verify
#ifdef verify
#undef verify
#endif

#define when(methodCall...) SBLWhen(methodCall)
#define verifyCalled(methodCall...) SBLVerify(methodCall)
#define verify(methodCall...) verifyCalled(methodCall)
#define verifyNever(args...) SBLVerifyNever(args)
#define verifyTimes(timesMatcher, methodCall...) SBLVerifyTimes(timesMatcher, methodCall)
#define verifyNoInteractions(mock) SBLVerifyNoInteractions(mock)
#define resetMock(mock) SBLResetMock(mock)

#define times(times) SBLTimes(times)
#define atLeast(times) SBLAtLeast(times)
#define never() SBLNever()
#define between(atLeast, atMost) SBLBetween(atLeast, atMost)

#define any(argumentType...) SBLAny(argumentType)
#define capture(captorReference) SBLCapture(captorReference)

#define mock(classOrProtocol) SBLMock(classOrProtocol)
