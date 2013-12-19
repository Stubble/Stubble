#import "SBLInvocationRecord.h"

typedef void (^SBLActionBlock)(void);
typedef void (^SBLInvocationActionBlock)(NSInvocation *invocation);

@interface SBLStubbedInvocation : SBLInvocationRecord

@property (nonatomic, readonly) NSArray *actionBlocks;

- (SBLStubbedInvocation *)thenReturn:(id)returnValue;
- (SBLStubbedInvocation *)thenDo:(SBLActionBlock)actionBlock;
- (SBLStubbedInvocation *)thenDoWithInvocation:(SBLInvocationActionBlock)actionBlock;

@end