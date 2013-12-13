#import "SBLStubbleCore.h"

#define WHEN(...) ({ [SBLStubbleCore.core prepareForWhen]; (void)__VA_ARGS__; [SBLStubbleCore.core performWhen]; })
#define VERIFY(...) ({ [SBLStubbleCore.core prepareForVerify]; (void)__VA_ARGS__; [SBLStubbleCore.core performVerify]; })


@interface SBLMock : NSObject

+ (id)mockForClass:(Class)class;

@end
