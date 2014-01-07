#import "SBLMockCore.h"

// AssertMacros.h defines a legacy macro for verify
#ifdef verify
#undef verify
#endif

#define when(methodCall...) SBLWhen(methodCall)
#define verify(methodCall...) SBLVerify(methodCall)
#define verifyNever(args...) SBLVerifyNever(args)
#define verifyTimes(timesMatcher, methodCall...) SBLVerifyTimes(timesMatcher, methodCall)

#define times(times) SBLTimes(times)
#define atLeast(times) SBLAtLeast(times)
#define never() SBLNever()
#define between(atLeast, atMost) SBLBetween(atLeast, atMost)

#define any() SBLAny()
#define anyWithPlaceholder(placeholder...) SBLAnyWithPlaceholder(placeholder)
#define anyCGRect() SBLAnyCGRect()
#define capture(captorReference) SBLCapture(captorReference)

#define mock(classOrProtocol) SBLMock(classOrProtocol)
