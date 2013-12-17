#import "SBLTransactionManager.h"

#define WHEN(...) ({ [SBLTransactionManager.currentTransactionManager invokeWhenMethodForObjectInBlock:^(){ (void)__VA_ARGS__; }]; })
#define VERIFY(args) VERIFY_TIMES(1, args)
// TODO: Better name. Possibly chained like VERIFY(...).TIMES()
#define VERIFY_TIMES(times, ...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performVerifyNumberOfTimes:times]; })
#define VERIFY_NEVER(args) VERIFY_TIMES(0, args)

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
