#import "SBLTransactionManager.h"
#import "SBLMatcher.h"
#import "SBLVerificationHandler.h"
#import "SBLErrors.h"

#define SBLWhen(methodCall...) ({ [SBLTransactionManager.currentTransactionManager prepareForWhen]; (void)methodCall; [SBLTransactionManager.currentTransactionManager performWhen]; })

#define SBLVerify(methodCall...) SBLVerifyTimes(SBLAtLeast(1), methodCall)
#define SBLVerifyNever(args...) SBLVerifyTimes(SBLNever(), args)
#define SBLVerifyNoInteractions(mock) ({ SBLMockObject *mockObject = mock; [mockObject verifyMockNotCalled]; })
#define SBLVerifyTimes(timesMatcher, methodCall...) ({ SBLHandleVerifyTimes(timesMatcher, methodCall); })
#define SBLHandleVerifyTimes(timesMatcher, methodCall...) ({ SBLHandleVerificationResult(SBLVerifyTimesImpl(timesMatcher, methodCall)); })
#define SBLVerifyTimesImpl(timesMatcher, methodCall...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)methodCall; [SBLTransactionManager.currentTransactionManager performVerifyNumberOfTimes:timesMatcher]; })
#define SBLHandleVerificationResult(verificationResult) ({ [SBLVerificationHandler handleVerificationResult:verificationResult inTestCase:self inFile:__FILE__ onLine:__LINE__]; })
#define SBLSingleArg(...) __VA_ARGS__

#define SBLTimes(times) ({ [SBLTimesMatcher exactly:times]; })
#define SBLAtLeast(times) ({ [SBLTimesMatcher atLeast:times]; })
#define SBLNever() ({ [SBLTimesMatcher never]; })
#define SBLBetween(atLeast, atMost) ({ [SBLTimesMatcher between:atLeast andAtMost:atMost]; })

#define SBLAny() _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wconversion\"") \
    ({ SBLMatcher *matcher = [SBLMatcher any]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; [matcher placeholder]; }) \
    _Pragma("clang diagnostic pop")

#define SBLAnyWithPlaceholder(placeholder...) ({ [SBLTransactionManager.currentTransactionManager addMatcher:[SBLMatcher any]]; placeholder; })
#define SBLAnyCGRect() SBLAnyWithPlaceholder(CGRectZero)

#define SBLCapture(captorReference) _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wconversion\"") \
    ({ SBLMatcher *matcher = [SBLMatcher captor:captorReference]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; [matcher placeholder]; }) \
    _Pragma("clang diagnostic pop")

#define SBLMock(classOrProtocol) ({ const char *typeEncoding = @encode(typeof(classOrProtocol)); \
    SBLMockObject *mock = nil; \
    if (strcmp(typeEncoding, "#") == 0) { mock = [SBLMockObject mockForClass:(id)classOrProtocol]; } \
    else if (strcmp(typeEncoding, "@") == 0) { mock = [SBLMockObject mockForProtocol:(id)classOrProtocol]; } \
    (id)mock; })