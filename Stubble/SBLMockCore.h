#import "SBLTransactionManager.h"
#import "SBLMatcher.h"
#import "SBLVerificationHandler.h"
#import "SBLErrors.h"
#import "SBLMockObject.h"

#define SBLWhen(methodCall...) ({ [SBLTransactionManager.currentTransactionManager prepareForWhen]; (void)methodCall; [SBLTransactionManager.currentTransactionManager performWhen]; })

#define SBLVerify(methodCall...) SBLVerifyTimes(SBLAtLeast(1), methodCall)
#define SBLVerifyNever(args...) SBLVerifyTimes(SBLNever(), args)
#define SBLVerifyNoInteractions(mock) ({ SBLHandleVerificationResult(SBLVerifyNoInteractionsImpl(mock)); })
#define SBLVerifyNoInteractionsImpl(mock) ({ [(SBLMockObject *)mock sblVerifyMockNotCalled]; })
#define SBLVerifyTimes(timesMatcher, methodCall...) ({ SBLHandleVerifyTimes(timesMatcher, methodCall); })
#define SBLHandleVerifyTimes(timesMatcher, methodCall...) ({ SBLHandleVerificationResult(SBLVerifyTimesImpl(timesMatcher, methodCall)); })
#define SBLVerifyTimesImpl(timesMatcher, methodCall...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)methodCall; [SBLTransactionManager.currentTransactionManager performVerifyNumberOfTimes:timesMatcher]; })
#define SBLHandleVerificationResult(verificationResult) ({ [SBLVerificationHandler handleVerificationResult:verificationResult inTestCase:self inFile:__FILE__ onLine:__LINE__]; })
#define SBLResetMock(mock) ([(SBLMockObject *)mock sblResetMock])

#define SBLTimes(times) ({ [SBLTimesMatcher exactly:times]; })
#define SBLAtLeast(times) ({ [SBLTimesMatcher atLeast:times]; })
#define SBLNever() ({ [SBLTimesMatcher never]; })
#define SBLBetween(atLeast, atMost) ({ [SBLTimesMatcher between:atLeast andAtMost:atMost]; })

#define __SBLNumberOfArgs(unused, _1, VAL, ...) VAL
#define SBLNumberOfArgs(...) __SBLNumberOfArgs(unused, ## __VA_ARGS__, 1, 0)

#define SBLAny(...) _SBLAny(SBLNumberOfArgs(__VA_ARGS__), __VA_ARGS__)
#define _SBLAny(ARGC, ARGS...) __SBLAny(ARGC, ARGS)
#define __SBLAny(ARGC, ARGS...) SBLAny_ ## ARGC (ARGS)
#define SBLAny_0(argumentType...) ({ SBLMatcher *matcher = [SBLMatcher any]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; [matcher placeholder]; })
#define SBLAny_1(argumentType...) ({ SBLMatcher *matcher = [SBLMatcher any]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; NSValue *placeholderValue = [matcher placeholderWithType:@encode(argumentType)]; argumentType placeholder; [placeholderValue getValue:&placeholder]; placeholder; })

#define SBLCapture(captorReference) ({ SBLMatcher *matcher = [SBLMatcher captor:captorReference]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; NSValue *placeholderValue = [matcher placeholderWithType:@encode(typeof(*(captorReference)))]; typeof(*(captorReference)) placeholder; [placeholderValue getValue:&placeholder]; placeholder; })
//#define SBLCapture(captorReference) ({ SBLMatcher *matcher = [SBLMatcher captor:captorReference]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; NSValue *placeholderValue = [matcher placeholderWithType:@encode(typeof(*(captorReference)))]; void *pointer; [placeholderValue getValue:&pointer]; typeof(*(captorReference)) placeholder = pointer; placeholder; })


#define SBLMock(classOrProtocol) ({ const char *typeEncoding = @encode(typeof(classOrProtocol)); \
    SBLMockObject *mock = nil; \
    if (strcmp(typeEncoding, "#") == 0) { mock = [SBLMockObject sblMockForClass:(id)classOrProtocol]; } \
    else if (strcmp(typeEncoding, "@") == 0) { mock = [SBLMockObject sblMockForProtocol:(id)classOrProtocol]; } \
    (id)mock; })