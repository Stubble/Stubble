#import "SBLTransactionManager.h"

#define WHEN(...) ({ [SBLTransactionManager.currentTransactionManager prepareForWhen]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performWhen]; })
#define VERIFY(...) ({ [SBLTransactionManager.currentTransactionManager prepareForVerify]; (void)__VA_ARGS__; [SBLTransactionManager.currentTransactionManager performVerify]; })

#define any() _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wconversion\"") \
({ [SBLTransactionManager.currentTransactionManager addMatcher:[SBLMatcher any]]; (id)0; }) \
_Pragma ("clang diagnostic pop") \

@interface SBLMock : NSObject

+ (id)mockForClass:(Class)class;

@end
