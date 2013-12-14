#import "SBLTransactionManager.h"

#define WHEN(...) ({ [SBLTransactionManager.currentTransactionManager prepareForWhen]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performWhen]; })
#define VERIFY(args) VERIFY_TIMES(1, args)
// TODO: Better name. Possibly chained like VERIFY(...).TIMES()
#define VERIFY_TIMES(times, ...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performVerifyNumberOfTimes:times]; })
#define VERIFY_NEVER(args) VERIFY_TIMES(0, args)

#define any() _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wconversion\"") \
({ [SBLTransactionManager.currentTransactionManager addMatcher:[SBLMatcher any]]; (void *)0; }) \
_Pragma ("clang diagnostic pop") \

#define anyWithValidValue(...) ({ [SBLTransactionManager.currentTransactionManager addMatcher:[SBLMatcher any]]; __VA_ARGS__; })
#define anyCGRect() anyWithValidValue(CGRectZero)

@interface SBLMock : NSObject

+ (id)mockForClass:(Class)class;

@end
