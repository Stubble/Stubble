#import "SBLTransactionManager.h"
#import "SBLTimesMatcher.h"

#define WHEN(args...) ({ [SBLTransactionManager.currentTransactionManager invokeWhenMethodForObjectInBlock:^(){ (void)args; }]; })
#define VERIFY(args) VERIFY_TIMES(times(1), args)
#define times(times) ({ [SBLTimesMatcher exactly:times]; })
#define atLeast(times) ({ [SBLTimesMatcher atLeast:times]; })
#define never() ({ [SBLTimesMatcher never]; })
// TODO: Want this to also be VERIFY, not VERIFY_TIMES...
#define VERIFY_TIMES(timesMatcher, args...)  ({ [SBLTransactionManager.currentTransactionManager invokeVerifyMethodForObjectInBlock:^(){ (void)args; } times:timesMatcher]; })
#define VERIFY_NEVER(args) VERIFY_TIMES(never(), args)

//#define any() _Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wconversion\"") \
//({ SBLMatcher *matcher = [SBLMatcher any]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; (__bridge void *)matcher; }) \
//_Pragma ("clang diagnostic pop") \

#define any() _Pragma("clang diagnostic push") \
	_Pragma("clang diagnostic ignored \"-Wconversion\"") \
	 ({ SBLMatcher *matcher = [SBLMatcher any]; [SBLTransactionManager.currentTransactionManager addMatcher:matcher]; [matcher placeholder]; }) \
	_Pragma("clang diagnostic pop")

#define anyObjectReference(...) anyWithPlaceholder(&@"placeholder")
#define anyWithPlaceholder(...) ({ [SBLTransactionManager.currentTransactionManager addMatcher:[SBLMatcher any]]; __VA_ARGS__; })
#define anyCGRect() anyWithPlaceholder(CGRectZero)

@interface SBLMock : NSObject

+ (id)mockForClass:(Class)class;

@end
