#import "SBLStubbedInvocation.h"
#import "SBLTransactionManager.h"

@interface SBLStubbedInvocation ()

@property (nonatomic, readwrite) id returnValue;

@end

@implementation SBLStubbedInvocation

- (SBLStubbedInvocation *)thenReturn:(id)returnValue {
	self.returnValue = returnValue;
	
    // TODO verify that it makes sense for the current invocation
    // TODO eventually self can be used for some type of chaining
    return self;
}

- (BOOL)shouldUnboxReturnValue {
	//	NSLog(@"NSObject * : %s", [self.returnValue objCType]);
	//	NSLog(@"methodReturnType : %s", [[self.invocation methodSignature] methodReturnType]);
	return [self.returnValue isKindOfClass:[NSValue class]] && strcmp([self returnType], [self.returnValue objCType]) == 0;
}

@end