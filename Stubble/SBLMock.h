#import "SBLStubbleCore.h"

#define WHEN(...) ({ [SBLStubbleCore.core prepareForWhen]; (void)__VA_ARGS__; [SBLStubbleCore.core performWhen]; })
#define VERIFY(...) ({ [SBLStubbleCore.core prepareForVerify]; (void)__VA_ARGS__; [SBLStubbleCore.core performVerify]; })

#define any() _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wconversion\"") \
({ [SBLStubbleCore.core addMatcher:[SBLMatcher any]]; (id)0; }) \
_Pragma ("clang diagnostic pop") \

@interface SBLMock : NSObject

+ (id)mockForClass:(Class)class;

@end
