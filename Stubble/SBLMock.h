#import "SBLMockCore.h"

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

@interface SBLMock : NSObject

+ (id)mockForClass:(Class)class;
+ (id)mockForProtocol:(Protocol *)protocol;

@end
