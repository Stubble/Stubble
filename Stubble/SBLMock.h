#import "SBLTransactionManager.h"
#import "SBLTimesMatcher.h"

#define WHEN(...) ({ [SBLTransactionManager.currentTransactionManager invokeWhenMethodForObjectInBlock:^(){ (void)__VA_ARGS__; }]; })
#define VERIFY(args) VERIFY_TIMES(TIMES(1), args)
#define TIMES(times) ({ [SBLTimesMatcher exactly:times]; })
#define NEVER() ({ [SBLTimesMatcher never]; })
// TODO: Want this to also be VERIFY, not VERIFY_TIMES...
#define VERIFY_TIMES(timesMatcher, ...)  ({ [SBLTransactionManager.currentTransactionManager invokeVerifyMethodForObjectInBlock:^(){ (void)__VA_ARGS__; } times:timesMatcher]; })
#define VERIFY_NEVER(args) VERIFY_TIMES(NEVER(), args)

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
