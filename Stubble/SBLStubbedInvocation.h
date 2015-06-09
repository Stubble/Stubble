#import "SBLInvocationRecord.h"

typedef void (^SBLActionBlock)(void);
typedef void (^SBLInvocationActionBlock)(NSInvocation *invocation);

@interface SBLStubbedInvocation : SBLInvocationRecord

- (SBLStubbedInvocation *)thenReturn:(id)returnValue;
- (SBLStubbedInvocation *)thenDo:(SBLActionBlock)actionBlock;
- (SBLStubbedInvocation *)thenDoWithInvocation:(SBLInvocationActionBlock)actionBlock;

- (void)performActionBlocksWithInvocation:(NSInvocation *)invocation allowingUnboxing:(BOOL)allowUnboxing;

@end