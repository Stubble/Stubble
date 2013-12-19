#import "SBLStubbedInvocation.h"
#import "SBLTransactionManager.h"

@interface SBLStubbedInvocation ()

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
	BOOL shouldUnboxReturnValue = [returnValue isKindOfClass:[NSValue class]] && strcmp([self returnType], [returnValue objCType]) == 0;
	
	[self thenDoWithInvocation:^(NSInvocation *invocation) {
		NSUInteger methodReturnLength = [[invocation methodSignature] methodReturnLength];
		if (shouldUnboxReturnValue) {
			void *buffer = malloc(methodReturnLength);
			[returnValue getValue:buffer];
			[invocation setReturnValue:buffer];
			free(buffer);
		} else {
            if (!methodReturnLength){
                // Throw Exception?
            } else {
                id invocationReturnValue = returnValue;
                [invocation setReturnValue:&invocationReturnValue];
            }
		}
	}];
	
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

@end