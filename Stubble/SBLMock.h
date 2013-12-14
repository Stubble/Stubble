#import "SBLTransactionManager.h"

#define WHEN(...) ({ [SBLTransactionManager.currentTransactionManager prepareForWhen]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performWhen]; })
#define VERIFY(...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performVerify]; })
// TODO: Better name. Possibly chained like VERIFY(...).TIMES()
#define VERIFY_TIMES(times, ...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performVerifyNumberOfTimes:times]; })
// TODO: Macro calling macro? This is just VERIFY_TIMES with 0
#define VERIFY_NEVER(...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performVerifyNumberOfTimes:0]; })

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
