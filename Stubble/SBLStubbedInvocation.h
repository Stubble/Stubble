#import "SBLInvocationRecord.h"

@interface SBLStubbedInvocation : SBLInvocationRecord

@property (nonatomic, readonly) id returnValue;
@property (nonatomic, readonly) BOOL shouldUnboxReturnValue;

- (SBLStubbedInvocation *)thenReturn:(id)returnValue;

@end