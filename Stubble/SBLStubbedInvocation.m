#import "SBLStubbedInvocation.h"
#import "SBLTransactionManager.h"

@interface SBLStubbedInvocation ()

@property (nonatomic, readwrite) id returnValue;
@property (nonatomic, readwrite) NSArray *actionBlocks;

@end

@implementation SBLStubbedInvocation

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
	if (self = [super initWithInvocation:invocation]) {
		self.actionBlocks = @[];
	}
	return self;
}

- (SBLStubbedInvocation *)thenReturn:(id)returnValue {
	self.returnValue = returnValue;
	
    // TODO verify that it makes sense for the current invocation
    // TODO eventually self can be used for some type of chaining (Should anything be allowed after -thenReturn:?)
    return self;
}

- (SBLStubbedInvocation *)thenDo:(SBLActionBlock)actionBlock {
	[self thenDoWithInvocation:^(NSInvocation *invocation) {
		actionBlock();
	}];
	return self;
}

- (SBLStubbedInvocation *)thenDoWithInvocation:(SBLInvocationActionBlock)actionBlock {
	self.actionBlocks = [self.actionBlocks arrayByAddingObject:[actionBlock copy]];
	return self;
}

- (BOOL)shouldUnboxReturnValue {
	//	NSLog(@"NSObject * : %s", [self.returnValue objCType]);
	//	NSLog(@"methodReturnType : %s", [[self.invocation methodSignature] methodReturnType]);
	return [self.returnValue isKindOfClass:[NSValue class]] && strcmp([self returnType], [self.returnValue objCType]) == 0;
}

@end